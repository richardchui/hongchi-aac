//
//  EditAACViewController.m
//  hongchiaac
//
//  Created by OEM on 31/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "EditAACViewController.h"
#import "AppDelegate.h"
#import <Foundation/Foundation.h>

#import "Classes/UserProfile.h"
#import "Classes/UserCard.h"
#import "Handlers/ProfileHandler.h"
#import "EditAACCard.h"
#import "Utils.h"
#import "Constants.h"
#import "LibCard.h"
#import "LibCardSelectorViewController.h"
#import "Handlers/SettingHandler.h"
#import "AppDelegate.h"

@interface EditAACViewController ()

@end

@implementation EditAACViewController

@synthesize scrollView,pageControl;
@synthesize arrViewPages;
@synthesize viewFolderSelector;
@synthesize viewColorSelector;
@synthesize btnBack;
@synthesize imgSelectedCardImage;
@synthesize btnSwap;
@synthesize btnOpenFolder;
@synthesize btnChangeColor;
@synthesize viewAddNewItemSelector;
@synthesize btnOpenCardLibrary;
@synthesize btnOpenDeviceCamera;
@synthesize btnDeleteCard;
@synthesize lblCaptionCN,lblCaptionTW,txtCaptionCustom;
@synthesize btnConfirmChangeCaptionCustom;
@synthesize btnOpenDeviceLibrary;
@synthesize btnVoice,btnVoiceMale,btnVoiceFemale,btnVoiceCustom,btnVoiceCustomEdit;
@synthesize viewRecorderViewBase;
@synthesize btnVoiceCustomDelete;
@synthesize btnSelectCard,btnAddCard,btnAddFolder;
@synthesize lblCaptionCNTitle, lblCaptionTWTitle;
@synthesize viewCurrentBoarderColor;
@synthesize lblProfileName;

#define LAYOUT_1X1  1
#define LAYOUT_1X2  2
#define LAYOUT_1X3  3
#define LAYOUT_2X4  4
#define LAYOUT_2x6  5
#define LAYOUT_3X6  6

#define DIRECTION_LEFT @"left"
#define DIRECTION_RIGHT @"right"

#define MAX_LENGTH_FOR_CUSTOM_CAPTION   8

#define ANIMATION_NONE 0
#define ANIMATION_OPEN_FOLDER 1
#define ANIMATION_CLOSE_FOLDER 2

#define PLIST_PROFILE @"profiles.plist"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  NSLog(@"addagain!");
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClickAACCard:) name:@"onClickEditAACCard" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFinishedSelectCardFromLibrary:) name:@"onFinishedSelectCardFromLibrary" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onExitRecorder:) name:@"onExitRecorder" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSaveAndExitRecorder:) name:@"onSaveAndExitRecorder" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClickDelSoundFromRecorder:) name:@"onClickDelSoundFromRecorder" object:nil];
  
  /*
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClickAACCard:) name:@"onClickAACCard" object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCloseProfileMenu:) name:@"closeProfileMenu" object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeProfileWithProfileID:) name:@"changeProfileWithProfileID" object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReloadForUpdatedProfile:) name:@"reloadForUpdatedProfile" object:nil];
   */
  
  
  return self;
}

- (void)viewDidLoad
{
  testcheck=0;
  _isSwapMode = NO;
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  
  //remove the super observer that is not use
  /*
   [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeProfileMenu" object:nil];
   [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeProfileWithProfileID" object:nil];
   [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadForUpdatedProfile" object:nil];
   */
  
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicatoinChangeLang:) name:@"applicatoinChangeLang" object:nil];
  
  [self setLanguage:[SettingHandler getApplicationLanguage]];
  
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (void)dealloc {
  
  
  //[loadedProfile release];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicatoinChangeLang" object:nil];
  
  [lblProfileName release];
  [viewCurrentBoarderColor release];
  [scrollView release];
  [pageControl release];
  [viewFolderSelector release];
  [viewColorSelector release];
  [viewAddNewItemSelector release];
  [btnBack release];
  [btnSwap release];
  [btnDeleteCard release];
  [btnChangeColor release];
  [btnOpenFolder release];
  [btnOpenCardLibrary release];
  [btnOpenDeviceLibrary release];
  [btnOpenDeviceCamera release];
  
  [viewRecorderViewBase release];
  [btnVoiceMale release];
  [btnVoiceFemale release];
  [btnVoiceCustom release];
  [btnVoiceCustomEdit release];
  [btnVoiceCustomDelete release];
  
  [lblCaptionTW release];
  [lblCaptionCN release];
  [txtCaptionCustom release];
  [btnConfirmChangeCaptionCustom release];
  
  [imgSelectedCardImage release];
  
  //[aacCardFolderBuffer release];
  //[aacCardNewItemBuffer release];
  
  //[vcLibCardSelector release];
  //[imagePickerController release];
//  [popoverController release];
  
  [arrViewPages release];
  //[arrCardsetWhole release];
  //[arrCardsetInUse release];
  //[userCardFromCardView release];
  [viewControllers release];
  
  [stackedIndex release];
  [stackedIndexForSelectedCard release];
  [arraySelectedCards release];
  
  [recordViewController release];
  
  [btnSelectCard release];
  [btnAddCard release];
  [btnAddFolder release];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onClickEditAACCard" object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onFinishedSelectCardFromLibrary" object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onExitRecorder" object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onSaveAndExitRecorder" object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onClickDelSoundFromRecorder" object:nil];
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
///////////////////////////////////////////////
#pragma IBAction handler
-(IBAction)onCloseFolderSelector:(id)sender{
  [self toggleFolderSelector:NO];
}
-(IBAction)onClickBack:(id)sender {
  if(!_isSwapMode)
    [self upOneFolder];
  else{
    //UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:@"This is not supported in SWAP mode" delegate:nil cancelButtonTitle:@"CLOSE" otherButtonTitles:nil];
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:alertMsgCannotBackWhileSwapping delegate:nil cancelButtonTitle:alertBoxClose otherButtonTitles:nil];
    [av show];
    [av release];
  }
}
-(IBAction)onClickFolderSelectorSelect:(id)sender{
  if(aacCardFolderBuffer!=nil){
    if(_isSwapMode){
      [self swapCard:aacCardFolderBuffer];
    }else{
      [self selectCard:aacCardFolderBuffer];
    }
  }
  [self toggleFolderSelector:NO];
}
-(IBAction)onClickFolderSelectorOpen:(id)sender{
  if(aacCardFolderBuffer!=nil){
    [self openFolder:aacCardFolderBuffer];
  }
  [self toggleFolderSelector:NO];
}
-(IBAction)onClickSwap:(id)sender{
  // [[NSNotificationCenter defaultCenter] postNotificationName:@"showAsHighlight" object:aacCardSelected];
  //////////////////////////////////
  //iphone is overried thisfunction
  /////////////////////////////////
  if(!_isSwapMode){
    _isSwapMode = YES;
    [btnSwap setSelected:YES];
  }else{
    _isSwapMode = NO;
    [btnSwap setSelected:NO];
  }
}
-(IBAction)onClickCloseView:(id)sender{
  [Utils removeAllChildOfPage:scrollView];
  aacCardSelected = nil;
  [aacCardSelected release];
  
  //aacCardFolderBuffer = nil;
  aacCardNewItemBuffer = nil;
  aacCardFolderBuffer = nil;
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"onCloseEditAAC" object:self];
}
-(IBAction)onClickColorBox:(id)sender{
  UIButton *btn = (UIButton *)sender;
  
  if([[btn backgroundColor] isEqual:[UIColor greenColor]]){
    [aacCardSelected setBordColorID:4];
  }else{
    [aacCardSelected setBordColorID:[Constants getColorIdByColor:[btn backgroundColor]]];
  }
  
  [viewCurrentBoarderColor setBackgroundColor:[btn backgroundColor]];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
  [self performSelector:@selector(updateAndYes) withObject:nil afterDelay:[Constants getDelayLoadingTime]];

//  [self updateAndSaveSelectedCard];
//  [self reloadScrollView:YES];
  [self toggleColorSelector:NO];
}

-(IBAction)onClickColorSelector:(id)sender{
  [self toggleColorSelector:YES];
}

-(IBAction)onCloseColorSelector:(id)sender{
  [self toggleColorSelector:NO];
}

-(IBAction)onCloseAddNewItemSelecor:(id)sender{
  [self toggleAddNewItemSelector:NO];
}

-(IBAction)onClickAddNewCard:(id)sender{
  [self addCard:aacCardNewItemBuffer];
  [self toggleAddNewItemSelector:NO];
}

-(IBAction)onClickAddNewFolder:(id)sender{
  [self addFolder:aacCardNewItemBuffer];
  [self toggleAddNewItemSelector:NO];
}

-(IBAction)onClickOpenCardLibrary:(id)sender{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
  [self performSelector:@selector(openCardLibrary) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
  //[self openCardLibrary];
}
-(IBAction)onClickAddPage:(id)sender{
  [self addPage];
}
-(IBAction)onClickDeletePage:(id)sender{
  UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:actionSheetDeletePage delegate:self cancelButtonTitle:nil destructiveButtonTitle:actionSheetConfirmDelete otherButtonTitles:actionSheetCancel,nil];
  [ac showInView:self.view];
  [ac setTag:1];
  [ac release];
}
-(IBAction)onClickDeleteCard:(id)sender{
  UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:actionSheetDeleteCard delegate:self cancelButtonTitle:nil destructiveButtonTitle:actionSheetConfirmDelete otherButtonTitles:actionSheetCancel,nil];
  [ac showInView:self.view];
  [ac setTag:2];
  [ac release];
}
-(IBAction)onClickMovePageToNext:(id)sender{
  if([pageControl currentPage]==[pageControl numberOfPages]-1){
    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]]){
      [Utils alert:@"這是溝通簿的最後一頁。"];
    }else{
      [Utils alert:@"这是沟通簿的最后一页。"];
    }
  }else{
    [self movePageTo:DIRECTION_RIGHT];
  }
}
-(IBAction)onClickMovePageToPrev:(id)sender{
  if([pageControl currentPage]==0){
    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]]){
      [Utils alert:@"這是溝通簿的首頁。"];
    }else{
      [Utils alert:@"这是沟通簿的首页。"];
    }
  }else{
    [self movePageTo:DIRECTION_LEFT];
  }
}
-(IBAction)onClickConfirmChangeCaptionCustom:(id)sender{
  
  [aacCardSelected setIsEmpty:NO];
  if([txtCaptionCustom.text length]>8)
    [[aacCardSelected getUserCard] setCaptionCustom:[txtCaptionCustom.text  substringToIndex:8]];
  else
    [[aacCardSelected getUserCard] setCaptionCustom:txtCaptionCustom.text];
  
  
//  [self updateAndSaveSelectedCard];
//  [self selectCard:aacCardSelected];
//  [self reloadScrollView:YES];
//  
//  [self.view endEditing:YES];

  [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
  [self performSelector:@selector(updateAndYes) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
  [self selectCard:aacCardSelected];
  [self.view endEditing:YES];
}
-(IBAction)onClickOpenDeviceLibrary:(id)sender{
  [self openDeviceLibrary:sender];
}
-(IBAction)onClickOpenDeviceCamera:(id)sender{
  [self openDeviceCamera:sender];
}
-(IBAction)onClickVoice:(id)sender{
  //    if([aacCardSelected get])
  if([loadedProfile getVoiceMode]==0){
    
  }else{
    if([[aacCardSelected getVoiceCustom] length]>0){
      
      NSString *filePath = [Utils getFullPath:[NSString stringWithFormat:@"/profiles/%@/%@.caf",[loadedProfile getProfileID],[aacCardSelected getVoiceCustom]]];
      
      [Utils playSoundofFilePath:filePath withCallBackObject:nil];
    }else{
      if([loadedProfile getVoiceMode]==1){
        if([[aacCardSelected getCardID] length]>0)
          [Utils playSoundOfCard:[aacCardSelected getCardID] withMode:1 withCallBackObject:nil];
      }
      if([loadedProfile getVoiceMode]==2){
        if([[aacCardSelected getCardID] length]>0)
          [Utils playSoundOfCard:[aacCardSelected getCardID] withMode:2 withCallBackObject:nil];
      }
    }
    
  }
}
-(IBAction)onClickVoiceMale:(id)sender{
  if([[aacCardSelected getCardID] length]>0)
    [Utils playSoundOfCard:[aacCardSelected getCardID] withMode:2 withCallBackObject:nil];
}
-(IBAction)onClickVoiceFemale:(id)sender{
  if([[aacCardSelected getCardID] length]>0)
    [Utils playSoundOfCard:[aacCardSelected getCardID] withMode:1 withCallBackObject:nil];
}
-(IBAction)onClickVoiceCustom:(id)sender{
  
  if([[aacCardSelected getVoiceCustom] length]>0){
    
    NSString *filePath = [Utils getFullPath:[NSString stringWithFormat:@"/profiles/%@/%@.caf",[loadedProfile getProfileID],[aacCardSelected getVoiceCustom]]];
    
    [Utils playSoundofFilePath:filePath withCallBackObject:nil];
  }
  
}
-(IBAction)onClickVoiceCustomEdit:(id)sender{
  [self recordCustomVoice];
}
-(IBAction)onClickVoiceCustomDelete:(id)sender{
  [self removeCustomVoice];
}
-(IBAction)onClickRecorderViewBase:(id)sender{
  //[self closeRecorder];
}

-(IBAction)onChangeCaption:(id)sender{
  if([txtCaptionCustom.text length]>MAX_LENGTH_FOR_CUSTOM_CAPTION)
    [txtCaptionCustom.text substringToIndex:MAX_LENGTH_FOR_CUSTOM_CAPTION];
}
//////////////////////////////////////////////
//run once/////////////////////////////////
-(void)loadProfile:(UserProfile *)profile{
  
  userCardFromCardView = [[NSMutableDictionary alloc]init];
  
  loadedProfile = profile;
  
  [lblProfileName setText:[loadedProfile getName]];
  
  layout = [profile getLayout];
  
  arrCardsetWhole = [[NSMutableArray alloc] initWithArray:[profile getCardset]];
  
  arrCardsetInUse = [[NSMutableArray alloc] initWithArray:arrCardsetWhole]; //defaul we will show all cards in the first level
  cardPerPage = [self getNumberOfCardPerPageFromLayout:layout];
  row = [self getRowFromLayout:layout];
  col = [self getColFromLayout:layout];
  numOfPage = ceil((float)[arrCardsetInUse count]/(float)cardPerPage)+1;
  
  stackedIndex = [[NSMutableArray alloc] init];
  [self initScrollView];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLoading" object:self];
  
  NSLog(@"gethere");
  if([loadedProfile getCaptionMode]==0){
    [lblCaptionTW setHidden:NO];
    [lblCaptionTWTitle setHidden:NO];
  }else{
    [lblCaptionCN setHidden:NO];
    [lblCaptionCNTitle setHidden:NO];
  }
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
  
  NSLog(@"start from here b ?");
  [self loadScrollViewWithPage:0];
  //return;
  //[self loadScrollViewWithPage:1];
  for(int x=0; x<=numOfPage; x++){
    [self loadScrollViewWithPage:x];
  }
}
-(void)loadScrollViewWithPage:(int)page{
  if (page<0 || page>=numOfPage) return ;
  
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
  NSDictionary *content = [Utils getContentFromPlist:PLIST_PROFILE];
  for(int i = (page)*cardPerPage; i<((page+1)*cardPerPage); i++){
    
    if(i<[arrCardsetInUse count]){
      NSMutableDictionary *tempD = [[NSMutableDictionary alloc] initWithDictionary:[arrCardsetInUse objectAtIndex:i]];
      
      UserCard *userCard = [[UserCard alloc] initWithContent:tempD];
      EditAACCard *aacCard = [[EditAACCard alloc] initWithUserCard:userCard cardIndex:i profileID:[loadedProfile getProfileID] withPlist:content];
      
      //NSMutableDictionary *tempD = [[NSMutableDictionary alloc] init];
      //UserCard *userCard = [[UserCard alloc] init];
      // EditAACCard *aacCard = [[EditAACCard alloc] init];
      
      //userCard = nil;
      //[userCard release];
      //[tempD release];
      
      
      if(i==tempSelectedCardIndex){
        aacCardSelected = aacCard;
        [aacCardSelected retain];
      }
      
      /*
       if(viewPage == nil){
       NSLog(@"is nil");
       }else{
       NSLog(@"is not nil");
       }
       
       if(aacCard == nil){
       NSLog(@"is aac nil");
       }else{
       NSLog(@"is not aac nil");
       }
       
       NSLog(@"check1 : %@",viewPage);
       NSLog(@"check2 : %@",aacCard);
       */
      
      [viewPage addSubview:aacCard.view];
      
      [aacCard resizeImageToSize:[self getCardSize:layout]];
      CGRect frame = aacCard.view.frame;
      
      frame.origin.x = (tempCounter % col) * [self getCardXMargin:layout] + (viewPage.frame.size.width - frame.size.width * col)/col/2;
      frame.origin.y = (int)floor(((float)tempCounter / (float)col)) * [self getCardYMargin:layout] + (viewPage.frame.size.height - frame.size.height * row)/row/2;
      
      aacCard.view.frame = frame;
      
      
    }else{
      
      //empty card
      
      UserCard *userCard = [[UserCard alloc]initWithEmptyContent];
      EditAACCard *aacCard = [[EditAACCard alloc] initWithUserCard:userCard cardIndex:i profileID:[loadedProfile getProfileID] withPlist:content];
      
      //userCard = nil;
      //[userCard release];
      
      [viewPage addSubview:aacCard.view];
      
      
      [aacCard resizeImageToSize:[self getCardSize:layout]];
      CGRect frame = aacCard.view.frame;
      
      frame.origin.x = (tempCounter % col) * [self getCardXMargin:layout] + (viewPage.frame.size.width - frame.size.width * col)/col/2;
      frame.origin.y = (int)floor(((float)tempCounter / (float)col)) * [self getCardYMargin:layout] + (viewPage.frame.size.height - frame.size.height * row)/row/2;
      
      aacCard.view.frame = frame;
      
    }
    
    
    tempCounter++;
  }
  [content release];
}

//folder////////////////////////////////////////
-(void)openFolder:(EditAACCard *)aacCard{
  //show back button
  [btnBack setHidden:NO];
  [stackedIndex addObject:[aacCard getCardIndex]];
  //[Utils removeAllChildOfPage:scrollView];
  [self updateScrollView:[[NSMutableArray alloc] initWithArray:[aacCard getCardset]] withPageNum:0 withAnimation:ANIMATION_OPEN_FOLDER retainSelectedCard:YES];
  [self deselectCard];
}
-(void)upOneFolder{
  NSMutableArray *tempCardset=[[NSMutableArray alloc] initWithArray:arrCardsetWhole];
  NSDictionary *tempAACCard=[[NSDictionary alloc] init];
  
  
  for(int i=0; i<[stackedIndex count]; i++){
    tempAACCard = [tempCardset objectAtIndex:[[stackedIndex objectAtIndex:i] intValue]];
    
    if(i<[stackedIndex count]-1)
      tempCardset = [[NSMutableArray alloc] initWithArray:[tempAACCard objectForKey:@"cardset"]];
    else{
      int pageNum = (int)floor( [[stackedIndex objectAtIndex:i] intValue] / cardPerPage );
      
      [self updateScrollView:tempCardset withPageNum:pageNum withAnimation:ANIMATION_CLOSE_FOLDER retainSelectedCard:YES];
    }
  }
  
  [stackedIndex removeLastObject];
  if([stackedIndex count]==0)[btnBack setHidden:YES];
  
  [self deselectCard];
}
-(void)updateScrollView:(NSMutableArray *)newCardset withPageNum:(int)pageNum withAnimation:(int)animation retainSelectedCard:(BOOL)retain{
  
  arrCardsetInUse = newCardset;
  numOfPage = ceil((float)[arrCardsetInUse count]/(float)cardPerPage)+1;
  
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
  
  
  
  tempSelectedCardIndex = [[aacCardSelected getCardIndex] intValue];
  
  //[Utils removeAllChild:scrollView];
  //if(retain)
  //   [Utils revmoeAllChildOfPage:scrollView exceptCard:aacCardSelected];
  //else
  //aacCardSelected = nil;
  
  [Utils removeAllChildOfPage:scrollView];
  
  
  
  scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * numOfPage , scrollView.frame.size.height);
  
  pageControl.numberOfPages = numOfPage;
  pageControl.currentPage = pageNum;
  
  
  //   [self loadScrollViewWithPage:pageNum];
  
  NSLog(@"start from here a ?");
  for(int x=0; x<=numOfPage; x++){
    [self loadScrollViewWithPage:x];
  }
  
  //}
  testcheck++;
  CGRect frame = scrollView.frame;
  frame.origin.x = frame.size.width * pageNum;
  frame.origin.y = 0;
  [scrollView scrollRectToVisible:frame animated:NO];
}
-(void)updateScrollView2:(NSMutableArray *)newCardset withPageNum:(int)pageNum withAnimation:(int)animation retainSelectedCard:(BOOL)retain{
  
  arrCardsetInUse = newCardset;
  numOfPage = ceil((float)[arrCardsetInUse count]/(float)cardPerPage)+1;
  
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
  
  tempSelectedCardIndex = [[aacCardSelected getCardIndex] intValue];
  
  //[Utils removeAllChild:scrollView];
  //if(retain)
  //   [Utils revmoeAllChildOfPage:scrollView exceptCard:aacCardSelected];
  //else
  //aacCardSelected = nil;
  
  [Utils removeAllChildOfPage:scrollView];
  
  scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * numOfPage , scrollView.frame.size.height);
  
  pageControl.numberOfPages = numOfPage;
  pageControl.currentPage = pageNum;
  
  //if(testcheck<1){
  //    [self loadScrollViewWithPage:pageNum-1];  // seems no use, will load all anyway
  //[self loadScrollViewWithPage:pageNum];
  //[self loadScrollViewWithPage:pageNum+1];
  
  
  NSLog(@"reloading scroll view");
  for(int x=0; x<=numOfPage; x++){
    [self loadScrollViewWithPage:x];
  }
  //}
  testcheck++;
  CGRect frame = scrollView.frame;
  frame.origin.x = frame.size.width * pageNum;
  frame.origin.y = 0;
  [scrollView scrollRectToVisible:frame animated:NO];
}
-(IBAction)onClickTestAddPages:(id)sender{
  [self testAddPage];
}
-(IBAction)onClickTestDelPages:(id)sender{
  [self testDelPage];
}
-(void)testAddPage{
  //[self initScrollView];
  //[self openRecorder];
  
  //[self loadScrollViewWithPage:0];
  //[self updateAndSaveSelectedCard];
  NSLog(@"%@",arrCardsetInUse);
  NSLog(@"arrCardSetInUse count : %d",[arrCardsetInUse count]);
  
}
-(void)testDelPage{
  [Utils removeAllChildOfPage:scrollView];
  //[self closeRecorder];
}

//about selected card///////////////////////////////////////
-(void)selectCard:(EditAACCard *)aacCard{
  
  if(aacCard == NULL || aacCard == nil){
    NSLog(@"\n1:%@\n2:%@\n3:%d",stackedIndex, stackedIndexForSelectedCard, tempSelectedCardIndex);
    return;
  }
  
  aacCardSelected = aacCard;
  stackedIndexForSelectedCard = [[NSMutableArray alloc] initWithArray:stackedIndex];
  
  if(![aacCardSelected isEmpty]){
    [imgSelectedCardImage setImage:[aacCardSelected getCardImage]];
  }else
    [imgSelectedCardImage setImage:[UIImage imageNamed:@"empty_card_edit.png"]];
  
  NSLog(@">>>>>>>>>>before");
  NSLog(@"[%d],[%d]", [aacCardSelected isCard], [aacCardSelected isEmpty]);
  if(![aacCardSelected isCard] && ![aacCardSelected isEmpty]) {
//    [self updateAndSaveSelectedCard];
//    [self reloadScrollView:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
    [self performSelector:@selector(updateAndYes) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
  }
  
  
  NSLog(@">>>>>>>>>>end:%@",aacCardSelected);
  [lblCaptionCN setText:[aacCardSelected getCaptionRawCN]];
  [lblCaptionTW setText:[aacCardSelected getCaptionRawTW]];
  [txtCaptionCustom setText:[aacCardSelected getCaptionRawCustom]];
  
  
  [btnSwap setEnabled:YES];
  [btnChangeColor setEnabled:YES];
  [btnOpenCardLibrary setEnabled:YES];
  [btnDeleteCard setEnabled:YES];
  [btnConfirmChangeCaptionCustom setEnabled:YES];
  [btnOpenDeviceLibrary setEnabled:YES];
  [btnOpenDeviceCamera setEnabled:YES];
  [btnVoice setEnabled:YES];
  [btnVoiceMale setEnabled:YES];
  [btnVoiceFemale setEnabled:YES];
  [btnVoiceCustomEdit setEnabled:YES];
  if([[aacCardSelected getVoiceCustom] length]>0){
    [btnVoiceCustom setEnabled:YES];
    [btnVoiceCustomDelete setEnabled:YES];
  }else{
    [btnVoiceCustom setEnabled:NO];
    [btnVoiceCustomDelete setEnabled:NO];
  }
  
  
  
}
-(void)deselectCard{
  aacCardSelected = nil;
  stackedIndexForSelectedCard = nil;
  [imgSelectedCardImage setImage:[UIImage imageNamed:@"empty_card.png"] ];
  
  [lblCaptionCN setText:@""];
  [lblCaptionTW setText:@""];
  [txtCaptionCustom setText:@""];
  
  [btnDeleteCard setEnabled:NO];
  [btnSwap setEnabled:NO];
  [btnChangeColor setEnabled:NO];
  [btnOpenCardLibrary setEnabled:NO];
  [btnConfirmChangeCaptionCustom setEnabled:NO];
  [btnOpenDeviceLibrary setEnabled:NO];
  [btnOpenDeviceCamera setEnabled:NO];
  
  [btnVoice setEnabled:NO];
  [btnVoiceMale setEnabled:NO];
  [btnVoiceFemale setEnabled:NO];
  [btnVoiceCustom setEnabled:NO];
  [btnVoiceCustomEdit setEnabled:NO];
  [btnVoiceCustomDelete setEnabled:NO];
}
-(void)swapCard:(EditAACCard *)aacCard{
  _isSwapMode = NO;
  [btnSwap setSelected:NO];
  
  
  //::::::::logic:::::::::
  //first, we have to get
  //- subtree of originalCard
  //- subtree of targetedCard
  //
  //then we can get the original object from the subtree(array) with the oriCardIndex
  //also, we can get the targeted object from the subtree with the tarCardIndex
  //
  //as we have 2 object, then we can use replaceObjectAtIndex to swap 2 objects
  //
  //finally, we have to update the whole tree with the new subtree & reload the current tree
  
  int oriCardIndex = [[aacCardSelected getCardIndex] intValue];
  int tarCardIndex = [[aacCard getCardIndex] intValue];
  
  [aacCardSelected setCardIndex:tarCardIndex];
  [aacCard setCardIndex:oriCardIndex];
  
  
  NSMutableArray *tarCardSubTree = [[NSMutableArray alloc] initWithArray:[self getSubCardSetByStack:stackedIndex]];
  
  if(![stackedIndex isEqualToArray:stackedIndexForSelectedCard]){
    UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"" message:@"You cannot swap 2 cards in different categories" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
    [av release];
  }else{
    if(tarCardIndex >= [tarCardSubTree count]){
      //clicking on real empty card
      //we have to fill in the array with empty cards for the exchangeIndex
      int numOfExtraEmtpyCards = tarCardIndex - ([tarCardSubTree count] - 1);
      
      for(int n=0;n<numOfExtraEmtpyCards;n++){
        UserCard *userCard = [[UserCard alloc]initWithEmptyContent];
        [tarCardSubTree addObject:[userCard getDictionaryContent]];
      }
    }
    
    [tarCardSubTree exchangeObjectAtIndex:oriCardIndex withObjectAtIndex:tarCardIndex];
    
    NSMutableArray **pTarCardSubTree ;
    pTarCardSubTree = &tarCardSubTree;
    
    //next we have to remove all empty cards after the last non-empty cards
    
    
    [self removeEmptyCardsInTail:pTarCardSubTree];
    //////////////////////////////////
    
    [self recurGetSubCardSet:stackedIndex oriArray:&arrCardsetWhole token:0 withContent:pTarCardSubTree];
    
  }
  
  
  [self saveProfile];
  
  int pageNum = (int)floor( [[aacCardSelected getCardIndex] intValue] / cardPerPage );
  [self updateScrollView:tarCardSubTree withPageNum:pageNum withAnimation:ANIMATION_NONE retainSelectedCard:YES];
  //[self updateScrollView:tarCardSubTree withPageNum:0 withAnimation:ANIMATION_NONE];
  
  /*
   NSLog(@"retain count %p :%d",&tarCardSubTree, [tarCardSubTree retainCount]);
   //tarCardSubTree = nil;
   //[tarCardSubTree release];
   */
  
  testcheck++;
  NSLog(@"-- %d",testcheck);
  [[NSNotificationCenter defaultCenter] postNotificationName:@"showAsNormal" object:self];
  //NSLog(@"checkpoint");
  NSLog(@"====");
  
}
-(NSMutableArray *)getSubCardSetByStack:(NSMutableArray *)stack{
  
  //NSMutableArray *tempCardset=[[[NSMutableArray alloc] initWithArray:arrCardsetWhole] autorelease];
  NSMutableArray *tempCardset = arrCardsetWhole;
  
  NSDictionary *tempAACCard;//=[[NSDictionary alloc] init];
  for(int i=0; i<[stack count]; i++){
    tempAACCard = [tempCardset objectAtIndex:[[stack objectAtIndex:i] intValue]];
    //if(i<[stack count]-1)
    tempCardset = [[NSMutableArray alloc] initWithArray:[tempAACCard objectForKey:@"cardset"]];
  }
  //[tempAACCard release];
  return tempCardset;
}
-(void)recurGetSubCardSet:(NSArray *)stack oriArray:(NSMutableArray **)oriArray token:(int)t withContent:(NSMutableArray **)content{
  //return;
  int j = [stack count]-1-t;
  //NSMutableArray *x = *oriArray;
  
  if(j>0){
    NSMutableDictionary *tempAACCard = [*oriArray objectAtIndex:[[stack objectAtIndex:t]intValue]];
    NSMutableArray *tempAACCardCardset = [tempAACCard objectForKey:@"cardset"];
    NSMutableArray **p = &tempAACCardCardset;
    return [self recurGetSubCardSet:stack oriArray:p token:t+1 withContent:content];
  }
  if([stack count]>0){
    //[*oriArray replaceObjectAtIndex:t withObject:[*content objectAtIndex:[[stack objectAtIndex:t] intValue]]];
    NSMutableDictionary *tempAACCard = [*oriArray objectAtIndex:[[stack objectAtIndex:t]intValue]];
    NSMutableDictionary *newAACCard = [[NSMutableDictionary alloc] initWithDictionary:tempAACCard];
    [tempAACCard release];
    [newAACCard setValue:*content forKey:@"cardset"];
    
    //NSLog(@"be : %@",[*oriArray objectAtIndex:[[stack objectAtIndex:t]intValue]]);
    //NSLog(@"to : %@",newAACCard);
    
    [*oriArray replaceObjectAtIndex:[[stack objectAtIndex:t] intValue] withObject:newAACCard];
  }else{
    *oriArray = *content;
  }
}
-(NSMutableArray *)recurGetSubCardSet:(NSArray *)stack oriArray:(NSMutableArray *)oriArray token:(int)t{
  int j = [stack count]-1-t;
  if(j>0){
    return [self recurGetSubCardSet:stack oriArray:[oriArray objectAtIndex:[[stack objectAtIndex:t] intValue]] token:t+1];
  }
  if([stack count]>0)
    return [oriArray objectAtIndex:[[stack objectAtIndex:t] intValue]];
  else
    return oriArray;
}
-(void)removeEmptyCardsInTail:(NSMutableArray **)content{
  for(int m=[*content count]-1;m>=0;m--){
    NSMutableDictionary *userCard = [*content objectAtIndex:m];
    if([[userCard objectForKey:@"card_id"] isEqualToString:@"empty_card"] &&
       [[userCard objectForKey:@"image_custom"] isEqualToString:@""] &&
       [[userCard objectForKey:@"voice_custom"] isEqualToString:@""] &&
       [[userCard objectForKey:@"caption_custom"] isEqualToString:@""]
       ){
      [*content removeObjectAtIndex:m];
    }else{
      return;
    }
  }
  return;
}
//////////////////////////////////////////////
-(void)toggleFolderSelector:(BOOL) isToggle{
  if(isToggle){
    [btnOpenFolder setEnabled:!_isSwapMode];
    [self.view addSubview:viewFolderSelector];
  }else{
    [viewFolderSelector removeFromSuperview];
    aacCardFolderBuffer = nil;
  }
}
-(void)toggleColorSelector:(BOOL) isToggle{
  if(isToggle){
    [self.view addSubview:viewColorSelector];
  }else{
    [viewColorSelector removeFromSuperview];
  }
}
-(void)toggleAddNewItemSelector:(BOOL) isToggle{
  if(isToggle){
    [self.view addSubview:viewAddNewItemSelector];
  }else{
    [viewAddNewItemSelector removeFromSuperview];
    aacCardFolderBuffer = nil;
  }
}

-(void)saveProfile{
  [loadedProfile setCardset:arrCardsetWhole];
  //[ProfileHandler updateProfile:loadedProfile];
  [ProfileHandler updateProfileWithoutReload:loadedProfile];
}
-(void)reloadScrollView:(BOOL)retainCard{
  NSMutableArray *tarCardSubTree = [[NSMutableArray alloc] initWithArray:[self getSubCardSetByStack:stackedIndexForSelectedCard]];
  
  if([stackedIndex isEqualToArray:stackedIndexForSelectedCard]){
    int pageNum = (int)floor( [[aacCardSelected getCardIndex] intValue] / cardPerPage );
    [self updateScrollView2:tarCardSubTree withPageNum:pageNum withAnimation:ANIMATION_NONE retainSelectedCard:retainCard];
  }
  
}

//////////////////////////////////////////////
-(void)addCard:(EditAACCard *)aacCard{
  [aacCard setIsCard:YES];
  //add an empty card first
  
  [self selectCard:aacCard];
}
-(void)deleteCard{
  /*
   UserCard *userCard = [aacCardSelected getUserCard];
   
   [loadedProfile deleteCustomImageFile:[userCard getImageCustom]];
   
   */
  
  if(![[aacCardSelected.getUserCard getImageCustom] isEqualToString:@""])
    [loadedProfile deleteCustomImageFile:[aacCardSelected.getUserCard getImageCustom]];
  
  UserCard *userCard = [[UserCard alloc]initWithEmptyContent];
  aacCardSelected = [[EditAACCard alloc] initWithUserCard:userCard cardIndex:[[aacCardSelected getCardIndex] intValue ] profileID:[loadedProfile getProfileID]];
  
//  [self updateAndSaveSelectedCard];
//  [self reloadScrollView:NO];
//  [self deselectCard];
//  
//  [aacCardSelected release];
//  aacCardSelected = nil;
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
  [self performSelector:@selector(updateAndNo) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
//  [self deselectCard];
//  [aacCardSelected release];
//  aacCardSelected = nil;
}

-(void)addFolder:(EditAACCard *)aacCard{
  [aacCard setCardID:@""];
  [aacCard setIsCard:NO];
  [aacCard setEmptyCardset];
  
  [self selectCard:aacCard];
}
//////////////////////////////////////////////
-(void)addPage{
  if([pageControl currentPage]==[pageControl numberOfPages]-1){
    
    
    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]]){
      UIAlertView *av =[[UIAlertView alloc] initWithTitle:@"" message:@"這是空白頁，未能再增加頁面。" delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil];
      [av show];
      [av release];
    }else{
      UIAlertView *av =[[UIAlertView alloc] initWithTitle:@"" message:@"这是空白页，未能再增加页面。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
      [av show];
      [av release];
    }
    return;
  }
  
  NSMutableArray *currentCardSubTree = [[NSMutableArray alloc] initWithArray:[self getSubCardSetByStack:stackedIndex]];
  int cutIndex = ([pageControl currentPage])*cardPerPage;
  
  NSMutableArray *arrHead = [[NSMutableArray alloc] init];
  NSMutableArray *arrTail = [[NSMutableArray alloc] init];
  NSMutableArray *arrMiddle = [[NSMutableArray alloc] init];//new array for empty
  NSMutableArray *arrMerged = [[NSMutableArray alloc] init];
  
  //init arrMiddlew with empty card
  for(int i=0;i<cardPerPage;i++){
    UserCard *userCard = [[UserCard alloc]initWithEmptyContent];
    [arrMiddle addObject:[userCard getDictionaryContent]];
  }
  
  //splite the current array into 2 arrays
  for(int i=0;i<[currentCardSubTree count];i++){
    if(i<cutIndex){
      [arrHead addObject:[currentCardSubTree objectAtIndex:i]];
    }else{
      [arrTail addObject:[currentCardSubTree objectAtIndex:i]];
    }
  }
  
  [arrMerged addObjectsFromArray:arrHead];
  [arrMerged addObjectsFromArray:arrMiddle];
  [arrMerged addObjectsFromArray:arrTail];
  
  NSMutableArray **pCurrentCardSubTree ;
  pCurrentCardSubTree = &arrMerged;
  
  [self recurGetSubCardSet:stackedIndex oriArray:&arrCardsetWhole token:0 withContent:pCurrentCardSubTree];
  [self saveProfile];
  
  [self updateScrollView:arrMerged withPageNum:[pageControl currentPage] withAnimation:ANIMATION_NONE retainSelectedCard:YES];
}
-(void)deletePage{
  NSMutableArray *currentCardSubTree = [[NSMutableArray alloc] initWithArray:[self getSubCardSetByStack:stackedIndex]];
  int cutIndex = ([pageControl currentPage])*cardPerPage;
  
  NSMutableArray *arrHead = [[NSMutableArray alloc] init];
  NSMutableArray *arrTail = [[NSMutableArray alloc] init];
  NSMutableArray *arrMiddle = [[NSMutableArray alloc] init];//new array for empty
  NSMutableArray *arrMerged = [[NSMutableArray alloc] init];
  
  for(int i=0;i<[currentCardSubTree count];i++){
    if(i<cutIndex){
      [arrHead addObject:[currentCardSubTree objectAtIndex:i]];
    }else if(i>=cutIndex && i<(cutIndex+cardPerPage)){
      [arrMiddle addObject:[currentCardSubTree objectAtIndex:i]];
    }else{
      [arrTail addObject:[currentCardSubTree objectAtIndex:i]];
    }
  }
  
  [arrMerged addObjectsFromArray:arrHead];
  [arrMerged addObjectsFromArray:arrTail];
  
  NSMutableArray **pCurrentCardSubTree ;
  pCurrentCardSubTree = &arrMerged;
  
  //next we have to remove all empty cards after the last non-empty cards
  [self removeEmptyCardsInTail:pCurrentCardSubTree];
  
  [self recurGetSubCardSet:stackedIndex oriArray:&arrCardsetWhole token:0 withContent:pCurrentCardSubTree];
  [self saveProfile];
  
  [self updateScrollView:arrMerged withPageNum:[pageControl currentPage] withAnimation:ANIMATION_NONE retainSelectedCard:YES];
}
-(void)movePageTo:(NSString *)direction{
  NSMutableArray *currentCardSubTree = [[NSMutableArray alloc] initWithArray:[self getSubCardSetByStack:stackedIndex]];
  int cutIndex = ([pageControl currentPage])*cardPerPage;
  
  //for(int m=0;m<[currentCardSubTree count];m++){
  //    NSLog(@"--%@",[[currentCardSubTree objectAtIndex:m] objectForKey:@"card_id"]);
  //}
  
  NSMutableArray *arrHead = [[NSMutableArray alloc] init];
  NSMutableArray *arrTail = [[NSMutableArray alloc] init];
  NSMutableArray *arrMiddle1 = [[NSMutableArray alloc] init];
  NSMutableArray *arrMiddle2 = [[NSMutableArray alloc] init];
  
  NSMutableArray *arrMerged = [[NSMutableArray alloc] init];
  
  
  //fill up all empty slot with real emtpy card obect at the end before slice
  int numberOfEmptyCardToAdd = [pageControl numberOfPages]*cardPerPage-[currentCardSubTree count];
  for(int j=0;j<numberOfEmptyCardToAdd;j++){
    UserCard *userCard = [[UserCard alloc]initWithEmptyContent];
    [currentCardSubTree addObject:[userCard getDictionaryContent]];
  }
  
  NSLog(@"---------------%@",direction);
  if([direction isEqualToString:DIRECTION_LEFT]){
    //normal case
    for(int i=0;i<[currentCardSubTree count];i++){
      if(i<cutIndex-cardPerPage){
        //NSLog(@"head : %d",i);
        [arrHead addObject:[currentCardSubTree objectAtIndex:i]];
      }else if(i>=(cutIndex-cardPerPage) && i<cutIndex){
        //NSLog(@"mid1 : %d",i);
        [arrMiddle1 addObject:[currentCardSubTree objectAtIndex:i]];
      }else if(i>=cutIndex && i<cutIndex+cardPerPage){
        //NSLog(@"mid2 : %d",i);
        [arrMiddle2 addObject:[currentCardSubTree objectAtIndex:i]];
      }else{
        //NSLog(@"tail : %d",i);
        [arrTail addObject:[currentCardSubTree objectAtIndex:i]];
      }
    }
    
    /*
     //when moving the last empty page to the left
     //as the last empty page is actually not exist,
     //we have to add empty card to mid2 rather than just move the page
     //in this case, tail should be EMPTY too
     if([pageControl currentPage]==[pageControl numberOfPages]-1){
     for(int n=0;n<numOfPage;n++){
     UserCard *userCard = [[UserCard alloc]initWithEmptyContent];
     [arrMiddle2 addObject:[userCard getDictionaryContent]];
     }
     }
     */
  }else{
    //normal case
    for(int i=0;i<[currentCardSubTree count];i++){
      if(i<cutIndex){
        //NSLog(@"head : %d",i);
        [arrHead addObject:[currentCardSubTree objectAtIndex:i]];
      }else if(i>=cutIndex && i<cutIndex+cardPerPage){
        //NSLog(@"mid1 : %d",i);
        [arrMiddle1 addObject:[currentCardSubTree objectAtIndex:i]];
      }else if(i>=(cutIndex+cardPerPage) && i<cutIndex+cardPerPage*2){
        //NSLog(@"mid2 : %d",i);
        [arrMiddle2 addObject:[currentCardSubTree objectAtIndex:i]];
      }else{
        //NSLog(@"tail : %d",i);
        [arrTail addObject:[currentCardSubTree objectAtIndex:i]];
      }
    }
    
    /*
     //when moving the n-1 page to the right
     //we have to pre-add emtpy card to the n (last) page, which is phyically not exist, before move
     if([pageControl currentPage]==[pageControl numberOfPages]-2){
     for(int n=0;n<numOfPage;n++){
     UserCard *userCard = [[UserCard alloc]initWithEmptyContent];
     [arrMiddle2 addObject:[userCard getDictionaryContent]];
     }
     }
     */
  }
  
  for(int m=0;m<[arrHead count];m++){
    NSLog(@"HD--%@",[[arrHead objectAtIndex:m] objectForKey:@"card_id"]);
  }
  for(int m=0;m<[arrMiddle2 count];m++){
    NSLog(@"M2--%@",[[arrMiddle2 objectAtIndex:m] objectForKey:@"card_id"]);
  }
  for(int m=0;m<[arrMiddle1 count];m++){
    NSLog(@"M1--%@",[[arrMiddle1 objectAtIndex:m] objectForKey:@"card_id"]);
  }
  for(int m=0;m<[arrTail count];m++){
    NSLog(@"TL--%@",[[arrTail objectAtIndex:m] objectForKey:@"card_id"]);
  }
  
  [arrMerged addObjectsFromArray:arrHead];
  [arrMerged addObjectsFromArray:arrMiddle2];
  [arrMerged addObjectsFromArray:arrMiddle1];
  [arrMerged addObjectsFromArray:arrTail];
  
  NSMutableArray **pCurrentCardSubTree ;
  pCurrentCardSubTree = &arrMerged;
  
  //for(int m=0;m<[arrMerged count];m++){
  //    NSLog(@"--%@",[[arrMerged objectAtIndex:m] objectForKey:@"card_id"]);
  //}
  
  //next we have to remove all empty cards after the last non-empty cards
  [self removeEmptyCardsInTail:pCurrentCardSubTree];
  
  [self recurGetSubCardSet:stackedIndex oriArray:&arrCardsetWhole token:0 withContent:pCurrentCardSubTree];
  [self saveProfile];
  
  if([direction isEqualToString:DIRECTION_LEFT])
    [self updateScrollView:arrMerged withPageNum:[pageControl currentPage]-1 withAnimation:ANIMATION_NONE retainSelectedCard:YES ];
  else
    [self updateScrollView:arrMerged withPageNum:[pageControl currentPage]+1 withAnimation:ANIMATION_NONE retainSelectedCard:YES];
}
//card library////////////////////////////////
-(void)openCardLibrary{
  //this function is overrided
}

//device library//////////////////////////////
-(void)openDeviceLibrary:(id)sender{
  isPickFromAlbum = YES;
  //[Utils listDirectory:[Utils getFullPath:[NSString stringWithFormat:@"profiles/%@",[loadedProfile getProfileID]]]];
  imagePickerController = [[UIImagePickerController alloc] init];
  imagePickerController.delegate = self;
  imagePickerController.allowsEditing = YES;
  
  if (NSClassFromString(@"UISplitViewController") != nil && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //currentDeviceType = iPad;
    popoverController=[[UIPopoverController alloc] initWithContentViewController:imagePickerController];
    popoverController.delegate=self;
    [popoverController presentPopoverFromRect:((UIButton *)sender).bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
  }
  else {
    //currentDeviceType = iPhone;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.viewController presentModalViewController:imagePickerController animated:YES];
  }
}
//device camera//////////////////////////////
-(void)openDeviceCamera:(id)sender{
  isPickFromAlbum = NO;
  
  imagePickerController = [[UIImagePickerController alloc] init];
  imagePickerController.delegate = self;
  imagePickerController.allowsEditing = YES;
  imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
  
  //imagePickerController.view.frame = self.view.frame;
  
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate.viewController presentModalViewController:imagePickerController animated:YES];
  //[self.view addSubview:imagePickerController.view];
}
//////////////////////////////////////////////
#pragma even handler
-(void) onClickAACCard:(NSNotification *)notification{
  EditAACCard *clickedAACCard = (EditAACCard *)notification.object;
  
  if([clickedAACCard isEmpty]){
    //is empty card
    if(_isSwapMode){
      [self swapCard:clickedAACCard];
      [self deselectCard];
    }else{
      aacCardNewItemBuffer = clickedAACCard;
      [self toggleAddNewItemSelector:YES];
    }
  }else{
    if([clickedAACCard isCard]){
      //is card
      if(_isSwapMode){
        [self swapCard:clickedAACCard];
        [self deselectCard];
      }else{
        [self selectCard:clickedAACCard];
      }
    }else{
      //is folder
      aacCardFolderBuffer = clickedAACCard;
      if(!_isSwapMode){
        [self toggleFolderSelector:YES];
      }else{
        [self swapCard:aacCardFolderBuffer];
        [self deselectCard];
      }
    }
  }
}
-(void) onFinishedSelectCardFromLibrary:(NSNotification *)notification{
  
  LibCard *selectedLibCard = (LibCard *)notification.object;
  
  if(notification.object == nil){
    [vcLibCardSelector.view removeFromSuperview];
    [vcLibCardSelector release];
    vcLibCardSelector = nil;
    return ;
  }
  
  [aacCardSelected setCardID:[selectedLibCard getCardID]];
  [aacCardSelected.getUserCard setImageCustom:@""];
  // UserCard *userCard = [aacCardSelected getUserCard];
  
  [self updateAndSaveSelectedCard];
  [self reloadScrollView:YES];
  [self selectCard:aacCardSelected];
  
  [vcLibCardSelector.view removeFromSuperview];
  [vcLibCardSelector release];
  vcLibCardSelector = nil;
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLoading" object:self];
}
////////////////////////////////////
//update the selected card
-(void)updateAndSaveSelectedCard{
  
  NSMutableArray *tarCardSubTree = [[NSMutableArray alloc] initWithArray:[self getSubCardSetByStack:stackedIndexForSelectedCard]];
  
  if([[aacCardSelected getCardIndex] intValue] >= [tarCardSubTree count]){
    //clicking on real empty card
    //we have to fill in the array with empty cards for the exchangeIndex
    int numOfExtraEmtpyCards = [[aacCardSelected getCardIndex] intValue] - ([tarCardSubTree count] - 1);
    for(int n=0;n<numOfExtraEmtpyCards;n++){
      UserCard *userCard = [[UserCard alloc]initWithEmptyContent];
      [tarCardSubTree addObject:[userCard getDictionaryContent]];
    }
  }
  
  [tarCardSubTree replaceObjectAtIndex:[[aacCardSelected getCardIndex]intValue] withObject:[aacCardSelected getUserCardContent]];
  
  NSMutableArray **pTarCardSubTree ;
  pTarCardSubTree = &tarCardSubTree;
  
  //NSLog(@"%@",tarCardSubTree);
  //next we have to remove all empty cards after the last non-empty cards
  [self removeEmptyCardsInTail:pTarCardSubTree];
  
  [self recurGetSubCardSet:stackedIndex oriArray:&arrCardsetWhole token:0 withContent:pTarCardSubTree];
  
  [self saveProfile];
  
  // Seems no need, will call reloadScrollView afterwards anyways
//      if([stackedIndex isEqualToArray:stackedIndexForSelectedCard]){
//          int pageNum = (int)floor( [[aacCardSelected getCardIndex] intValue] / cardPerPage );
//          [self updateScrollView:tarCardSubTree withPageNum:pageNum withAnimation:ANIMATION_NONE retainSelectedCard:YES];
//      }
  return;
}
-(void)setCustomImage:(UIImage *)image{
  //get custom image name
  
  NSDate* date = [NSDate date];
  NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
  [formatter setDateFormat:@"yyMMddHHmmssSSS"];
  NSString* fileName = [formatter stringFromDate:date];
  
  UserCard *userCard = [aacCardSelected getUserCard];
  
  [loadedProfile deleteCustomImageFile:[userCard getImageCustom]];
  
  
  [aacCardSelected setIsEmpty:NO];
  [userCard setImageCustom:fileName];
  
  [loadedProfile saveCustomImage:image fileName:fileName];
  
//  [self updateAndSaveSelectedCard];
//  [self reloadScrollView:YES];
//  [self selectCard:aacCardSelected];

  [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
  [self performSelector:@selector(updateAndYes) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
  [self selectCard:aacCardSelected];
}

//all about recording
-(void)recordCustomVoice{
  [self openRecorder];
}
-(void)onClickDelSoundFromRecorder:(NSNotification *)notification{
  [self removeCustomVoice];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"deletedCustomVoice" object:self];
}
-(void)onExitRecorder:(NSNotification *)notification{
  [self closeRecorder];
}
-(void)onSaveAndExitRecorder:(NSNotification *)notification{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLoading" object:self];
  
  NSDate* date = [NSDate date];
  NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
  [formatter setDateFormat:@"yyMMddHHmmssSSS"];
  NSString* fileName = [formatter stringFromDate:date];
  
  //[formatter release];
  
  UserCard *userCard = [aacCardSelected getUserCard];
  
  [loadedProfile deleteCustomVoice:[NSString stringWithFormat:@"%@.caf",[userCard getVoiceCustom]]];
  [aacCardSelected setIsEmpty:NO];
  [userCard setVoiceCustom:fileName];
  
  [loadedProfile saveCustomVoice:fileName];
  
//  [self updateAndSaveSelectedCard];
//  [self reloadScrollView:YES];
//  [self selectCard:aacCardSelected];
//  
//  [self closeRecorder];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
  [self performSelector:@selector(updateAndYes) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
  [self selectCard:aacCardSelected];
  
  [self closeRecorder];

}
-(void)removeCustomVoice{
  //iphone overrided this function
  UserCard *userCard = [aacCardSelected getUserCard];
  
  [loadedProfile deleteCustomVoice:[userCard getVoiceCustom]];
  [aacCardSelected setIsEmpty:NO];
  [userCard setVoiceCustom:@""];
  
//  [self updateAndSaveSelectedCard];
//  [self reloadScrollView:YES];
//  [self selectCard:aacCardSelected];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
  [self performSelector:@selector(updateAndYes) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
  [self selectCard:aacCardSelected];
  
}
-(void)openRecorder{
  if(recordViewController == nil){
    recordViewController = [[RecorderViewController alloc] init];
  }
  
  [recordViewController resetRecorder];
  
  //        NSString *filePath = [Utils getFullPath:[NSString stringWithFormat:@"/profiles/%@/%@.caf",[loadedProfile getProfileID],[aacCardSelected getVoiceCustom]]];
  
  
  CGRect frame = recordViewController.view.frame;
  frame.origin.x = (viewRecorderViewBase.frame.size.width - recordViewController.view.frame.size.width)/2;
  frame.origin.y = (viewRecorderViewBase.frame.size.height - recordViewController.view.frame.size.height)/2;
  
  recordViewController.view.frame = frame;
  
  [viewRecorderViewBase addSubview:recordViewController.view];
  [self.view addSubview:viewRecorderViewBase];
  
  if(![[aacCardSelected getVoiceCustom] isEqualToString:@""]){
    NSLog(@"PATH BEFORE FX :%@",[Utils getFullPath:[NSString stringWithFormat:@"/profiles/%@/%@.caf",[loadedProfile getProfileID],[aacCardSelected getVoiceCustom]]]);
    
    [recordViewController setCustomVoice:[Utils getFullPath:[NSString stringWithFormat:@"/profiles/%@/%@.caf",[loadedProfile getProfileID],[aacCardSelected getVoiceCustom]]]];
  }
}
-(void)closeRecorder{
  [viewRecorderViewBase removeFromSuperview];
  [recordViewController.view removeFromSuperview];
  [recordViewController release];
  recordViewController = nil;
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
  if(layoutID == LAYOUT_1X2) return 460;
  if(layoutID == LAYOUT_1X3) return 380;
  if(layoutID == LAYOUT_2X4) return 240;
  if(layoutID == LAYOUT_2x6) return 190;
  if(layoutID == LAYOUT_3X6) return 166;
  
  return 1;
}
-(int)getCardXMargin:(int)layoutID{
  if(layoutID == LAYOUT_1X1) return 460;
  if(layoutID == LAYOUT_1X2) return 460;
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
  if(layoutID == LAYOUT_2X4) return 260;
  if(layoutID == LAYOUT_2x6) return 240;
  if(layoutID == LAYOUT_3X6) return 166;
  
  return 1;
}
-(void)debug{
  NSLog(@"arrCardsetWhole : \n%@",arrCardsetWhole);
}

#pragma imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)_img editingInfo:(NSDictionary *)editInfo{
  NSLog(@"close image picker");
  [imagePickerController release];
  
  
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
  NSString *imageSourceKey;
  //if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
  imageSourceKey = @"UIImagePickerControllerEditedImage";
  //else
  //    imageSourceKey = @"UIImagePickerControllerOriginalImage";
  
  UIImage *image = [Utils resizeImageWithImage:[Utils cropCenterOfImageWithImage:[info objectForKey:imageSourceKey]] toSize:CGSizeMake(500, 500)];
  //UIImage *image = [Utils resizeImageWithImage:[Utils cropCenterOfImageWithImage:[info objectForKey:@"UIImagePickerControllerEditedImage"]] toSize:CGSizeMake(500, 500)];
  
  
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
  
  [self setCustomImage:image];
  NSLog(@"close image picker with selected data");
  
  
  if(isPickFromAlbum){
    NSLog(@"ispickfromalbum");
    [popoverController dismissPopoverAnimated:YES];
  }else{
    NSLog(@"is not pickfromalbum");
  }
  
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate.viewController dismissModalViewControllerAnimated:YES];
  [imagePickerController.view removeFromSuperview];
  
  [imagePickerController release];
  //    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
  //    [[imagePickerController parentViewController] dismissModalViewControllerAnimated:YES];
  
  
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
  
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate.viewController dismissModalViewControllerAnimated:YES];
  [imagePickerController.view removeFromSuperview];
  [imagePickerController release];
}
#pragma popover
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)pc{
  [popoverController dismissPopoverAnimated:YES];
  [popoverController release];
}
#pragma textField
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  if(textField.text.length >= MAX_LENGTH_FOR_CUSTOM_CAPTION && range.length==0){
    return NO;
  }else{
    return YES;
  }
}
#pragma actionsheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if([actionSheet tag]==1){
    if (buttonIndex == 0) {
      [self deletePage];
    }
  }
  
  if([actionSheet tag]==2){
    if(buttonIndex == 0){
      [self deleteCard];
    }
  }
}

#pragma language
-(void)onApplicatoinChangeLang:(NSNotification *)notification{
  [self setLanguage:notification.object];
  NSLog(@"applicatoinChangeLang : editaacviewcontroller");
}
-(void)setLanguage:(NSString *)lang{
  if([lang isEqualToString:[Constants getLanguageCodeTW]]){
    [btnOpenCardLibrary setTitle:[Utils getText:@"圖庫" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnOpenDeviceLibrary setTitle:[Utils getText:@"相簿" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnOpenDeviceCamera setTitle:[Utils getText:@"相機" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnVoiceMale setTitle:[Utils getText:@"男聲" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnVoiceFemale setTitle:[Utils getText:@"女聲" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnVoiceCustom setTitle:[Utils getText:@"自定聲" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnVoiceCustomEdit setTitle:[Utils getText:@"更改自定聲" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnVoiceCustomDelete setTitle:[Utils getText:@"刪除自定聲" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnDeleteCard setTitle:[Utils getText:@"刪除" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnSelectCard setTitle:[Utils getText:@"選擇" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnOpenFolder setTitle:[Utils getText:@"打開" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnAddFolder setTitle:[Utils getText:@"加類別" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnSwap setTitle:[Utils getText:@"對調" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnConfirmChangeCaptionCustom setTitle:[Utils getText:@"確定" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    
    alertMsgCannotBackWhileSwapping = [Utils getText:@"對調字卡時不能返回上層" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"];
    alertMsgCannotAddPageFromBlackPage = [Utils getText:@"不能在空頁上加頁" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"];
    alertBoxClose = [Utils getText:@"關閉" ForLang:[Constants getLanguageCodeTW] atView:@"AlertView"];
    
    actionSheetDeletePage = [Utils getText:@"你確定要刪除這個頁?" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"];
    actionSheetDeleteCard = [Utils getText:@"你確定要刪除這卡?" ForLang:[Constants getLanguageCodeTW] atView:@"EditAACViewController"];
    actionSheetConfirm = [Utils getText:@"確定" ForLang:[Constants getLanguageCodeTW] atView:@"ActionSheet"];
    actionSheetConfirmDelete = [Utils getText:@"確定刪除" ForLang:[Constants getLanguageCodeTW] atView:@"ActionSheet"];
    actionSheetCancel = [Utils getText:@"取消" ForLang:[Constants getLanguageCodeTW] atView:@"ActionSheet"];
  }
  
  if([lang isEqualToString:[Constants getLanguageCodeCN]]){
    
    [btnOpenCardLibrary setTitle:[Utils getText:@"圖庫" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnOpenDeviceLibrary setTitle:[Utils getText:@"相簿" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnOpenDeviceCamera setTitle:[Utils getText:@"相機" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnVoiceMale setTitle:[Utils getText:@"男聲" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnVoiceFemale setTitle:[Utils getText:@"女聲" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnVoiceCustom setTitle:[Utils getText:@"自定聲" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnVoiceCustomEdit setTitle:[Utils getText:@"更改自定聲" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnVoiceCustomDelete setTitle:[Utils getText:@"刪除自定聲" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnDeleteCard setTitle:[Utils getText:@"刪除" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnSelectCard setTitle:[Utils getText:@"選擇" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnOpenFolder setTitle:[Utils getText:@"打開" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnAddFolder setTitle:[Utils getText:@"加類別" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnSwap setTitle:[Utils getText:@"對調" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    [btnConfirmChangeCaptionCustom setTitle:[Utils getText:@"確定" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"] forState:UIControlStateNormal];
    
    
    alertMsgCannotBackWhileSwapping = [Utils getText:@"對調字卡時不能返回上層" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"];
    alertMsgCannotAddPageFromBlackPage = [Utils getText:@"不能在空頁上加頁" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"];
    
    alertBoxClose = [Utils getText:@"關閉" ForLang:[Constants getLanguageCodeCN] atView:@"AlertView"];
    
    actionSheetDeletePage = [Utils getText:@"你確定要刪除這個頁?" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"];
    actionSheetDeleteCard = [Utils getText:@"你確定要刪除這卡?" ForLang:[Constants getLanguageCodeCN] atView:@"EditAACViewController"];
    actionSheetConfirm = [Utils getText:@"確定" ForLang:[Constants getLanguageCodeCN] atView:@"ActionSheet"];
    actionSheetConfirmDelete = [Utils getText:@"確定刪除" ForLang:[Constants getLanguageCodeCN] atView:@"ActionSheet"];
    actionSheetCancel = [Utils getText:@"取消" ForLang:[Constants getLanguageCodeCN] atView:@"ActionSheet"];
  }
}

-(void) updateAndYes{
  [self updateAndSaveSelectedCard];
  [self reloadScrollView:YES];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLoading" object:self];
}

// This will only be used when deleting card
-(void) updateAndNo{
  [self updateAndSaveSelectedCard];
  [self reloadScrollView:NO];
  [self deselectCard];
  
  // The following functions have to be executed after the above
  [aacCardSelected release];
  aacCardSelected = nil;
  [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLoading" object:self];
}


@end
