//
//  SequencingScoreViewController.m
//  hongchiaac
//
//  Created by Ray.Liu on 2/21/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import "SequencingScoreViewController.h"
#import "SequencingGameViewController.h"
#import "Utils.h"
#import "Constants.h"
#import "../../Handlers/SettingHandler.h"

@implementation SequencingScoreViewController

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
    
    if(correctAnswerCount==10){
        [self playSoundFile:@"g1_ending_1.mp3"];
    }else if(correctAnswerCount >=5){
        [self playSoundFile:@"g1_ending_2.mp3"];
    }else{
        [self playSoundFile:@"g1_ending_3.mp3"];
    }
    
    [self setLanguage:[SettingHandler getApplicationLanguage]];    
}

- (void)dealloc
{
    [btnClose release];
    [lblTotalAnswerCount release];
    [lblCorrectAnswerCount release];
    [lblWrongAnswerCount release];
    [lblMissingAnswerCount release];
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
    
    [((SequencingGameViewController *)self.myParentController) btnExit_Click:nil];
    //[self.myParentController.view removeFromSuperview];
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


-(void)setLanguage:(NSString *)lang{
    if([lang isEqualToString:[Constants getLanguageCodeTW]]){
        [lblTotal setText:[Utils getText:@"總數：" ForLang:[Constants getLanguageCodeTW] atView:@"SequencingGame"] ];
        [lblTotalCorrect setText:[Utils getText:@"正確：" ForLang:[Constants getLanguageCodeTW] atView:@"SequencingGame"] ];
        [lblTotalWrong setText:[Utils getText:@"錯誤：" ForLang:[Constants getLanguageCodeTW] atView:@"SequencingGame"] ];
    }
    
    if([lang isEqualToString:[Constants getLanguageCodeCN]]){
        [lblTotal setText:[Utils getText:@"總數：" ForLang:[Constants getLanguageCodeCN] atView:@"SequencingGame"] ];
        [lblTotalCorrect setText:[Utils getText:@"正確：" ForLang:[Constants getLanguageCodeCN] atView:@"SequencingGame"] ];
        [lblTotalWrong setText:[Utils getText:@"錯誤：" ForLang:[Constants getLanguageCodeCN] atView:@"SequencingGame"] ];
    }
}

@end
