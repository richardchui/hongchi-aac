//
//  MatchingLevelViewController.m
//  hongchiaac
//
//  Created by Ray.Liu on 1/29/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import "MatchingLevelViewController.h"
#import "../../Constants.h"
#import "../../Utils.h"
#import "../../Handlers/SettingHandler.h"

@implementation MatchingLevelViewController

@synthesize viewInstructionTW, viewInstructionCN;

#pragma - MiniGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]]){
        [self.view addSubview:viewInstructionTW];
    }else{
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
    [btnLevel6 release];
    [btnExit release];
    [lblHighLevel release];
    [lblLowLevel release];
    [viewInstructionCN release];
    [viewInstructionTW release];
    [super dealloc];
}

- (void)refresh
{
    [super refresh];
}

#pragma - MatchingLevelViewController

- (IBAction)btnLevel_Click:(id)sender
{
    switch ([sender tag]) {
        case 1:
            currentLevelIndex = 1;
            break;
        case 2:
            currentLevelIndex = 2;
            break;
        case 3:
            currentLevelIndex = 3;
            break;
        case 4:
            currentLevelIndex = 4;
            break;
        case 5:
            currentLevelIndex = 5;
            break;
        case 6:
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
-(void)setLanguage:(NSString *)lang{
    if([lang isEqualToString:[Constants getLanguageCodeTW]]){
        
        [lblLowLevel setText:[Utils getText:@"初級" ForLang:[Constants getLanguageCodeTW] atView:@"MatchingGame"] ];
        [lblHighLevel setText:[Utils getText:@"高級" ForLang:[Constants getLanguageCodeTW] atView:@"MatchingGame"] ];
        
        [btnLevel2 setTitle:[Utils getText:@"兩張咭" ForLang:[Constants getLanguageCodeTW] atView:@"MatchingGame"] forState:UIControlStateNormal];
        [btnLevel3 setTitle:[Utils getText:@"三張咭" ForLang:[Constants getLanguageCodeTW] atView:@"MatchingGame"] forState:UIControlStateNormal];
        [btnLevel4 setTitle:[Utils getText:@"八張咭" ForLang:[Constants getLanguageCodeTW] atView:@"MatchingGame"] forState:UIControlStateNormal];
        [btnLevel5 setTitle:[Utils getText:@"十二張咭" ForLang:[Constants getLanguageCodeTW] atView:@"MatchingGame"] forState:UIControlStateNormal];
        [btnLevel6 setTitle:[Utils getText:@"十八張咭" ForLang:[Constants getLanguageCodeTW] atView:@"MatchingGame"] forState:UIControlStateNormal];
    }
    
    if([lang isEqualToString:[Constants getLanguageCodeCN]]){
        
        [lblLowLevel setText:[Utils getText:@"初級" ForLang:[Constants getLanguageCodeCN] atView:@"MatchingGame"] ];
        [lblHighLevel setText:[Utils getText:@"高級" ForLang:[Constants getLanguageCodeCN] atView:@"MatchingGame"] ];
        
        [btnLevel2 setTitle:[Utils getText:@"兩張咭" ForLang:[Constants getLanguageCodeCN] atView:@"MatchingGame"] forState:UIControlStateNormal];
        [btnLevel3 setTitle:[Utils getText:@"三張咭" ForLang:[Constants getLanguageCodeCN] atView:@"MatchingGame"] forState:UIControlStateNormal];
        [btnLevel4 setTitle:[Utils getText:@"八張咭" ForLang:[Constants getLanguageCodeCN] atView:@"MatchingGame"] forState:UIControlStateNormal];
        [btnLevel5 setTitle:[Utils getText:@"十二張咭" ForLang:[Constants getLanguageCodeCN] atView:@"MatchingGame"] forState:UIControlStateNormal];
        [btnLevel6 setTitle:[Utils getText:@"十八張咭" ForLang:[Constants getLanguageCodeCN] atView:@"MatchingGame"] forState:UIControlStateNormal];

    }
}
-(IBAction)closeIntstruction:(id)sender{
    [viewInstructionTW removeFromSuperview];
    [viewInstructionCN removeFromSuperview];
}
@end
