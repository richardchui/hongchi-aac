//
//  MatchingScoreViewController.m
//  hongchiaac
//
//  Created by Ray.Liu on 12/5/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "MatchingScoreViewController.h"
#import "MatchingGameViewController.h"
#import "../../Utils.h"
#import "../../Constants.h"
#import "../../Handlers/SettingHandler.h"

@implementation MatchingScoreViewController

#pragma - MiniGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int totalAnswerCount = [[self.myExtraData objectForKey:@"total_answer_count"] intValue];
    int correctAnswerCount = [[self.myExtraData objectForKey:@"correct_answer_count"] intValue];
    int wrongAnswerCount = [[self.myExtraData objectForKey:@"wrong_answer_count"] intValue];
    int missingAnswerCount = totalAnswerCount - correctAnswerCount - wrongAnswerCount;
    
    [lblTotalAnswerCount setText:[NSString stringWithFormat:@"%i", totalAnswerCount]];
    [lblCorrectAnswerCount setText:[NSString stringWithFormat:@"%i", correctAnswerCount]];
    [lblWrongAnswerCount setText:[NSString stringWithFormat:@"%i", wrongAnswerCount]];
    [lblMissingAnswerCount setText:[NSString stringWithFormat:@"%i", missingAnswerCount]];
    
    [self setLanguage:[SettingHandler getApplicationLanguage]];
    
    if(correctAnswerCount==10){
        [self playSoundFile:@"g1_ending_1.mp3"];
    }else if(correctAnswerCount >=5){
        [self playSoundFile:@"g1_ending_2.mp3"];
    }else{
        [self playSoundFile:@"g1_ending_3.mp3"];
    }
}

- (void)dealloc
{
    [btnClose release];
    [lblTotalAnswerCount release];
    [lblCorrectAnswerCount release];
    [lblWrongAnswerCount release];
    [lblMissingAnswerCount release];
    [lblFinishGameMessage release];
    [lblScore release];
    
    [super dealloc];
}

- (void)refresh
{
    [super refresh];
}

#pragma - MatchingScoreViewController

- (IBAction)btnClose_Click:(id)sender
{
    [self exit];
}

- (void)exit
{
    [self.view removeFromSuperview];
    
    [((MatchingGameViewController *)self.myParentController) btnExit_Click:nil];
    //[self.myParentController.view removeFromSuperview];
}

-(void)setLanguage:(NSString *)lang{
    if([lang isEqualToString:[Constants getLanguageCodeTW]]){
        
        [lblFinishGameMessage setText:[Utils getText:@"恭喜！您已完成所有題目，總分如下：" ForLang:[Constants getLanguageCodeTW] atView:@"MatchingGame"] ];
        [lblScore setText:[Utils getText:@"分數" ForLang:[Constants getLanguageCodeTW] atView:@"MatchingGame"] ];

    }
    
    if([lang isEqualToString:[Constants getLanguageCodeCN]]){
        
        [lblFinishGameMessage setText:[Utils getText:@"恭喜！您已完成所有題目，總分如下：" ForLang:[Constants getLanguageCodeCN] atView:@"MatchingGame"] ];
        [lblScore setText:[Utils getText:@"分數" ForLang:[Constants getLanguageCodeCN] atView:@"MatchingGame"] ];
        
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
    

    [Utils playSoundofFilePath:pathLocal withCallBackObject:self];
}
@end
