//
//  ProfileViewController_iPad.m
//  hongchiaac
//
//  Created by OEM on 22/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "ProfileViewController_iPad.h"
#import "Classes/UserProfile.h"
#import "EditAACViewController_iPad.h"
#import "Handlers/ProfileHandler.h"
#import "Constants.h"

@interface ProfileViewController_iPad ()

@end

@implementation ProfileViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithUserProfile:(UserProfile *)userProfile{
    self = [super init];
    if(self){
        
    }
    
    //userProfileInEdit = userProfile;
    NSLog(@"here?");
    for(UserProfile *up in arrAllProfiles){
        if([[up getProfileID] isEqualToString:[userProfile getProfileID]]){

            userProfileInEdit = up;
        }
    }
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(userProfileInEdit != nil){
        [self editUserProfile:userProfileInEdit];
        [self showProfileDetail];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc{
    [_viewEditAAC release];
    [super dealloc];
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

-(void)deleteUserProfile:(UserProfile *)profile{
    [ProfileHandler removeProfileWithID:[profile getProfileID]];

    //if([[userProfileInEdit getProfileID] isEqualToString:[userProfileToBeDeleted getProfileID]]){
        [viewProfileDetail removeFromSuperview];
        [self reloadTableView];
    
        [userProfileInEdit release];
        userProfileInEdit = nil;
    //}else{
     //   [self reloadTableView];
    //}
    
    
}
#pragma tableview
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self editUserProfile:(UserProfile *)[arrAllProfiles objectAtIndex:[indexPath row]]];
    [self showProfileDetail];
     
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [self editUserProfile:(UserProfile *)[arrAllProfiles objectAtIndex:[indexPath row]]];
    [self showProfileDetail];

    
}
-(void)showProfileDetail{
    [viewContainer addSubview:viewProfileDetail];
}
-(void)hideProfileDetail{
    [viewProfileDetail removeFromSuperview];

}

-(IBAction)onClickOpenEditAAC:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
    [self performSelector:@selector(openEditAAC) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
}
-(void)openEditAAC{
    if(_viewEditAAC == nil){
        _viewEditAAC = [[EditAACViewController_iPad alloc] initWithNibName:@"EditAACViewController_iPad" bundle:nil];
    }
    [self.view addSubview:_viewEditAAC.view];
    [_viewEditAAC loadProfile:userProfileInEdit];
}
#pragma even handler
-(void) onCloseEditAAC:(NSNotification *)notification{
    
    [_viewEditAAC.view removeFromSuperview];
    
    //[_viewEditAAC removeFromParentViewController];
    [_viewEditAAC release];
    _viewEditAAC = nil;
    NSLog(@"after closed : %@",userProfileInEdit);    
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    //overrided
    //Assign new frame to your view
    //[self.view setFrame:CGRectMake(0,-20,320,460)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    if([tvRemark isFirstResponder])
        [self.view setFrame:CGRectMake(0, -260, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    //overrided
    //[self.view setFrame:CGRectMake(0,0,320,460)];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}
@end





