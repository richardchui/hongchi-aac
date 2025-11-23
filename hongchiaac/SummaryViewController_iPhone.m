//
//  SummaryViewController_iPhone.m
//  hongchiaac
//
//  Created by OEM on 7/2/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import "SummaryViewController_iPhone.h"
#import "SummaryItemViewController.h"
#import "Classes/UserProfile.h"
#import "Utils.h"

@interface SummaryViewController_iPhone ()

@end

@implementation SummaryViewController_iPhone

#define PROFILE_PER_PAGE 6

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
-(void)initPageWithPageNum:(int)page forPage:(UIView *)viewPage{
    int tempCounter  = 0;
    
    for (int i = (page)*PROFILE_PER_PAGE ; i<((page+1)*PROFILE_PER_PAGE) && i<[arrProfiles count]; i++) {
        //NSLog(@"now i : %d",i);
        //SummaryItemViewController *item = [[SummaryItemViewController alloc] initWithProfileID:[arrProfiles objectAtIndex:i]];
        
        SummaryItemViewController *item = [[SummaryItemViewController alloc] initWithProfileID:[(UserProfile *)[arrProfiles objectAtIndex:i] getProfileID]];
        
        [item resizeImageToSize:120];
        
        [viewPage addSubview:item.view];
        //item.lblProfileName.text = [NSString stringWithFormat:@"%@",[arrProfiles objectAtIndex:i]];
        //item.lblProfileName.text = [[dictProfiles objectForKey:[arrProfiles objectAtIndex:i]] objectForKey:@"name"];
        
        item.lblProfileName.text = [(UserProfile *)[arrProfiles objectAtIndex:i] getName];
        
        /*
        NSString *imagePath = [[NSString alloc] initWithFormat:@"/profiles/%@/%@.jpg",[arrProfiles objectAtIndex:i],[arrProfiles objectAtIndex:i]];
        NSLog(@"profile image path : %@",[Utils getFullPath:imagePath]);
        if([Utils isFileExist:imagePath]){
            item.imgProfilePic.image = [UIImage imageWithContentsOfFile:[Utils getFullPath:imagePath]];
        }
         */
        NSString *imagePath = [[NSString alloc] initWithFormat:@"/profiles/%@/%@.jpg",[(UserProfile *)[arrProfiles objectAtIndex:i] getProfileID],@"profilepic"];
        //NSLog(@"profile image path : %@",[Utils getFullPath:imagePath]);
        if([Utils isFileExist:imagePath]){
            //NSLog(@"file exist");
            item.imgProfilePic.image = [Utils resizeImageWithImage:[UIImage imageWithContentsOfFile:[Utils getFullPath:imagePath]] toSize:CGSizeMake(120, 120)];
        }else{
            //NSLog(@"file not exist");
            item.imgProfilePic.image = [Utils resizeImageWithImage:[UIImage imageNamed:@"default_profile_picture.jpg"]toSize:CGSizeMake(120, 120)];
        }
        [imagePath release];
        
        CGRect frame = item.view.frame;
        frame.origin.x = (tempCounter % 3) * 140 + (viewPage.frame.size.width - frame.size.width * 3)/3/2;
        frame.origin.y = (int)floor(((float)tempCounter / (float)3)) * 140 + (viewPage.frame.size.height - frame.size.height * 2)/2/2;
        
        item.view.frame = frame;
        tempCounter++;
    }
    
    
    
}
@end
