//
//  SequencingGameViewController.m
//  hongchiaac
//
//  Created by Ray.Liu on 12/11/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "SequencingGameViewController.h"
#import "../../Handlers/ProfileHandler.h"
#import "../../AACCard.h"
#import "../../Utils.h"
#import "../../Constants.h"
#import "../../Utils.h"
#import "../../Handlers/SettingHandler.h"

@implementation SequencingGameViewController

#define PROGRESS_BAR_HEAD_IMAGE_OFF @"progress_bar_a.png"
#define PROGRESS_BAR_HEAD_IMAGE_ON @"progress_bar_a_selected.png"
#define PROGRESS_BAR_MIDDLE_IMAGE_OFF @"progress_bar_b.png"
#define PROGRESS_BAR_MIDDLE_IMAGE_ON @"progress_bar_b_selected.png"
#define PROGRESS_BAR_END_IMAGE_OFF @"progress_bar_c.png"
#define PROGRESS_BAR_END_IMAGE_ON @"progress_bar_c_selected.png"

@synthesize dropTargets;
@synthesize dragTargets;
@synthesize dropTarget;
@synthesize dragObject;
@synthesize dragObjectDefaultParentView;
@synthesize touchOffset;
@synthesize homePosition;
@synthesize ivProgress1,ivProgress2,ivProgress3,ivProgress4,ivProgress5,ivProgress6,ivProgress7,ivProgress8,ivProgress9,ivProgress10;
@synthesize ivStreamAnimation;
@synthesize lblAccScore;
#pragma - MiniGameViewController

#define PLIST_PROFILE @"profiles.plist"

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopGameBGMusicA" object:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.myParentController name:@"onClickAACCard" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClickAACCard:) name:@"onClickAACCard" object:nil];
    
    isClickedExit = NO;
  
    currentQuestionIndex = 0;
    currentAnswerIndex = 0;
    
    totalAnswerCount = 1;
    correctAnswerCount = 0;
    wrongAnswerCount = 0;
    maxQuestionCount = 10;
    
    currentLevel = [[self.myExtraData objectForKey:@"game_level"] intValue];
    
    userProfile = [[UserProfile alloc] initWithProfileID:[self.myExtraData objectForKey:@"profile_id"]];
    
    [self initCurrentCardset];
    
    //isPlayingSound = false;
    //isPlayingAllCards = false;
    //nowPlayingCardIndex = 0;
    
    NSLog(@"current level : %d",currentLevel);
    
    [self reloadGameView];
    //[self setProgressBarWithProgress:totalAnswerCount];
    
    [self setLanguage:[SettingHandler getApplicationLanguage]];
    
}

- (void)dealloc
{
    [lblAccScore release];
    [btnExit release];
    [btnRedo release];
    [btnSubmit release];
    [cardArea release];
    [userProfile release];
    [orgSentenceItems release];
    [randomSentenceItems release];
    [btnPlayQuestionSound release];
    [lblAnswerResult release];
    [lblAnswerBoxColor release];
    [lblQuestionBoxColor release];
    [dropTargets release];
    [dragTargets release];
    [dropTarget release];
    [dragObject release];
    [dragObjectDefaultParentView release];
    [SequencingCardsetViewController release];
    [currentCardset release];
    [ivProgress1 release];
    [ivProgress2 release];
    [ivProgress3 release];
    [ivProgress4 release];
    [ivProgress5 release];
    [ivProgress6 release];
    [ivProgress7 release];
    [ivProgress8 release];
    [ivProgress9 release];
    [ivProgress10 release];
    [ivStreamAnimation release];
    [super dealloc];
}

- (void)refresh
{
    [super refresh];
}

#pragma - SequencingGameViewController

- (IBAction)btnExit_Click:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playGameBGMusicA" object:self];
    
    isClickedExit = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onClickAACCard" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.myParentController selector:@selector(onClickAACCard:) name:@"onClickAACCard" object:nil];
    
    [self stopPlaySound];
    
    [self.view removeFromSuperview];
}

- (IBAction)btnSubmit_Click:(id)sender
{
    if(anwseredCardCount == [dropTargets count])
        [self checkResult];
    else
        NSLog(@"no wor");
}

- (IBAction)btnPlayQuestionSound_Click:(id)sender
{
    if ([randomSentenceItems count] <= 0)
    {
        return;
    }
    
    NSLog(@"isPlayingAllCard : %d, isPlayingSound : %d",isPlayingAllCards, isPlayingSound);
    
    if (!isPlayingAllCards && !isPlayingSound) {
        nowPlayingCardIndex = 0;
        isPlayingAllCards=YES;
        [self playSelectedCardOfIndex:nowPlayingCardIndex];
        
    }
}

- (IBAction)btnRedo_Click:(id)sender
{
    currentAnswerIndex = 0;
    anwseredCardCount = 0;
    [btnSubmit setEnabled:NO];
    for (int i = 0; i < [dragTargets count]; i++)
    {
        for (int j = 0; j < [dropTargets count]; j++)
        {
            UIView *dropView = (UIView *)[dropTargets objectAtIndex:j];
            if ([dropView.subviews count] == 2)
            {
                if ([[dropView.subviews objectAtIndex:1] tag] == i)
                {
                    UIView *dragView = (UIView *)[dragTargets objectAtIndex:i];
                    
                    UIView *aacView = (UIView *)[dropView.subviews objectAtIndex:1];
                    
                    
                    AACCard *aacCard = (AACCard *)[dictAACCards objectForKey:[NSString stringWithFormat:@"%i",aacView.tag]];
                   [aacCard resizeImageToSizeVirtually:220];
                    
                    
                    [dragView addSubview:aacView];

                    
                    break;
                }
            }
            
            //NSLog(@"count: %i", [dropView.subviews count]);
        }
    }
    
    /*
     [aacCard.view setFrame:CGRectMake(
     cardWidth / 2 - aacCard.view.frame.size.width / 2,
     cardHeight / 2 - aacCard.view.frame.size.height / 2,
     aacCard.view.frame.size.width,
     aacCard.view.frame.size.height)];
     */
    [self initGameValues];
}

- (void)initCurrentCardset
{
    NSMutableArray *cardsets = (NSMutableArray *)[[Utils getContentFromPlist:@"sequencing_cardsets.plist"] objectForKey:@"cardsets"];
    for (int i = 0; i < [cardsets count]; i++)
    {
        NSString *cardsetID = [[cardsets objectAtIndex:i] objectForKey:@"id"];
        NSString *targetCardsetID = [self.myExtraData objectForKey:@"game_set_id"];
        
        if ([cardsetID isEqualToString:targetCardsetID])
        {
            currentCardset = [cardsets objectAtIndex:i];
            break;
        }
    }
}

- (void)reloadGameView
{
    if (isClickedExit)
    {
        return;
    }
  canStartClicking = NO;  // one more variable to prevent user from clicking before question sound file is played
  
    anwseredCardCount= 0;
    [btnSubmit setEnabled:NO];
    if(totalAnswerCount>1){
        [self playSoundFile:@"ans_right.m4a"];
    }
    isPlayingSound = false;
    isPlayingAllCards = false;
    nowPlayingCardIndex = 0;
    
    currentAnswerIndex = 0;
    thisQuestionWrongCount = 0;
    
    [lblTotalQuestionCount setText:[NSString stringWithFormat:@"%i", maxQuestionCount]];
    [lblTotalQuestionIndex setText:[NSString stringWithFormat:@"%i", maxQuestionCount]];
    //[lblCurrentQuestionIndex setText:[NSString stringWithFormat:@"%i", totalAnswerCount]];
    [lblCurrentQuestionIndex setText:[NSString stringWithFormat:@"%i", correctAnswerCount]];
    
    [self setProgressBarWithProgress:totalAnswerCount];
    
    [self initGameValues];
    [self clearGameView];
    
    [btnPlayQuestionSound setEnabled:YES];
    [btnRedo setEnabled:YES];
    //[btnSubmit setEnabled:YES];
    
    CGFloat currentX = cardArea.frame.size.width / 2 - (cardWidth*currentLevel + cardMargin*(currentLevel-1)) / 2;
    CGFloat currentY = 0;
    
    //draw question box
    dragTargets = [[NSMutableArray alloc] init];
    for (int i = 0; i < currentLevel; i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(currentX,currentY,cardWidth,cardHeight)];
        //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(225+(45*i),373,91,92)];
        [view setBackgroundColor:[lblAnswerBoxColor textColor]];

        [view setTag:(i+1)];
        [cardArea addSubview:view];
        [dragTargets addObject:view];
        
        currentX += (cardWidth + cardMargin);
    }
    
    currentX = cardArea.frame.size.width / 2 - (cardWidth*currentLevel + cardMargin*(currentLevel-1)) / 2;
    currentY += (cardHeight + cardMargin);
    
    //draw answer box
    if (dropTargets != nil)
    {
        [dropTargets release];
    }
    dropTargets = [[NSMutableArray alloc] init];
    for (int i = 0; i < currentLevel; i++)
    {
        //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(currentX,currentY,cardWidth,cardHeight)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(225+(135*i),373,91,92)];
        [view setBackgroundColor:[lblQuestionBoxColor textColor]];
        [view setTag:((i+1)*-1)];
        [cardArea addSubview:view];
        [dropTargets addObject:view];
        
        UITextField *txtCardID = [[UITextField alloc] init];
        [txtCardID setHidden:YES];
        [txtCardID setText:[[orgSentenceItems objectAtIndex:i] objectForKey:@"card_id"]];
        [view addSubview:txtCardID];
        
        currentX += (cardWidth + cardMargin);
    }
    
    //add card into question box
    dictAACCards = [[NSMutableDictionary alloc] init];
    
    NSDictionary *content = [Utils getContentFromPlist:PLIST_PROFILE];    
    
    for (int i = 0; i < [randomSentenceItems count]; i++)
    {
        UserCard *userCard = [[UserCard alloc] initWithContent:[randomSentenceItems objectAtIndex:i]];
        AACCard *aacCard = [[AACCard alloc] initWithUserCard:userCard cardIndex:i profileID:[self.myExtraData objectForKey:@"profile_id"] withPlist:content];
//        NSLog(@"size: %f",aacCard.viewCardBorder.frame.size.width);
        [aacCard.view setFrame:CGRectMake(
                                         cardWidth / 2 - aacCard.view.frame.size.width / 2,
                                         cardHeight / 2 - aacCard.view.frame.size.height / 2,
                                         aacCard.view.frame.size.width,
                                         aacCard.view.frame.size.height)];
        
        UITextField *txtID = [[UITextField alloc] init];
        [txtID setHidden:YES];
        [txtID setText:[aacCard getCardID]];
        [aacCard.view addSubview:txtID];
        
        [((UIView *)[cardArea.subviews objectAtIndex:i]) addSubview:aacCard.view];
        [aacCard.view setTag:i];
        
        [aacCard resizeImageToSizeVirtually:220];
        
        [dictAACCards setValue:aacCard forKey:[NSString stringWithFormat:@"%i",i]];
    }
    
    [content release];
    
    [self performSelector:@selector(btnPlayQuestionSound_Click:) withObject:nil afterDelay:1.0];
}

- (void)initGameValues
{
    if (currentLevel == 2)
    {
        cardMargin = 30;
        cardWidth = cardHeight = 240;
    }
    else if (currentLevel == 3)
    {
        cardMargin = 30;
        cardWidth = cardHeight = 220;
    }
    else if (currentLevel == 4)
    {
        cardMargin = 50;
        cardWidth = cardHeight = 200;
    }
    else if (currentLevel == 5)
    {
        cardMargin = 30;
        cardWidth = cardHeight = 170;
    }
    else if (currentLevel == 6)
    {
        cardMargin = 10;
        cardWidth = cardHeight = 160;
    }
    
    [self initQuestionAnswerSentenceItems];
}

- (void)clearGameView
{
    while ([cardArea.subviews count] > 0)
    {
        UIView *tmpView = [cardArea.subviews objectAtIndex:0];
        
        while ([tmpView.subviews count] > 0)
        {
            UIView *tmpSubObject = [tmpView.subviews objectAtIndex:0];
            [tmpSubObject removeFromSuperview];
            //[tmpSubObject release];
            //NSLog(@"this is %@,",tmpSubObject);
        }
        
        [tmpView removeFromSuperview];
        [tmpView release];
    }
    
    [lblAnswerResult setText:@""];
}

- (NSMutableArray *)getRandomSentence
{
    NSMutableArray *cards = [[currentCardset objectForKey:@"set"] objectAtIndex:currentQuestionIndex];
    NSMutableArray *customArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [cards count]; i++)
    {
        //init to card format
        NSMutableDictionary *cardContent = [[NSMutableDictionary alloc] init];
        [cardContent setValue:@"YES" forKey:@"is_card"];
        [cardContent setValue:[cards objectAtIndex:i] forKey:@"card_id"];
        [cardContent setValue:@"" forKey:@"image_custom"];
        [cardContent setValue:@"" forKey:@"voice_custom"];
        [cardContent setValue:@"" forKey:@"caption_custom"];
        [cardContent setValue:@"0" forKey:@"border_color_id"];
        
        [customArray addObject:cardContent];
    }
    
    return customArray;    
}

- (void)initQuestionAnswerSentenceItems
{
    if (orgSentenceItems != nil) {
        [orgSentenceItems release];
    }
    if (randomSentenceItems != nil) {
        [randomSentenceItems release];
    }

    orgSentenceItems = [self getRandomSentence];
    randomSentenceItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < [orgSentenceItems count]; i++) {
        [randomSentenceItems addObject:[orgSentenceItems objectAtIndex:i]];
    }
    [MiniGameViewController randomArray:randomSentenceItems];
}

#pragma even handler

- (void) onClickAACCard:(NSNotification *)notification
{
    if(isPlayingAllCards)return;
  if (!canStartClicking) {
    return;
  }
  
    AACCard *selectedCard = (AACCard *)notification.object;
    
    bool allowDrag = YES;
    
    for (int i = 0; i < [dropTargets count]; i++)
    {
        if (selectedCard.view.superview == [dropTargets objectAtIndex:i])
        {
            allowDrag = NO;
            break;
        }
    }
    
    if (allowDrag)
    {
        UIView *currentAnswerBox = (UIView *)[dropTargets objectAtIndex:currentAnswerIndex];

       [currentAnswerBox addSubview:selectedCard.view];
        
        CGRect frame= selectedCard.viewCardBorder.frame;
        frame.origin.x = 8;
        selectedCard.viewCardBorder.frame = frame;
         
//        [selectedCard.view setFrame:currentAnswerBox.frame];
        [selectedCard resizeImageToSizeVirtually:92];
        
        currentAnswerIndex++;
        anwseredCardCount++;
        
        if(anwseredCardCount == [dropTargets count]){
            [btnSubmit setEnabled:YES];
        }
    }
    
}

#pragma AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self finishPLaySound];
}

- (void)playSoundOfCustomVoice:(NSString *)fileName
{
    if(!isPlayingSound)
    {
        NSString *filePath = [Utils getFullPath:[NSString stringWithFormat:@"/profiles/%@/%@.caf",[userProfile getProfileID],fileName]];
        
        isPlayingSound=YES;
        [Utils playSoundofFilePath:filePath withCallBackObject:self];
    }
}

- (void)playSoundOfCard:(NSString *)cardID withMode:(int)mode
{    
//    if(!isPlayingSound)
//    {
        isPlayingSound=YES;
        [Utils playSoundOfCard:cardID withMode:mode withCallBackObject:self];
//    }
}

- (void)finishPLaySound
{
    isPlayingSound=NO;
    
    if(isPlayingAllCards){
        nowPlayingCardIndex++;
        
        if(nowPlayingCardIndex < [orgSentenceItems count]){
            [self playSelectedCardOfIndex:nowPlayingCardIndex];
        }else{
            isPlayingAllCards=NO;
        }
      
      canStartClicking = YES;
    }
  
}

- (void)playSelectedCardOfIndex:(int)i
{
    if([orgSentenceItems count]>0)
    {
        UserCard *userCard = [[UserCard alloc] initWithContent:[orgSentenceItems objectAtIndex:i]];
        
        AACCard *aacCard = [[AACCard alloc] initWithUserCard:userCard cardIndex:i profileID:[self.myExtraData objectForKey:@"profile_id"]];
        
        if([[userCard getVoiceCustom] length]>0){
            [self playSoundOfCustomVoice:[userCard getVoiceCustom]];
        }else{
            if([aacCard haveDefaultCard])
            {
                [self playSoundOfCard:[(UserCard *)[aacCard getUserCard] getCardID] withMode:[userProfile getVoiceMode]];
            }
        }
    }
}

- (void)checkResult
{
    
    
    [btnRedo setEnabled:NO];
    [btnPlayQuestionSound setEnabled:NO];
    [btnSubmit setEnabled:NO];
 
    bool isCorrect = YES;
    
    for (int i = 0; i < [dropTargets count]; i++)
    {
        UIView *dropView = (UIView *)[dropTargets objectAtIndex:i];
        
        NSLog(@"");
        
        if ([dropView.subviews count] == 1)
        {
            isCorrect = NO;
            break;
        }
        
        NSString *dropViewCardID = ((UITextField *)[dropView.subviews objectAtIndex:0]).text;
        
        UIView *selectedCardView = (UIView *)[dropView.subviews objectAtIndex:1];
        NSString *selectedCardID = ((UITextField *)[selectedCardView.subviews objectAtIndex:3]).text;
        
        if (![dropViewCardID isEqualToString:selectedCardID])
        {
            isCorrect = NO;
            break;
        }
    }
    
    CGFloat delay = 1.0;
    
    if (isCorrect)
    {
        [self playCorrectSound];
//        [lblAnswerResult setTextColor:[UIColor greenColor]];
        [lblAnswerResult setTextColor:[UIColor colorWithRed:0 green:0.6 blue:0 alpha:1.0]];
//        [lblAnswerResult setText:@"答對了"];
        [lblAnswerResult setText:strAnswerCorrect];
        
        correctAnswerCount++;
        currentQuestionIndex++;
        
        [self playStreamAnimation];
    }
    else
    {
        [lblAnswerResult setTextColor:[UIColor redColor]];
        //[lblAnswerResult setText:@"答錯了"];
        [lblAnswerResult setText:strAnswerWrong];
        
        thisQuestionWrongCount++;
        
        if (thisQuestionWrongCount < 3)
        {
            if (thisQuestionWrongCount == 1)
            {
                [self playWrongTime1Sound];
                [self performSelector:@selector(redoBecauseWrong) withObject:nil afterDelay:2.0];
            }
            else if (thisQuestionWrongCount == 2)
            {
                [self playWrongTime2Sound];
                [self performSelector:@selector(redoBecauseWrong) withObject:nil afterDelay:2.0];
            }
            return;
        }
        else
        {
            thisQuestionWrongCount = 0;
        }
        
        [self playWrongTime3Sound];
        
        wrongAnswerCount++;
        
        CGFloat showAnswerDelay = 2.5 * [dropTargets count] + 2.0;
        CGFloat lastWrongDelay = 3.0;
        [self performSelector:@selector(showAnswer) withObject:nil afterDelay:lastWrongDelay];
        
        delay = lastWrongDelay + showAnswerDelay;
    }
    
//    currentQuestionIndex++;
  
    if ((currentQuestionIndex < 10) && !(currentQuestionIndex == 9 && !isCorrect))
    {
        totalAnswerCount++;
        [self performSelector:@selector(reloadGameView) withObject:nil afterDelay:delay+2];
    }
    else
    {
        //NSLog(@"no question lu");
        [self performSelector:@selector(showResultPage) withObject:nil afterDelay:delay+2];
    }
    //[self setProgressBarWithProgress:totalAnswerCount];
}

- (void)initScoreResult
{
    if (scoreResult != nil)
    {
        [scoreResult release];
    }
    scoreResult = [[NSMutableDictionary alloc] init];
    [scoreResult setValue:[NSString stringWithFormat:@"%i",totalAnswerCount] forKey:@"total_answer_count"];
    [scoreResult setValue:[NSString stringWithFormat:@"%i",correctAnswerCount] forKey:@"correct_answer_count"];
    [scoreResult setValue:[NSString stringWithFormat:@"%i",wrongAnswerCount] forKey:@"wrong_answer_count"];
}

- (void)showResultPage
{
    if (isClickedExit)
    {
        return;
    }
    
    //NSLog(@"show result page");
    [self.view addSubview:sequencingScoreViewController.view];
}

- (void)redoBecauseWrong
{
    [btnRedo setEnabled:YES];
    [btnPlayQuestionSound setEnabled:YES];
    //[btnSubmit setEnabled:YES];
    [lblAnswerResult setText:@""];
    [self btnRedo_Click:btnRedo];
}

- (void)playCorrectSound
{
    [self stopPlaySound];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *Path = [paths objectAtIndex:0];
    
    NSString *soundFileName = @"ans_right.m4a";
    
    [self playNewCorrectSound];
    
    if(![fm fileExistsAtPath:[Path stringByAppendingPathComponent:soundFileName]]){
        NSString *pathLocal = [Path stringByAppendingPathComponent:soundFileName];
        NSString *pathBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:soundFileName];
        [fm copyItemAtPath:pathBundle toPath:pathLocal error:nil];
        
    }
    
    NSString *pathLocal = [Path stringByAppendingPathComponent:soundFileName];
    
    //NSLog(@"PATH: %@", pathLocal);
    
    //NSString *filePath = [Utils getFullPath:@"/ans_right.m4a"];
    //NSLog(@"path: %@", filePath);
    isPlayingSound=YES;
    
    mainPlayerChannel = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:pathLocal] error:nil];
    //[mainPlayerChannel play];
    //[Utils playSoundofFilePath:pathLocal withCallBackObject:self];
}

- (void)playWrongTime1Sound
{
    [self stopPlaySound];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *Path = [paths objectAtIndex:0];
    
    NSString *soundFileName = @"ans_wrong1.mp3";
    
    [self playNewWrongSoundWithAttemp:1];
    
    
    if(![fm fileExistsAtPath:[Path stringByAppendingPathComponent:soundFileName]]){
        NSString *pathLocal = [Path stringByAppendingPathComponent:soundFileName];
        NSString *pathBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:soundFileName];
        [fm copyItemAtPath:pathBundle toPath:pathLocal error:nil];
        
    }
    
    NSString *pathLocal = [Path stringByAppendingPathComponent:soundFileName];
    
    mainPlayerChannel = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:pathLocal] error:nil];
    //[mainPlayerChannel play];
    //[Utils playSoundofFilePath:pathLocal withCallBackObject:self];
}

- (void)playWrongTime2Sound
{
    [self stopPlaySound];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *Path = [paths objectAtIndex:0];
    
    NSString *soundFileName = @"ans_wrong1.mp3";
    
    [self playNewWrongSoundWithAttemp:1];
    
    if(![fm fileExistsAtPath:[Path stringByAppendingPathComponent:soundFileName]]){
        NSString *pathLocal = [Path stringByAppendingPathComponent:soundFileName];
        NSString *pathBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:soundFileName];
        [fm copyItemAtPath:pathBundle toPath:pathLocal error:nil];
        
    }
    
    NSString *pathLocal = [Path stringByAppendingPathComponent:soundFileName];
    
    
    mainPlayerChannel = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:pathLocal] error:nil];
    //[mainPlayerChannel play];
    //[Utils playSoundofFilePath:pathLocal withCallBackObject:self];
}

- (void)playWrongTime3Sound
{
    [self stopPlaySound];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *Path = [paths objectAtIndex:0];
    
    NSString *soundFileName = @"ans_wrong2.mp3";
    
    [self playNewWrongSoundWithAttemp:2];
    
    if(![fm fileExistsAtPath:[Path stringByAppendingPathComponent:soundFileName]]){
        NSString *pathLocal = [Path stringByAppendingPathComponent:soundFileName];
        NSString *pathBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:soundFileName];
        [fm copyItemAtPath:pathBundle toPath:pathLocal error:nil];
        
    }
    
    NSString *pathLocal = [Path stringByAppendingPathComponent:soundFileName];
    
    isPlayingSound=YES;
    
    mainPlayerChannel = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:pathLocal] error:nil];
    //[mainPlayerChannel play];
    //[Utils playSoundofFilePath:pathLocal withCallBackObject:self];
}

- (void)showAnswer
{

    [self btnRedo_Click:btnRedo];
    
    for (int i = 0; i < [dragTargets count]; i++)
    {
        UIView *dragView = (UIView *)[dragTargets objectAtIndex:i];
        UIView *cardView = (UIView *)[dragView.subviews objectAtIndex:0];
        [cardView setHidden:YES];
    }
    
    for (int i = 0; i < [dragTargets count]; i++)
    {
        UIView *dragView = (UIView *)[dragTargets objectAtIndex:i];
        UIView *cardView = (UIView *)[dragView.subviews objectAtIndex:0];
        NSString *cardView_cardID = ((UITextField *)[cardView.subviews objectAtIndex:3]).text;
        
        for (int a = 0; a < [dropTargets count]; a++)
        {
            UIView *currentDropView = (UIView *)[dropTargets objectAtIndex:a];
            NSString *dropView_cardID = ((UITextField *)[currentDropView.subviews objectAtIndex:0]).text;
            
            if ([dropView_cardID isEqualToString:cardView_cardID])
            {
                [currentDropView addSubview:cardView];
                break;
            }
        }
    }
    
    
    CGFloat delay = 0.0;
    currentShowAnswerCount = 0;
    isPlayingSound = NO;
    
    for (int i = 0; i < [dropTargets count]; i++)
    {
        delay = (i+1) * 2.5;  // changed to 2.2, otherwise some sound files cannot be played
        [self performSelector:@selector(showAnswerCardAction) withObject:nil afterDelay:delay];
        
    }
  
    currentQuestionIndex++;
}

- (void)showAnswerCardAction
{
    if (isClickedExit)
    {
        return;
    }
    
    currentShowAnswerCount++;
    [self playSelectedCardOfIndex:(currentShowAnswerCount-1)];
    UIView *dropView = (UIView *)[dropTargets objectAtIndex:(currentShowAnswerCount - 1)];
    
    //////////////
    UIView *aacView = (UIView *)[dropView.subviews objectAtIndex:1];
    AACCard *aacCard = (AACCard *)[dictAACCards objectForKey:[NSString stringWithFormat:@"%i",aacView.tag]];
    
    CGRect frame= aacCard.viewCardBorder.frame;
    frame.origin.x = 8;
    aacCard.viewCardBorder.frame = frame;
    
    [aacCard resizeImageToSizeVirtually:92];
    //////////////
    
    [[dropView.subviews objectAtIndex:1] setHidden:NO];
}

- (void)stopPlaySound
{
    nowPlayingCardIndex = 9999;
    [self finishPLaySound];
    
    if (mainPlayerChannel != nil)
    {
        [mainPlayerChannel stop];
    }
}

-(void)setProgressBarWithProgress:(int)i
{
    i=i-1;
    NSLog(@"setpro : %d", i);
    [ivProgress1 setImage:[UIImage imageNamed:((i>=1)?PROGRESS_BAR_HEAD_IMAGE_ON:PROGRESS_BAR_HEAD_IMAGE_OFF)]];
    [ivProgress2 setImage:[UIImage imageNamed:((i>=2)?PROGRESS_BAR_MIDDLE_IMAGE_ON:PROGRESS_BAR_MIDDLE_IMAGE_OFF)]];
    [ivProgress3 setImage:[UIImage imageNamed:((i>=3)?PROGRESS_BAR_MIDDLE_IMAGE_ON:PROGRESS_BAR_MIDDLE_IMAGE_OFF)]];
    [ivProgress4 setImage:[UIImage imageNamed:((i>=4)?PROGRESS_BAR_MIDDLE_IMAGE_ON:PROGRESS_BAR_MIDDLE_IMAGE_OFF)]];
    [ivProgress5 setImage:[UIImage imageNamed:((i>=5)?PROGRESS_BAR_MIDDLE_IMAGE_ON:PROGRESS_BAR_MIDDLE_IMAGE_OFF)]];
    [ivProgress6 setImage:[UIImage imageNamed:((i>=6)?PROGRESS_BAR_MIDDLE_IMAGE_ON:PROGRESS_BAR_MIDDLE_IMAGE_OFF)]];
    [ivProgress7 setImage:[UIImage imageNamed:((i>=7)?PROGRESS_BAR_MIDDLE_IMAGE_ON:PROGRESS_BAR_MIDDLE_IMAGE_OFF)]];
    [ivProgress8 setImage:[UIImage imageNamed:((i>=8)?PROGRESS_BAR_MIDDLE_IMAGE_ON:PROGRESS_BAR_MIDDLE_IMAGE_OFF)]];
    [ivProgress9 setImage:[UIImage imageNamed:((i>=9)?PROGRESS_BAR_MIDDLE_IMAGE_ON:PROGRESS_BAR_MIDDLE_IMAGE_OFF)]];
    [ivProgress10 setImage:[UIImage imageNamed:((i>=10)?PROGRESS_BAR_END_IMAGE_ON:PROGRESS_BAR_END_IMAGE_OFF)]];
    
}

-(void)playStreamAnimation{
    NSArray *streamFrames = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"steam_a1.png"],[UIImage imageNamed:@"steam_a2.png"],[UIImage imageNamed:@"steam_a3.png"],[UIImage imageNamed:@"steam_a4.png"],[UIImage imageNamed:@"steam_a5.png"],[UIImage imageNamed:@"steam_a1.png"], nil];
    
    ivStreamAnimation.animationDuration = 1;
    ivStreamAnimation.animationImages = streamFrames;
    ivStreamAnimation.animationRepeatCount = 1;
    [streamFrames release];
    
    [ivStreamAnimation startAnimating];
}

-(void)playNewCorrectSound{
    if(currentLevel==2 || currentLevel ==3){
        [self playSoundFile:@"g2_easy_1.mp3"];
    }else{
        [self playSoundFile:@"g2_hard_1.mp3"];
    }
}
-(void)playNewWrongSoundWithAttemp:(int)i{
    if(currentLevel==2 || currentLevel ==3){
        if(i==1)
            [self playSoundFile:@"g2_easy_2.mp3"];
        else
            [self playSoundFile:@"g2_easy_3.mp3"];
    }else{
        if(i==1)
            [self playSoundFile:@"g2_hard_2.mp3"];
        else
            [self playSoundFile:@"g2_hard_3.mp3"];            
    }
}
-(void)playSoundFile:(NSString *)soundFileName{
    NSLog(@"playing %@",soundFileName);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *Path = [paths objectAtIndex:0];
    
    if(![fm fileExistsAtPath:[Path stringByAppendingPathComponent:soundFileName]]){
        NSString *pathLocal = [Path stringByAppendingPathComponent:soundFileName];
        NSString *pathBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:soundFileName];
        [fm copyItemAtPath:pathBundle toPath:pathLocal error:nil];
        
    }
    
    NSString *pathLocal = [Path stringByAppendingPathComponent:soundFileName];
    
    //isPlayingSound=YES;
    [Utils playSoundofFilePath:pathLocal withCallBackObject:self];
}

-(void)setLanguage:(NSString *)lang{
    if([lang isEqualToString:[Constants getLanguageCodeTW]]){

        [btnPlayQuestionSound setTitle:[Utils getText:@"聲音提示" ForLang:[Constants getLanguageCodeTW] atView:@"SequencingGame"] forState:UIControlStateNormal];
        [btnSubmit setTitle:[Utils getText:@"確定" ForLang:[Constants getLanguageCodeTW] atView:@"SequencingGame"] forState:UIControlStateNormal];
        [btnRedo setTitle:[Utils getText:@"重做" ForLang:[Constants getLanguageCodeTW] atView:@"SequencingGame"] forState:UIControlStateNormal];
        
        strAnswerCorrect = @"答對了";
        strAnswerWrong = @"答錯了";
        
        [lblAccScore setText:[Utils getText:@"累積分數" ForLang:[Constants getLanguageCodeTW] atView:@"SequencingGame"]];

    }
    
    if([lang isEqualToString:[Constants getLanguageCodeCN]]){

        [btnPlayQuestionSound setTitle:[Utils getText:@"聲音提示" ForLang:[Constants getLanguageCodeCN] atView:@"SequencingGame"] forState:UIControlStateNormal];
        [btnSubmit setTitle:[Utils getText:@"確定" ForLang:[Constants getLanguageCodeCN] atView:@"SequencingGame"] forState:UIControlStateNormal];
        [btnRedo setTitle:[Utils getText:@"重做" ForLang:[Constants getLanguageCodeCN] atView:@"SequencingGame"] forState:UIControlStateNormal];
        
        strAnswerCorrect = @"答对了";
        strAnswerWrong = @"答错了";
        
        [lblAccScore setText:[Utils getText:@"累積分數" ForLang:[Constants getLanguageCodeCN] atView:@"SequencingGame"]];
    }
}
@end
