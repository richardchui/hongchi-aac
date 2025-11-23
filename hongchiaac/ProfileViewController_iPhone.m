//
//  ProfileViewController_iPhone.m
//  hongchiaac
//
//  Created by OEM on 22/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "ProfileViewController_iPhone.h"
#import "Classes/UserProfile.h"
#import "EditAACViewController_iPhone.h"
#import "Constants.h"
#import "Utils.h"
#import "Handlers/ProfileHandler.h"


@interface ProfileViewController_iPhone ()

@end

@implementation ProfileViewController_iPhone

@synthesize btnBack;
@synthesize scrollViewProfileDetail;

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
    NSLog(@"delete : %@",profile);
    [ProfileHandler removeProfileWithID:[profile getProfileID]];
    
    //if([[userProfileInEdit getProfileID] isEqualToString:[userProfileToBeDeleted getProfileID]]){
        [viewProfileDetail removeFromSuperview];
        [userProfileInEdit release];
        userProfileInEdit = nil;
    //}
    
    [self reloadTableView];
    [self hideProfileDetail];
}

#pragma tableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self editUserProfile:(UserProfile *)[arrAllProfiles objectAtIndex:[indexPath row]]];
    [self showProfileDetail];
    
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [self editUserProfile:(UserProfile *)[arrAllProfiles objectAtIndex:[indexPath row]]];
    [self showProfileDetail];
}

-(void)showProfileDetail{

    scrollViewProfileDetail.contentSize = CGSizeMake(viewProfileDetail.frame.size.width, viewProfileDetail.frame.size.height);
    scrollViewProfileDetail.showsHorizontalScrollIndicator =NO;
    scrollViewProfileDetail.showsVerticalScrollIndicator=YES;
    scrollViewProfileDetail.delegate = self;
    [scrollViewProfileDetail addSubview:viewProfileDetail];
    
    
    
    CGRect frame = scrollViewProfileDetail.frame;
    frame.origin.x=frame.size.width;
    scrollViewProfileDetail.frame = frame;
    frame.origin.x=0;
    
    [viewContainer addSubview:scrollViewProfileDetail];
    
    [btnAddNewProfile setHidden:YES];
    [btnDeleteProfile setHidden:YES];
    [btnChangeProfileList setHidden:YES];
    
    [UIView animateWithDuration:0.3 animations:^(void){scrollViewProfileDetail.frame=frame;} completion:^(BOOL finished){
        //show the back button to move upper level
        [btnBack setHidden:NO];
        
    }];
    
}
-(void)hideProfileDetail{
    CGRect frame = scrollViewProfileDetail.frame;
    frame.origin.x=frame.size.width;

    [btnBack setHidden:YES];
    [btnDeleteProfile setHidden:YES];
    [btnChangeProfileList setHidden:NO];
    [UIView animateWithDuration:0.3 animations:^(void){scrollViewProfileDetail.frame=frame;} completion:^(BOOL finished){
        //show the back button to move upper level
        [scrollViewProfileDetail removeFromSuperview];
        [btnAddNewProfile setHidden:NO];
        [btnDeleteProfile setHidden:NO];
    }];
}

-(void)openEditAAC{
    if(_viewEditAAC == nil){
        _viewEditAAC = [[EditAACViewController_iPhone alloc] initWithNibName:@"EditAACViewController_iPhone" bundle:nil];
    }

    [self.view addSubview:_viewEditAAC.view];
    [_viewEditAAC loadProfile:userProfileInEdit];

}
#pragma event Handler
-(IBAction)onClickBack:(id)sender{
    [self hideProfileDetail];
}
-(IBAction)onClickOpenEditAAC:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
    [self performSelector:@selector(openEditAAC) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
}

#pragma scrollView
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [txtProfileName resignFirstResponder];
    [txtSelectedProfileName resignFirstResponder];
    [tvRemark resignFirstResponder];
}

#pragma handler
-(void) onCloseEditAAC:(NSNotification *)notification{
    
    [_viewEditAAC.view removeFromSuperview];
    
    [_viewEditAAC release];
    _viewEditAAC = nil;
    NSLog(@"after closed : %@",userProfileInEdit);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtProfileName resignFirstResponder];
    [txtSelectedProfileName resignFirstResponder];
    [tvRemark resignFirstResponder];
    
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    //overrided
    //Assign new frame to your view
    //[self.view setFrame:CGRectMake(0,-20,320,460)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    if([tvRemark isFirstResponder])
        [self.scrollViewProfileDetail setFrame:CGRectMake(0, -100, scrollViewProfileDetail.frame.size.width, scrollViewProfileDetail.frame.size.height)];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    //overrided
    //[self.view setFrame:CGRectMake(0,0,320,460)];
    [self.scrollViewProfileDetail setFrame:CGRectMake(0, 0, scrollViewProfileDetail.frame.size.width, scrollViewProfileDetail.frame.size.height)];
}

@end
