//
//  SequencingGameViewController.h
//  hongchiaac
//
//  Created by Ray.Liu on 12/11/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "../MiniGameViewController.h"
#import "SequencingCardsetViewController.h"
#import "SequencingScoreViewController.h"

@class UserProfile;
@class AACCard;
@class UserCard;

@interface SequencingGameViewController : MiniGameViewController <AVAudioPlayerDelegate>
{
    IBOutlet UIButton *btnExit;
    IBOutlet UIButton *btnRedo;
    IBOutlet UIButton *btnSubmit;
    IBOutlet UIView *cardArea;
    IBOutlet UIButton *btnPlayQuestionSound;
    IBOutlet UILabel *lblAnswerResult;
    IBOutlet UILabel *lblAnswerBoxColor;
    IBOutlet UILabel *lblQuestionBoxColor;
    
    UserProfile *userProfile;
    int currentLevel;
    CGFloat cardWidth, cardHeight, cardMargin;
    NSMutableArray *orgSentenceItems, *randomSentenceItems;
    
    BOOL isPlayingSound;
    BOOL isPlayingAllCards;
    int nowPlayingCardIndex;
    
    int currentQuestionIndex;
    int currentAnswerIndex;
    NSMutableDictionary *currentCardset;
    NSMutableDictionary *scoreResult;
    
    IBOutlet UILabel *lblTotalQuestionCount;
    IBOutlet UILabel *lblTotalQuestionIndex;
    IBOutlet UILabel *lblCurrentQuestionIndex;
    
    NSMutableDictionary *dictAACCards;
    
    int totalAnswerCount;
    int correctAnswerCount;
    int wrongAnswerCount;
    int maxQuestionCount;
    
    SequencingScoreViewController *sequencingScoreViewController;
    
    int thisQuestionWrongCount;
    
    int currentShowAnswerCount;
    
    AVAudioPlayer *mainPlayerChannel;
    
    BOOL isClickedExit;
  bool canStartClicking;
  
    UIImageView *ivProgress1;
    UIImageView *ivProgress2;
    UIImageView *ivProgress3;
    UIImageView *ivProgress4;
    UIImageView *ivProgress5;
    UIImageView *ivProgress6;
    UIImageView *ivProgress7;
    UIImageView *ivProgress8;
    UIImageView *ivProgress9;
    UIImageView *ivProgress10;
    
    UIImageView *ivStreamAnimation;
    
    NSString *strAnswerCorrect;
    NSString *strAnswerWrong;
    
    UILabel *lblAccScore;
    
    int anwseredCardCount;
}

@property (nonatomic, strong) NSMutableArray *dropTargets;
@property (nonatomic, strong) NSMutableArray *dragTargets;
@property (nonatomic, strong) UIView *dropTarget;
@property (nonatomic, strong) UIView *dragObject;
@property (nonatomic, strong) UIView *dragObjectDefaultParentView;
@property (nonatomic, assign) CGPoint touchOffset;
@property (nonatomic, assign) CGPoint homePosition;

@property (nonatomic,readonly) IBOutlet UIImageView *ivProgress1;
@property (nonatomic,readonly) IBOutlet UIImageView *ivProgress2;
@property (nonatomic,readonly) IBOutlet UIImageView *ivProgress3;
@property (nonatomic,readonly) IBOutlet UIImageView *ivProgress4;
@property (nonatomic,readonly) IBOutlet UIImageView *ivProgress5;
@property (nonatomic,readonly) IBOutlet UIImageView *ivProgress6;
@property (nonatomic,readonly) IBOutlet UIImageView *ivProgress7;
@property (nonatomic,readonly) IBOutlet UIImageView *ivProgress8;
@property (nonatomic,readonly) IBOutlet UIImageView *ivProgress9;
@property (nonatomic,readonly) IBOutlet UIImageView *ivProgress10;
@property (nonatomic,readonly) IBOutlet UILabel *lblAccScore;

@property (nonatomic, readonly) IBOutlet UIImageView *ivStreamAnimation;
- (IBAction)btnExit_Click:(id)sender;
- (IBAction)btnRedo_Click:(id)sender;
- (IBAction)btnPlayQuestionSound_Click:(id)sender;
- (IBAction)btnSubmit_Click:(id)sender;

- (void)initCurrentCardset;
- (void)reloadGameView;
- (void)clearGameView;
- (void)initGameValues;
- (NSMutableArray *)getRandomSentence;
- (void)initQuestionAnswerSentenceItems;

- (void)playSoundOfCustomVoice:(NSString *)fileName;
- (void)playSoundOfCard:(NSString *)cardID withMode:(int)mode;
- (void)finishPLaySound;
- (void)playSelectedCardOfIndex:(int)i;
- (void)checkResult;
- (void)initScoreResult;
- (void)showResultPage;
- (void)redoBecauseWrong;

- (void)playCorrectSound;
- (void)playWrongTime1Sound;
- (void)playWrongTime2Sound;
- (void)playWrongTime3Sound;

- (void)showAnswer;
- (void)showAnswerCardAction;

- (void)stopPlaySound;

@end
