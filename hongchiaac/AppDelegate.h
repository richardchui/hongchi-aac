//
//  AppDelegate.h
//  hongchiaac
//
//  Created by OEM on 4/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSDictionary *defaultCardsPlist;

}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) NSDictionary *defaultCardsPlist;

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
@end
