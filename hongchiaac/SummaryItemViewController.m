//
//  SummaryItemViewController.m
//  hongchiaac
//
//  Created by OEM on 6/2/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import "SummaryItemViewController.h"
#import "Constants.h"

@interface SummaryItemViewController ()

@end

@implementation SummaryItemViewController
@synthesize imgProfilePic;
@synthesize lblProfileName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithProfileID:(NSString *)pid{
    self = [super init];
    if(self){
        
    }
    profileID = pid;
    
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

-(void)dealloc{
    [imgProfilePic release];
    [lblProfileName release];
    [profileID release];
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
-(void)resizeImageToSize:(int)height{
    int width = (int)(height/6*5);
    
    CGRect frame = self.view.frame;
    frame.size.width = width;
    frame.size.height = height;
    self.view.frame = frame;
    
    frame = self.imgProfilePic.frame;
    frame.origin.x = 3;
    frame.origin.y = 3;
    frame.size.width = width-6;
    frame.size.height = width-6;
    self.imgProfilePic.frame = frame;
    
    frame.size.width =width;
    frame.size.height=height-width;
    frame.origin.x=0;
    frame.origin.y=width;    
    lblProfileName.frame=frame;
}

#pragma touch events
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view setBackgroundColor:[UIColor greenColor]];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view setBackgroundColor:[UIColor colorWithRed:1 green:0.5 blue:0 alpha:1]];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view setBackgroundColor:[UIColor colorWithRed:255 green:127 blue:0 alpha:1]];    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
    [self performSelector:@selector(clickedProfile) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
    
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view setBackgroundColor:[UIColor colorWithRed:1 green:0.5 blue:0 alpha:1]];
}
-(void)clickedProfile{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onClickProfileInSummary" object:profileID];    
}
@end
