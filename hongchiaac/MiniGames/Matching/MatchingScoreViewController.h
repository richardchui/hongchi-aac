//
//  MatchingScoreViewController.h
//  hongchiaac
//
//  Created by Ray.Liu on 12/5/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../MiniGameViewController.h"

@interface MatchingScoreViewController : MiniGameViewController
{
    IBOutlet UIButton *btnClose;
    IBOutlet UILabel *lblTotalAnswerCount;
    IBOutlet UILabel *lblCorrectAnswerCount;
    IBOutlet UILabel *lblWrongAnswerCount;
    IBOutlet UILabel *lblMissingAnswerCount;
    
    IBOutlet UILabel *lblFinishGameMessage;
    IBOutlet UILabel *lblScore;
}

- (IBAction)btnClose_Click:(id)sender;
- (void)exit;

@end
