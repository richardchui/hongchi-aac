//
//  SequencingScoreViewController.h
//  hongchiaac
//
//  Created by Ray.Liu on 2/21/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../MiniGameViewController.h"

@interface SequencingScoreViewController : MiniGameViewController
{
    IBOutlet UIButton *btnClose;
    IBOutlet UILabel *lblTotalAnswerCount;
    IBOutlet UILabel *lblCorrectAnswerCount;
    IBOutlet UILabel *lblWrongAnswerCount;
    IBOutlet UILabel *lblMissingAnswerCount;
    
    IBOutlet UILabel *lblTotal;
    IBOutlet UILabel *lblTotalCorrect;
    IBOutlet UILabel *lblTotalWrong;
}

- (IBAction)btnClose_Click:(id)sender;
- (void)exit;

@end
