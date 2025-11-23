//
//  SequencingSettingsCell.m
//  hongchiaac
//
//  Created by Ray.Liu on 12/19/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "SequencingCardsetCell.h"
#import "../../AACCard.h"
#import "../../Utils.h"
#import "SequencingCardsetViewController.h"

@implementation SequencingCardsetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    [lblTitle setText:title];
}
- (void)setQuestionNumberWithIndex:(int)index{
    if(index==0)[lblQuestionNumber setText:@"A"];
    if(index==1)[lblQuestionNumber setText:@"B"];
    if(index==2)[lblQuestionNumber setText:@"C"];
    if(index==3)[lblQuestionNumber setText:@"D"];
    if(index==4)[lblQuestionNumber setText:@"E"];
    if(index==5)[lblQuestionNumber setText:@"F"];
    if(index==6)[lblQuestionNumber setText:@"G"];
    if(index==7)[lblQuestionNumber setText:@"H"];
    if(index==8)[lblQuestionNumber setText:@"I"];
    if(index==9)[lblQuestionNumber setText:@"J"];
    if(index==10)[lblQuestionNumber setText:@"K"];
    if(index==11)[lblQuestionNumber setText:@"L"];
    if(index==12)[lblQuestionNumber setText:@"M"];
    if(index==13)[lblQuestionNumber setText:@"N"];
    if(index==14)[lblQuestionNumber setText:@"O"];
    if(index==15)[lblQuestionNumber setText:@"P"];
    if(index==16)[lblQuestionNumber setText:@"Q"];
    if(index==17)[lblQuestionNumber setText:@"R"];
    if(index==18)[lblQuestionNumber setText:@"S"];
    if(index==19)[lblQuestionNumber setText:@"T"];
    if(index==20)[lblQuestionNumber setText:@"U"];
    if(index==21)[lblQuestionNumber setText:@"V"];
    if(index==22)[lblQuestionNumber setText:@"W"];
    if(index==23)[lblQuestionNumber setText:@"X"];
    if(index==24)[lblQuestionNumber setText:@"Y"];
    if(index==25)[lblQuestionNumber setText:@"Z"];
}
- (void)setDescription:(NSString *)desc
{
    [lblDescription setText:desc];
}

- (void)setCardsetID:(NSString *)csid
{
    [txtCardsetID setText:csid];
}

- (void)setParentController:(UIViewController *)parentController
{
    myParentController = parentController;
}

@end
