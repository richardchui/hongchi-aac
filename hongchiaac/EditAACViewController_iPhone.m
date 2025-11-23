//
//  EditAACViewController_iPhone.m
//  hongchiaac
//
//  Created by OEM on 7/2/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import "EditAACViewController_iPhone.h"
#import "LibCardSelectorViewController.h"
#import "LibCardSelectorViewController_iPhone.h"
#import "EditAACCard.h"
#import "Classes/UserProfile.h"
#import "Constants.h"

@interface EditAACViewController_iPhone ()

@end

@implementation EditAACViewController_iPhone
@synthesize viewCardDetail;

#define LAYOUT_1X1  1
#define LAYOUT_1X2  2
#define LAYOUT_1X3  3
#define LAYOUT_2X4  4
#define LAYOUT_2x6  5
#define LAYOUT_3X6  6

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
    isAnimating = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc{
    [viewCardDetail release];
    
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


-(IBAction)onClickCloseCardDetail:(id)sender{
    [viewCardDetail removeFromSuperview];
    [self deselectCard];
}
-(IBAction)onClickSwap:(id)sender{
    if(!_isSwapMode){
        _isSwapMode = YES;
        [btnSwap setSelected:YES];
    }else{
        _isSwapMode = NO;
        [btnSwap setSelected:NO];
    }
    [viewCardDetail removeFromSuperview];
}

-(void)selectCard:(EditAACCard *)aacCard{
    if(aacCard == NULL || aacCard == nil){
        return;
    }
    
    aacCardSelected = aacCard;
    stackedIndexForSelectedCard = [[NSMutableArray alloc] initWithArray:stackedIndex];
    
    if(![aacCardSelected isEmpty]){
        [imgSelectedCardImage setImage:[aacCardSelected getCardImage]];
    }else
        [imgSelectedCardImage setImage:[UIImage imageNamed:@"empty_card_edit.png"]];
    
    [lblCaptionCN setText:[aacCardSelected getCaptionRawCN]];
    [lblCaptionTW setText:[aacCardSelected getCaptionRawTW]];
    [txtCaptionCustom setText:[aacCardSelected getCaptionRawCustom]];
    
    
    //[self.view addSubview:viewCardDetail];
    [self showHideCardDetail:YES];
    
    
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
    NSLog(@"color : %d",[[aacCardSelected getUserCard] getBorderColorID]);
    [viewCurrentBoarderColor setBackgroundColor:[Constants getColorById:[aacCardSelected.getUserCard getBorderColorID]]];
}
-(void)deselectCard{
    [self showHideCardDetail:NO];    
    [super deselectCard];
    
}
-(void)deleteCard{
    //[self showHideCardDetail:NO];
    [super deleteCard];
    [viewCardDetail removeFromSuperview];
   // [self showHideCardDetail:NO];
}

-(void)openCardLibrary{
    
    
    if(vcLibCardSelector == nil){
        //vcLibCardSelector = [[LibCardSelectorViewController alloc] initWithNibName:@"LibCardSelectorViewController_iPhone" bundle:nil];
        vcLibCardSelector = [[LibCardSelectorViewController_iPhone alloc] init];
    }
    [vcLibCardSelector setCardCaptionLanguage:[loadedProfile getCaptionMode]];
    [vcLibCardSelector setVoiceMode:[loadedProfile getVoiceMode]];    
    [self.view addSubview:vcLibCardSelector.view];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLoading" object:self];
}
-(void)showHideCardDetail:(BOOL)isShown{
    if(isAnimating)return;
    
    isAnimating = YES;
    
    CGRect frame = viewCardDetail.frame;
    frame.origin.x = 0;
    
    if(isShown){
        frame.origin.y = viewCardDetail.frame.size.height* -1;
        viewCardDetail.frame = frame;
        [self.view addSubview:viewCardDetail];
        frame.origin.y = 0;
        
        //[UIView animateWithDuration:0.1 animations:^(void){viewCardDetail.frame=frame;} completion:^(BOOL finsihed){isAnimating=NO;}];
        viewCardDetail.frame = frame;
        isAnimating =NO;
    }else{
        frame.origin.y = 0;
        viewCardDetail.frame = frame;
        frame.origin.y = viewCardDetail.frame.size.height* -1;
        //[UIView animateWithDuration:0.1 animations:^(void){viewCardDetail.frame=frame;} completion:^(BOOL finsihed){isAnimating=NO;[viewCardDetail removeFromSuperview];}];
        
        viewCardDetail.frame = frame;
        isAnimating = NO;
        [viewCardDetail removeFromSuperview];
    }
    
    
}

-(void)removeCustomVoice{
    UserCard *userCard = [aacCardSelected getUserCard];
    
    [loadedProfile deleteCustomVoice:[userCard getVoiceCustom]];
    [aacCardSelected setIsEmpty:NO];
    [userCard setVoiceCustom:@""];
    
    [self updateAndSaveSelectedCard];
    [self reloadScrollView:YES];
}
-(int)getNumberOfCardPerPageFromLayout:(int)layoutID{
    
    if(layoutID == LAYOUT_1X1) return 1;
    if(layoutID == LAYOUT_1X2) return 2;
    if(layoutID == LAYOUT_1X3) return 3;
    if(layoutID == LAYOUT_2X4) return 8;
    if(layoutID == LAYOUT_2x6) return 12;
    if(layoutID == LAYOUT_3X6) return 12;
    
    return 0;
}
-(int)getRowFromLayout:(int)layoutID{
    
    if(layoutID == LAYOUT_1X1) return 1;
    if(layoutID == LAYOUT_1X2) return 1;
    if(layoutID == LAYOUT_1X3) return 1;
    if(layoutID == LAYOUT_2X4) return 2;
    if(layoutID == LAYOUT_2x6) return 2;
    if(layoutID == LAYOUT_3X6) return 2;
    
    return 1;
}
-(int)getCardSize:(int)layoutID{
    if(layoutID == LAYOUT_1X1) return 220;
    if(layoutID == LAYOUT_1X2) return 220;
    if(layoutID == LAYOUT_1X3) return 170;
    if(layoutID == LAYOUT_2X4) return 120;
    if(layoutID == LAYOUT_2x6) return 86;
    if(layoutID == LAYOUT_3X6) return 86;
    
    return 1;
}
-(int)getCardXMargin:(int)layoutID{
    if(layoutID == LAYOUT_1X1) return 230;
    if(layoutID == LAYOUT_1X2) return 230;
    if(layoutID == LAYOUT_1X3) return 150;
    if(layoutID == LAYOUT_2X4) return 118;
    if(layoutID == LAYOUT_2x6) return 76;
    if(layoutID == LAYOUT_3X6) return 76;
    
    return 1;
}
-(int)getCardYMargin:(int)layoutID{
    if(layoutID == LAYOUT_1X1) return 0;
    if(layoutID == LAYOUT_1X2) return 0;
    if(layoutID == LAYOUT_1X3) return 0;
    if(layoutID == LAYOUT_2X4) return 124;
    if(layoutID == LAYOUT_2x6) return 110;
    if(layoutID == LAYOUT_3X6) return 110;
    
    return 1;
}

#pragma keyboard
#pragma keyboard notification
- (void)keyboardDidShow:(NSNotification *)notification
{
    [viewCardDetail setFrame:CGRectMake(0, -100, viewCardDetail.frame.size.width, viewCardDetail.frame.size.height)];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [viewCardDetail setFrame:CGRectMake(0, 0, viewCardDetail.frame.size.width, viewCardDetail.frame.size.height)];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtCaptionCustom resignFirstResponder];
}
@end
