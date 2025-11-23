//
//  MatchingGameViewController.h
//  hongchiaac
//
//  Created by Ray.Liu on 12/4/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "../MiniGameViewController.h"
#import "MatchingScoreViewController.h"

@class UserProfile;
@class AACCard;
@class UserCard;

@interface MatchingGameViewController : MiniGameViewController <AVAudioPlayerDelegate,UIAlertViewDelegate>
{
    IBOutlet UISegmentedControl *scLayout;
    UserProfile *userProfile;
    NSMutableArray *cardset;
    AACCard *questionCard;
    int questionIndex;
    MatchingScoreViewController *scoreViewController;
    IBOutlet UILabel *questionText;
    IBOutlet UIButton *btnPlayQuestionSound;
    IBOutlet UILabel *lblAnswerResult;
    IBOutlet UIView *selectedCardArea;
    IBOutlet UIButton *btnNext;
    IBOutlet UIButton *btnRandom;
    IBOutlet UIButton *btnScore;
    IBOutlet UIButton *btnExit;
    BOOL isPlayingSound;
    
    BOOL isAnswered;
    int gameLayout;
    int totalAnswerCount;
    int correctAnswerCount;
    int wrongAnswerCount;
    int maxQuestionCount;
    
    NSMutableDictionary *scoreResult;
    
    IBOutlet UILabel *lblTotalQuestionCount;
    IBOutlet UILabel *lblTotalQuestionIndex;
    IBOutlet UILabel *lblCurrentQuestionIndex;
    
    UIImageView *iconCorrect;
    
    int totalCardCount;
    int currentCardCount;
    int missingCardCount;
    
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
    
    UILabel *lblCurrentMarkTitle;
    UILabel *lblCurrentMark;
    
    Boolean isReadyForAnswer;
    
    int totalAnswerTried;
    
    UIView *viewWrongAnswerCover;
    
    BOOL isHavingWrongAttemp;
    
    BOOL isWaitingNextQuestion;
}


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
@property (nonatomic,readonly) IBOutlet UILabel *lblCurrentMarkTitle;
@property (nonatomic,readonly) IBOutlet UILabel *lblCurrentMark;

-(IBAction) onLayoutChanged;
- (IBAction)btnPlayQuestionSound_Click:(id)sender;
- (IBAction)btnNext_Click:(id)sender;
- (IBAction)btnRandom_Click:(id)sender;
- (IBAction)btnScore_Click:(id)sender;
- (IBAction)btnExit_Click:(id)sender;
- (void)initStartupObjects;
- (void)reloadGameView;
- (void)randomCardsetArray;
- (void)clearGameView;

- (void)playSoundOfCard:(NSString *)cardID withMode:(int)mode;
- (void)playSoundOfCustomVoice:(NSString *)fileName;
- (void)stopSound;
- (void)finishPLaySound;
- (void)checkAnswer:(AACCard *)selectedCard;
- (void)initScoreResult;



@end
