//
//  ViewController_iPad.h
//  hongchiaac
//
//  Created by OEM on 9/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController_iPad : ViewController<UIActionSheetDelegate>{
    UIView *v;
    
    NSURL *importFileURL;
    
    NSString *actionSheetContentImportProfile;
    NSString *alertViewContentImportedProfile;
    NSString *actionSheetConfirm;
    NSString *actionSheetCancel;
    NSString *alertViewOK;
    
    AVAudioPlayer *player;
}

@property (nonatomic, retain) IBOutlet UIView *v;

@property (strong, atomic) ALAssetsLibrary* library;

-(void) showHideLoadingLayout:(BOOL)isShow;
-(void) handleOpenURL:(NSURL *)url;
-(void) installNewProfile:(NSURL *)url;

@end
