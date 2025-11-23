//
//  AACViewController.h
//  hongchiaac
//
//  Created by OEM on 9/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class UserProfile;
@class AACCard;
//@class MatchingGameViewController;
@class MatchingLevelViewController;
//@class SequencingGameViewController;
@class SequencingLevelViewController;

@interface AACViewController : UIViewController <UIScrollViewDelegate, AVAudioPlayerDelegate>  {
    UserProfile *loadedProfile;
    NSDictionary *profileContents;
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    UIButton *btnBack;
    UIButton *btnPlay;
    UIButton *btnDiscard;
    UIButton *btnDiscardAll;
    UIView *selectedCardContainer;
    UIView *viewMenu;
    UIView *viewGameSelector;
    UIButton *btnMenuProfile;
    UIButton *btnMenuSetting;
    UIButton *btnMenuWeb;
    UIButton *btnCloseMenu;
    UIButton *btnPageBack;
    UIButton *btnPageHome;
    UIButton *btnPageNext;
    UIButton *btnMiniGame;
    UIButton *btnGameSelectorBack;
    UIButton *btnGame1;
    UIButton *btnGame2;
    UILabel *lblProfileName;
    UIButton *btnBackToSummary;
    
    NSMutableArray *arrViewPages;
    NSArray *arrCardsetWhole;
    NSArray *arrCardsetInUse;
    NSMutableDictionary *userCardFromCardView;
    NSMutableArray *viewControllers;
    
    UILabel *lblSettingPopupTitle;
    
    //stackedIndex will be put the card index of different level's cardset
    //e.g.
    /*
        root
            -card1
            -folderA
                -card2
                -card3
                -folderB
                    -card4
            -card5
            -folderC
                -card7
            -card6
     
        if click folderA, then stackedIndex = 1 (the card with index 1 of first level isclicked )
        if click folderB, then stackedIndex = 1,2 (B is the 3nd item(index=2) of folder A
        if click folderC, then stackedIndex = 3
     
        so we may use the stackedIndex to locate the last level
     */
    NSMutableArray *stackedIndex;
    NSMutableArray *arraySelectedCards;
    
    int cardPerPage;
    int numOfPage;
    int row;
    int col;
    int layout;
    BOOL pageControlUsed;
    BOOL isPlayingSound;
    BOOL isPlayingAllCards;
    int nowPlayingCardIndex;
    NSTimeInterval clickDownMenuTime;
    NSTimeInterval clickDownSummeryTime;
    
    MatchingLevelViewController *matchingLevelViewController;
    SequencingLevelViewController *sequencingLevelViewController;
}

@property (retain, nonatomic)IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic)IBOutlet UIPageControl *pageControl;
@property (retain, nonatomic)IBOutlet UIView *tempView;
@property (retain, nonatomic)IBOutlet UIButton *btnBack;
@property (retain, nonatomic)IBOutlet UIButton *btnPlay;
@property (retain, nonatomic)IBOutlet UIButton *btnDiscard;
@property (retain, nonatomic)IBOutlet UIButton *btnDiscardAll;
@property (retain, nonatomic)IBOutlet UIView *selectedCardContainer;
@property (retain, nonatomic)IBOutlet UIView *viewMenu;
@property (retain, nonatomic)IBOutlet UIView *viewGameSelector;
@property (retain, nonatomic)IBOutlet UIButton *btnMenuProfile;
@property (retain, nonatomic)IBOutlet UIButton *btnMenuSetting;
@property (retain, nonatomic)IBOutlet UIButton *btnMenuWeb;
@property (retain, nonatomic)IBOutlet UIButton *btnCloseMenu;
@property (retain, nonatomic)IBOutlet UIButton *btnPageBack;
@property (retain, nonatomic)IBOutlet UIButton *btnPageHome;
@property (retain, nonatomic)IBOutlet UIButton *btnPageNext;
@property (retain, nonatomic)IBOutlet UIButton *btnMiniGame;
@property (retain, nonatomic)IBOutlet UIButton *btnGameSelectorBack;
@property (retain, nonatomic)IBOutlet UIButton *btnGame1;
@property (retain, nonatomic)IBOutlet UIButton *btnGame2;
@property (retain, nonatomic)IBOutlet UILabel *lblProfileName;
@property (retain, nonatomic)IBOutlet UIButton *btnBackToSummary;

@property (nonatomic, retain) NSMutableArray *arrViewPages;

@property (nonatomic, retain) IBOutlet UILabel *lblSettingPopupTitle;

- (IBAction)changePage:(id)sender;
-(IBAction)onClickBack:(id)sender;
-(IBAction)onClickDiscard:(id)sender;
-(IBAction)onClickDiscardAll:(id)sender;
-(IBAction)onClickPlay:(id)sender;
-(IBAction)onClickMenu:(id)sender;

-(IBAction)onMousePressMenu:(id)sender;
-(IBAction)onMouseReleaseMenu:(id)sender;

-(IBAction)onMousePressSummery:(id)sender;
-(IBAction)onMouseReleaseSummery:(id)sender;


-(IBAction)onClickMenuProfile:(id)sender;
-(IBAction)onClickCloseMenu:(id)sender;
-(IBAction)onclickPageBack:(id)sender;
-(IBAction)onclickPageHome:(id)sender;
-(IBAction)onclickPageNext:(id)sender;
-(IBAction)onClickGameSelector:(id)sender;
-(IBAction)onClickCloseGameSelector:(id)sender;
-(IBAction)onClickGame1:(id)sender;
-(IBAction)onClickGame2:(id)sender;
-(IBAction)onClickSetting:(id)sender;
-(IBAction)onClickBackToSummary:(id)sender;

-(IBAction)onClickWebSite:(id)sender;

//-(void)reloadProfile:(UserProfile *)profile;
-(void)reloadProfile;

-(void)loadProfile:(UserProfile *)profile;
-(void)initScrollView;
-(void)openFolder:(AACCard *)aacCard;

-(void)selectCard:(AACCard *)aacCard;
-(void)discardCard;
-(void)playSelectedCardSound;
-(void)drawSelectedCard;

-(void)finishPlaySoundDueToNoFile;

-(void)playSoundOfCard:(NSString *)cardID withMode:(int)mode;

@end
