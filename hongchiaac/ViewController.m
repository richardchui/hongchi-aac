//
//  ViewController.m
//  hongchiaac
//
//  Created by OEM on 4/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize loadingView;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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

-(void) showHideLoadingLayout:(BOOL)isShow{
    //overridded
}
-(void) handleOpenURL:(NSURL *)url{
    //overrieded
}
-(void) installNewProfile:(NSURL *)url{
    //overridded
}
@end
