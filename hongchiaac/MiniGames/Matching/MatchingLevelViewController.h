//
//  MatchingLevelViewController.h
//  hongchiaac
//
//  Created by Ray.Liu on 1/29/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiniGameViewController.h"
#import "MatchingGameViewController.h"

@interface MatchingLevelViewController : MiniGameViewController
{

    
    IBOutlet UIButton *btnLevel1;
    IBOutlet UIButton *btnLevel2;
    IBOutlet UIButton *btnLevel3;
    IBOutlet UIButton *btnLevel4;
    IBOutlet UIButton *btnLevel5;
    IBOutlet UIButton *btnLevel6;
    
    IBOutlet UIButton *btnExit;
    
    IBOutlet UILabel *lblLowLevel;
    IBOutlet UILabel *lblHighLevel;
    
    int currentLevelIndex;
    MatchingGameViewController *gameViewController;
    
    UIView *viewInstructionTW;
    UIView *viewInstructionCN;
}

- (IBAction)btnLevel_Click:(id)sender;
- (IBAction)btnExit_Click:(id)sender;

@property (nonatomic, retain) IBOutlet UIView *viewInstructionTW;
@property (nonatomic, retain) IBOutlet UIView *viewInstructionCN;

-(IBAction)closeIntstruction:(id)sender;

@end
