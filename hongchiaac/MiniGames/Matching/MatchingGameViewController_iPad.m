//
//  MatchingViewController_iPad.m
//  hongchiaac
//
//  Created by Ray.Liu on 12/4/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "MatchingGameViewController_iPad.h"
#import "MatchingScoreViewController_iPad.h"

@implementation MatchingGameViewController_iPad

#pragma - MatchingGameViewController

- (IBAction)btnPlayQuestionSound_Click:(id)sender
{
    [super btnPlayQuestionSound_Click:sender];
}

- (IBAction)btnNext_Click:(id)sender
{
    [super btnNext_Click:sender];
}

- (IBAction)btnRandom_Click:(id)sender
{
    [super btnRandom_Click:sender];
}

- (IBAction)btnScore_Click:(id)sender
{
    [super initScoreResult];
    
    scoreViewController = [[MatchingScoreViewController_iPad alloc] initWithNavigationController:self.myNavigationController ParentController:self ExtraData:scoreResult];
    
    [super btnScore_Click:sender];
}

- (IBAction)btnExit_Click:(id)sender
{
    [super btnExit_Click:sender];
}

- (void)reloadGameView
{
    [super reloadGameView];
}

@end
