//
//  EditAACViewController.h
//  hongchiaac
//
//  Created by OEM on 31/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RecorderViewController.h"

@class UserProfile;
@class EditAACCard;
@class LibCardSelectorViewController;
//almost the same as AACViewController

@interface EditAACViewController : UIViewController <UIScrollViewDelegate, AVAudioPlayerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIPopoverControllerDelegate,UIActionSheetDelegate, UITextFieldDelegate> {
    UserProfile *loadedProfile;
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    UIView *viewFolderSelector;
    UIView *viewColorSelector;
    UIView *viewAddNewItemSelector;
    UIButton *btnBack;
    UIButton *btnSwap;
    UIButton *btnDeleteCard;
    UIButton *btnChangeColor;
    UIButton *btnOpenFolder;
    UIButton *btnOpenCardLibrary;
    UIButton *btnOpenDeviceLibrary;
    UIButton *btnOpenDeviceCamera;
    
    UIView *viewRecorderViewBase;
    UIButton *btnVoice;
    UIButton *btnVoiceMale;
    UIButton *btnVoiceFemale;
    UIButton *btnVoiceCustom;
    UIButton *btnVoiceCustomEdit;
    UIButton *btnVoiceCustomDelete;
    
    UIButton *btnSelectCard;
    UIButton *btnAddCard;
    UIButton *btnAddFolder;
    
    UILabel *lblCaptionTWTitle;
    UILabel *lblCaptionCNTitle;
    UILabel *lblCaptionTW;
    UILabel *lblCaptionCN;
    UITextField *txtCaptionCustom;
    UIButton *btnConfirmChangeCaptionCustom;
    
    //selected Card things
    UIImageView *imgSelectedCardImage;
    
    UIView *viewCurrentBoarderColor;
    
    EditAACCard *aacCardFolderBuffer;//it is used if the user click on the folder
    EditAACCard *aacCardNewItemBuffer;//it is used if the user add new add/folder
    EditAACCard *aacCardSelected;
    
    LibCardSelectorViewController *vcLibCardSelector;
    UIImagePickerController *imagePickerController;
    UIPopoverController *popoverController;
    
    NSMutableArray *arrViewPages;
    NSMutableArray *arrCardsetWhole;
    NSMutableArray *arrCardsetInUse;
    NSMutableDictionary *userCardFromCardView;
    NSMutableArray *viewControllers;
    
    NSMutableArray *stackedIndex;
    NSMutableArray *stackedIndexForSelectedCard;
    NSMutableArray *arraySelectedCards;
    
    RecorderViewController *recordViewController;
    
    UILabel *lblProfileName;
    
    int cardPerPage;
    int numOfPage;
    int row;
    int col;
    int layout;
    BOOL pageControlUsed;
    
    BOOL _isSwapMode;
    
    int tempSelectedCardIndex;
    int testcheck;
    
    //alert text
    NSString *alertMsgCannotBackWhileSwapping;
    NSString *alertMsgCannotAddPageFromBlackPage;
    NSString *alertBoxClose;
    
    //actionsheet
    NSString *actionSheetDeletePage;
    NSString *actionSheetDeleteCard;
    NSString *actionSheetConfirm;
    NSString *actionSheetCancel;
    NSString *actionSheetConfirmDelete;
    
    int isPickFromAlbum;
}

@property (retain, nonatomic)IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic)IBOutlet UIPageControl *pageControl;
@property (retain, nonatomic)IBOutlet UIButton *btnBack;
@property (retain, nonatomic)IBOutlet UIButton *btnSwap;
@property (retain, nonatomic)IBOutlet UIButton *btnDeleteCard;
@property (retain, nonatomic)IBOutlet UIButton *btnOpenFolder;
@property (retain, nonatomic)IBOutlet UIButton *btnChangeColor;
@property (retain, nonatomic)IBOutlet UIButton *btnOpenCardLibrary;
@property (retain, nonatomic)IBOutlet UIButton *btnOpenDeviceLibrary;
@property (retain, nonatomic)IBOutlet UIButton *btnOpenDeviceCamera;
@property (retain, nonatomic)IBOutlet UIView *viewFolderSelector;
@property (retain, nonatomic)IBOutlet UIView *viewColorSelector;
@property (retain, nonatomic)IBOutlet UIView *viewAddNewItemSelector;
@property (retain, nonatomic)IBOutlet UIImageView *imgSelectedCardImage;
@property (retain, nonatomic)IBOutlet UILabel *lblCaptionTWTitle;
@property (retain, nonatomic)IBOutlet UILabel *lblCaptionCNTitle;
@property (retain, nonatomic)IBOutlet UILabel *lblCaptionTW;
@property (retain, nonatomic)IBOutlet UILabel *lblCaptionCN;
@property (retain, nonatomic)IBOutlet UITextField *txtCaptionCustom;
@property (retain, nonatomic)IBOutlet UIButton *btnConfirmChangeCaptionCustom;
@property (retain, nonatomic)IBOutlet UIButton *btnVoice;
@property (retain, nonatomic)IBOutlet UIButton *btnVoiceMale;
@property (retain, nonatomic)IBOutlet UIButton *btnVoiceFemale;
@property (retain, nonatomic)IBOutlet UIButton *btnVoiceCustom;
@property (retain, nonatomic)IBOutlet UIButton *btnVoiceCustomEdit;
@property (retain, nonatomic)IBOutlet UIButton *btnVoiceCustomDelete;
@property (retain, nonatomic)IBOutlet UIView *viewRecorderViewBase;
@property (retain, nonatomic)IBOutlet UIView *viewCurrentBoarderColor;

@property (retain, nonatomic)IBOutlet UIButton *btnSelectCard;
@property (retain, nonatomic)IBOutlet UIButton *btnAddCard;
@property (retain, nonatomic)IBOutlet UIButton *btnAddFolder;

@property (retain, nonatomic)IBOutlet UILabel *lblProfileName;

@property (nonatomic, retain) NSMutableArray *arrViewPages;

-(void)loadProfile:(UserProfile *)profile;
-(void)initScrollView;

-(IBAction)onCloseFolderSelector:(id)sender;
-(IBAction)onClickBack:(id)sender;
-(IBAction)onClickFolderSelectorSelect:(id)sender;
-(IBAction)onClickFolderSelectorOpen:(id)sender;
-(IBAction)onClickColorSelector:(id)sender;
-(IBAction)onCloseColorSelector:(id)sender;
-(IBAction)onClickSwap:(id)sender;
-(IBAction)onClickCloseView:(id)sender;
-(IBAction)onClickColorBox:(id)sender;
-(IBAction)onCloseAddNewItemSelecor:(id)sender;
-(IBAction)onClickAddNewCard:(id)sender;
-(IBAction)onClickAddNewFolder:(id)sender;
-(IBAction)onClickOpenCardLibrary:(id)sender;
-(IBAction)onClickAddPage:(id)sender;
-(IBAction)onClickDeletePage:(id)sender;
-(IBAction)onClickDeleteCard:(id)sender;
-(IBAction)onClickMovePageToNext:(id)sender;
-(IBAction)onClickMovePageToPrev:(id)sender;
-(IBAction)onClickConfirmChangeCaptionCustom:(id)sender;
-(IBAction)onClickOpenDeviceLibrary:(id)sender;
-(IBAction)onClickOpenDeviceCamera:(id)sender;
-(IBAction)onClickVoice:(id)sender;
-(IBAction)onClickVoiceMale:(id)sender;
-(IBAction)onClickVoiceFemale:(id)sender;
-(IBAction)onClickVoiceCustom:(id)sender;
-(IBAction)onClickVoiceCustomEdit:(id)sender;
-(IBAction)onClickRecorderViewBase:(id)sender;
-(IBAction)onClickVoiceCustomDelete:(id)sender;
-(IBAction)onChangeCaption:(id)sender;

-(IBAction)onClickTestAddPages:(id)sender;
-(IBAction)onClickTestDelPages:(id)sender;

-(void)deselectCard;
-(void)deleteCard;
-(void)addCard:(EditAACCard *)aacCard;

-(void)updateAndSaveSelectedCard;
-(void)reloadScrollView:(BOOL)retainCard;
@end
