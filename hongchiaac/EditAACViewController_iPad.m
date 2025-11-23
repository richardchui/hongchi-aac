//
//  EditAACViewController_iPad.m
//  hongchiaac
//
//  Created by OEM on 31/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "EditAACViewController_iPad.h"
#import "LibCardSelectorViewController.h"
#import "Classes/UserProfile.h"

@interface EditAACViewController_iPad ()

@end

@implementation EditAACViewController_iPad


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
///////////////////

-(void)openCardLibrary{
    if(vcLibCardSelector == nil){
        vcLibCardSelector = [[LibCardSelectorViewController alloc] initWithNibName:@"LibCardSelectorViewController_iPad" bundle:nil];
    }
    [vcLibCardSelector setCardCaptionLanguage:[loadedProfile getCaptionMode]];
    [vcLibCardSelector setVoiceMode:[loadedProfile getVoiceMode]];
    [self.view addSubview:vcLibCardSelector.view];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLoading" object:self];    
}
@end
