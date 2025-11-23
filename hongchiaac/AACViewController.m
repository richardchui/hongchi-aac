//
//  AACViewController.m
//  hongchiaac
//
//  Created by OEM on 9/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <QuartzCore/QuartzCore.h>
#import "AACViewController.h"
#import "Classes/UserProfile.h"
#import "Classes/UserCard.h"
#import "AACCard.h"
#import "Utils.h"
#import "Constants.h"
#import "MiniGames/Matching/MatchingLevelViewController.h"
#import "MiniGames/Sequencing/SequencingLevelViewController.h"
#import "Handlers/SettingHandler.h"
#import "Handlers/ProfileHandler.h"


@interface AACViewController ()

@end

@implementation AACViewController

@synthesize scrollView,pageControl;
@synthesize arrViewPages;
@synthesize btnBack,btnDiscard, btnPlay,btnDiscardAll;
@synthesize selectedCardContainer;
@synthesize viewMenu, btnCloseMenu;
@synthesize viewGameSelector;
@synthesize btnPageBack, btnPageHome, btnPageNext;
@synthesize btnMenuProfile,btnMenuSetting, btnMenuWeb;
@synthesize btnMiniGame;
@synthesize btnGameSelectorBack;
@synthesize btnGame1;
@synthesize btnGame2;
@synthesize lblProfileName;
@synthesize btnBackToSummary;
@synthesize lblSettingPopupTitle;

#define LAYOUT_1X1  1
#define LAYOUT_1X2  2
#define LAYOUT_1X3  3
#define LAYOUT_2X4  4
#define LAYOUT_2x6  5
#define LAYOUT_3X6  6

#define ANIMATION_OPEN_FOLDER 1
#define ANIMATION_CLOSE_FOLDER 2
#define PLIST_PROFILE @"profiles.plist"

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
  
  // Store the profiles plist for repeated use
  profileContents = [Utils getContentFromPlist:PLIST_PROFILE];
  
  isPlayingSound = false;
  isPlayingAllCards = false;
  nowPlayingCardIndex = 0;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClickAACCard:) name:@"onClickAACCard" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCloseProfileMenu:) name:@"closeProfileMenu" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCloseSetting:) name:@"closeSetting" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeProfileWithProfileID:) name:@"changeProfileWithProfileID" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReloadForUpdatedProfile:) name:@"reloadForUpdatedProfile" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicatoinChangeLang:) name:@"applicatoinChangeLang" object:nil];
  
  
  //new code for default profile
  userCardFromCardView = [[NSMutableDictionary alloc]init];
  layout = 0;
  arrCardsetWhole = [[NSArray alloc] init];
  arrCardsetInUse = [[NSArray alloc] init];
  cardPerPage = 0;
  row = 0;
  col = 0;
  numOfPage = 0;
  
  stackedIndex = [[NSMutableArray alloc] init];
  
  
  
  [self initScrollView];
  
  
  
  //check if the have default profile
  /*
   NSString *defaultProfileID = [[NSString alloc] initWithString:[SettingHandler getDefaultProfileID]];
   
   if([defaultProfileID isEqualToString:@""]){
   //no default profile
   [self openProfileMenu];
   }else{
   //load default profile
   UserProfile *userProfile = [[UserProfile alloc] initWithProfileID:defaultProfileID];
   [self loadProfile:userProfile];
   }
   */
  //[self openProfileMenu];
  
  [self setLanguage:[SettingHandler getApplicationLanguage]];
  
  //////////////////////////////
  /*
   userCardFromCardView = [[NSMutableDictionary alloc]init];
   
   loadedProfile = profile;
   
   layout = [profile getLayout];
   [lblProfileName setText:[loadedProfile getName]];
   
   arrCardsetWhole = [[NSArray alloc] initWithArray:[profile getCardset]];
   arrCardsetInUse = [[NSArray alloc] initWithArray:arrCardsetWhole]; //defaul we will show all cards in the first level
   cardPerPage = [self getNumberOfCardPerPageFromLayout:layout];
   row = [self getRowFromLayout:layout];
   col = [self getColFromLayout:layout];
   numOfPage = ceil((float)[arrCardsetInUse count]/(float)cardPerPage);
   
   stackedIndex = [[NSMutableArray alloc] init];
   
   //update UI for single/6 card more
   if([loadedProfile getSingleCardMode]){
   [btnDiscard setHidden:YES];
   [btnDiscardAll setHidden:YES];
   [btnPlay setHidden:YES];
   
   }else{
   [btnDiscard setHidden:NO];
   [btnDiscardAll setHidden:NO];
   [btnPlay setHidden:NO];
   
   }
   
   //check if lock swiping
   [scrollView setScrollEnabled:![loadedProfile getLockSwiping]];
   
   [self initScrollView];
   */
  
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
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

////////UIScrollViewDelegate//////////
#pragma scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)_scrollView{
  if (pageControlUsed) {
    // do nothing - the scroll was initiated from the page control, not the user dragging
    return;
  }
	
  // Switch the indicator when more than 50% of the previous/next page is visible
  CGFloat pageWidth = scrollView.frame.size.width;
  int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
  pageControl.currentPage = page;
	
  // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
  [self loadScrollViewWithPage:page - 1];
  [self loadScrollViewWithPage:page];
  [self loadScrollViewWithPage:page + 1];
  
}
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  pageControlUsed = NO;
}
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  pageControlUsed = NO;
}

#pragma AVAudioPlayerDelegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
  /*
   isPlayingSound=NO;
   
   if(isPlayingAllCards){
   nowPlayingCardIndex++;
   
   //resetCardPosition
   NSArray *arrSubView = [[NSArray alloc] initWithArray:[selectedCardContainer subviews]];
   for(int j=0;j<[arrSubView count];j++){
   
   UIImageView *iv = (UIImageView *)[arrSubView objectAtIndex:j];
   CGRect frame = iv.frame;
   frame.origin.y = 0;
   iv.frame = frame;
   }
   
   if(nowPlayingCardIndex < [arraySelectedCards count]){
   [self playSelectedCardOfIndex:nowPlayingCardIndex];
   }else{
   isPlayingAllCards=NO;
   }
   }
   */
  
  [self finishPLaySound];
  //    [player stop];
  //    [player release];
  NSLog(@"2 = %p", &player);
  player = nil;
  [player release];
}

#pragma IBAction handler
-(IBAction)changePage:(id)sender {
  int page = pageControl.currentPage;
	
  // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
  [self loadScrollViewWithPage:page - 1];
  [self loadScrollViewWithPage:page];
  [self loadScrollViewWithPage:page + 1];
  
	// update the scroll view to the appropriate page
  CGRect frame = scrollView.frame;
  frame.origin.x = frame.size.width * page;
  frame.origin.y = 0;
  [scrollView scrollRectToVisible:frame animated:YES];
  
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
  pageControlUsed = YES;
}
-(IBAction)onClickBack:(id)sender {
  [self upOneFolder];
}
-(IBAction)onClickDiscard:(id)sender{
  [self discardCard];
}
-(IBAction)onClickDiscardAll:(id)sender{
  int totalLoop = [arraySelectedCards count];
  for(int i=0; i<totalLoop;i++){
    [self discardCard];
  }
}
-(IBAction)onClickPlay:(id)sender{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"onCheckIfAlive" object:self];
  
  if (!isPlayingAllCards && !isPlayingSound) {
    nowPlayingCardIndex = 0;
    isPlayingAllCards=YES;
    [self playSelectedCardOfIndex:nowPlayingCardIndex];
    
  }
  
}
-(IBAction)onClickMenu:(id)sender{
  //[self reloadProfile:loadedProfile];
  [self.view addSubview:viewMenu];
}

-(IBAction)onMousePressMenu:(id)sender{
  clickDownMenuTime = [NSDate timeIntervalSinceReferenceDate];
}
-(IBAction)onMouseReleaseMenu:(id)sender{
  if([SettingHandler getSettingLock]){
    if([NSDate timeIntervalSinceReferenceDate] - clickDownMenuTime > 2){
      [self.view addSubview:viewMenu];
    }
  }else{
    [self.view addSubview:viewMenu];
  }
}

-(IBAction)onMousePressSummery:(id)sender{
  clickDownSummeryTime = [NSDate timeIntervalSinceReferenceDate];
}
-(IBAction)onMouseReleaseSummery:(id)sender{
  if([SettingHandler getSettingLock]){
    if([NSDate timeIntervalSinceReferenceDate] - clickDownSummeryTime > 2){
      [[NSNotificationCenter defaultCenter] postNotificationName:@"backToSummaryFromAAC" object:nil];
    }
  }else{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backToSummaryFromAAC" object:nil];
  }
}

-(IBAction)onClickMenuProfile:(id)sender{
  
}
-(IBAction)onClickCloseMenu:(id)sender{
  [viewMenu removeFromSuperview];
}
-(IBAction)onclickPageBack:(id)sender{
  int page = pageControl.currentPage-1;
  [self loadScrollViewWithPage:page - 1];
  [self loadScrollViewWithPage:page];
  [self loadScrollViewWithPage:page + 1];
  
  CGRect frame = scrollView.frame;
  frame.origin.x = frame.size.width * page;
  frame.origin.y = 0;
  [scrollView scrollRectToVisible:frame animated:YES];
  
  pageControl.currentPage = page;
  
  pageControlUsed = YES;
}
-(IBAction)onclickPageHome:(id)sender{
  if([stackedIndex count]==0){
    [self reloadProfile];
    return;
  }
  
  NSArray *tempCardset=[[NSArray alloc] initWithArray:arrCardsetWhole];
  [self updateScrollView:tempCardset withPageNum:0 withAnimation:ANIMATION_CLOSE_FOLDER];
  
  //[stackedIndex removeLastObject];
  //if([stackedIndex count]==0)[btnBack setHidden:YES];
  stackedIndex = [[NSMutableArray alloc] init];
  [btnBack setHidden:YES];
  [btnBackToSummary setHidden:NO];
}
-(IBAction)onclickPageNext:(id)sender{
  int page = pageControl.currentPage+1;
  [self loadScrollViewWithPage:page - 1];
  [self loadScrollViewWithPage:page];
  [self loadScrollViewWithPage:page + 1];
  
  CGRect frame = scrollView.frame;
  frame.origin.x = frame.size.width * page;
  frame.origin.y = 0;
  [scrollView scrollRectToVisible:frame animated:YES];
  
  pageControl.currentPage = page;
  
  pageControlUsed = YES;
}
-(IBAction)onClickGameSelector:(id)sender {
  [self.view addSubview:viewGameSelector];
}
-(IBAction)onClickCloseGameSelector:(id)sender {
  [viewGameSelector removeFromSuperview];
}
-(IBAction)onClickGame1:(id)sender {
  [self.view addSubview:matchingLevelViewController.view];
}
-(IBAction)onClickGame2:(id)sender {
  [self.view addSubview:sequencingLevelViewController.view];
}
-(IBAction)onClickSetting:(id)sender{
  [self openSetting];
}
-(IBAction)onClickBackToSummary:(id)sender{
  //[viewMenu removeFromSuperview];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"backToSummaryFromAAC" object:nil];
}

-(IBAction)onClickWebSite:(id)sender{
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.hongchi.org.hk/staac.html"]];
}

//run once/////////////////////////////////
-(void)loadProfile:(UserProfile *)profile{
  
  userCardFromCardView = [[NSMutableDictionary alloc]init];
  loadedProfile = profile;
  
  layout = [profile getLayout];
  [lblProfileName setText:[loadedProfile getName]];
  
  arrCardsetWhole = [[NSArray alloc] initWithArray:[profile getCardset]];
  arrCardsetInUse = [[NSArray alloc] initWithArray:arrCardsetWhole]; //defaul we will show all cards in the first level
  
  cardPerPage = [self getNumberOfCardPerPageFromLayout:layout];
  row = [self getRowFromLayout:layout];
  col = [self getColFromLayout:layout];
  numOfPage = ceil((float)[arrCardsetInUse count]/(float)cardPerPage);
  
  stackedIndex = [[NSMutableArray alloc] init];
  
  //update UI for single/6 card more
  if([loadedProfile getSingleCardMode]){
    [btnDiscard setHidden:YES];
    [btnDiscardAll setHidden:YES];
    [btnPlay setHidden:YES];
    
  }else{
    [btnDiscard setHidden:NO];
    [btnDiscardAll setHidden:NO];
    [btnPlay setHidden:NO];
    
  }
  
  //check if lock swiping
  [scrollView setScrollEnabled:![loadedProfile getLockSwiping]];
  
  //[self initScrollView];
  
  [self updateScrollView:arrCardsetWhole withPageNum:0 withAnimation:NO];
  
  [Utils removeAllChild:selectedCardContainer];
  arraySelectedCards = [[NSMutableArray alloc] init];
}
-(void)initScrollView{
  
  NSMutableArray *pages = [[NSMutableArray alloc] init];
  for(unsigned i = 0 ; i < numOfPage ; i++){
    [pages addObject:[NSNull null]];
  }
  self.arrViewPages = pages;
  [pages release];
  
  scrollView.pagingEnabled = YES;
  scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * numOfPage , scrollView.frame.size.height);
  scrollView.showsHorizontalScrollIndicator = NO;
  scrollView.showsVerticalScrollIndicator = NO;
  scrollView.scrollsToTop = NO;
  scrollView.delegate = self;
  
  pageControl.numberOfPages = numOfPage;
  pageControl.currentPage = 0;
  
  [self loadScrollViewWithPage:0];
  [self loadScrollViewWithPage:1];
  
  /*
   NSLog(@"numOfPage is %d,%d",numOfPage,pageControl.numberOfPages);
   for(int x=0; x<=numOfPage; x++){
   NSLog(@"accviewcontroller - initScrollView - %d",x);
   [self loadScrollViewWithPage:x];
   }
   */
}
-(void)loadScrollViewWithPage:(int)page{
  
  if (page<0 || page>=numOfPage) {
    return ;
  }
  UIView *viewPage = [arrViewPages objectAtIndex:page];
  if((NSNull *)viewPage == [NSNull null]){
    viewPage = [[UIView alloc] init];
    [arrViewPages replaceObjectAtIndex:page withObject:viewPage];
    //[viewPage release];
  }
  
  if(nil == viewPage.superview){
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    viewPage.frame = frame;
    
    [self initPageWithPageNum:page forPage:viewPage];
    
    [scrollView addSubview:viewPage];
  }
}
-(void)initPageWithPageNum:(int)page forPage:(UIView *)viewPage{
  NSLog(@"------------init page with page number : %d",page);
  int tempCounter  = 0;
  
  // No need to read in every time
  //    NSDictionary *content = [Utils getContentFromPlist:PLIST_PROFILE];
  
  // After copying/adding a new profile, have to reload profileContents
  if ([SettingHandler getNeedReload]) {
    profileContents = [Utils getContentFromPlist:PLIST_PROFILE];
    [SettingHandler setNeedReload:FALSE];
  }
  
  for(int i = (page)*cardPerPage; i<((page+1)*cardPerPage) && i<[arrCardsetInUse count]; i++){
    
    NSMutableDictionary *tempD = [[NSMutableDictionary alloc] initWithDictionary:[arrCardsetInUse objectAtIndex:i]];
    //        NSLog(@"tempD");
    
    UserCard *userCard =[[UserCard alloc] initWithContent:tempD];
    //        NSLog(@"userCard");
    
    //        AACCard *aacCard = [[AACCard alloc] initWithUserCard:userCard cardIndex:i profileID:[loadedProfile getProfileID] withPlist:content];
    
    AACCard *aacCard = [[AACCard alloc] initWithUserCard:userCard cardIndex:i profileID:[loadedProfile getProfileID] withPlist:profileContents];
    //        NSLog(@"aacCard");
    
    [viewPage addSubview:aacCard.view];
    
    [aacCard resizeImageToSize:[self getCardSize:layout]];
    
    CGRect frame = aacCard.view.frame;
    frame.origin.x = (tempCounter % col) * [self getCardXMargin:layout] + (viewPage.frame.size.width - frame.size.width * col)/col/2;
    frame.origin.y = (int)floor(((float)tempCounter / (float)col)) * [self getCardYMargin:layout] + (viewPage.frame.size.height - frame.size.height * row)/row/2;
    aacCard.view.frame = frame;
    
    tempCounter++;
    
    //NSLog(@"---e--");
  }
  //    [content release];
}
/////////////////////////////////////
//-(void)reloadProfile:(UserProfile *)profile{
-(void)reloadProfile{
  [btnBack setHidden:YES];
  [btnBackToSummary setHidden:NO];
  //[self loadProfile:profile];
  //[loadedProfile release];
  loadedProfile = [[UserProfile alloc] initWithProfileID:[loadedProfile getProfileID]];
  
  [self loadProfile:loadedProfile];
}
/////////////////////////////////////
-(void)openFolder:(AACCard *)aacCard{
  //show back button
  [btnBack setHidden:NO];
  [btnBackToSummary setHidden:YES];
  [stackedIndex addObject:[aacCard getCardIndex]];
  [self updateScrollView:[aacCard getCardset] withPageNum:0 withAnimation:ANIMATION_OPEN_FOLDER];
}
-(void)upOneFolder{
  NSArray *tempCardset=[[NSArray alloc] initWithArray:arrCardsetWhole];
  NSDictionary *tempAACCard=[[NSDictionary alloc] init];
  
  for(int i=0; i<[stackedIndex count]; i++){
    tempAACCard = [tempCardset objectAtIndex:[[stackedIndex objectAtIndex:i] intValue]];
    
    if(i<[stackedIndex count]-1)
      tempCardset = [[NSArray alloc] initWithArray:[tempAACCard objectForKey:@"cardset"]];
    else{
      int pageNum = (int)floor( [[stackedIndex objectAtIndex:i] intValue] / cardPerPage );
      
      [self updateScrollView:tempCardset withPageNum:pageNum withAnimation:ANIMATION_CLOSE_FOLDER];
    }
  }
  
  [stackedIndex removeLastObject];
  if([stackedIndex count]==0){
    [btnBack setHidden:YES];
    [btnBackToSummary setHidden:NO];
  }else{
    [btnBack setHidden:NO];
    [btnBackToSummary setHidden:YES];
  }
  
  
}

-(void)selectCard:(AACCard *)aacCard{
  
  if(arraySelectedCards==nil)
    arraySelectedCards=[[NSMutableArray alloc]init];
  
  
  if(![loadedProfile getSingleCardMode]){
    if([arraySelectedCards count]<[Constants getMaxCardInSentenseBar])[arraySelectedCards addObject:aacCard];
  }else{
    if([arraySelectedCards count]<1)[arraySelectedCards addObject:aacCard];
  }
  
  [self drawSelectedCard];
}
-(void)discardCard{
  [arraySelectedCards removeLastObject];
  [self drawSelectedCard];
}
-(void)playSelectedCardSound{
}
-(void)drawSelectedCard{
  
  UIImageView *iv = [[UIImageView alloc] init];
  AACCard *aacCard;
  [Utils removeAllChild:selectedCardContainer];
  for(int i=0;i<[arraySelectedCards count];i++){
    aacCard = (AACCard *)[arraySelectedCards objectAtIndex:i];
    
    //UIGraphicsBeginImageContext(aacCard.view.frame.size);
    UIGraphicsBeginImageContext(CGSizeMake(aacCard.view.frame.size.width, aacCard.view.frame.size.width));
    
    [aacCard.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    iv = [[UIImageView alloc] initWithImage:resultingImage];
    
    CGRect frame = iv.frame;
    
    if([loadedProfile getSingleCardMode]){
      frame.origin.x=3*(130);
    }else{
      frame.origin.x=i*(130);
    }
    
    frame.origin.y=0;
    frame.size.width=120;
    frame.size.height=120;
    iv.frame=frame;
    
    [selectedCardContainer addSubview:iv];
    
  }
}

-(void)finishPLaySound{
  
  isPlayingSound=NO;
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"unsetAACCardActiveEffect" object:self];
  
  if(isPlayingAllCards){
    nowPlayingCardIndex++;
    //resetCardPosition
    NSArray *arrSubView = [[NSArray alloc] initWithArray:[selectedCardContainer subviews]];
    for(int j=0;j<[arrSubView count];j++){
      
      UIImageView *iv = (UIImageView *)[arrSubView objectAtIndex:j];
      CGRect frame = iv.frame;
      frame.origin.y = 0;
      iv.frame = frame;
    }
    
    if(nowPlayingCardIndex < [arraySelectedCards count]){
      [self playSelectedCardOfIndex:nowPlayingCardIndex];
    }else{
      isPlayingAllCards=NO;
    }
  }
}

-(void)finishPlaySoundDueToNoFile{
  [self finishPLaySound];
  
}

-(void)playSoundOfCard:(NSString *)cardID withMode:(int)mode{
  if(!isPlayingSound && mode>0){
    isPlayingSound=YES;
    [Utils playSoundOfCard:cardID withMode:mode withCallBackObject:self];
    
  }
}
-(void)playSoundOfCustomVoice:(NSString *)fileName{
  if(!isPlayingSound){
    
    
    NSString *filePath = [Utils getFullPath:[NSString stringWithFormat:@"/profiles/%@/%@.caf",[loadedProfile getProfileID],fileName]];
    
    isPlayingSound=YES;
    [Utils playSoundofFilePath:filePath withCallBackObject:self];
    //[filePath release];
  }
  
}
-(void)playSelectedCardOfIndex:(int)i{
  if([arraySelectedCards count]>0){
    AACCard *aacCard = (AACCard *)[arraySelectedCards objectAtIndex:i];
    UserCard *userCard = [aacCard getUserCard];
    
    NSArray *arrSubView = [[NSArray alloc] initWithArray:[selectedCardContainer subviews]];
    UIImageView *iv = [arrSubView objectAtIndex:i];
    CGRect frame = iv.frame;
    frame.origin.y=-3;
    iv.frame=frame;
    
    if([[userCard getVoiceCustom] length]>0){
      [self playSoundOfCustomVoice:[userCard getVoiceCustom]];
    }else{
      if([aacCard haveDefaultCard]){
        [self playSoundOfCard:[(UserCard *)[aacCard getUserCard] getCardID] withMode:[loadedProfile getVoiceMode]];
      }else{
        [self finishPLaySound];
      }
    }
    
  }
}
-(void)updateScrollView:(NSArray *)newCardset withPageNum:(int)pageNum withAnimation:(int)animation{
  arrCardsetInUse = newCardset;
  numOfPage = ceil((float)[arrCardsetInUse count]/(float)cardPerPage);
  
  NSMutableArray *pages = [[NSMutableArray alloc] init];
  for(unsigned i = 0 ; i < numOfPage ; i++){
    [pages addObject:[NSNull null]];
  }
  self.arrViewPages = pages;
  [pages release];
  
  //try some animation here
  
  if(animation > 0){
    UIGraphicsBeginImageContext(self.scrollView.bounds.size);
    
    [self.scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *dummyIV = [[UIImageView alloc] initWithImage:resultingImage];
    dummyIV.frame = scrollView.frame;
    
    [self.view addSubview:dummyIV];
    
    if(animation == ANIMATION_OPEN_FOLDER){
      double frameWHRatio = dummyIV.frame.size.height/dummyIV.frame.size.width;
      int scaleFactor = dummyIV.frame.size.width * 0.05;
      CGRect frame = dummyIV.frame;
      frame.size.width +=scaleFactor;
      frame.size.height +=scaleFactor*frameWHRatio;
      frame.origin.x -=(frame.size.width - dummyIV.frame.size.width)/2;
      frame.origin.y -=(frame.size.height - dummyIV.frame.size.height)/2;
      
      [UIView animateWithDuration:0.3 animations:^(void){[dummyIV setAlpha:0.0];dummyIV.frame=frame;} completion:^(BOOL finished){[dummyIV removeFromSuperview];}];
    }
    if(animation == ANIMATION_CLOSE_FOLDER){
      double frameWHRatio = dummyIV.frame.size.height/dummyIV.frame.size.width;
      int scaleFactor = dummyIV.frame.size.width * 1;
      CGRect frame = dummyIV.frame;
      frame.size.width -=scaleFactor;
      frame.size.height -=scaleFactor*frameWHRatio;
      frame.origin.x =120;//-=(frame.size.width - dummyIV.frame.size.width)/2;
      frame.origin.y =350;//-=(frame.size.height - dummyIV.frame.size.height)/2;
      
      [UIView animateWithDuration:0.3 animations:^(void){[dummyIV setAlpha:1.0];dummyIV.frame=frame;} completion:^(BOOL finished){[dummyIV removeFromSuperview];}];
    }
    
  }
  
  /////////////////////////
  
  //[Utils removeAllChild:scrollView];
  [Utils removeAllChildOfPage:scrollView];
  scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * numOfPage , scrollView.frame.size.height);
  
  pageControl.numberOfPages = numOfPage;
  pageControl.currentPage = pageNum;
  
  [self loadScrollViewWithPage:pageNum-1];
  //[self loadScrollViewWithPage:pageNum];
  //[self loadScrollViewWithPage:pageNum+1];
  
  for(int x=0; x<=numOfPage; x++){
    [self loadScrollViewWithPage:x];
  }
  
  CGRect frame = scrollView.frame;
  frame.origin.x = frame.size.width * pageNum;
  frame.origin.y = 0;
  [scrollView scrollRectToVisible:frame animated:NO];
}

-(void)openProfileMenu{
  //overidded
}
-(void)closeProfileMenu{
  //overrided
}

-(void)openSetting{
  //overridded
}
-(void)closeSetting{
  //overridded
}

#pragma even handler
-(void) cardInactiveEffectManual{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"unsetAACCardActiveEffect" object:self];
  isPlayingSound = NO;
}
-(void) onClickAACCard:(NSNotification *)notification{
  
  AACCard *clickedAACCard = (AACCard *)notification.object;
  
  if(isPlayingSound){
    return;
  }
  
  if(![loadedProfile getSingleCardMode]){
    if([arraySelectedCards count]==[Constants getMaxCardInSentenseBar])return;
  }else{
    if([arraySelectedCards count]==1)[self discardCard];
  }
  
  
  UserCard *userCard = [clickedAACCard getUserCard];
  
  
  BOOL needHighlight = NO;
  if([clickedAACCard isCard]){
    //is card
    
    if([loadedProfile getTappingSpeak] || [loadedProfile getSingleCardMode]){
      if([[userCard getVoiceCustom] length]>0){
        needHighlight = YES;
        [self playSoundOfCustomVoice:[userCard getVoiceCustom]];
      }else{
        if([clickedAACCard haveDefaultCard]){
          needHighlight = YES;
          [self playSoundOfCard:[(UserCard *)[clickedAACCard getUserCard] getCardID] withMode:[loadedProfile getVoiceMode]];
        }else{
          
        }
      }
    }
    
    
    [self selectCard:clickedAACCard];
    
    //[clickedAACCard cardActiveEffect:YES];
    //[self performSelector:@selector(cardInactiveEffectManual) withObject:nil afterDelay:1];
    
    if(needHighlight && [loadedProfile getVoiceMode]>0){
      if([loadedProfile getShowSelectFrame]){
        [clickedAACCard cardActiveEffect:YES];
      }
    }else{
      if([loadedProfile getShowSelectFrame]){
        [clickedAACCard cardActiveEffect:YES];
      }
      isPlayingSound = YES;
      [self performSelector:@selector(cardInactiveEffectManual) withObject:nil afterDelay:0.1];
    }
  }else{
    //is folder
    [self openFolder:clickedAACCard];
    
    if([loadedProfile getTappingSpeak] || [loadedProfile getSingleCardMode]){
      if([[userCard getVoiceCustom] length]>0){
        [self playSoundOfCustomVoice:[userCard getVoiceCustom]];
      }else{
        if([clickedAACCard haveDefaultCard]){
          [self playSoundOfCard:[(UserCard *)[clickedAACCard getUserCard] getCardID] withMode:[loadedProfile getVoiceMode]];
        }
      }
    }
    
    /*
     if([loadedProfile getTappingSpeak]){
     [Utils playSoundOfOpenFolder];
     }
     */
  }
  
}
-(void) onCloseProfileMenu:(NSNotification *)notification{
  //this function is overrided
}
-(void) onCloseSetting:(NSNotification *)notification{
  //this function is overrided
  [self closeSetting];
  [self reloadProfile];
}
-(void) onChangeProfileWithProfileID:(NSNotification *)notification{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLoading" object:self];
  
  UserProfile *profile = notification.object;
  [loadedProfile release];
  loadedProfile = [[UserProfile alloc] initWithProfileID:[profile getProfileID]];
  
  [self closeProfileMenu];
  
  /*
   UserProfile *profile = notification.object;
   [self closeProfileMenu];
   [viewMenu removeFromSuperview];
   NSLog(@"profile name : %@", [profile getName]);
   [loadedProfile release];
   loadedProfile = [[UserProfile alloc] initWithProfileID:[profile getProfileID]];
   [self reloadProfile:loadedProfile];
   */
  
}
-(void) onReloadForUpdatedProfile:(NSNotification *)notification{
  
  //UserProfile *profile = notification.object;
  NSString *profileID = [[NSString alloc] initWithString:notification.object];
  //if([[profile getProfileID] isEqualToString:[loadedProfile getProfileID]]){
  if([profileID isEqualToString:[loadedProfile getProfileID]]){
    // [self reloadProfile:profile];
    [self reloadProfile];
  }
  [profileID release];
}

#pragma utils_functions
-(int)getNumberOfCardPerPageFromLayout:(int)layoutID{
  
  if(layoutID == LAYOUT_1X1) return 1;
  if(layoutID == LAYOUT_1X2) return 2;
  if(layoutID == LAYOUT_1X3) return 3;
  if(layoutID == LAYOUT_2X4) return 8;
  if(layoutID == LAYOUT_2x6) return 12;
  if(layoutID == LAYOUT_3X6) return 18;
  
  return 0;
}
-(int)getColFromLayout:(int)layoutID{
  
  if(layoutID == LAYOUT_1X1) return 1;
  if(layoutID == LAYOUT_1X2) return 2;
  if(layoutID == LAYOUT_1X3) return 3;
  if(layoutID == LAYOUT_2X4) return 4;
  if(layoutID == LAYOUT_2x6) return 6;
  if(layoutID == LAYOUT_3X6) return 6;
  
  return 1;
}
-(int)getRowFromLayout:(int)layoutID{
  
  if(layoutID == LAYOUT_1X1) return 1;
  if(layoutID == LAYOUT_1X2) return 1;
  if(layoutID == LAYOUT_1X3) return 1;
  if(layoutID == LAYOUT_2X4) return 2;
  if(layoutID == LAYOUT_2x6) return 2;
  if(layoutID == LAYOUT_3X6) return 3;
  
  return 1;
}
-(int)getCardSize:(int)layoutID{
  if(layoutID == LAYOUT_1X1) return 500;
  if(layoutID == LAYOUT_1X2) return 500;
  if(layoutID == LAYOUT_1X3) return 380;
  if(layoutID == LAYOUT_2X4) return 250;
  if(layoutID == LAYOUT_2x6) return 190;
  if(layoutID == LAYOUT_3X6) return 166;
  
  return 1;
}
-(int)getCardXMargin:(int)layoutID{
  if(layoutID == LAYOUT_1X1) return 460;
  if(layoutID == LAYOUT_1X2) return 500;
  if(layoutID == LAYOUT_1X3) return 340;
  if(layoutID == LAYOUT_2X4) return 250;
  if(layoutID == LAYOUT_2x6) return 170;
  if(layoutID == LAYOUT_3X6) return 170;
  
  return 1;
}
-(int)getCardYMargin:(int)layoutID{
  if(layoutID == LAYOUT_1X1) return 460;
  if(layoutID == LAYOUT_1X2) return 460;
  if(layoutID == LAYOUT_1X3) return 460;
  if(layoutID == LAYOUT_2X4) return 250;
  if(layoutID == LAYOUT_2x6) return 240;
  if(layoutID == LAYOUT_3X6) return 166;
  
  return 1;
}

#pragma language
-(void)onApplicatoinChangeLang:(NSNotification *)notification{
  [self setLanguage:notification.object];
  NSLog(@"applicatoinChangeLang : aacviewcontroller");
}
-(void)setLanguage:(NSString *)lang{
  if([lang isEqualToString:[Constants getLanguageCodeTW]]){
    [btnMiniGame setTitle:[Utils getText:@"遊戲" ForLang:[Constants getLanguageCodeTW] atView:@"AACViewController"] forState:UIControlStateNormal];
    [btnMenuProfile setTitle:[Utils getText:@"檔案設定" ForLang:[Constants getLanguageCodeTW] atView:@"AACViewController"] forState:UIControlStateNormal];
    [btnMenuSetting setTitle:[Utils getText:@"系統設定" ForLang:[Constants getLanguageCodeTW] atView:@"AACViewController"] forState:UIControlStateNormal];
    [btnMenuWeb setTitle:[Utils getText:@"網頁" ForLang:[Constants getLanguageCodeTW] atView:@"AACViewController"] forState:UIControlStateNormal];
    [btnCloseMenu setTitle:[Utils getText:@"關閉" ForLang:[Constants getLanguageCodeTW] atView:@"AACViewController"] forState:UIControlStateNormal];
    [btnGame1 setTitle:[Utils getText:@"掃視遊戲" ForLang:[Constants getLanguageCodeTW] atView:@"AACViewController"] forState:UIControlStateNormal];
    //        [btnGame2 setTitle:[Utils getText:@"造句遊戲" ForLang:[Constants getLanguageCodeTW] atView:@"AACViewController"] forState:UIControlStateNormal];
    [btnGame2 setTitle:[Utils getText:@"組句遊戲" ForLang:[Constants getLanguageCodeTW] atView:@"AACViewController"] forState:UIControlStateNormal];
    [btnGameSelectorBack setTitle:[Utils getText:@"關閉" ForLang:[Constants getLanguageCodeTW] atView:@"AACViewController"] forState:UIControlStateNormal];
    
    [lblSettingPopupTitle setText:[Utils getText:@"設置" ForLang:[Constants getLanguageCodeTW] atView:@"AACViewController"]];
  }
  
  if([lang isEqualToString:[Constants getLanguageCodeCN]]){
    [btnMiniGame setTitle:[Utils getText:@"遊戲" ForLang:[Constants getLanguageCodeCN] atView:@"AACViewController"] forState:UIControlStateNormal];
    [btnMenuProfile setTitle:[Utils getText:@"檔案設定" ForLang:[Constants getLanguageCodeCN] atView:@"AACViewController"] forState:UIControlStateNormal];
    [btnMenuSetting setTitle:[Utils getText:@"系統設定" ForLang:[Constants getLanguageCodeCN] atView:@"AACViewController"] forState:UIControlStateNormal];
    [btnMenuWeb setTitle:[Utils getText:@"網頁" ForLang:[Constants getLanguageCodeCN] atView:@"AACViewController"] forState:UIControlStateNormal];
    [btnCloseMenu setTitle:[Utils getText:@"關閉" ForLang:[Constants getLanguageCodeCN] atView:@"AACViewController"] forState:UIControlStateNormal];
    [btnGame1 setTitle:[Utils getText:@"掃視遊戲" ForLang:[Constants getLanguageCodeCN] atView:@"AACViewController"] forState:UIControlStateNormal];
    //        [btnGame2 setTitle:[Utils getText:@"造句遊戲" ForLang:[Constants getLanguageCodeCN] atView:@"AACViewController"] forState:UIControlStateNormal];
    [btnGame2 setTitle:[Utils getText:@"組句遊戲" ForLang:[Constants getLanguageCodeCN] atView:@"AACViewController"] forState:UIControlStateNormal];
    [btnGameSelectorBack setTitle:[Utils getText:@"關閉" ForLang:[Constants getLanguageCodeCN] atView:@"AACViewController"] forState:UIControlStateNormal];
    
    [lblSettingPopupTitle setText:[Utils getText:@"設置" ForLang:[Constants getLanguageCodeCN] atView:@"AACViewController"]];
  }
}
@end
