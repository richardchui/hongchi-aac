//
//  SequencingSettingsViewController.m
//  hongchiaac
//
//  Created by Ray.Liu on 12/19/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "SequencingCardsetViewController.h"
#import "../../Handlers/ProfileHandler.h"
#import "../../AACCard.h"
#import "../../Utils.h"
#import "SequencingGameViewController.h"
#import "Constants.h"
#import "../../Handlers/SettingHandler.h"

@implementation SequencingCardsetViewController

#pragma - MiniGameViewController



- (void)viewDidLoad
{
    
    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]]){
        //actionSheetContentImportProfile = [Utils getText:@"要加入新的用戶資料嗎" ForLang:[Constants getLanguageCodeTW] atView:@"ViewController"];
        [lblGameName setText:[Utils getText:@"組句遊戲" ForLang:[Constants getLanguageCodeTW] atView:@"SequencingGame"]];
        
    }else{
        ///actionSheetContentImportProfile = [Utils getText:@"要加入新的用戶資料嗎" ForLang:[Constants getLanguageCodeCN] atView:@"ViewController"];
        [lblGameName setText:[Utils getText:@"組句遊戲" ForLang:[Constants getLanguageCodeCN] atView:@"SequencingGame"]];
        
    }
    
    
//    myData = [self getSentenceList];
    [self loadList];
    [super viewDidLoad];
    
}

- (void)refresh
{
    [super refresh];
}

- (void)dealloc
{
    [super dealloc];
    [self loadList];
    [lblGameName release];

}

#pragma - SequencingCardsetViewController

- (IBAction)btnClose_Click:(id)sender
{
    [self exit];
}

- (void)exit
{
    [self.view removeFromSuperview];
}

- (NSMutableArray *)getCardSetList
{
    NSMutableArray *cardsetList = [[NSMutableArray alloc] init];
    
    NSMutableArray *fullList = (NSMutableArray *)[[Utils getContentFromPlist:@"sequencing_cardsets.plist"] objectForKey:@"cardsets"];
    
    for (int i = 0; i < [fullList count]; i++)
    {
        NSString *level = [[fullList objectAtIndex:i] objectForKey:@"level"];
        if ([level isEqualToString:[self.myExtraData objectForKey:@"game_level"]])
        {
            [cardsetList addObject:[fullList objectAtIndex:i]];
        }
    }
    
    return cardsetList;
}

- (void)loadList
{
    myData = [[NSMutableArray alloc] initWithArray:[self getCardSetList]];
    [myTableView reloadData];
}


@end
