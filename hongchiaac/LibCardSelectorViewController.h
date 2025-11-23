//
//  LibCardSelectorViewController.h
//  hongchiaac
//
//  Created by OEM on 7/11/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LibCard;

@interface LibCardSelectorViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>{

    UIButton *btnClose;
    UIButton *btnSelect;
    UIImageView *imgViewSelectedCard;
    UISegmentedControl *scRootCategory;
    UITableView *tableViewSubCategory;
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    UIButton *btnSearch;
    UITextField *txtSearchKeyWord;
    UIButton *btnCustomVoice;
    
    NSDictionary *dictCategoryPlist;
    NSDictionary *dictSubCatList;
    NSArray *arrayDisplayedCards;
    NSMutableArray *arraySearchedResult;
    
    UIButton *btnBackToSubCat;    
    
    UILabel *lblCardCaptionTW;
    UILabel *lblCardCaptionCN;
    UILabel *lblcardCaption;
    
    UIView *viewCardList;    
    
    LibCard *selectedLibCard;
    
    int numOfPage;
    int col;
    int row;
    int cardPerPage;
    BOOL pageControlUsed;    
    NSMutableArray *arrViewPages;
    
    NSString *alertMsgNoSearchKey;
    NSString *alertMsgNoResult;
    NSString *alertBoxClose;
    
    int _captionLangMode;
    int _voiceMode;
    
    int testCounter;
    
    int _subCatCurSelIndex;
}

@property (retain, nonatomic) IBOutlet UIButton *btnClose;
@property (retain, nonatomic) IBOutlet UIButton *btnSelect;
@property (retain, nonatomic) IBOutlet UIImageView *imgViewSelectedCard;
@property (retain, nonatomic) IBOutlet UISegmentedControl *scRootCategory;
@property (retain, nonatomic) IBOutlet UITableView *tableViewSubCategory;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;
@property (retain, nonatomic) IBOutlet UIButton *btnSearch;
@property (retain, nonatomic) IBOutlet UITextField *txtSearchKeyWord;
@property (retain, nonatomic) IBOutlet UIButton *btnCustomVoice;
@property (nonatomic, retain) IBOutlet UIButton *btnBackToSubCat;

@property (retain, nonatomic) IBOutlet UILabel *lblCardCaptionTW;
@property (retain, nonatomic) IBOutlet UILabel *lblCardCaptionCN;
@property (retain, nonatomic) IBOutlet UILabel *lblcardCaption;

@property (nonatomic, retain) IBOutlet UIView *viewCardList;

@property (nonatomic, retain) NSMutableArray *arrViewPages;


-(IBAction)onClickClose:(id)sender;
-(IBAction)onClickSelect:(id)sender;
-(IBAction)onClickSearch:(id)sender;
-(IBAction)onClickCustomVoice:(id)sender;
-(void)setCardCaptionLanguage:(int)lang;
-(void)setVoiceMode:(int)voice;
-(IBAction)onChangeRootCategory:(id)sender;
-(IBAction)onClickBackToSubCat:(id)sender;

-(void)selectCard:(LibCard *)libCard;
-(void)deselectCard;
@end
