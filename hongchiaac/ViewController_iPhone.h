//
//  ViewController_iPhone.h
//  hongchiaac
//
//  Created by OEM on 9/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController_iPhone : ViewController<UIActionSheetDelegate>{
    UIView *v;
    
    NSURL *importFileURL;
    
    NSString *actionSheetContentImportProfile;
    NSString *alertViewContentImportedProfile;
    NSString *actionSheetConfirm;
    NSString *actionSheetCancel;
    NSString *alertViewOK;

  NSMutableArray *jpgFiles;
  NSString *savedFullPath;

    IBOutlet UIImageView *imgStripBarLeft;
    IBOutlet UIImageView *imgStripBarRight;
    
    IBOutlet UIView *viewBase;
    
}
@property (nonatomic, retain) IBOutlet UIView *v;

@property (strong, atomic) ALAssetsLibrary* library;

-(void) showHideLoadingLayout:(BOOL)isShow;
-(void) handleOpenURL:(NSURL *)url;
-(void) installNewProfile:(NSURL *)url;
-(void) copyJPGToAlbum;
@end
