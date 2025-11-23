//
//  MatchingGameViewController.m
//  hongchiaac
//
//  Created by Ray.Liu on 12/4/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "MatchingGameViewController.h"
#import "../../Handlers/ProfileHandler.h"
#import "../../AACCard.h"
#import "../../Utils.h"
#import "../../Constants.h"
#import "../../Handlers/SettingHandler.h"

@implementation MatchingGameViewController

#define PROGRESS_BAR_HEAD_IMAGE_OFF @"progress_bar_a.png"
#define PROGRESS_BAR_HEAD_IMAGE_ON @"progress_bar_a_selected.png"
#define PROGRESS_BAR_MIDDLE_IMAGE_OFF @"progress_bar_b.png"
#define PROGRESS_BAR_MIDDLE_IMAGE_ON @"progress_bar_b_selected.png"
#define PROGRESS_BAR_END_IMAGE_OFF @"progress_bar_c.png"
#define PROGRESS_BAR_END_IMAGE_ON @"progress_bar_c_selected.png"

#pragma - MiniGameViewController

#define PLIST_PROFILE @"profiles.plist"

@synthesize ivProgress1,ivProgress2,ivProgress3,ivProgress4,ivProgress5,ivProgress6,ivProgress7,ivProgress8,ivProgress9,ivProgress10;
@synthesize lblCurrentMark,lblCurrentMarkTitle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.myParentController name:@"onClickAACCard" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClickAACCard:) name:@"onClickAACCard" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.myParentController name:@"onClickAACEmtpyCardForGame" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClickAACCardEmpty:) name:@"onClickAACEmtpyCardForGame" object:nil];
    
    [self initStartupObjects];
    
    [self reloadGameView];
    
    [self setLanguage:[SettingHandler getApplicationLanguage]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopGameBGMusicA" object:self];
    
    [self flashingCover];
}

- (void)dealloc
{
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
    [lblCurrentMark release];
    [lblCurrentMarkTitle release];
    
    [scLayout release];
    [userProfile release];
    [cardset release];
    [questionCard release];
    [scoreViewController release];
    [questionText release];
    [lblAnswerResult release];
    [btnPlayQuestionSound release];
    [selectedCardArea release];
    [btnNext release];
    [btnRandom release];
    [btnScore release];
    [scoreResult release];
    [lblTotalQuestionCount release];
    [lblTotalQuestionIndex release];
    [lblCurrentQuestionIndex release];
    [iconCorrect release];
    [super dealloc];
}

- (void)refresh
{
    [super refresh];
}

#pragma - MatchingGameViewController

-(IBAction) onLayoutChanged
{
    gameLayout = [scLayout selectedSegmentIndex]+1;
    [self reloadGameView];
}

- (IBAction)btnPlayQuestionSound_Click:(id)sender
{
    NSDictionary *content = [Utils getContentFromPlist:PLIST_PROFILE];
    AACCard *aacCard = [[AACCard alloc] initWithUserCard:[questionCard getUserCard] cardIndex:0 profileID:[self.myExtraData objectForKey:@"profile_id"] withPlist:content];
    
    [content release];
    
    NSLog(@"btnPlayQuestionSound_Click>>>>>>> is ready ? %d",isReadyForAnswer);
    
    if([[questionCard getVoiceCustom] length] > 0)
    {
        [self playSoundOfCustomVoice:[questionCard getVoiceCustom]];
    }
    else
    {
        if([aacCard haveDefaultCard])
        {
            [self playSoundOfCard:[(UserCard *)[aacCard getUserCard] getCardID] withMode:[userProfile getVoiceMode]];
        }
    }
}

- (IBAction)btnNext_Click:(id)sender
{
    [self stopSound];
    
    //[self playSoundFile:@"ans_right.m4a"];
    [self playSoundFileWithoutCallBack:@"ans_right.m4a"];

    isAnswered = NO;
    totalAnswerCount++;
    [lblCurrentQuestionIndex setText:[NSString stringWithFormat:@"%i", totalAnswerCount]];
    [self setProgressBarWithProgress:totalAnswerCount];
    [lblAnswerResult setText:@""];
    [iconCorrect removeFromSuperview];
    [self reloadGameView];
}

- (IBAction)btnRandom_Click:(id)sender
{
    [self stopSound];
    [self reloadGameView];
}

- (IBAction)btnScore_Click:(id)sender
{     
    [self.view addSubview:scoreViewController.view];
}

- (IBAction)btnExit_Click:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onClickAACCard" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.myParentController selector:@selector(onClickAACCard:) name:@"onClickAACCard" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onClickAACEmtpyCardForGame" object:nil];    

    [[NSNotificationCenter defaultCenter] addObserver:self.myParentController selector:@selector(onClickAACCard:) name:@"onClickAACCard" object:nil];    

    [[NSNotificationCenter defaultCenter] postNotificationName:@"playGameBGMusicA" object:self];    
    
    [self.view removeFromSuperview];
    
    
}

- (void)initStartupObjects
{
    isAnswered = NO;
    totalAnswerCount = 1;
    correctAnswerCount = 0;
    wrongAnswerCount = 0;
    maxQuestionCount = 10;
    isWaitingNextQuestion = NO;
    
    [lblTotalQuestionCount setText:[NSString stringWithFormat:@"%i", maxQuestionCount]];
    [lblTotalQuestionIndex setText:[NSString stringWithFormat:@"%i", maxQuestionCount]];
    [lblCurrentQuestionIndex setText:[NSString stringWithFormat:@"%i", totalAnswerCount]];
    [self setProgressBarWithProgress:totalAnswerCount];
    [lblCurrentMark setText:[NSString stringWithFormat:@"%d",correctAnswerCount]];
    
    userProfile = [[UserProfile alloc] initWithProfileID:[self.myExtraData objectForKey:@"profile_id"]];
    
    //gameLayout = [userProfile getLayout];
    gameLayout = [[self.myExtraData objectForKey:@"game_level"] intValue];
    
    [scLayout setSelectedSegmentIndex:gameLayout-1];
    
    iconCorrect = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_ok.png"]];
}

- (void)reloadGameView
{
    totalAnswerTried=0;
    isWaitingNextQuestion = NO;
    
    [self setReady:NO];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(btnPlayQuestionSound_Click:) object:nil];
    
    if (userProfile != nil)
    {
        [userProfile release];
    }
    
    if (cardset != nil)
    {
        [cardset release];
    }
    
    userProfile = [[UserProfile alloc] initWithProfileID:[self.myExtraData objectForKey:@"profile_id"]];
    
    cardset = [[NSMutableArray alloc] init];
    [MiniGameViewController fillCardsetArray:cardset Cardset:[userProfile getCardset]];
    
    //NSLog(@"%@", [cardset objectAtIndex:0]);
    
    //NSLog(@"total count: %i", totalCardCount);
    //NSLog(@"current count: %i", currentCardCount);
    //NSLog(@"missing count: %i", missingCardCount);
    
    if ([cardset count] <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示" message:@"沒有足夠的卡進行遊戲" delegate:self
                              cancelButtonTitle:@"返回" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    //fill to absolute card count
    totalCardCount = (gameLayout == 2)?2:((gameLayout == 3)?3:((gameLayout == 4)?8:((gameLayout == 5)?12:((gameLayout == 6)?18:0))));
    currentCardCount = [cardset count];
    missingCardCount = totalCardCount - currentCardCount;
    
    for (int a = 0; a < missingCardCount; a++)
    {
        NSMutableDictionary *emptyCardContent = [MiniGameViewController getEmptyCardContent];
        [cardset addObject:emptyCardContent];
    }
    
    
    [self clearGameView];
    [self randomCardsetArray];
    
    int tempCounter = 0;
    //int layout = [userProfile getLayout];
    int layout = gameLayout;
    int row = [MiniGameViewController getRowFromLayout:layout];
    int col = [MiniGameViewController getColFromLayout:layout];
    
    NSMutableArray *availableCardset = [[NSMutableArray alloc] init];
    
    NSDictionary *content = [Utils getContentFromPlist:PLIST_PROFILE];
    
    for (int i = 0; i < [MiniGameViewController getCardCountByLayout:layout]; i++)
    {
        //![[[cardset objectAtIndex:i] objectForKey:@"card_id"] isEqualToString:@"empty_card"]
        
        if (i < [cardset count])
        {            
            //add card into selected card area
            UserCard *userCard = [[UserCard alloc] initWithContent:[cardset objectAtIndex:i]];
            AACCard *aacCard = [[AACCard alloc] initWithUserCard:userCard cardIndex:i profileID:[self.myExtraData objectForKey:@"profile_id"] withPlist:content];
            
            
            //marked used card
            if (!([[[cardset objectAtIndex:i] objectForKey:@"card_id"] isEqualToString:@"empty_card"] &&
                  [[[cardset objectAtIndex:i] objectForKey:@"voice_custom"] isEqualToString:@""] ))
            {
                [availableCardset addObject:aacCard];
            }
            
            [selectedCardArea addSubview:aacCard.view];
        
            
            //[aacCard resizeImageToSize:[MiniGameViewController getCardSize:[userProfile getLayout]]];
            [aacCard resizeImageToSize:[MiniGameViewController getCardSize:gameLayout]];
            
            CGRect frame = aacCard.view.frame;
            frame.origin.x = (tempCounter % col) * [MiniGameViewController getCardXMargin:layout] + (selectedCardArea.frame.size.width - frame.size.width * col)/col/2;
            frame.origin.y = (int)floor(((float)tempCounter / (float)col)) * [MiniGameViewController getCardYMargin:layout] + (selectedCardArea.frame.size.height - frame.size.height * row)/row/2;
            aacCard.view.frame = frame;
            
            UITextField *txtIsCorrect = [[UITextField alloc] init];
            [txtIsCorrect setText:@"0"];
            [txtIsCorrect setHidden:YES];
            [aacCard.view addSubview:txtIsCorrect];
            
            tempCounter++;
        }
    }
    
    [content release];

    questionIndex = arc4random() % [availableCardset count];
    
    NSLog(@"checking-------%d, %d",questionIndex, [availableCardset count]);
    questionCard = [availableCardset objectAtIndex:questionIndex];
    
    //if([[questionCard.view.subviews objectAtIndex:3] isKindOfClass:[UITextField class]])
        [((UITextField *)[questionCard.view.subviews objectAtIndex:3]) setText:@"1"];
    //else
    //    [((UITextField *)[questionCard.view.subviews objectAtIndex:2]) setText:@"1"];

    //questionCard = [[UserCard alloc] initWithContent:[availableCardset objectAtIndex:(questionIndex)]];
    
    /*
    if ([[questionCard getCaptionRawCustom] length] > 0)
    {
        [questionText setText:[questionCard getCaptionCustom]];
    }
    else
    {
        [questionText setText:[questionCard getCaptionTW]];
    }
    */
    
    //soundTimer = [[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(btnPlayQuestionSound_Click:) userInfo:nil repeats:NO] retain];
    
    //[self btnPlayQuestionSound_Click:btnPlayQuestionSound];

    NSLog(@"reaload game >>>>>%d",isReadyForAnswer);
    [self performSelector:@selector(btnPlayQuestionSound_Click:) withObject:nil afterDelay:1.5];
}

- (void)randomCardsetArray
{
    [MiniGameViewController randomArray:cardset];
}

- (void)clearGameView
{
    if (selectedCardArea != nil)
    {
        while ([selectedCardArea.subviews count] > 0)
        {
            UIView *tmpView = (UIView *)[selectedCardArea.subviews objectAtIndex:0];
            
            //release sub-object
            while ([tmpView.subviews count] > 0)
            {
                UIView *tmpSubObject = [tmpView.subviews objectAtIndex:0];
                [tmpSubObject removeFromSuperview];
//                [tmpSubObject release];  // cannot release under ios 7
            }
            
            [tmpView removeFromSuperview];
//            [tmpView release];  // cannot release under ios 7
        }
        
        viewWrongAnswerCover = nil;
        isHavingWrongAttemp = NO;
    }
}

#pragma even handler

- (void) onClickAACCard:(NSNotification *)notification
{
    if(isWaitingNextQuestion)return;
    NSLog(@"part1");
    if(!isReadyForAnswer)return;
    NSLog(@"part2");
    if(isPlayingSound)return;
    NSLog(@"part3");
    [self setReady:NO];
    NSLog(@"part4");
    if (isAnswered)
    {
        NSLog(@"part5");
//        [self setReady:YES];
//        return;
    }
    NSLog(@"part6");    
    
    AACCard *clickedAACCard = (AACCard *)notification.object;


    [self checkAnswer:clickedAACCard];
}

-(void) onClickAACCardEmpty:(NSNotification *)notification{
    if(isWaitingNextQuestion)return;    
    if(!isReadyForAnswer)return;
    if(isPlayingSound)return;
    if(totalAnswerTried>0)return;
    [self setReady:NO];
    
    wrongAnswerCount++;
    totalAnswerTried++;
    [lblAnswerResult setTextColor:[UIColor redColor]];
    [lblAnswerResult setText:@"答錯了"];
    
    [self playWrongSound];
    
        for (int a = 0; a < [selectedCardArea.subviews count]; a++)
        {
            UIView *tmpCardView = (UIView *)[selectedCardArea.subviews objectAtIndex:a];
            NSString *isCorrectKey = ((UITextField *)[tmpCardView.subviews objectAtIndex:3]).text;
            if ([isCorrectKey isEqualToString:@"1"])
            {
                //[tmpCardView addSubview:iconCorrect];
                
                
                tmpCardView.alpha = 1;
                
                [self recurFlash:3 v:tmpCardView duration:0.5];
                
                break;
            }
        }
    
    /*
    NSLog(@"totalAns:%d, maxQ:%d",totalAnswerCount,maxQuestionCount);
    if (totalAnswerCount < maxQuestionCount)
    {
        [[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(btnNext_Click:) userInfo:nil repeats:NO] retain];
    }
    else
    {
        [[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(btnScore_Click:) userInfo:nil repeats:NO] retain];
    }
    */
}

#pragma AVAudioPlayerDelegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
  NSLog(@"%@", player.url);
    [self finishPLaySound];
}

- (void)playSoundOfCard:(NSString *)cardID withMode:(int)mode
{
    if(!isPlayingSound)
    {
        isPlayingSound=YES;
        [Utils playSoundOfCard:cardID withMode:mode withCallBackObject:self];

    }
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

- (void)stopSound
{
    //NSString *filePath = [Utils getFullPath:@"empty.mp3"];
    //NSLog(@"%@", filePath);
    //[Utils playSoundofFilePath:filePath withCallBackObject:self];
}

- (void)finishPLaySound
{
    isPlayingSound=NO;
    //isReadyForAnswer=YES;
    NSLog(@"finishPlaySound");
    [self setReady:YES];
}

- (void)checkAnswer:(AACCard *)selectedCard
{

    

    //isReadyForAnswer = NO;
    [self setReady:YES];
    
    NSString *isCorrect;

    isCorrect = ((UITextField *)[selectedCard.view.subviews objectAtIndex:3]).text;
    
    NSLog(@"clicked answer is ::::::::: %@",isCorrect);
    if ([isCorrect isEqualToString:@"1"])
    {
        if(!isHavingWrongAttemp)
            correctAnswerCount++;

        [lblAnswerResult setTextColor:[UIColor colorWithRed:0 green:0.53 blue:0 alpha:1]];
        [lblAnswerResult setText:@"答對了"];
        [lblCurrentMark setText:[NSString stringWithFormat:@"%d",correctAnswerCount]];
        
        [self playCorrectSound];
        
        
        ////
        [selectedCard.view addSubview:iconCorrect];
        ////
        totalAnswerTried = 0;
    }
    else
    {
        if (isAnswered)
        {
            NSLog(@"is answered?");
            return;
        }
        
        if(totalAnswerTried==0){
            //The following is repeated once in the function self.onClickAACCardEmpty
            //if changed following code, please check the code in that function as well
        
            wrongAnswerCount++;
            totalAnswerTried++;
        
            [lblAnswerResult setTextColor:[UIColor redColor]];
            [lblAnswerResult setText:@"答錯了"];
        
            [self playWrongSound];
        
            for (int a = 0; a < [selectedCardArea.subviews count]; a++)
            {
                UIView *tmpCardView = (UIView *)[selectedCardArea.subviews objectAtIndex:a];
                NSString *isCorrectKey = ((UITextField *)[tmpCardView.subviews objectAtIndex:3]).text;
                if ([isCorrectKey isEqualToString:@"1"])
                {
                    //[tmpCardView addSubview:iconCorrect];
                
                    tmpCardView.alpha = 1;
                
                    /*
                 [UIView animateWithDuration:0.5 animations:^(void){tmpCardView.alpha=0;} completion:^(BOOL finished){
                        [UIView animateWithDuration:0.5 animations:^(void){tmpCardView.alpha=1;} completion:^(BOOL finished){;}];
                 }];
                 */
                    for(int c=0;c<[tmpCardView.subviews count];c++){
                        if( [[tmpCardView.subviews objectAtIndex:c] isKindOfClass:[UIImageView class]] )
                            tmpCardView = [tmpCardView.subviews objectAtIndex:c];
                        break;
                    }
                    
                    
                    //[self recurFlash:3 v:tmpCardView duration:0.5];
                
                    if(viewWrongAnswerCover==nil){
                        isHavingWrongAttemp = YES;
                        viewWrongAnswerCover = [[UIView alloc] initWithFrame:tmpCardView.frame];
                    
                        [viewWrongAnswerCover retain];
                        [viewWrongAnswerCover setBackgroundColor:[UIColor orangeColor]];
                        [viewWrongAnswerCover setAlpha:0];
                        [viewWrongAnswerCover setUserInteractionEnabled:NO];
                        [tmpCardView.superview addSubview:viewWrongAnswerCover];  
                    }
                    break;
                }
            }
        }
        
    
    }
    
    isAnswered = YES;    
    if ([isCorrect isEqualToString:@"1"]){
        if (totalAnswerCount < maxQuestionCount)
        {
            isWaitingNextQuestion = YES;
            [[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(btnNext_Click:) userInfo:nil repeats:NO] retain];
        }
        else
        {

            [[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(btnScore_Click:) userInfo:nil repeats:NO] retain];
        }
    }
    
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

-(void)setProgressBarWithProgress:(int)i
{
    i=i-1;
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

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self btnExit_Click:btnExit];
}
-(void)setLanguage:(NSString *)lang{
    if([lang isEqualToString:[Constants getLanguageCodeTW]]){
        
        [lblCurrentMarkTitle setText:[Utils getText:@"分數" ForLang:[Constants getLanguageCodeTW] atView:@"MatchingGame"] ];

        [btnPlayQuestionSound setTitle:[Utils getText:@"重覆播放" ForLang:[Constants getLanguageCodeTW] atView:@"MatchingGame"] forState:UIControlStateNormal];
    }
    
    if([lang isEqualToString:[Constants getLanguageCodeCN]]){
        
        
        [lblCurrentMarkTitle setText:[Utils getText:@"分數" ForLang:[Constants getLanguageCodeCN] atView:@"MatchingGame"] ];
        
        [btnPlayQuestionSound setTitle:[Utils getText:@"重覆播放" ForLang:[Constants getLanguageCodeCN] atView:@"MatchingGame"] forState:UIControlStateNormal];
        
        
    }
}

-(void)recurFlash:(int)t v:(UIView *)v duration:(float)d{
    t--;
    
//    [UIView animateWithDuration:d animations:^(void){v.alpha=0.6;} completion:^(BOOL finished){
    [UIView animateWithDuration:d delay:2 options:UIViewAnimationOptionTransitionNone animations:^(void){v.alpha=0;} completion:^(BOOL finished){
        [UIView animateWithDuration:d animations:^(void){v.alpha=1;} completion:^(BOOL finished){
            /*
            //if(t>0){
            if(totalAnswerTried>0){
                [self recurFlash:t v:v duration:d];
            }
            //}
            */
            ;}];
    }];
}

-(void)flashingCover{
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^(void){viewWrongAnswerCover.alpha=0;} completion:^(BOOL finished){
        [UIView animateWithDuration:0.5 animations:^(void){viewWrongAnswerCover.alpha=0.3;} completion:^(BOOL finished){
            [self flashingCover];
            ;}];
    }];
}

-(void)setReady:(BOOL)ready{
    NSLog(@"set ready to %d",ready);
    isReadyForAnswer = ready;
}

-(void)playCorrectSound{
    if(gameLayout==2 || gameLayout==3){
        [self playSoundFileWithoutCallBack:@"g1_easy_correct.mp3"];
    }else{
        if (totalAnswerCount < maxQuestionCount){
            [self playSoundFileWithoutCallBack:@"g1_hard_correct.mp3"];
        } else {
            [self playSoundFileWithoutCallBack:@"g1_easy_correct.mp3"];
        }
    }
    
}
-(void)playWrongSound{
    /*
    if(gameLayout==2 || gameLayout ==3){
        [self playSoundFile:@"g1_easy_wrong.mp3"];
    }else{
        [self playSoundFile:@"g1_hard_wrong.mp3"];
    }
     */
    [self playSoundFile:@"game_matching_try_again.mp3"];
}
-(void)playSoundFile:(NSString *)soundFileName{
    NSLog(@"playing %@",soundFileName);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *Path = [paths objectAtIndex:0];
    
    //NSString *soundFileName = @"ans_right.m4a";
    
    //NSString *soundFileName = @"g1_easy_correct.mp3";
    
    if(![fm fileExistsAtPath:[Path stringByAppendingPathComponent:soundFileName]]){
        NSString *pathLocal = [Path stringByAppendingPathComponent:soundFileName];
        NSString *pathBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:soundFileName];
        [fm copyItemAtPath:pathBundle toPath:pathLocal error:nil];
        
    }
    
    NSString *pathLocal = [Path stringByAppendingPathComponent:soundFileName];
    
    isPlayingSound=YES;
    [Utils playSoundofFilePath:pathLocal withCallBackObject:self];
}
-(void)playSoundFileWithoutCallBack:(NSString *)soundFileName{
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
    [Utils playSoundofFilePath:pathLocal withCallBackObject:nil];
}
@end
