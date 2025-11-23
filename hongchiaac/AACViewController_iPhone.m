//
//  AACViewController_iPhone.m
//  hongchiaac
//
//  Created by OEM on 12/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "AACViewController_iPhone.h"
#import "ProfileViewController_iPhone.h"
#import "Classes/UserCard.h"
#import "Utils.h"
#import "AACCard.h"
#import "MiniGames/Matching/MatchingGameViewController_iPad.h"
#import "SettingViewController_iPhone.h"

@interface AACViewController_iPhone ()

@end

@implementation AACViewController_iPhone

#define LAYOUT_1X1  1
#define LAYOUT_1X2  2
#define LAYOUT_1X3  3
#define LAYOUT_2X4  4
#define LAYOUT_2x6  5
#define LAYOUT_3X6  6

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

-(void)drawSelectedCard{

    
    UIImageView *iv = [[UIImageView alloc] init];
    AACCard *aacCard;
    [Utils removeAllChild:selectedCardContainer];
    for(int i=0;i<[arraySelectedCards count];i++){
        //iv = [[UIImageView alloc] initWithImage:[(AACCard *)[arraySelectedCards objectAtIndex:i] getCardImage]];
        aacCard = (AACCard *)[arraySelectedCards objectAtIndex:i];
        
        //UIGraphicsBeginImageContext(aacCard.view.frame.size);
        UIGraphicsBeginImageContext(CGSizeMake(aacCard.view.frame.size.width, aacCard.view.frame.size.width));
        [aacCard.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        iv = [[UIImageView alloc] initWithImage:resultingImage];
        
        CGRect frame = iv.frame;
//        frame.origin.x=i*(55);
        
        if([loadedProfile getSingleCardMode]){
            frame.origin.x=4*(55);
        }else{
            frame.origin.x=i*(55);
        }
        
        frame.origin.y=0;
        frame.size.width=50;
        frame.size.height=50;
        iv.frame=frame;
        
        [selectedCardContainer addSubview:iv];
    }
    
}

-(IBAction)onClickMenuProfile:(id)sender{
    if(profileViewController==nil){
        profileViewController = [[ProfileViewController_iPhone alloc] initWithUserProfile:loadedProfile];
    }
    [self.view addSubview:profileViewController.view];
}
-(void)closeProfileMenu{
    [profileViewController.view removeFromSuperview];
    [profileViewController release];
    profileViewController = nil;
    
    [viewMenu removeFromSuperview];
    
    [self reloadProfile];
}
#pragma event handler
-(void) onCloseProfileMenu:(NSNotification *)notification{
    [self closeProfileMenu];
}
-(void)openSetting{
    if(settingViewController==nil){
        settingViewController = [[SettingViewController_iPhone alloc] init];
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


-(int)getNumberOfCardPerPageFromLayout:(int)layoutID{
    
    if(layoutID == LAYOUT_1X1) return 1;
    if(layoutID == LAYOUT_1X2) return 2;
    if(layoutID == LAYOUT_1X3) return 3;
    if(layoutID == LAYOUT_2X4) return 8;
    if(layoutID == LAYOUT_2x6) return 12;
    if(layoutID == LAYOUT_3X6) return 12;
    
    return 0;
}
-(int)getRowFromLayout:(int)layoutID{
    
    if(layoutID == LAYOUT_1X1) return 1;
    if(layoutID == LAYOUT_1X2) return 1;
    if(layoutID == LAYOUT_1X3) return 1;
    if(layoutID == LAYOUT_2X4) return 2;
    if(layoutID == LAYOUT_2x6) return 2;
    if(layoutID == LAYOUT_3X6) return 2;
    
    return 1;
}
-(int)getCardSize:(int)layoutID{
    if(layoutID == LAYOUT_1X1) return 200;
    if(layoutID == LAYOUT_1X2) return 200;
    if(layoutID == LAYOUT_1X3) return 180;
    if(layoutID == LAYOUT_2X4) return 110;
    if(layoutID == LAYOUT_2x6) return 88;
    if(layoutID == LAYOUT_3X6) return 88;
    
    return 1;
}
-(int)getCardXMargin:(int)layoutID{
    if(layoutID == LAYOUT_1X1) return 230;
    if(layoutID == LAYOUT_1X2) return 230;
    if(layoutID == LAYOUT_1X3) return 160;
    if(layoutID == LAYOUT_2X4) return 120;
    if(layoutID == LAYOUT_2x6) return 80;
    if(layoutID == LAYOUT_3X6) return 80;
    
    return 1;
}
-(int)getCardYMargin:(int)layoutID{
    if(layoutID == LAYOUT_1X1) return 0;
    if(layoutID == LAYOUT_1X2) return 0;
    if(layoutID == LAYOUT_1X3) return 0;
    if(layoutID == LAYOUT_2X4) return 108;
    if(layoutID == LAYOUT_2x6) return 100;
    if(layoutID == LAYOUT_3X6) return 100;
    
    return 1;
}
@end
