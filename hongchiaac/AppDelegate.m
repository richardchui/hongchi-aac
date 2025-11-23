//
//  AppDelegate.m
//  hongchiaac
//
//  Created by OEM on 4/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ViewController_iPhone.h"
#import "ViewController_iPad.h"
#import "Utils.h"

@implementation AppDelegate
@synthesize defaultCardsPlist;

#if __IPAD_OS_VERSION_MAX_ALLOWED >= __IPAD_6_0

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    
    return UIInterfaceOrientationMaskAll;
    
    
}
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {

        self.viewController = [[ViewController_iPhone alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
    } else {

        self.viewController = [[ViewController_iPad alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
    }
    self.window.rootViewController = self.viewController;
    
    
    [self.window makeKeyAndVisible];
    
    // Read the default card plist once in AppDelegate
    self.defaultCardsPlist = [Utils getContentFromPlist:@"default_cards.plist"];

    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    //NSLog(@"open with url");
    //[self.viewController showHideLoadingLayout:YES];
    [self.viewController handleOpenURL:url];
    return YES;
}

@end
