//
//  LibCardSelectorViewController.m
//  hongchiaac
//
//  Created by OEM on 7/11/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "LibCardSelectorViewController.h"
#import "Utils.h"
#import "Classes/Card.h"
#import "Classes/UserCard.h"
#import "Handlers/DefaultCardHandler.h"
#import "LibCard.h"
#import "Constants.h"
#import "Handlers/SettingHandler.h"

@interface LibCardSelectorViewController ()

#define PLIST_DEFAULT_CARD @"default_cards.plist"
@end

@implementation LibCardSelectorViewController
@synthesize btnClose;
@synthesize btnSelect;
@synthesize scRootCategory;
@synthesize tableViewSubCategory;
@synthesize scrollView;
@synthesize pageControl;
@synthesize arrViewPages;
@synthesize imgViewSelectedCard;
@synthesize btnSearch;
@synthesize txtSearchKeyWord;
@synthesize lblCardCaptionCN, lblCardCaptionTW,btnCustomVoice;
@synthesize lblcardCaption;
@synthesize btnBackToSubCat;
@synthesize viewCardList;

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
    testCounter = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClickLibCard:) name:@"onClickLibCard" object:nil];
    
    selectedLibCard = nil;
    cardPerPage = 12;
    dictCategoryPlist = [[NSDictionary alloc] initWithDictionary:[Utils getContentFromPlist:@"category.plist"]];
    
    for(int i=0;i<[dictCategoryPlist count];i++){
        NSDictionary *rootCat = [dictCategoryPlist objectForKey:[NSString stringWithFormat:@"cat_%d",(i+1)]];
        if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]]){
            [scRootCategory setTitle:[rootCat objectForKey:@"caption_tw"] forSegmentAtIndex:i];
        }else{
            [scRootCategory setTitle:[rootCat objectForKey:@"caption_cn"] forSegmentAtIndex:i];
        }
    }
    [self loadSubCategoryByRootCatName:@"cat_1"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicatoinChangeLang:) name:@"applicatoinChangeLang" object:nil];
    
    
    [self setLanguage:[SettingHandler getApplicationLanguage]];
    
    NSLog(@"test2");    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onClickLibCard" object:nil];
    // Release any retained subviews of the main view.
}

-(void)dealloc{
/*
 UIScrollViewDelegate>{
 UIButton *btnClose;
 UIButton *btnSelect;
 UIImageView *imgViewSelectedCard;
 UISegmentedControl *scRootCategory;
 UITableView *tableViewSubCategory;
 UIScrollView *scrollView;
 UIPageControl *pageControl;
 
 NSDictionary *dictCategoryPlist;
 NSDictionary *dictSubCatList;
 NSArray *arrayDisplayedCards;
 
 LibCard *selectedLibCard;
 
 int numOfPage;
 int col;
 int row;
 int cardPerPage;
 BOOL pageControlUsed;
 NSMutableArray *arrViewPages;
 */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicatoinChangeLang" object:nil];     
    
    [btnCustomVoice release];
    [btnClose release];
    [btnSelect release];
    [imgViewSelectedCard release];
    [scRootCategory release];
    [tableViewSubCategory release];
    [scrollView release];
    [pageControl release];
    
    [dictCategoryPlist release];

    [lblCardCaptionCN release];
    [lblCardCaptionTW release];
    
    [viewCardList release];
    [btnBackToSubCat release];
    
    //[dictSubCatList release];
    ///[arrayDisplayedCards release];
    
    //[selectedLibCard release];
    ///[arrViewPages release];
    
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
//////////////
-(IBAction)onClickClose:(id)sender{
    //[Utils removeAllChildOfPage:scrollView];
    [self removeChildInScrollView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onFinishedSelectCardFromLibrary" object:nil];
}
-(IBAction)onClickSelect:(id)sender{
    if(selectedLibCard!=nil){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
        [self performSelector:@selector(clickedSelect) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
    }
}
-(IBAction)onClickSearch:(id)sender{
    [self search];
}
-(IBAction)onClickCustomVoice:(id)sender{
    //[loadedProfile getVoiceMode]
    //[Utils playSoundOfCard:[aacCardSelected getCardID] withMode:1 withCallBackObject:nil];
    if(_voiceMode!=0){
        [Utils playSoundOfCard:[selectedLibCard getCardID] withMode:_voiceMode withCallBackObject:nil];
    }
}
-(IBAction)onChangeRootCategory:(id)sender{
    if([scRootCategory selectedSegmentIndex]==0)
        [self loadSubCategoryByRootCatName:@"cat_1"];
    else
        [self loadSubCategoryByRootCatName:@"cat_2"];        
}
-(IBAction)onClickBackToSubCat:(id)sender{
    //overrided
    
}
////////////
-(void)removeChildInScrollView{
    for(UIView *subview in [scrollView subviews]) {
        for(UIView *subsubview in [subview subviews]){
            if([[subsubview nextResponder] isKindOfClass:[LibCard class]]){
                [subsubview removeFromSuperview];
                [[subsubview nextResponder] release];
                NSLog(@"delete libCard");
            }else{
                if([[subsubview nextResponder] isKindOfClass:[UIView class]]){
                    [subsubview removeFromSuperview];
                    [[subsubview nextResponder] release];
                    NSLog(@"delete uiview");
                }
//                NSLog(@"card not deleted : %@",[subsubview nextResponder]);
            }
        }
        /*
        if([subview isKindOfClass:[UIImageView class]]){
            //NSLog(@"is uiimageview");
            NSLog(@"is uiimageview : %@, %@",subview, [subview nextResponder]);
        }else{
            //NSLog(@"not uniimageview");
            //[subview removeFromSuperview];
            NSLog(@"not uiimageview : %@, %@",subview, [subview nextResponder]);
            [subview removeFromSuperview];
            
        }
         */
    }
}
-(void)loadSubCategoryByRootCatName:(NSString *)rootCatName{
    //iphone overrided this function
    
    if([rootCatName isEqualToString:@"cat_1"]){
        dictSubCatList = [[dictCategoryPlist objectForKey:rootCatName] objectForKey:@"sub_cat"];
    }
    if([rootCatName isEqualToString:@"cat_2"]){
        dictSubCatList = [[dictCategoryPlist objectForKey:rootCatName] objectForKey:@"sub_cat"];
    }
    _subCatCurSelIndex = 0;
    [tableViewSubCategory reloadData];

    [self loadCardBySubCatIndex:0];
}
-(void)loadCardBySubCatIndex:(int)i{
    
    _subCatCurSelIndex = i;
    
    //iphone orverrided this function
    NSLog(@"dictSubCatList : %d",[dictSubCatList count]);
    if([dictSubCatList count]>i){

        [self deselectCard];        
        
        //[arrayDisplayedCards release];
        arrayDisplayedCards = [[NSArray alloc] initWithArray:[[dictSubCatList objectForKey:[NSString stringWithFormat:@"sub_cat_%d",i+1]] objectForKey:@"cards"] copyItems:YES];
        

        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
        [self performSelector:@selector(initScrollView) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
        //[self initScrollView];
         
    }
}
-(void)initScrollView{
    [self removeChildInScrollView];
    
    if(testCounter>1){
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"hideLoading" object:self];
        //[self removeChildInScrollView];
        //return;
    }else{
        testCounter++;
    }
    
    numOfPage = ceil((float)[arrayDisplayedCards count]/(float)cardPerPage);
    row = [self getRow];
    col = [self getCol];
    
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
    
    scrollView.contentOffset = CGPointMake(0, 0);
    
    //[self loadScrollViewWithPage:0];
    //[self loadScrollViewWithPage:1];
    for(int x=0; x<=numOfPage; x++){
      [self loadScrollViewWithPage:x];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLoading" object:self];
}
////////////
#pragma tableView
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dictSubCatList count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellStyle style = UITableViewCellStyleDefault;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseCell"];
    
    if(!cell)cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:@"BaseCell"] autorelease];
    
    if(_captionLangMode==0)
        cell.textLabel.text = [[dictSubCatList objectForKey:[NSString stringWithFormat:@"sub_cat_%d",[indexPath row]+1]] objectForKey:@"caption_tw"];
    else
        cell.textLabel.text = [[dictSubCatList objectForKey:[NSString stringWithFormat:@"sub_cat_%d",[indexPath row]+1]] objectForKey:@"caption_cn"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    /*
    if([[userProfileInEdit getProfileID] isEqualToString:[(UserProfile *)[arrAllProfiles objectAtIndex:[indexPath row]] getProfileID]]){
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
     */
    if(_subCatCurSelIndex==0 && [indexPath row]==0){
        [tableViewSubCategory selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self loadCardBySubCatIndex:[indexPath row]];
      //[self loadCardBySubCatIndex:0];
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
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    pageControlUsed = NO;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageControlUsed = NO;
}

-(void)loadScrollViewWithPage:(int)page{
    if (page<0 || page>=numOfPage) return ;
    
    UIView *viewPage = [arrViewPages objectAtIndex:page];
    if((NSNull *)viewPage == [NSNull null]){
        viewPage = [[UIView alloc] init];
        [arrViewPages replaceObjectAtIndex:page withObject:viewPage];
        [viewPage release];
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

    int tempCounter  = 0;
    
    NSDictionary *plist = [Utils getContentFromPlist:PLIST_DEFAULT_CARD];
    
    for(int i = (page)*cardPerPage; i<((page+1)*cardPerPage) && i<[arrayDisplayedCards count]; i++){

        Card *card = [[Card alloc] initWithContent:[DefaultCardHandler getCardWithID:[arrayDisplayedCards objectAtIndex:i] withPlist:plist] withCardID:[arrayDisplayedCards objectAtIndex:i]];
        //Card *card =[[Card alloc] init];

        LibCard *libCard = [[LibCard alloc]initWithCard:card];

        [viewPage addSubview:libCard.view];

        [libCard resizeImageToSize:[self getCardSize]];

        if(_captionLangMode==0)
            [libCard setDisplayCaption:[card getCaptionTW]];
        else
            [libCard setDisplayCaption:[card getCaptionCN]];

        CGRect frame = libCard.view.frame;
        frame.origin.x = (tempCounter % col) * [self getCardXMargin] + (viewPage.frame.size.width - frame.size.width * col)/col/2;
        frame.origin.y = (int)floor(((float)tempCounter / (float)col)) * [self getCardYMargin] + (viewPage.frame.size.height - frame.size.height * row)/row/2;

        libCard.view.frame = frame;

        tempCounter++;
        
    }
    
    [plist release];
    
}
-(int)getCardSize{
    return 140;
}
-(int)getRow{
    return 3;
}
-(int)getCol{
    return 4;
}
-(int)getCardXMargin{
    return 170;
}
-(int)getCardYMargin{
    return 170;
}
-(void)setCardCaptionLanguage:(int)langMode{
    _captionLangMode = langMode;
}
-(void)setVoiceMode:(int)voice{
    _voiceMode = voice;
}
-(void)clickedSelect{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onFinishedSelectCardFromLibrary" object:selectedLibCard];    
}

-(void)search{
    //iphone overridded
    [txtSearchKeyWord resignFirstResponder];
    
    
    NSString *langKey = [[NSString alloc] initWithFormat:@"caption_%@",[SettingHandler getApplicationLanguage]];

    if(![txtSearchKeyWord.text length]){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:alertMsgNoSearchKey delegate:nil cancelButtonTitle:alertBoxClose otherButtonTitles:nil];
        [av show];
        [av release];
        
        return;
    }
    
    //NSDictionary *allCards = [[NSDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_DEFAULT_CARD]];
    NSDictionary *allCards = [Utils getContentFromPlist:PLIST_DEFAULT_CARD];
    NSString *key = [txtSearchKeyWord text];
    
    [arraySearchedResult release];
    arraySearchedResult = [[NSMutableArray alloc] init];
    
    /*
    NSString *tt = @"書";
    
    if([tt isEqualToString:@"书"]){
        NSLog(@"!!!");
    }else{
        NSLog(@"....");
    }
    
    NSLog(@"1%lu",(unsigned long)[tt rangeOfString:@"书"].location);
    NSLog(@"2%lu",(unsigned long)[tt rangeOfString:@"書"].location);    
    */
    for(NSString *cardID in allCards){
    
        NSDictionary *card = [allCards objectForKey:cardID];
        /*
         
        if(
           ([cardID rangeOfString:key].location != NSNotFound) ||
           ([[card objectForKey:@"caption_cn"] rangeOfString:key].location != NSNotFound) ||
           ([[card objectForKey:@"caption_tw"] rangeOfString:key].location != NSNotFound)
        ){
            NSLog(@"key : %@, cardID : %@, [%@][%@]",key,cardID,[card objectForKey:@"caption_cn"],[card objectForKey:@"caption_tw"]);
            [arraySearchedResult addObject:cardID];
        }
         */
        //([cardID rangeOfString:key].location != NSNotFound) ||
        if(
           
           ([[card objectForKey:langKey] rangeOfString:key].location != NSNotFound)
           ){
            //NSLog(@"%@ is in %@，%@",key, [card objectForKey:langKey],cardID);
            [arraySearchedResult addObject:cardID];
        }
    }
    if([arraySearchedResult count]>0){
        //arrayDisplayedCards = [[NSArray alloc] initWithArray:arraySearchedResult];
        arrayDisplayedCards = arraySearchedResult;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
        [self performSelector:@selector(initScrollView) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
    }else{
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:alertMsgNoResult delegate:nil cancelButtonTitle:alertBoxClose otherButtonTitles:nil];
        [av show];
        [av release];
    }
}

-(void)selectCard:(LibCard *)libCard{
    //iphone overrided this function

    selectedLibCard = libCard;
    
    [imgViewSelectedCard setImage:[UIImage imageNamed:[selectedLibCard getCardImageName]]];
    [imgViewSelectedCard setHidden:NO];
    [lblCardCaptionTW setText:[libCard getCaptionTW]];
    [lblCardCaptionCN setText:[libCard getCaptionCN]];
    
    if(_captionLangMode==0){
        [lblcardCaption setText:[libCard getCaptionTW]];
    }else{
        [lblcardCaption setText:[libCard getCaptionCN]];
    }
    
    [btnCustomVoice setHidden:NO];
    [btnSelect setEnabled:YES];
}
-(void)deselectCard{
    [imgViewSelectedCard setHidden:YES];
    [btnCustomVoice setHidden:YES];
    [lblcardCaption setText:@""];
    [lblCardCaptionTW setText:@""];
    [lblCardCaptionCN setText:@""];
    [selectedLibCard release];
    selectedLibCard = nil;
    
    [btnSelect setEnabled:NO];
    
    
}

#pragma even handler
-(void) onClickLibCard:(NSNotification *)notification{
    
    LibCard *clickedLibCard = (LibCard *)notification.object;
    [self selectCard:clickedLibCard];
}

#pragma language
-(void)onApplicatoinChange :(NSNotification *)notification{
    [self setLanguage:notification.object];
    NSLog(@"applicatoinChangeLang : libcardselectorviewcontroller");    
}
-(void)setLanguage:(NSString *)lang{
    
    if([lang isEqualToString:[Constants getLanguageCodeTW]]){
        
        [btnSearch setTitle:[Utils getText:@"搜尋" ForLang:[Constants getLanguageCodeTW] atView:@"LibCardSelectorViewController"] forState:UIControlStateNormal];
        [btnSelect setTitle:[Utils getText:@"選擇" ForLang:[Constants getLanguageCodeTW] atView:@"LibCardSelectorViewController"] forState:UIControlStateNormal];
        [btnClose setTitle:[Utils getText:@"關閉" ForLang:[Constants getLanguageCodeTW] atView:@"LibCardSelectorViewController"] forState:UIControlStateNormal];

        alertMsgNoSearchKey = [Utils getText:@"沒有搜尋字" ForLang:[Constants getLanguageCodeTW] atView:@"LibCardSelectorViewController"];
        alertMsgNoResult = [Utils getText:@"沒有相關字卡" ForLang:[Constants getLanguageCodeTW] atView:@"LibCardSelectorViewController"];
        alertBoxClose = [Utils getText:@"關閉" ForLang:[Constants getLanguageCodeTW] atView:@"AlertView"];
    }
    
    if([lang isEqualToString:[Constants getLanguageCodeCN]]){
        [btnSearch setTitle:[Utils getText:@"搜尋" ForLang:[Constants getLanguageCodeCN] atView:@"LibCardSelectorViewController"] forState:UIControlStateNormal];
        [btnSelect setTitle:[Utils getText:@"選擇" ForLang:[Constants getLanguageCodeCN] atView:@"LibCardSelectorViewController"] forState:UIControlStateNormal];
        [btnClose setTitle:[Utils getText:@"關閉" ForLang:[Constants getLanguageCodeCN] atView:@"LibCardSelectorViewController"] forState:UIControlStateNormal];
        
        alertMsgNoSearchKey = [Utils getText:@"沒有搜尋字" ForLang:[Constants getLanguageCodeCN] atView:@"LibCardSelectorViewController"];
        alertMsgNoResult = [Utils getText:@"沒有相關字卡" ForLang:[Constants getLanguageCodeCN] atView:@"LibCardSelectorViewController"];
        alertBoxClose = [Utils getText:@"關閉" ForLang:[Constants getLanguageCodeCN] atView:@"AlertView"];
       
    }
 
}
@end
