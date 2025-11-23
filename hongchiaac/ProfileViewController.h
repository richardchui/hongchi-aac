//
//  ProfileViewController.h
//  hongchiaac
//
//  Created by OEM on 22/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//
#import <MessageUI/MFMailComposeViewController.h>
#import <UIKit/UIKit.h>
#import "Classes/UserProfile.h"

@interface ProfileViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIPickerViewDelegate, UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIPopoverControllerDelegate,UIActionSheetDelegate> {
    UITableView *tableViewProfiles;
    
    UIButton *btnClose;
    UIButton *btnAddNewProfile;
    UIButton *btnOpenEditAAC;
    UISegmentedControl *scLayout;
    UISegmentedControl *scVoice;
    UISegmentedControl *scCaption;
    UISegmentedControl *scSingleCardMode;
    UIView *viewContainer;    
    UIView *viewProfileDetail;
    UIView *viewAddProfile;
    UISwitch *switchSingleCardMode;
    UISwitch *switchTappingSpeak;
    UISwitch *switchLockSwiping;
    UISwitch *switchCaptionOnOff;
    UISwitch *switchShowSelectFrame;
    
    UILabel *lblName;
    UILabel *lblRemark;
    UILabel *lblSingleCardMode;
    UILabel *lblTappingSpeak;
    UILabel *lblLockSwiping;
    UILabel *lblLayout;
    UILabel *lblCaption;
    UILabel *lblSound;
    UILabel *lblShowSelectFrame;
    
    UITextField *txtProfileName;
    UIPickerView *pickerView;
    UIButton *btnConfirmNewProfile;
    UIButton *btnCancelNewProfile;
    
    UITextField *txtSelectedProfileName;
    UIButton *btnDeleteProfile;
    UIButton *btnChangeSelectedProfileName;
    
    UIButton *btnSetAsDefault;
    
    UITextView *tvRemark;
    UIButton *btnChangeRemark;
    
    UIImageView *imgViewProfilePic;
    UIButton *btnChangeProfilePic;
    UIButton *btnDeleteProfilePic;
    
    UIButton *btnChangeProfileList;
    
    UIButton *btnShareProfile;
    
    UILabel *lblProfilePic;
    
    NSDictionary *dictAllProfiles;
    NSMutableArray *arrAllProfiles;
    
    UserProfile *userProfileInEdit;
    UserProfile *userProfileToBeDeleted;

    //actionsheet
    NSString *actionSheetContentDeleteProfile;
    NSString *actionSheetContentDeleteProfilePic;
    NSString *actionSheetConfirm;
    NSString *actionSheetCancel;
    
    NSString *actionSheetCamera;
    NSString *actionSheetGallery;
    
    NSString *alertViewMsgNoProfile;
    
    UIImagePickerController *imagePickerController;
    UIPopoverController *popoverController;
    
    UILabel *lblNewProfileTitle;
    UILabel *lblNewProfileName;
    UILabel *lblNewProfileCopyTitle;
    
    NSString *strDontUse;
    NSString *alertMsgNoEmailAC;
    
}

@property (nonatomic,retain) IBOutlet UITableView *tableViewProfiles;
@property (nonatomic,retain) IBOutlet UIButton *btnClose;
@property (nonatomic,retain) IBOutlet UIButton *btnOpenEditAAC;
@property (nonatomic,retain) IBOutlet UIButton *btnAddNewProfile;
@property (nonatomic, retain) IBOutlet UIView *viewProfileDetail;
@property (nonatomic, retain) IBOutlet UIView *viewContainer;
@property (nonatomic,retain) IBOutlet UISegmentedControl *scLayout;
@property (nonatomic, retain) IBOutlet UISegmentedControl *scVoice;
@property (nonatomic, retain) IBOutlet UISegmentedControl *scCaption;
@property (nonatomic, retain) IBOutlet UISegmentedControl *scSingleCardMode;
@property (nonatomic, retain) IBOutlet UIView *viewAddProfile;
@property (nonatomic, retain) IBOutlet UITextField *txtProfileName;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UIButton *btnConfirmNewProfile;
@property (nonatomic, retain) IBOutlet UIButton *btnCancelNewProfile;
@property (retain, nonatomic) IBOutlet UILabel *lblProfilePic;

@property (nonatomic, retain) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UILabel *lblRemark;
@property (nonatomic, retain) IBOutlet UILabel *lblSingleCardMode;
@property (nonatomic, retain) IBOutlet UILabel *lblTappingSpeak;
@property (nonatomic, retain) IBOutlet UILabel *lblLockSwiping;
@property (nonatomic, retain) IBOutlet UILabel *lblLayout;
@property (nonatomic, retain) IBOutlet UILabel *lblCaption;
@property (nonatomic, retain) IBOutlet UILabel *lblSound;
@property (nonatomic, retain) IBOutlet UILabel *lblShowSelectFrame;

@property (nonatomic, retain) IBOutlet UITextField *txtSelectedProfileName;
@property (nonatomic, retain) IBOutlet UIButton *btnDeleteProfile;
@property (nonatomic, retain) IBOutlet UIButton *btnChangeSelectedProfileName;

@property (nonatomic, retain) IBOutlet UISwitch *switchSingleCardMode;
@property (nonatomic, retain) IBOutlet UISwitch *switchTappingSpeak;
@property (nonatomic, retain) IBOutlet UISwitch *switchLockSwiping;
@property (nonatomic, retain) IBOutlet UISwitch *switchCaptionOnOff;
@property (nonatomic, retain) IBOutlet UISwitch *switchShowSelectFrame;

@property (nonatomic, retain) IBOutlet UIButton *btnSetAsDefault;

@property (nonatomic, retain) IBOutlet UITextView *tvRemark;
@property (nonatomic, retain) IBOutlet UIButton *btnChangeRemark;

@property (nonatomic, retain) IBOutlet UIImageView *imgViewProfilePic;
@property (nonatomic, retain) IBOutlet UIButton *btnChangeProfilePic;
@property (nonatomic, retain) IBOutlet UIButton *btnDeleteProfilePic;

@property (nonatomic, retain) IBOutlet UIButton *btnShareProfile;

@property (nonatomic, retain) IBOutlet UIButton *btnChangeProfileList;

@property (nonatomic, retain) IBOutlet UILabel *lblNewProfileTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblNewProfileName;
@property (nonatomic, retain) IBOutlet UILabel *lblNewProfileCopyTitle;

-(void)editUserProfile:(UserProfile *)profile;
-(void)reloadTableView;

-(IBAction)onClickClose:(id)sender;
-(IBAction)onLayoutChanged;
-(IBAction)onVoiceChanged:(id)sender;
-(IBAction)onCaptionChanged:(id)sender;
-(IBAction)onSingleCardChanged:(id)sender;
-(IBAction)onClickAddNewProfile:(id)sender;

-(IBAction)onClickConfirmNewProfile:(id)sender;
-(IBAction)onClickCancelNewProfile:(id)sender;

-(IBAction)onClickDeleteProfile:(id)sender;

-(IBAction)onClickChangeSelectedProfileName:(id)sender;

-(IBAction)onSwitchSingleCardMode:(id)sender;
-(IBAction)onSwitchTappingSpeak:(id)sender;
-(IBAction)onSwitchLockSwiping:(id)sender;
-(IBAction)onSwitchCaptionOnOff:(id)sender;
-(IBAction)onSwitchShowSelectFrame:(id)sender;

-(IBAction)onClickSetAsDefault:(id)sender;
-(IBAction)onClickChangeRemark:(id)sender;

-(IBAction)onClickEditProfileList:(id)sender;

-(IBAction)onClickShareProfile:(id)sender;

-(IBAction)onClickChangeProfilePic:(id)sender;
-(IBAction)onClickDeleteProfilePic:(id)sender;
-(IBAction)onClickOpenEditAAC:(id)sender;

-(void)saveProfileImage:(UIImage *)image;
@end
