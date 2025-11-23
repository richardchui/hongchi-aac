//
//  ViewController_iPhone.m
//  hongchiaac
//
//  Created by OEM on 9/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "ViewController_iPhone.h"
#import "Classes/Tester.h"
#import "Utils.h"
#import "xlib/Objective-Zip/ZipFile.h"
#import "xlib/Objective-Zip/ZipWriteStream.h"
#import "xlib/Objective-Zip/ZipReadStream.h"
#import "xlib/Objective-Zip/FileInZipInfo.h"
#import "Handlers/ProfileHandler.h"
#import "Constants.h"
#import "Handlers/SettingHandler.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface ViewController_iPhone ()

@end

@implementation ViewController_iPhone
@synthesize v;
@synthesize library;


#define PLIST_PROFILE @"profiles.plist"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    
    
    return self;
}

- (void)viewDidLoad
{
    
//    Tester *tester = [[Tester alloc] initWithView:self.view];
    Tester *tester = [[Tester alloc] initWithView:viewBase];
    //[tester run];
    [tester runStarter];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
  jpgFiles = [[NSMutableArray alloc] init];
  
    self.library = [[ALAssetsLibrary alloc] init];
    
    [self.view addSubview:viewBase];
    
    
    if(IS_IPHONE5){
        CGRect frame = self.view.frame;
        
        /*
        frame.size.width = 568;
        self.view.frame = frame;
        
        frame = imgStripBar.frame;
        frame.origin.x = 480;
        imgStripBar.frame = frame;
        */
        //[self.view addSubview:imgStripBar];
        
        [self.view addSubview:imgStripBarLeft];
        
        frame = imgStripBarRight.frame;
        frame.origin.x = 524;
        imgStripBarRight.frame = frame;
        [self.view addSubview:imgStripBarRight];
        
        //move the view to center
        frame = viewBase.frame;
        frame.origin.x = 44;
        viewBase.frame = frame;
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoading:) name:@"showLoading" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLoading:) name:@"hideLoading" object:nil];
}

- (void)viewDidUnload
{
    self.library = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    //return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return YES;
}
-(void) showLoading:(NSNotification *)notification{
    [self showHideLoadingLayout:YES];
}
-(void) hideLoading:(NSNotification *)notification{
    [self showHideLoadingLayout:NO];
}
-(void) showHideLoadingLayout:(BOOL)isShow{
    if(isShow){
        //[self.view addSubview:loadingView];
        [viewBase addSubview:loadingView];
    }else{
        [loadingView removeFromSuperview];
    }
}
-(void) handleOpenURL:(NSURL *)url{
  // Check if it is safe to do import
  NSString *alertMsg;
  NSString *btnMsg;
  
  if (![SettingHandler getSafeImport]) {
    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]]){
      alertMsg = [Utils getText:@"加入新檔案必須在檔案頁進行" ForLang:[Constants getLanguageCodeTW] atView:@"ViewController"];
      btnMsg = [Utils getText:@"確定" ForLang:[Constants getLanguageCodeTW] atView:@"ActionSheet"];
    } else {
      alertMsg = [Utils getText:@"加入新檔案必須在檔案頁進行" ForLang:[Constants getLanguageCodeCN] atView:@"ViewController"];
      btnMsg = [Utils getText:@"確定" ForLang:[Constants getLanguageCodeCN] atView:@"ActionSheet"];
    }
    
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:alertMsg delegate:nil cancelButtonTitle:btnMsg otherButtonTitles:nil];
    [av show];
    [av release];
    return;
  }
    
    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]]){
        actionSheetContentImportProfile = [Utils getText:@"要加入新的用戶資料嗎" ForLang:[Constants getLanguageCodeTW] atView:@"ViewController"];
        alertViewContentImportedProfile = [Utils getText:@"新用戶資料加入完成" ForLang:[Constants getLanguageCodeTW] atView:@"ViewController"];
        actionSheetConfirm = [Utils getText:@"確定" ForLang:[Constants getLanguageCodeTW] atView:@"ActionSheet"];
        actionSheetCancel =[Utils getText:@"取消" ForLang:[Constants getLanguageCodeTW] atView:@"ActionSheet"];
        alertViewOK = [Utils getText:@"關閉" ForLang:[Constants getLanguageCodeTW] atView:@"AlertView"];
    }else{
        actionSheetContentImportProfile = [Utils getText:@"要加入新的用戶資料嗎" ForLang:[Constants getLanguageCodeCN] atView:@"ViewController"];
        alertViewContentImportedProfile = [Utils getText:@"新用戶資料加入完成" ForLang:[Constants getLanguageCodeCN] atView:@"ViewController"];
        actionSheetConfirm = [Utils getText:@"確定" ForLang:[Constants getLanguageCodeCN] atView:@"ActionSheet"];
        actionSheetCancel =[Utils getText:@"取消" ForLang:[Constants getLanguageCodeCN] atView:@"ActionSheet"];
        alertViewOK = [Utils getText:@"關閉" ForLang:[Constants getLanguageCodeCN] atView:@"AlertView"];
    }
    
    importFileURL = [url retain];
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:actionSheetContentImportProfile delegate:self cancelButtonTitle:nil destructiveButtonTitle:actionSheetConfirm otherButtonTitles:actionSheetCancel,nil];
    
    [as setTag:1];
    [as showInView:self.view];
    [as release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([actionSheet tag]==1){
        if(buttonIndex == 0){
//            [self installNewProfile:importFileURL];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
            [self performSelector:@selector(installNewProfile) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
        }else
            [importFileURL release];
    }
}
-(void) installNewProfile{
[self installNewProfile:importFileURL];
}
-(void) installNewProfile:(NSURL *)url{
    [self showHideLoadingLayout:YES];
    NSString *tempZipFile = [Utils getFullPath:@"tempZip.zip"];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    [data writeToFile:tempZipFile atomically:YES];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:tempZipFile]){
        //make a new profile ID
        NSString *newProfileID = [ProfileHandler getNewProfileID];
        
        //check if the profiles folder exist, create if not
        NSString *profilePath = @"/profiles/";
        if(![Utils isDirectoryExist:profilePath]){
            [Utils createDirectory:profilePath];
        }
        //check a folder for this new import profile
        NSString *profileFolderPath= [[NSString alloc] initWithFormat:@"/profiles/%@/",newProfileID];
        [Utils createDirectory:profileFolderPath];
        
        NSString *fullPathOfProfileFolder = [Utils getFullPath:profileFolderPath];
        savedFullPath = [fullPathOfProfileFolder copy];

        ZipFile *unzipFile = [[ZipFile alloc] initWithFileName:tempZipFile mode:ZipFileModeUnzip];
        NSArray *infos = [unzipFile listFileInZipInfos];
        for(FileInZipInfo *info in infos){
            //NSLog(@"- %@ %@ %d (%d)", info.name, info.date, info.size,info.level);
            
            NSLog(@"unzipping : %@ (file size : %d) (length: %d)",info.name, info.size,info.length);
            
            [unzipFile locateFileInZip:info.name];
            
            ZipReadStream *read = [unzipFile readCurrentFileInZip];
            NSMutableData *data = [[NSMutableData alloc] initWithLength:info.length];
            int bytesRead = [read readDataWithBuffer:data];
            NSLog(@"%d",bytesRead);
            
            if(![info.name isEqualToString:@"profile_content.plist"]){
                [data writeToFile:[fullPathOfProfileFolder stringByAppendingPathComponent:info.name] atomically:NO];
                
                if([[info.name pathExtension] isEqualToString:@"jpg"]){
                    //UIImageWriteToSavedPhotosAlbum([UIImage imageWithContentsOfFile:[fullPathOfProfileFolder stringByAppendingPathComponent:info.name]], self, nil, nil);
                  
                  // Cannot keep writing the files
//                    [self.library saveImage:[UIImage imageWithContentsOfFile:[fullPathOfProfileFolder stringByAppendingPathComponent:info.name]] toAlbum:@"Hong Chi AAC" withCompletionBlock:^(NSError *error) {
//                        if (error!=nil) {
//                            NSLog(@"Big error: %@", [error description]);
//                        }
//                    }];

                  [jpgFiles addObject:info.name];
                }
            }else{
                
                [data writeToFile:[fullPathOfProfileFolder stringByAppendingPathComponent:info.name] atomically:YES];
                
                NSMutableDictionary *profileDict = [[NSMutableDictionary alloc] initWithContentsOfFile:[fullPathOfProfileFolder stringByAppendingPathComponent:info.name]];
                
                //update profile_plist////////////////
                NSMutableDictionary *oriContent = [[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_PROFILE]];
                //[oriContent setValue:profileDict forKey:newProfileID];
                
                [profileDict setObject:[NSNumber numberWithInt:[oriContent count]] forKey:@"order"];
                
                [oriContent setObject:profileDict forKey:newProfileID];
                
                
                NSLog(@"new profileid : %@",newProfileID);
                NSLog(@"---%@",oriContent);
                [Utils writeContentToPlist:PLIST_PROFILE withContent:oriContent];
                [oriContent release];
                //////////////
                [Utils deleteFileInGiveFullPath:[fullPathOfProfileFolder stringByAppendingPathComponent:info.name]];
            }
            [read finishedReading];
            [data release];
            
        }
        NSLog(@"=============");
        //[Utils listDirectory:fullPathOfProfileFolder];
      
      [self copyJPGToAlbum];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLoading" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadListForImportedProfile" object:self];       
    [self performSelector:@selector(completedInstallNewProfile) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:alertViewContentImportedProfile delegate:nil cancelButtonTitle:nil otherButtonTitles:alertViewOK,nil];
    [av show];
    [av release];
}
-(void)completedInstallNewProfile{
    [self showHideLoadingLayout:NO];
}
-(NSDictionary *) dictionaryFromXML:(NSString *)xml{
    // NSString *x = [NSString stringWithFormat:@"<x>%@</x>",xml];
    //    NSXMLDo
    return NULL;
}

-(void)copyJPGToAlbum{
  NSLog(@"copyJPG called");
  if ([jpgFiles count] > 0) {
    NSLog(@"Copying %@", jpgFiles[0]);
    [self.library saveImage:[UIImage imageWithContentsOfFile:[savedFullPath stringByAppendingPathComponent:jpgFiles[0]]]
                    toAlbum:@"Hong Chi AAC"
        withCompletionBlock:^(NSError *error) {
          if (error!=nil) {
            NSLog(@"Still error");
          } else {
            [jpgFiles removeObject:0];
            [self copyJPGToAlbum];
          }
        }
     ];
  }
}

@end
