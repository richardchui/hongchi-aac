//
//  StartingViewController.h
//  hongchiaac
//
//  Created by OEM on 5/2/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface StartingViewController : UIViewController{
    UIButton *btnStart;
    
    UIActivityIndicatorView *aiv;
  
  NSMutableArray *jpgFiles;
  NSString *savedFullPath;
}

@property (nonatomic, retain) IBOutlet UIButton *btnStart;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *aiv;

@property (strong, atomic) ALAssetsLibrary* library;


-(IBAction)onClickStart:(id)sender;
-(void)copyJPGToAlbum;

@end
