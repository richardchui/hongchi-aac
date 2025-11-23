//
//  StartingViewController.m
//  hongchiaac
//
//  Created by OEM on 5/2/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import "StartingViewController.h"
#import "Classes/Tester.h"
#import "Handlers/SettingHandler.h"
#import "xlib/Objective-Zip/ZipFile.h"
#import "xlib/Objective-Zip/ZipWriteStream.h"
#import "xlib/Objective-Zip/ZipReadStream.h"
#import "xlib/Objective-Zip/FileInZipInfo.h"
#import "Handlers/ProfileHandler.h"
#import "Utils.h"
#import "Constants.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface StartingViewController ()

@end

@implementation StartingViewController
@synthesize btnStart;
@synthesize aiv;

#define PLIST_PROFILE @"profiles.plist"

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
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  jpgFiles = [[NSMutableArray alloc] init];
  
  [Utils skipDoc:@""];
  [Utils skipDoc:@"/profiles"];
  
  self.library = [[ALAssetsLibrary alloc] init];
  
  //copy once the card plist
  [Utils copyFileFromBundleToLocal:@"default_cards.plist"];
  [Utils copyFileFromBundleToLocal:@"language_resource.plist"];
  [Utils copyFileFromBundleToLocal:@"category.plist"];
  [Utils copyFileFromBundleToLocal:@"sequencing_cardsets.plist"];
  
  //[self initDefaultProfile];
  
  if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]]){
    [btnStart setTitle:[Utils getText:@"進入" ForLang:[Constants getLanguageCodeTW] atView:@"StartingViewController"] forState:UIControlStateNormal];
  }else{
    [btnStart setTitle:[Utils getText:@"進入" ForLang:[Constants getLanguageCodeCN] atView:@"StartingViewController"] forState:UIControlStateNormal];
  }
  
  [aiv startAnimating];
  [self performSelector:@selector(initDefaultProfile) withObject:nil afterDelay:0.01];
}

- (void)viewDidUnload
{
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

-(void)dealloc{
  [btnStart release];
  [super dealloc];
}

-(IBAction)onClickStart:(id)sender{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"onClickStartInStarting" object:nil];
}

-(void)initFilesForProfile{
  [Utils copyDefaultProfileFileFromBundleToLocal:@"default_profile_01" fileName:@"130506182314570.caf"];
}
-(void)initDefaultProfile{
  [self installNewProfile:@"defaultProfile1x1.zip"];
  [self installNewProfile:@"defaultProfile1x2.zip"];
  [self installNewProfile:@"defaultProfile1x3.zip"];
  [self installNewProfile:@"defaultProfile2x4.zip"];
  [self installNewProfile:@"defaultProfile2x6.zip"];
  [self installNewProfile:@"defaultProfile3x6.zip"];
  
//  NSLog(@"Total jpg files added - %i", [jpgFiles count]);
//  while ([jpgFiles count] > 0) {
//    [self copyJPGToAlbum];
//    [jpgFiles removeObjectAtIndex:0];
//  }
  
  [Utils skipDoc:@""];
  [Utils skipDoc:@"/profiles"];
  
  [btnStart setHidden:NO];
  [aiv stopAnimating];
}
//-(void) installNewProfile:(NSURL *)url{
-(void) installNewProfile:(NSString *)profileFileName{
  NSLog(@"Installing %@", profileFileName);
  
  NSString *tempZipFile = [Utils getFullPath:profileFileName];
  NSFileManager *fm = [NSFileManager defaultManager];
  BOOL isAlreadyLoaded = YES;
  
  
  
  //////////////////////////////
  //check if the zip is in local
  //NSLog(@"-------------------------------------------%@-------------",profileFileName);
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
  NSString *Path = [paths objectAtIndex:0];
  if(![fm fileExistsAtPath:[Path stringByAppendingPathComponent:profileFileName]]){
    NSLog(@"not in local");
    NSString *pathLocal = [Path stringByAppendingPathComponent:profileFileName];
    NSString *pathBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:profileFileName];
    
    
    [Utils skipDoc:[NSString stringWithFormat:@"/%@",profileFileName]];
    [fm copyItemAtPath:pathBundle toPath:pathLocal error:nil];
    [Utils skipDoc:[NSString stringWithFormat:@"/%@",profileFileName]];
    isAlreadyLoaded = NO;
    
  } else {
    NSLog(@"in local");
  }
  
  [Utils skipDoc:[NSString stringWithFormat:@"/profiles/%@",profileFileName]];
  
  //////////////////////////////
  //NSLog(@"------------------------>>>");
  
  if([fm fileExistsAtPath:tempZipFile] && !isAlreadyLoaded){
    
    NSLog(@"Creating new profile <<<");
    //make a new profile ID
    NSString *newProfileID = [ProfileHandler getNewProfileID];
    
    
    
    //skip the profile folder///////
    [Utils skipDoc:[NSString stringWithFormat:@"/profiles/%@",newProfileID]];
    ////////////////////////////////
    
    
    
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
      NSLog(@"- %@ %@ %d (%d)", info.name, info.date, info.size,info.level);
      
      NSLog(@"unzipping : %@ (file size : %d) (length: %d)",info.name, info.size,info.length);
      
      [unzipFile locateFileInZip:info.name];
      
      ZipReadStream *read = [unzipFile readCurrentFileInZip];
      NSMutableData *data = [[NSMutableData alloc] initWithLength:info.length];
      //int bytesRead = [read readDataWithBuffer:data];
      [read readDataWithBuffer:data];
      //NSLog(@"%d",bytesRead);
      
      if(![info.name isEqualToString:@"profile_content.plist"]){
        [data writeToFile:[fullPathOfProfileFolder stringByAppendingPathComponent:info.name] atomically:NO];
        
        if([[info.name pathExtension] isEqualToString:@"jpg"]){
          NSLog(@"writing jpg");
          //UIImageWriteToSavedPhotosAlbum([UIImage imageWithContentsOfFile:[fullPathOfProfileFolder stringByAppendingPathComponent:info.name]], self, nil, nil);
          
          // Cannot keep adding, the device will not be able to handle, have to do it one at a time.
                              [self.library saveImage:[UIImage imageWithContentsOfFile:[fullPathOfProfileFolder stringByAppendingPathComponent:info.name]] toAlbum:@"Hong Chi AAC" withCompletionBlock:^(NSError *error) {
                                  if (error!=nil) {
                                      // NSLog(@"Default big error: %@ %@", profileFileName, [error description]);
                                        NSLog(@"Default big error: %@ - %@", profileFileName, info.name);
                                  }
                              }];
          
          
          [jpgFiles addObject:[savedFullPath stringByAppendingPathComponent:info.name]];
        }
      }else{
        NSLog(@"writing plist");
        [data writeToFile:[fullPathOfProfileFolder stringByAppendingPathComponent:info.name] atomically:YES];
        
        NSMutableDictionary *profileDict = [[NSMutableDictionary alloc] initWithContentsOfFile:[fullPathOfProfileFolder stringByAppendingPathComponent:info.name]];
        
        //update profile_plist////////////////
        NSMutableDictionary *oriContent = [[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_PROFILE]];
        //[oriContent setValue:profileDict forKey:newProfileID];
        
        [profileDict setObject:[NSNumber numberWithInt:[oriContent count]] forKey:@"order"];
        
        [oriContent setObject:profileDict forKey:newProfileID];
        
        
        NSLog(@"order:%d  profileid:%@",[oriContent count], newProfileID);
        
        
        //NSLog(@"new profileid : %@",newProfileID);
        //NSLog(@"---%@",oriContent);
        [Utils writeContentToPlist:PLIST_PROFILE withContent:oriContent];
        [oriContent release];
        //////////////
        [Utils deleteFileInGiveFullPath:[fullPathOfProfileFolder stringByAppendingPathComponent:info.name]];
      }
      [read finishedReading];
      [data release];
      
    }
    //NSLog(@"=============");
    //skip the profile folder///////
    [Utils skipDoc:[NSString stringWithFormat:@"/profiles/%@",newProfileID]];
    ////////////////////////////////
  }
  
  //  [self copyJPGToAlbum];
}

-(void)copyJPGToAlbum{
  NSLog(@"copyJPG called");
    NSLog(@"Copying %@", jpgFiles[0]);
    [self.library saveImage:[UIImage imageWithContentsOfFile:jpgFiles[0]]
                    toAlbum:@"Hong Chi AAC"
        withCompletionBlock:^(NSError *error) {
          if (error!=nil) {
            NSLog(@"Still error");
          } else {
            NSLog(@"JPG copied");
//            [jpgFiles removeObjectAtIndex:0];
//            if ([jpgFiles count] > 0)
//              [self copyJPGToAlbum];
          }
        }
     ];

//  while ([jpgFiles count] > 0) {
//    NSLog(@"Copying %@", jpgFiles[0]);
//    [self.library saveImage:[UIImage imageWithContentsOfFile:jpgFiles[0]]
//                    toAlbum:@"Hong Chi AAC"
//        withCompletionBlock:^(NSError *error) {
//          if (error!=nil) {
//            NSLog(@"Still error");
//          } else {
//            NSLog(@"JPG copied");
//            [jpgFiles removeObjectAtIndex:0];
//            if ([jpgFiles count] > 0)
//              [self copyJPGToAlbum];
//          }
//        }
//     ];
//    [jpgFiles removeObjectAtIndex:0];
//  }
}
@end
