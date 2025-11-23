//
//  LibCardSelectorViewController_iPhone.m
//  hongchiaac
//
//  Created by OEM on 7/2/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import "LibCardSelectorViewController_iPhone.h"
#import "Constants.h"
#import "Utils.h"
#import "Handlers/SettingHandler.h"

@interface LibCardSelectorViewController_iPhone ()

@end

@implementation LibCardSelectorViewController_iPhone

#define PLIST_DEFAULT_CARD @"default_cards.plist"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];

    isAnimating = NO;
    cardPerPage = 8;
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
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
////

-(IBAction)onClickBackToSubCat:(id)sender{
    [self showHideCardList:NO];
}

-(void)loadSubCategoryByRootCatName:(NSString *)rootCatName{
    if([rootCatName isEqualToString:@"cat_1"]){
        dictSubCatList = [[dictCategoryPlist objectForKey:rootCatName] objectForKey:@"sub_cat"];
    }
    if([rootCatName isEqualToString:@"cat_2"]){
        dictSubCatList = [[dictCategoryPlist objectForKey:rootCatName] objectForKey:@"sub_cat"];
    }
    
    _subCatCurSelIndex = -1;
    [tableViewSubCategory reloadData];
    
    //[self loadCardBySubCatIndex:0];
}

-(void)loadCardBySubCatIndex:(int)i{
    if([dictSubCatList count]>i){
        
        //[arrayDisplayedCards release];
        arrayDisplayedCards = [[NSArray alloc] initWithArray:[[dictSubCatList objectForKey:[NSString stringWithFormat:@"sub_cat_%d",i+1]] objectForKey:@"cards"] copyItems:YES];
        
        [self deselectCard];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
        [self showHideCardList:YES];
        [self performSelector:@selector(initScrollView) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
        //[self initScrollView];
        
        
    }
}

-(void)showHideCardList:(BOOL)isShown{
    if(isAnimating)return;
    
    isAnimating = YES;
    
    CGRect frame = viewCardList.frame;
    frame.origin.y = 0;
    
    if(isShown){
        frame.origin.x = viewCardList.frame.size.width;
        viewCardList.frame = frame;
        [self.view addSubview:viewCardList];
        frame.origin.x = 0;
        
        [UIView animateWithDuration:0.5 animations:^(void){viewCardList.frame=frame;} completion:^(BOOL finsihed){isAnimating=NO;}];
    }else{
        frame.origin.x = 0;
        viewCardList.frame = frame;
        frame.origin.x = viewCardList.frame.size.width;        
        [UIView animateWithDuration:0.5 animations:^(void){viewCardList.frame=frame;} completion:^(BOOL finsihed){isAnimating=NO;[viewCardList removeFromSuperview];}];
    }
    
    
}

-(void)search{

    [txtSearchKeyWord resignFirstResponder];
   
    NSString *langKey = [[NSString alloc] initWithFormat:@"caption_%@",[SettingHandler getApplicationLanguage]];    

    if(![txtSearchKeyWord.text length]){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:alertMsgNoSearchKey delegate:nil cancelButtonTitle:alertBoxClose otherButtonTitles:nil];
        [av show];
        [av release];
        
        return;
    }
    //[self loadCardBySubCatIndex:0];

    NSDictionary *allCards = [Utils getContentFromPlist:PLIST_DEFAULT_CARD];
    NSString *key = [txtSearchKeyWord text];
    
    [arraySearchedResult release];
    arraySearchedResult = [[NSMutableArray alloc] init];
    
    for(NSString *cardID in allCards){
        
        NSDictionary *card = [allCards objectForKey:cardID];
        
        //([cardID rangeOfString:key].location != NSNotFound) ||
        if(
           ([[card objectForKey:langKey] rangeOfString:key].location != NSNotFound)
           ){
            //NSLog(@"key : %@, cardID : %@, [%@][%@]",key,cardID,[card objectForKey:@"caption_cn"],[card objectForKey:@"caption_tw"]);
            [arraySearchedResult addObject:cardID];
        }
        
    }
    if([arraySearchedResult count]>0){
        arrayDisplayedCards = arraySearchedResult;
        
        [self deselectCard];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
        [self showHideCardList:YES];        
        [self performSelector:@selector(initScrollView) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
    }else{
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:alertMsgNoResult delegate:nil cancelButtonTitle:alertBoxClose otherButtonTitles:nil];
        [av show];
        [av release];
    }
 
}

-(void)selectCard:(LibCard *)libCard{
    selectedLibCard = libCard;

    if(selectedLibCard!=nil){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
        [self performSelector:@selector(clickedSelect) withObject:nil afterDelay:[Constants getDelayLoadingTime]];
    }
}
///
-(int)getCardSize{
    return 120;
}
-(int)getRow{
    return 2;
}
-(int)getCol{
    return 4;
}
-(int)getCardXMargin{
    return 120;
}
-(int)getCardYMargin{
    return 130;
}

#pragma keyboard notification
- (void)keyboardDidShow:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0, -200, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtSearchKeyWord resignFirstResponder];
}
@end
