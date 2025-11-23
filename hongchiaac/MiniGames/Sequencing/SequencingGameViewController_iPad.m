//
//  SequencingGameViewController_iPad.m
//  hongchiaac
//
//  Created by Ray.Liu on 12/11/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "SequencingGameViewController_iPad.h"
#import "SequencingCardsetViewController_iPad.h"

@implementation SequencingGameViewController_iPad

#pragma - SequencingGameViewController

- (IBAction)btnExit_Click:(id)sender
{
    [super btnExit_Click:sender];
}

- (void)showResultPage
{
    [super initScoreResult];
    
    sequencingScoreViewController = [[SequencingScoreViewController_iPad alloc] initWithNavigationController:self.myNavigationController ParentController:self ExtraData:scoreResult];
    
    [super showResultPage];
}

@end