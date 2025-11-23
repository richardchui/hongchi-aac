//
//  SequencingSettingsViewController.h
//  hongchiaac
//
//  Created by Ray.Liu on 12/19/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../MiniGameViewController.h"

@class SequencingGameViewController;
@class UserProfile;
@class AACCard;
@class UserCard;

@interface SequencingCardsetViewController : MiniGameViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIButton *btnClose;
    IBOutlet UITableView *myTableView;
    NSMutableArray *myData;
    
    IBOutlet UILabel *lblGameName;
    
    SequencingGameViewController *sequencingGameViewController;
    

}

- (IBAction)btnClose_Click:(id)sender;
- (void)exit;
- (NSMutableArray *)getCardSetList;
- (void)loadList;



@end
