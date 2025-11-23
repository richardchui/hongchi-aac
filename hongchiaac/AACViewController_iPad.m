//
//  AACViewController_iPad.m
//  ;
//
//  Created by OEM on 9/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "Utils.h"
#import "AACViewController.h"
#import "AACViewController_iPad.h"
#import "Classes/UserProfile.h"
#import "Classes/UserCard.h"
#import "AACCard.h"
#import "Handlers/ProfileHandler.h"
#import "MiniGames/Matching/MatchingLevelViewController_iPad.h"
#import "MiniGames/Sequencing/SequencingLevelViewController_iPad.h"

@interface AACViewController_iPad ()

@end

@implementation AACViewController_iPad

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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

//////////////////////////
-(IBAction)onClickMenuProfile:(id)sender{
    [self openProfileMenu];
}
-(void)openProfileMenu{
    if(profileViewController==nil){
        profileViewController = [[ProfileViewController_iPad alloc] initWithUserProfile:loadedProfile];
    }
    [self.view addSubview:profileViewController.view];
}
-(void)closeProfileMenu{
    [profileViewController.view removeFromSuperview];
    [profileViewController release];
    profileViewController = nil;
    [viewMenu removeFromSuperview];    
    //[self reloadProfile:loadedProfile];
    [self reloadProfile];
}
-(void)openSetting{
    if(settingViewController==nil){
        settingViewController = [[SettingViewController_iPad alloc] init];
    }
    [self.view addSubview:settingViewController.view];
}
-(void)closeSetting{
    [settingViewController.view removeFromSuperview];
    [settingViewController release];
    settingViewController = nil;
    //[self reloadProfile:loadedProfile];
    NSLog(@"closed setting");
}
#pragma event handler
-(void) onCloseProfileMenu:(NSNotification *)notification{
    //UserProfile *profile = notification.object;
    [self closeProfileMenu];
    //[self reloadProfile:profile];
//    loadedProfile = [ProfileHandler getProfileWithID:[loadedProfile getProfileID]];
    
    /*
    NSString *profileID = [[NSString alloc] initWithString:[loadedProfile getProfileID]];
    [loadedProfile release];
    loadedProfile = [[UserProfile alloc] initWithProfileID:profileID];
    [profileID release];
    */
}


-(void)onClickGame1:(id)sender
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:[loadedProfile getProfileID] forKey:@"profile_id"];
    
    matchingLevelViewController = [[MatchingLevelViewController_iPad alloc] initWithNavigationController:nil ParentController:self ExtraData:data];
    
    [super onClickGame1:sender];
}

-(void)onClickGame2:(id)sender
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:[loadedProfile getProfileID] forKey:@"profile_id"];
    
    sequencingLevelViewController = [[SequencingLevelViewController_iPad alloc] initWithNavigationController:nil ParentController:self ExtraData:data];
    
    [super onClickGame2:sender];
}

@end
