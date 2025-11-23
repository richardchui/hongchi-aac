//
//  SettingViewController.m
//  hongchiaac
//
//  Created by OEM on 24/1/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import "SettingViewController.h"
#import "Constants.h"
#import "Handlers/SettingHandler.h"
#import "Utils.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize scLang;
@synthesize btnClose;
@synthesize switchSettingLock;
@synthesize lblSettingLockReminder;
@synthesize lblLangTitle;
@synthesize lblSettingLockTitle;
@synthesize lblSetting;
@synthesize tvDisclaimer;
@synthesize ivIcon1,ivIcon2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]]){
        [scLang setSelectedSegmentIndex:0];
    }
    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeCN]]){
        [scLang setSelectedSegmentIndex:1];
    }
    [switchSettingLock setOn:[SettingHandler getSettingLock]];
    [lblSettingLockReminder setHidden:![SettingHandler getSettingLock]];
    [ivIcon1 setHidden:![SettingHandler getSettingLock]];
    [ivIcon2 setHidden:![SettingHandler getSettingLock]];
    
    [self setLanguage:[SettingHandler getApplicationLanguage]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)dealloc{
    [lblLangTitle release];
    [scLang release];
    [btnClose release];
    [lblSettingLockReminder release];
    [lblSettingLockTitle release];
    [lblSetting release];
    [tvDisclaimer release];
    [ivIcon2 release];
    [ivIcon1 release];
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

-(IBAction)onChangeLang:(id)sender{
    if([scLang selectedSegmentIndex] == 0){
        [SettingHandler setApplicationLanguage:[Constants getLanguageCodeTW]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"applicatoinChangeLang" object:[Constants getLanguageCodeTW]];
        
        [self setLanguage:[SettingHandler getApplicationLanguage]];
    }
    if([scLang selectedSegmentIndex] == 1){
        [SettingHandler setApplicationLanguage:[Constants getLanguageCodeCN]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"applicatoinChangeLang" object:[Constants getLanguageCodeCN]];
        
        [self setLanguage:[SettingHandler getApplicationLanguage]];
    }
}
-(IBAction)onClickClose:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeSetting" object:nil];
}
-(IBAction)onSwitchSettingLock:(id)sender{
    [SettingHandler setSettingLock:[switchSettingLock isOn]];
    [lblSettingLockReminder setHidden:![switchSettingLock isOn]];
    [ivIcon1 setHidden:![switchSettingLock isOn]];
    [ivIcon2 setHidden:![switchSettingLock isOn]];
}

-(void)setLanguage:(NSString *)lang{
     if([lang isEqualToString:[Constants getLanguageCodeTW]]){
        [lblLangTitle setText:[Utils getText:@"介面語言" ForLang:[Constants getLanguageCodeTW] atView:@"SettingViewController"]];
        [lblSettingLockTitle setText:[Utils getText:@"系統保護" ForLang:[Constants getLanguageCodeTW] atView:@"SettingViewController"]];
         [lblSetting setText:[Utils getText:@"系統設定" ForLang:[Constants getLanguageCodeTW] atView:@"AACViewController"]];
         
         //「設定」鍵(icon)及「檔案頁」鍵(icon)已加保護，如要啟動，需按鍵3秒 。
         //[lblSettingLockReminder setText:[Utils getText:@"需按「設定」鍵及「檔案頁」鍵3秒" ForLang:[Constants getLanguageCodeTW] atView:@"SettingViewController"]];
         [lblSettingLockReminder setText:@"「設定」鍵           及「檔案頁」鍵           已加保護，如要啟動，需按鍵3秒。"];

         [tvDisclaimer setText:@"版權聲明\n此應用程式的所有內容,包括但不限於文字、圖像、影音、軟件及程式等之版權, 均為匡智會所有。 任何人士不得未經本會的書面同意, 以任何方式抄襲、更改、複印、出版、上載、傳送及發放此應用程式內的資訊及材料。\n\nCopyright statement\nThe copyright of all contents in this application, including but not limited to texts, graphics, drawings, audio recordings and the scripts and software, belongs to Hong Chi Association.\nYou must not create derivative works, modify, copy, reproduce, alter, or publicly display any content from this application without prior written permission of Hong Chi Association.\n\n\n免責聲明：\n任何非由本會輸入到應用程式內的文字、圖像、照片或聲音檔案, 用戶需全權負責相關的版權。\n\nDisclaimer Statement:\nThe user is solely responsible for any matter concerning the copyright of texts, graphics, drawings, photos, audio recordings, that are not inputs provided by Hong Chi Association, in the Application.\n"];
     }
     
     if([lang isEqualToString:[Constants getLanguageCodeCN]]){
         [lblLangTitle setText:[Utils getText:@"介面語言" ForLang:[Constants getLanguageCodeCN] atView:@"SettingViewController"]];
         [lblSettingLockTitle setText:[Utils getText:@"系統保護" ForLang:[Constants getLanguageCodeCN] atView:@"SettingViewController"]];
         [lblSetting setText:[Utils getText:@"系統設定" ForLang:[Constants getLanguageCodeCN] atView:@"AACViewController"]];
         
         //「設定」鍵(icon)及「檔案頁」鍵(icon)已加保護，如要啟動，需按鍵3秒 。
         //[lblSettingLockReminder setText:[Utils getText:@"需按「設定」鍵及「檔案頁」鍵3秒" ForLang:[Constants getLanguageCodeCN] atView:@"SettingViewController"]];
         [lblSettingLockReminder setText:@"「设定」键           及「档案页」键           已加保护，如要启动，需按键3秒。"];
         
         [tvDisclaimer setText:@"版权声明\n此应用程序的所有内容,包括但不限于文字、图像、影音、软件及程序等之版权, 均为匡智会所有。 任何人士不得未经本会的书面同意, 以任何方式抄袭、更改、复印、出版、上载、传送及发放此应用程序内的信息及材料。\n\nCopyright statement\nThe copyright of all contents in this application, including but not limited to texts, graphics, drawings, audio recordings and the scripts and software, belongs to Hong Chi Association.\nYou must not create derivative works, modify, copy, reproduce, alter, or publicly display any content from this application without prior written permission of Hong Chi Association.\n\n\n免责声明：\n任何非由本会输入到应用程序内的文字、图像、照片或声音档案, 用户需全权负责相关的版权。\n\nDisclaimer Statement:\nThe user is solely responsible for any matter concerning the copyright of texts, graphics, drawings, photos, audio recordings, that are not inputs provided by Hong Chi Association, in the Application.\n\n"];
         
     }
     
    
}
@end
