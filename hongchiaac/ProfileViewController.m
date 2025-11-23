//
//  ProfileViewController.m
//  hongchiaac
//
//  Created by OEM on 22/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "ProfileViewController.h"
#import "Handlers/ProfileHandler.h"
#import "Handlers/SettingHandler.h"
#import "Classes/UserProfile.h"
#import "EditAACViewController.h"
#import "Constants.h"
#import "Utils.h"
#import "xlib/Objective-Zip/ZipFile.h"
#import "xlib/Objective-Zip/ZipWriteStream.h"
#import "AppDelegate.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize tableViewProfiles;
@synthesize btnAddNewProfile,btnClose;
@synthesize viewProfileDetail;
@synthesize viewContainer;
@synthesize scLayout;
@synthesize btnOpenEditAAC;
@synthesize scVoice;
@synthesize scCaption;
@synthesize viewAddProfile;
@synthesize txtProfileName,btnCancelNewProfile,btnConfirmNewProfile,pickerView;
@synthesize txtSelectedProfileName,btnDeleteProfile;
@synthesize btnChangeSelectedProfileName;
@synthesize switchSingleCardMode,switchTappingSpeak;
@synthesize btnSetAsDefault;
@synthesize tvRemark, btnChangeRemark;
@synthesize switchLockSwiping;
@synthesize switchCaptionOnOff;
@synthesize lblName, lblRemark, lblSingleCardMode, lblTappingSpeak, lblLockSwiping, lblLayout, lblCaption,lblSound;
@synthesize imgViewProfilePic, btnChangeProfilePic, btnDeleteProfilePic;
@synthesize btnChangeProfileList;
@synthesize scSingleCardMode;
@synthesize btnShareProfile;
@synthesize lblProfilePic;
@synthesize lblNewProfileCopyTitle, lblNewProfileName, lblNewProfileTitle;
@synthesize switchShowSelectFrame;
@synthesize lblShowSelectFrame;

#define PLIST_PROFILE @"profiles.plist"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    NSDictionary *content = [Utils getContentFromPlist:PLIST_PROFILE];     
    
    dictAllProfiles = [[NSDictionary alloc] initWithDictionary:[ProfileHandler getAllProfiles]];
    //NSLog(@"list all profile in profileView : %@",dictAllProfiles);
    //dictAllProfiles = [[NSDictionary alloc] init];
    
    arrAllProfiles = [[NSMutableArray alloc] init];
    for (NSString* key in dictAllProfiles) {
        
        [arrAllProfiles addObject:[[UserProfile alloc] initWithProfileID:key withPlist:content]];
        //[arrAllProfiles addObject:[[UserProfile alloc] initWithProfileID:key]];
    }
    
    [self reorderProfileArray];
    
    [content release];
    
    return self;
}
- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCloseEditAAC:) name:@"onCloseEditAAC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicatoinChangeLang:) name:@"applicatoinChangeLang" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadListForImportedProfile:) name:@"reloadListForImportedProfile" object:nil];
    //[self setLanguage:[SettingHandler getApplicationLanguage]];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setLanguage:[SettingHandler getApplicationLanguage]];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onCloseEditAAC" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicatoinChangeLang" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadListForImportedProfile" object:nil];
    
    [scSingleCardMode release];
    [tableViewProfiles release];
    [btnClose release];
    [btnAddNewProfile release];
    [btnOpenEditAAC release];
    [scLayout release];
    [scVoice release];
    [viewContainer release];
    [viewProfileDetail release];
    [viewAddProfile release];
    [switchSingleCardMode release];
    [switchTappingSpeak release];
    [switchLockSwiping release];
    [switchCaptionOnOff release];
    
    [txtProfileName release];
    [pickerView release];
    [btnConfirmNewProfile release];
    [btnCancelNewProfile release];
    
    [txtSelectedProfileName release];
    [btnDeleteProfile release];
    [btnChangeSelectedProfileName release];
    
    [btnSetAsDefault release];
    
    [tvRemark release];
    [btnChangeRemark release];
    //[dictAllProfiles release];
    //[arrAllProfiles release];
    
    [lblName release];
    [lblRemark release];
    [lblSingleCardMode release];
    [lblTappingSpeak release];
    [lblLockSwiping release];
    [lblLayout release];
    [lblCaption release];
    [lblSound release];
    [lblProfilePic release];
    
    [btnShareProfile release];
    
    //lblNewProfileCopyTitle, lblNewProfileName, lblNewProfileTitle;
    [lblNewProfileCopyTitle release];
    [lblNewProfileName release];
    [lblNewProfileTitle release];
    
    [lblShowSelectFrame release];
    [switchShowSelectFrame release];
    
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    //return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(void)editUserProfile:(UserProfile *)profile{
    //userProfileInEdit = [[UserProfile alloc] init];
    userProfileInEdit = profile;
    [txtSelectedProfileName setText:[profile getName]];
    [scLayout setSelectedSegmentIndex:[userProfileInEdit getLayout]-1];
    [scVoice setSelectedSegmentIndex:[userProfileInEdit getVoiceMode]-1];
    [scCaption setSelectedSegmentIndex:[userProfileInEdit getCaptionMode]];
    [switchSingleCardMode setOn:[userProfileInEdit getSingleCardMode]];
    [switchTappingSpeak setOn:[userProfileInEdit getTappingSpeak]];
    [switchLockSwiping setOn:[userProfileInEdit getLockSwiping]];
    [switchCaptionOnOff setOn:[userProfileInEdit getCaptionOnOff]];
    [switchShowSelectFrame setOn:[userProfileInEdit getShowSelectFrame]];
    
    if([userProfileInEdit getSingleCardMode]){
        [scSingleCardMode setSelectedSegmentIndex:0];
        [switchTappingSpeak setEnabled:NO];
    }else{
        [scSingleCardMode setSelectedSegmentIndex:1];
        [switchTappingSpeak setEnabled:YES];
    }
    
    [tvRemark setText:[userProfileInEdit getRemark]];
    
    if([[profile getProfileID] isEqualToString:[SettingHandler getDefaultProfileID]]){
        [btnSetAsDefault setSelected:YES];
        [btnSetAsDefault setHighlighted:YES];
    }else{
        [btnSetAsDefault setSelected:NO];
        [btnSetAsDefault setHighlighted:NO];
    }
    
    NSString *imagePath = [[NSString alloc] initWithFormat:@"/profiles/%@/%@.jpg",[profile getProfileID],@"profilepic"];
    //NSLog(@"profile image path : %@",[Utils getFullPath:imagePath]);
    if([Utils isFileExist:imagePath]){
        imgViewProfilePic.image = [UIImage imageWithContentsOfFile:[Utils getFullPath:imagePath]];
    }else{
        imgViewProfilePic.image = [UIImage imageNamed:@"default_profile_picture.jpg"];
    }
    [imagePath release];
}
-(void)deleteUserProfile:(UserProfile *)profile{
    //code in sub class
}
-(void)reloadTableView{
    //dictAllProfiles = [[NSDictionary alloc] initWithDictionary:[ProfileHandler getAllProfiles]];
    dictAllProfiles = [ProfileHandler getAllProfiles];
    [arrAllProfiles release];
    arrAllProfiles = [[NSMutableArray alloc] init];
    for (NSString* key in dictAllProfiles) {
        [arrAllProfiles addObject:[[UserProfile alloc] initWithProfileID:key]];
    }
    [self reorderProfileArray];
    [tableViewProfiles reloadData];
}

-(void)toggleProfileListEditMode:(BOOL)isOn{
    [tableViewProfiles setEditing:isOn];
    
    if(isOn){
        [viewProfileDetail setUserInteractionEnabled:NO];
        [viewProfileDetail setAlpha:0.5];
        [btnAddNewProfile setEnabled:NO];
        [btnDeleteProfile setEnabled:NO];
        [btnClose setEnabled:NO];
        
    }else{
        [viewProfileDetail setUserInteractionEnabled:YES];
        [viewProfileDetail setAlpha:1];
        [btnAddNewProfile setEnabled:YES];
        [btnDeleteProfile setEnabled:YES];
        [btnClose setEnabled:YES];
        
        [tableViewProfiles reloadData];
    }
}
-(void)reorderProfileArray{
    

    NSMutableArray *sortedArray = [[NSMutableArray alloc] initWithArray:[arrAllProfiles sortedArrayUsingSelector:@selector(compare:)]];

    /*
    for(int i=0; i<[sortedArray count]; i++){
        //NSLog(@"-%d",[[arrAllProfiles objectAtIndex:i] getOrder]);
        [[sortedArray objectAtIndex:i] updateOrder:i];
    }
     */
    
    [arrAllProfiles release];
    arrAllProfiles = sortedArray;
    sortedArray = nil;
    //[sortedArray release];

    
}
#pragma event handler
-(IBAction)onClickClose:(id)sender{
    //if([dictAllProfiles count]>0 && userProfileInEdit != nil)
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"closeProfileMenu" object:userProfileInEdit];
    if([dictAllProfiles count]>0 && userProfileInEdit != nil){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
        [self performSelector:@selector(closeAndGoToAAC) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
    }else{
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:alertViewMsgNoProfile delegate:nil cancelButtonTitle:actionSheetConfirm otherButtonTitles:nil];
        [av show];
        [av release];
    }
}
-(void)closeAndGoToAAC{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"changeProfileWithProfileID" object:userProfileInEdit];    
}
-(IBAction)onLayoutChanged{
//    NSLog(@"%d",[scLayout selectedSegmentIndex]);
    [userProfileInEdit updateLayout:[scLayout selectedSegmentIndex]+1];
}
-(IBAction)onVoiceChanged:(id)sender{
    [userProfileInEdit updateVoiceMode:[scVoice selectedSegmentIndex]+1];
}
-(IBAction)onCaptionChanged:(id)sender{
    [userProfileInEdit updateCaptionMode:[scCaption selectedSegmentIndex]];
}
-(IBAction)onSingleCardChanged:(id)sender{
    NSLog(@"onSingeCardChaged:%d", [scSingleCardMode selectedSegmentIndex]);
    if([scSingleCardMode selectedSegmentIndex]==0){
        [userProfileInEdit updateSingleCardMode:YES];
        [switchTappingSpeak setEnabled:NO];
    }else{
        [userProfileInEdit updateSingleCardMode:NO];
        [switchTappingSpeak setEnabled:YES];
    }
}
-(IBAction)onClickAddNewProfile:(id)sender{
    [txtProfileName setText:@""];
    [self.view addSubview:viewAddProfile];
    [pickerView reloadAllComponents];
}
-(IBAction)onClickConfirmNewProfile:(id)sender{
    NSLog(@"name : %@",[txtProfileName text]);
    //NSLog(@"profile index : %d", [pickerView selectedRowInComponent:0]);
    int selectedProfileIndex = [pickerView selectedRowInComponent:0];
    
    if(selectedProfileIndex>0){
        UserProfile *userProfile = [arrAllProfiles objectAtIndex:selectedProfileIndex-1];
        
        [ProfileHandler addProfileWithName:[txtProfileName text] userProfile:userProfile];
    }else{
        [ProfileHandler addProfileWithName:[txtProfileName text]];
    }
    
    [viewAddProfile removeFromSuperview];
    [self reloadTableView];
}
-(IBAction)onClickCancelNewProfile:(id)sender{
    [viewAddProfile removeFromSuperview];
}
-(IBAction)onClickDeleteProfile:(id)sender{
    
    if(userProfileInEdit == nil){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:alertViewMsgNoProfile delegate:nil cancelButtonTitle:nil otherButtonTitles:actionSheetConfirm, nil];
        [av show];
        [av release];
    }else{
    
        UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:actionSheetContentDeleteProfile delegate:self cancelButtonTitle:nil destructiveButtonTitle:actionSheetConfirm otherButtonTitles:actionSheetCancel,nil];
        [ac setTag:1];
        [ac showInView:self.view];
        [ac release];
    }
}
-(IBAction)onClickChangeSelectedProfileName:(id)sender{
    [userProfileInEdit updateProfileName:txtSelectedProfileName.text];
    [self reloadTableView];    
}
-(IBAction)onSwitchSingleCardMode:(id)sender{
    [userProfileInEdit updateSingleCardMode:[switchSingleCardMode isOn]];
}
-(IBAction)onSwitchTappingSpeak:(id)sender{
    [userProfileInEdit updateTappingSpeak:[switchTappingSpeak isOn]];
}
-(IBAction)onSwitchLockSwiping:(id)sender{
    [userProfileInEdit updateLockSwiping:[switchLockSwiping isOn]];
}
-(IBAction)onSwitchCaptionOnOff:(id)sender{
    [userProfileInEdit updateCaptionOnOff:[switchCaptionOnOff isOn]];
}
-(IBAction)onSwitchShowSelectFrame:(id)sender{
    [userProfileInEdit updateShowSelectFrame:[switchShowSelectFrame isOn]];
}
-(IBAction)onClickSetAsDefault:(id)sender{
    if([btnSetAsDefault isSelected]){
        [btnSetAsDefault setSelected:NO];
        [btnSetAsDefault setHighlighted:NO];
        
        [SettingHandler setDefaultProfileWithProfileID:@""];
    }else{
        UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@"This action will override the existing default profile. Do you want to process?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:actionSheetConfirm otherButtonTitles:actionSheetCancel,nil];
        [ac setTag:2];
        [ac showInView:self.view];
        [ac release];
    }
}
-(IBAction)onClickChangeRemark:(id)sender{
    [userProfileInEdit updateRemark:tvRemark.text];   
}
-(IBAction)onClickEditProfileList:(id)sender{
    [self toggleProfileListEditMode:![tableViewProfiles isEditing]];

}
-(IBAction)onClickShareProfile:(id)sender{
    [self displayComposerSheet];
}
-(IBAction)onClickChangeProfilePic:(id)sender{
    //[self openDeviceCamera:sender];
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:actionSheetCamera,actionSheetGallery,actionSheetCancel,nil ];
    as.tag = 3;
    [as showInView:self.view];
    [as release];
                         
}
-(IBAction)onClickDeleteProfilePic:(id)sender{
        
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:actionSheetContentDeleteProfilePic delegate:self cancelButtonTitle:nil destructiveButtonTitle:actionSheetConfirm otherButtonTitles:actionSheetCancel,nil];
    [ac setTag:4];
    [ac showInView:self.view];
    [ac release];

}
-(IBAction)onClickOpenEditAAC:(id)sender{
    
}
#pragma tableView
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dictAllProfiles count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellStyle style = UITableViewCellStyleDefault;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseCell"];
    
    
    if(!cell)cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:@"BaseCell"] autorelease];
    
    
    cell.textLabel.text = [(UserProfile *)[arrAllProfiles objectAtIndex:[indexPath row]] getName];
    
    
    if([[userProfileInEdit getProfileID] isEqualToString:[(UserProfile *)[arrAllProfiles objectAtIndex:[indexPath row]] getProfileID]]){
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.editingAccessoryType = UITableViewCellAccessoryNone;
    cell.showsReorderControl = YES;
     
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    NSString *userName = [(UserProfile *)[arrAllProfiles objectAtIndex:[indexPath row]] getName];
    
    if([userName isEqualToString:[userProfileInEdit getName]]){
        //cell.backgroundColor = [UIColor ];
        //[cell setSelected:YES];
    }
    */
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"changeProfileWithProfileID" object:(UserProfile *)[arrAllProfiles objectAtIndex:[indexPath row]]];
    //NSLog(@"selectRow : %@",[(UserProfile *)[arrAllProfiles objectAtIndex:[indexPath row]] getName]);
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"test %d",[indexPath row]);
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSLog(@"moveRowAtIndexPath %d, %d",[sourceIndexPath row],[destinationIndexPath row]);
    [ProfileHandler reorderProfileFromIndex:[sourceIndexPath row] toIndex:[destinationIndexPath row]];
    //[self reorderProfileArray];
    //[tableViewProfiles reloadData];
    [self reloadTableView];
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
    //return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    userProfileToBeDeleted = (UserProfile *)[arrAllProfiles objectAtIndex:[indexPath row]];
    
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:actionSheetContentDeleteProfile delegate:self cancelButtonTitle:nil destructiveButtonTitle:actionSheetConfirm otherButtonTitles:actionSheetCancel,nil];
    [ac setTag:1];
    [ac showInView:self.view];
    [ac release];
}
#pragma pickerView
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [dictAllProfiles count]+1;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(row==0){
        return strDontUse;//@"[不使用]";
    }else{
        return [(UserProfile *)[arrAllProfiles objectAtIndex:row-1] getName];
    }
}

#pragma actionsheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([actionSheet tag] == 1){
        if (buttonIndex == 0) {
            [self deleteUserProfile:userProfileInEdit];
            //NSLog(@"deleteing: %@ , %@",userProfileInEdit, userProfileToBeDeleted);
            //[self deleteUserProfile:userProfileToBeDeleted];
            
            
            //[userProfileToBeDeleted release];
            //userProfileToBeDeleted = nil;
        }
    }
    
    if([actionSheet tag] == 2){
        if(buttonIndex== 0){
            NSLog(@">> set as default");
            [btnSetAsDefault setSelected:YES];
            [btnSetAsDefault setHighlighted:YES];
            
            [SettingHandler setDefaultProfileWithProfileID:[userProfileInEdit getProfileID]];
        }
    }
    if([actionSheet tag] == 3){
        if(buttonIndex==0){
            [self openDeviceCamera:nil];
        }
        if(buttonIndex==1){
            [self openDeviceLibrary:nil];
        }
    }
    if([actionSheet tag] == 4){
        if (buttonIndex == 0) {
            NSString *path= [[NSString alloc] initWithFormat:@"/profiles/%@/",[userProfileInEdit getProfileID]];
            [Utils deleteImage:@"profilepic" path:path];
            
            [imgViewProfilePic setImage:[UIImage imageNamed:@"default_profile_picture.jpg"]];
            
            [path release];
        }
    }
}

-(void) onCloseEditAAC:(NSNotification *)notification{
    
}

#pragma language
-(void)onApplicatoinChangeLang:(NSNotification *)notification{
    [self setLanguage:notification.object];
    NSLog(@"applicatoinChangeLang : profileviewcontroller");    
}
-(void)setLanguage:(NSString *)lang{
    
    if([lang isEqualToString:[Constants getLanguageCodeTW]]){
        
        [lblName setText:[Utils getText:@"名稱" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"]];
        [lblRemark setText:[Utils getText:@"備註" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"]];
        [btnChangeSelectedProfileName setTitle:[Utils getText:@"確定" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"] forState:UIControlStateNormal];
        [btnChangeRemark setTitle:[Utils getText:@"確定" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"] forState:UIControlStateNormal];
        [lblSingleCardMode setText:[Utils getText:@"句子列" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"]];
        [lblTappingSpeak setText:[Utils getText:@"按卡發聲" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"]];
        [lblLockSwiping setText:[Utils getText:@"鎖定滑動翻頁" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"]];
        [lblLayout setText:[Utils getText:@"排列" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"]];
        [lblCaption setText:[Utils getText:@"標題" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"]];
        [lblShowSelectFrame setText:[Utils getText:@"顯示選擇框" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"]];
        
        [lblSound setText:[Utils getText:@"聲音" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"]];
        [btnOpenEditAAC setTitle:[Utils getText:@"編輯圖卡" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"] forState:UIControlStateNormal];
        [btnDeleteProfile setTitle:[Utils getText:@"刪除檔案" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"] forState:UIControlStateNormal];
        
        [btnSetAsDefault setTitle:[Utils getText:@"主頁面顯示" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"] forState:UIControlStateNormal];
        
        actionSheetContentDeleteProfile = [Utils getText:@"你確定要刪除這個檔案?" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"];
        actionSheetContentDeleteProfilePic = [Utils getText:@"你確定要還原為預設圖案嗎?" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"];        
        actionSheetConfirm = [Utils getText:@"確定" ForLang:[Constants getLanguageCodeTW] atView:@"ActionSheet"];
        actionSheetCancel = [Utils getText:@"取消" ForLang:[Constants getLanguageCodeTW] atView:@"ActionSheet"];
        
        actionSheetCamera = [Utils getText:@"相機" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"];
        actionSheetGallery = [Utils getText:@"相簿" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"];

        [btnChangeProfilePic setTitle:[Utils getText:@"更改" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"] forState:UIControlStateNormal];
        [btnDeleteProfilePic setTitle:[Utils getText:@"預設圖案" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"] forState:UIControlStateNormal];
        
        [btnShareProfile setTitle:[Utils getText:@"分享檔案" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"] forState:UIControlStateNormal];
        
        [lblProfilePic setText:[Utils getText:@"檔案相片" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"]];
        
        [btnConfirmNewProfile setTitle:[Utils getText:@"確定" ForLang:[Constants getLanguageCodeTW] atView:@"ActionSheet"] forState:UIControlStateNormal];
        [btnCancelNewProfile setTitle:[Utils getText:@"取消" ForLang:[Constants getLanguageCodeTW] atView:@"ActionSheet"] forState:UIControlStateNormal];
        
        [btnClose setTitle:[Utils getText:@"開啟溝通簿" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"] forState:UIControlStateNormal];
        
        
        alertViewMsgNoProfile = @"請選擇檔案";
        
        [lblNewProfileTitle setText:[Utils getText:@"新增檔案" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"]];
        [lblNewProfileName setText:[Utils getText:@"名稱" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"]];
        [lblNewProfileCopyTitle setText:[Utils getText:@"複製現有檔案" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"]];
        strDontUse = [Utils getText:@"建立新檔案" ForLang:[Constants getLanguageCodeTW] atView:@"ProfileViewController"];
        alertMsgNoEmailAC = @"未能進行檔案分享，請先到iOS裝置的「設定」新增電郵帳號";
    }
    
    if([lang isEqualToString:[Constants getLanguageCodeCN]]){
        
     
     [lblName setText:[Utils getText:@"名稱" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"]];
     [lblRemark setText:[Utils getText:@"備註" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"]];
     [btnChangeSelectedProfileName setTitle:[Utils getText:@"確定" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"] forState:UIControlStateNormal];
     [btnChangeRemark setTitle:[Utils getText:@"確定" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"] forState:UIControlStateNormal];
     [lblSingleCardMode setText:[Utils getText:@"句子列" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"]];
     [lblTappingSpeak setText:[Utils getText:@"按卡發聲" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"]];
     [lblLockSwiping setText:[Utils getText:@"鎖定滑動翻頁" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"]];
     [lblLayout setText:[Utils getText:@"排列" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"]];
     [lblCaption setText:[Utils getText:@"標題" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"]];
     [lblSound setText:[Utils getText:@"聲音" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"]];
     [lblShowSelectFrame setText:[Utils getText:@"顯示選擇框" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"]];
        
     [btnOpenEditAAC setTitle:[Utils getText:@"編輯圖卡" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"] forState:UIControlStateNormal];
     [btnDeleteProfile setTitle:[Utils getText:@"刪除檔案" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"] forState:UIControlStateNormal];
     
     [btnSetAsDefault setTitle:[Utils getText:@"主頁面顯示" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"] forState:UIControlStateNormal];
        
     actionSheetContentDeleteProfile = [Utils getText:@"你確定要刪除這個檔案?" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"];
     actionSheetContentDeleteProfilePic = [Utils getText:@"你確定要還原為預設圖案嗎?" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"];
     actionSheetConfirm = [Utils getText:@"確定" ForLang:[Constants getLanguageCodeCN] atView:@"ActionSheet"];
     actionSheetCancel = [Utils getText:@"取消" ForLang:[Constants getLanguageCodeCN] atView:@"ActionSheet"];
        
        actionSheetCamera = [Utils getText:@"相機" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"];
        actionSheetGallery = [Utils getText:@"相簿" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"];
        
        [btnChangeProfilePic setTitle:[Utils getText:@"更改" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"] forState:UIControlStateNormal];
        [btnDeleteProfilePic setTitle:[Utils getText:@"預設圖案" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"] forState:UIControlStateNormal];
        
        [btnShareProfile setTitle:[Utils getText:@"分享檔案" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"] forState:UIControlStateNormal];
        
        [lblProfilePic setText:[Utils getText:@"檔案相片" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"]];
        
        [btnConfirmNewProfile setTitle:[Utils getText:@"確定" ForLang:[Constants getLanguageCodeCN] atView:@"ActionSheet"] forState:UIControlStateNormal];
        [btnCancelNewProfile setTitle:[Utils getText:@"取消" ForLang:[Constants getLanguageCodeCN] atView:@"ActionSheet"] forState:UIControlStateNormal];
        
        [btnClose setTitle:[Utils getText:@"開啟溝通簿" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"] forState:UIControlStateNormal];
        
        [lblNewProfileTitle setText:[Utils getText:@"新增檔案" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"]];
        [lblNewProfileName setText:[Utils getText:@"名稱" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"]];
        [lblNewProfileCopyTitle setText:[Utils getText:@"複製現有檔案" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"]];
        strDontUse = [Utils getText:@"建立新檔案" ForLang:[Constants getLanguageCodeCN] atView:@"ProfileViewController"];
        alertMsgNoEmailAC = @"未能进行档案分享，请先到iOS装置的「设置」新增电邮帐号";
    }
    
}

#pragma share&mail
-(void)displayComposerSheet
{

    
    if(![MFMailComposeViewController canSendMail]){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:alertMsgNoEmailAC delegate:nil cancelButtonTitle:actionSheetConfirm otherButtonTitles: nil];//actionSheetCancel
        [av show];
        [av release];
        return;
    }
    
    NSError *error = nil;
    NSString *path= [[NSString alloc] initWithFormat:@"/profiles/%@/",[userProfileInEdit getProfileID]];
    if([Utils isDirectoryExist:path]){
        NSLog(@"exit folder");
    }else{
        NSLog(@"not exit folder");        
    }

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *zipLibrary = [paths objectAtIndex:0];
    NSString *fullPathToFile = [zipLibrary stringByAppendingPathComponent:@"backUp.zip"];

    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:fullPathToFile]){
        [Utils deleteFileInGiveFullPath:fullPathToFile];
    }
    
    ZipFile *zipFile = [[ZipFile alloc] initWithFileName:fullPathToFile mode:ZipFileModeCreate];
    
    //zip for all custom image and audio files
    NSArray *files = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:[Utils getFullPath:path] error:&error];
    for(int i = 0;i<files.count;i++){
        id myArrayElement = [files  objectAtIndex:i];
        
        ZipWriteStream *stream = [zipFile writeFileInZipWithName:myArrayElement compressionLevel:ZipCompressionLevelBest];
        [stream writeData:[NSData dataWithContentsOfFile:[Utils getFullPath:[NSString stringWithFormat:@"%@/%@",path,myArrayElement]]]];
        [stream finishedWriting];
    }
    
    //so here, we have to make a plist that contain profile content
    //NSDictionary *profileDictionary = [ProfileHandler getProfileWithID:[userProfileInEdit getProfileID]];
    NSMutableDictionary *profileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[ProfileHandler getProfileWithID:[userProfileInEdit getProfileID]]];
    [profileDictionary setObject:@"" forKey:@"remark"];
    
    NSString *saveToFilePath = [Utils getFullPath:@"profile_content.plist"];
    if([fm fileExistsAtPath:saveToFilePath]){
        [Utils deleteFileInGiveFullPath:saveToFilePath];
    }
    [profileDictionary writeToFile:saveToFilePath atomically:YES];
    
    ZipWriteStream *steam = [zipFile writeFileInZipWithName:@"profile_content.plist" compressionLevel:ZipCompressionLevelBest];
    [steam writeData:[NSData dataWithContentsOfFile:saveToFilePath]];
    [steam finishedWriting];
    /////////////////////////////////
    
    [zipFile close];    
    [profileDictionary release];
    
    ////////////////
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    

    
    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeCN]]){
        [picker setSubject:@"「匡智沟通易」学员档案分享"];        
    }else{
        [picker setSubject:@"「匡智溝通易」學員檔案分享"];
    }

    
    // Attach the zipped profile to the email
    [picker addAttachmentData:[NSData dataWithContentsOfFile:fullPathToFile] mimeType:@"application/zip" fileName:[NSString stringWithFormat:@"%@.aacprofile",[userProfileInEdit getName]]];
    
    // Fill out the email body text
    NSString *emailBody;
    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeCN]]){
        emailBody = @"我刚建立了一个学员档案并想与你分享！\n\n请透过iPad, iPhone或iPod Touch内置的「邮件」下载并开启附件。";
    }else{
        emailBody = @"我剛建立了一個學員檔案並想與你分享！\n\n請透過iPad, iPhone或iPod Touch內置的「郵件」下載並開啟附件。";
    }
    [picker setMessageBody:emailBody isHTML:NO];
//    [self presentModalViewController:picker animated:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.viewController presentModalViewController:picker animated:YES];
    
    [picker release];
     
}
- (void)prepareTheZippedProfile{

    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //this function overrided by iphone
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
 //   [self dismissModalViewControllerAnimated:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.viewController dismissModalViewControllerAnimated:YES];
}

//device camera//////////////////////////////
-(void)openDeviceLibrary:(id)sender{
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
  
  // For some reasons, the iPad method won't work under iOS 8
//    if (NSClassFromString(@"UISplitViewController") != nil && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        //currentDeviceType = iPad;
//        popoverController=[[UIPopoverController alloc] initWithContentViewController:imagePickerController];
//        popoverController.delegate=self;
//        //[popoverController presentPopoverFromRect:((UIButton *)sender).bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
//        [popoverController presentPopoverFromRect:btnChangeProfilePic.bounds inView:btnChangeProfilePic permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
//    }
//    else {
        //currentDeviceType = iPhone;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.viewController presentModalViewController:imagePickerController animated:YES];
//    }
}
-(void)openDeviceCamera:(id)sender{
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.viewController presentModalViewController:imagePickerController animated:YES];
    //[self.view addSubview:imagePickerController.view];
}
#pragma imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *imageSourceKey;
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        imageSourceKey = @"UIImagePickerControllerEditedImage";
    else
        imageSourceKey = @"UIImagePickerControllerOriginalImage";
        
    UIImage *image = [Utils resizeImageWithImage:[Utils cropCenterOfImageWithImage:[info objectForKey:imageSourceKey]] toSize:CGSizeMake(500, 500)];
    
    NSLog(@"~~~~~~~~~~!!!~~~~~~");
    switch ([(UIImage *)[info objectForKey:imageSourceKey] imageOrientation]) {
        case UIImageOrientationUp: //Left
            NSLog(@"up");
            image = [[UIImage alloc] initWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationUp];
            break;
        case UIImageOrientationDown: //Right
            NSLog(@"down");
            image = [[UIImage alloc] initWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationDown];
            break;
        case UIImageOrientationLeft: //Down
            NSLog(@"left");
            image = [[UIImage alloc] initWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationLeft];
            break;
        case UIImageOrientationRight: //Up
            NSLog(@"right");
            image = [[UIImage alloc] initWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationRight];
            break;
        default:
            break;
    }
    NSLog(@"~~~~~~~~~~!!!~~~~~~");
    
    [self saveProfileImage:image];
    [imgViewProfilePic setImage:image];
    NSLog(@"close image picker with selected data");
    [popoverController dismissPopoverAnimated:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.viewController dismissModalViewControllerAnimated:YES];
    [imagePickerController.view removeFromSuperview];
    [imagePickerController release];

}
-(void)saveProfileImage:(UIImage *)image{
    NSString *profilePath = @"/profiles/";
    if(![Utils isDirectoryExist:profilePath]){
        [Utils createDirectory:profilePath];
    }
    NSString *path= [[NSString alloc] initWithFormat:@"/profiles/%@/",[userProfileInEdit getProfileID]];
    
    if(![Utils isDirectoryExist:path]){
        [Utils createDirectory:path];
    }
    
    //NSLog(@"save to %@, with name: %@",path,[userProfileInEdit getProfileID]);
    
    //save image to own directory
    //[Utils deleteImage:[userProfileInEdit getProfileID] path:path];
    //[Utils saveImage:image imageName:[userProfileInEdit getProfileID] path:path];
    [Utils deleteImage:@"profilepic" path:path];
    [Utils saveImage:image imageName:@"profilepic" path:path];
    
    [path release];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.viewController dismissModalViewControllerAnimated:YES];
    
    [imagePickerController.view removeFromSuperview];
    [imagePickerController release];
}

#pragma keyboard notification
- (void)keyboardDidShow:(NSNotification *)notification
{
    //overrided
    //Assign new frame to your view
    //[self.view setFrame:CGRectMake(0,-20,320,460)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    //overrided
    //[self.view setFrame:CGRectMake(0,0,320,460)];
}

#pragma reloadListForImportProfile
-(void)reloadListForImportedProfile:(NSNotification *)notification{
    NSLog(@"reloaded profile list");
    [self reloadTableView];
}
@end
