//
//  SequencingSettingsCell.h
//  hongchiaac
//
//  Created by Ray.Liu on 12/19/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SequencingCardsetCell : UITableViewCell
{
    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *lblDescription;
    IBOutlet UITextField *txtCardsetID;
    IBOutlet UILabel *lblQuestionNumber;
    

    UIViewController *myParentController;
}



- (void)setTitle:(NSString *)title;
- (void)setQuestionNumberWithIndex:(int)index;
- (void)setDescription:(NSString *)desc;
- (void)setCardsetID:(NSString *)csid;
- (void)setParentController:(UIViewController *)parentController;

@end
