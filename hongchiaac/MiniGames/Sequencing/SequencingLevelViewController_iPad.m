//
//  SequencingLevelViewController_iPad.m
//  hongchiaac
//
//  Created by Ray.Liu on 2/20/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import "SequencingLevelViewController_iPad.h"

@implementation SequencingLevelViewController_iPad

#pragma - SequencingLevelViewController

- (IBAction)btnLevel_Click:(id)sender
{
    [super btnLevel_Click:sender];
    
    cardsetViewController = [[SequencingCardsetViewController_iPad alloc] initWithNavigationController:nil ParentController:self.myParentController ExtraData:self.myExtraData];
    
    [self.view addSubview:cardsetViewController.view];
}

@end
