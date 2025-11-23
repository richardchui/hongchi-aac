//
//  MatchingLevelViewController_iPad.m
//  hongchiaac
//
//  Created by Ray.Liu on 1/30/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import "MatchingLevelViewController_iPad.h"

@implementation MatchingLevelViewController_iPad

#pragma - MatchingLevelViewController

- (IBAction)btnLevel_Click:(id)sender
{
    [super btnLevel_Click:sender];
    
    gameViewController = [[MatchingGameViewController_iPad alloc] initWithNavigationController:nil ParentController:self.myParentController ExtraData:self.myExtraData];
    
    [self.view addSubview:gameViewController.view];
}

@end
