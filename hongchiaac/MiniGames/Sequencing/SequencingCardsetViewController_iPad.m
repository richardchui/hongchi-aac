//
//  SequencingSettingsViewController_iPad.m
//  hongchiaac
//
//  Created by Ray.Liu on 12/19/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "SequencingCardsetViewController_iPad.h"
#import "../../Handlers/SettingHandler.h"
#import "Constants.h"

@implementation SequencingCardsetViewController_iPad

#pragma - SequencingCardsetViewController

- (IBAction)btnClose_Click:(id)sender
{
    [super btnClose_Click:sender];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;//200.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"--> %d",[myData count]);
	return [myData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //myData = [self getSentenceList];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"SequencingCardsetCell_iPad" owner:nil options:nil];
    
    for (id currentObject in nibObjects)
    {
        if ([currentObject isKindOfClass:[SequencingCardsetCell_iPad class]])
        {
            cell = (SequencingCardsetCell_iPad *)currentObject;
            
            NSString *sqcs_id = [[myData objectAtIndex:indexPath.row] objectForKey:@"id"];
            NSString *sqcs_title = [[myData objectAtIndex:indexPath.row] objectForKey:@"name"];
            NSString *sqcs_desc = [[myData objectAtIndex:indexPath.row] objectForKey:@"description"];
            
            if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeCN]]){
                sqcs_title = [sqcs_title stringByReplacingOccurrencesOfString:@"遊戲"
                                                     withString:@"游戏"];
            }
            
            [(SequencingCardsetCell_iPad *)cell setCardsetID:sqcs_id];
            [(SequencingCardsetCell_iPad *)cell setTitle:sqcs_title];
            [(SequencingCardsetCell_iPad *)cell setDescription:sqcs_desc];
            
            [(SequencingCardsetCell_iPad *)cell setParentController:self];
                        
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sqcs_id = [[myData objectAtIndex:indexPath.row] objectForKey:@"id"];
    //NSLog(@"cardset_id: %@",sqcs_id);
    
    [self.myExtraData setValue:sqcs_id forKey:@"game_set_id"];
   // NSLog(@"!!!!!!!!!!!!!!!!  ---  %@",sqcs_id);
    sequencingGameViewController = [[SequencingGameViewController_iPad alloc] initWithNavigationController:self.myNavigationController ParentController:self.myParentController ExtraData:self.myExtraData];
    
    [self.view addSubview:sequencingGameViewController.view];
}


-(void)setLanguage:(NSString *)lang{
    if([lang isEqualToString:[Constants getLanguageCodeTW]]){
        [lblGameName setText:@"造句遊戲"];
    }
    
    if([lang isEqualToString:[Constants getLanguageCodeCN]]){
        [lblGameName setText:@"造句游戏"];
    }
}

@end
