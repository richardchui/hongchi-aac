//
//  SettingViewController.h
//  hongchiaac
//
//  Created by OEM on 24/1/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController{
    UISegmentedControl *scLang;
    UIButton *btnClose;
    UISwitch *switchSettingLock;
    
    UILabel *lblSettingLockReminder;
    UILabel *lblSettingLockTitle;
    UILabel *lblLangTitle;
    
    UILabel *lblSetting;
    
    UITextView *tvDisclaimer;
    
    UIImageView *ivIcon1;
    UIImageView *ivIcon2;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *scLang;
@property (nonatomic, retain) IBOutlet UIButton *btnClose;
@property (nonatomic, retain) IBOutlet UISwitch *switchSettingLock;
@property (nonatomic, retain) IBOutlet UILabel *lblSettingLockReminder;
@property (nonatomic, retain) IBOutlet UILabel *lblSettingLockTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblLangTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblSetting;
@property (nonatomic, retain) IBOutlet UITextView *tvDisclaimer;
@property (nonatomic, retain) IBOutlet UIImageView *ivIcon1;
@property (nonatomic, retain) IBOutlet UIImageView *ivIcon2;

-(IBAction)onChangeLang:(id)sender;
-(IBAction)onClickClose:(id)sender;
-(IBAction)onSwitchSettingLock:(id)sender;
@end
