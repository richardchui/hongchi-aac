//
//  SequencingLevelViewController.m
//  hongchiaac
//
//  Created by Ray.Liu on 2/20/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import "SequencingLevelViewController.h"
#import "Constants.h"
#import "../../Handlers/SettingHandler.h"
#import "Utils.h"

@implementation SequencingLevelViewController

#pragma - MiniGameViewController

@synthesize viewInstructionTW, viewInstructionCN;

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]]){
        //actionSheetContentImportProfile = [Utils getText:@"要加入新的用戶資料嗎" ForLang:[Constants getLanguageCodeTW] atView:@"ViewController"];
        [lblGameName setText:[Utils getText:@"組句遊戲" ForLang:[Constants getLanguageCodeTW] atView:@"SequencingGame"]];
        
        [self.view addSubview:viewInstructionTW];
    }else{
        ///actionSheetContentImportProfile = [Utils getText:@"要加入新的用戶資料嗎" ForLang:[Constants getLanguageCodeCN] atView:@"ViewController"];
        [lblGameName setText:[Utils getText:@"組句遊戲" ForLang:[Constants getLanguageCodeCN] atView:@"SequencingGame"]];
        
        [self.view addSubview:viewInstructionCN];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playGameBGMusicA" object:self];
    [self setLanguage:[SettingHandler getApplicationLanguage]];
    
}

- (void)dealloc
{
    [btnLevel1 release];
    [btnLevel2 release];
    [btnLevel3 release];
    [btnLevel4 release];
    [btnLevel5 release];
    [btnExit release];
    [lblGameName release];
    [viewInstructionCN release];
    [viewInstructionTW release];
    [super dealloc];
}

- (void)refresh
{
    [super refresh];
}

#pragma - SequencingLevelViewController

- (IBAction)btnLevel_Click:(id)sender
{
    switch ([sender tag]) {
        case 1:
            currentLevelIndex = 2;
            break;
        case 2:
            currentLevelIndex = 3;
            break;
        case 3:
            currentLevelIndex = 4;
            break;
        case 4:
            currentLevelIndex = 5;
            break;
        case 5:
            currentLevelIndex = 6;
            break;
        default:
            currentLevelIndex = 0;
            break;
    }
    
    [self.myExtraData setValue:[NSString stringWithFormat:@"%i",currentLevelIndex] forKey:@"game_level"];
}

- (IBAction)btnExit_Click:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopGameBGMusicA" object:self];    
    [self.view removeFromSuperview];
}

-(IBAction)closeIntstruction:(id)sender{
    [viewInstructionTW removeFromSuperview];
    [viewInstructionCN removeFromSuperview];
}

-(void)setLanguage:(NSString *)lang{
    if([lang isEqualToString:[Constants getLanguageCodeTW]]){
        
        [lblLowLevel setText:[Utils getText:@"初級" ForLang:[Constants getLanguageCodeTW] atView:@"MatchingGame"] ];
        [lblHighLevel setText:[Utils getText:@"高級" ForLang:[Constants getLanguageCodeTW] atView:@"MatchingGame"] ];

        [btnLevel1 setTitle:[Utils getText:@"二張咭" ForLang:[Constants getLanguageCodeTW] atView:@"SequencingGame"] forState:UIControlStateNormal];
        [btnLevel2 setTitle:[Utils getText:@"三張咭" ForLang:[Constants getLanguageCodeTW] atView:@"SequencingGame"] forState:UIControlStateNormal];
        [btnLevel3 setTitle:[Utils getText:@"四張咭" ForLang:[Constants getLanguageCodeTW] atView:@"SequencingGame"] forState:UIControlStateNormal];
        [btnLevel4 setTitle:[Utils getText:@"五張咭" ForLang:[Constants getLanguageCodeTW] atView:@"SequencingGame"] forState:UIControlStateNormal];
        [btnLevel5 setTitle:[Utils getText:@"六張咭" ForLang:[Constants getLanguageCodeTW] atView:@"SequencingGame"] forState:UIControlStateNormal];

    }
    
    if([lang isEqualToString:[Constants getLanguageCodeCN]]){
        
        [lblLowLevel setText:[Utils getText:@"初級" ForLang:[Constants getLanguageCodeCN] atView:@"MatchingGame"] ];
        [lblHighLevel setText:[Utils getText:@"高級" ForLang:[Constants getLanguageCodeCN] atView:@"MatchingGame"] ];
        
        [btnLevel1 setTitle:[Utils getText:@"二張咭" ForLang:[Constants getLanguageCodeCN] atView:@"SequencingGame"] forState:UIControlStateNormal];
        [btnLevel2 setTitle:[Utils getText:@"三張咭" ForLang:[Constants getLanguageCodeCN] atView:@"SequencingGame"] forState:UIControlStateNormal];
        [btnLevel3 setTitle:[Utils getText:@"四張咭" ForLang:[Constants getLanguageCodeCN] atView:@"SequencingGame"] forState:UIControlStateNormal];
        [btnLevel4 setTitle:[Utils getText:@"五張咭" ForLang:[Constants getLanguageCodeCN] atView:@"SequencingGame"] forState:UIControlStateNormal];
        [btnLevel5 setTitle:[Utils getText:@"六張咭" ForLang:[Constants getLanguageCodeCN] atView:@"SequencingGame"] forState:UIControlStateNormal];

        
    }
}
@end
