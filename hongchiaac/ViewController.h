//
//  ViewController.h
//  hongchiaac
//
//  Created by OEM on 4/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    UIView *loadingView;
}

@property (nonatomic, retain) IBOutlet UIView *loadingView;

-(void) showHideLoadingLayout:(BOOL)isShow;
-(void) installNewProfile:(NSURL *)url;
-(void) handleOpenURL:(NSURL *)url;
@end
