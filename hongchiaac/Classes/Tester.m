//
//  Tester.m
//  hongchiaac
//
//  Created by OEM on 8/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "Tester.h"
#import "Utils.h"
#import "Card.h"
#import "UserCard.h"
#import "UserProfile.h"
#import "../Handlers/ProfileHandler.h"
#import "../Handlers/DefaultCardHandler.h"
#import "../Handlers/SettingHandler.h"
#import "../AACCard.h"
#import "../AACViewController.h"
#import "../AACViewController_iPad.h"
#import "../AACViewController_iPhone.h"
#import "../EditAACViewController_iPad.h"
#import "../RecorderViewController.h"
#import "../ProfileViewController_iPad.h"
#import "../StartingViewController_iPad.h"
#import "../StartingViewController_iPhone.h"
#import "../SummaryViewController_iPad.h"
#import "../SummaryViewController_iPhone.h"

#import "../MiniGames/Matching/MatchingGameViewController_iPad.h"

@implementation Tester

@synthesize view;

#define TEST_PROFILE_ID @"profile001"

-(id)initWithView:(UIView *)displayView{
  if(self=[super init]){
    //view = [[UIView alloc] init];
    view = displayView;
  }
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClickProfileInSummary:) name:@"onClickProfileInSummary" object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClickStartInStarting:) name:@"onClickStartInStarting" object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToSummaryFromAAC:) name:@"backToSummaryFromAAC" object:nil];
  
  return self;
}

-(void)dealloc{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onClickProfileInSummary" object:nil];
  
  [view release];
  [aac_iPad release];
  [aac_iPhone release];
  [editAAC_iPad release];
  
  [super dealloc];
}

-(void)run{
  // NSString *defaultProfileID = [[NSString alloc] initWithString:[SettingHandler getDefaultProfileID]];
  
  // NSLog(@"defaultProfileID is : %@",defaultProfileID);
  
  
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    aac_iPhone = [[AACViewController_iPhone alloc] initWithNibName:@"AACViewController_iPhone" bundle:nil];
    [view addSubview:aac_iPhone.view];
    
    UserProfile *userProfile = [[UserProfile alloc] initWithProfileID:TEST_PROFILE_ID];
    //UserProfile *userProfile = [[UserProfile alloc] initWithProfileID:defaultProfileID];
    [aac_iPhone loadProfile:userProfile];
    
    
  }else{
    aac_iPad = [[AACViewController_iPad alloc] initWithNibName:@"AACViewController_iPad" bundle:nil];
    [view addSubview:aac_iPad.view];
    
    //UserProfile *userProfile = [[UserProfile alloc] initWithProfileID:TEST_PROFILE_ID];
    //UserProfile *userProfile = [[UserProfile alloc] initWithProfileID:defaultProfileID];
    //[aac_iPad loadProfile:userProfile];
  }
  
  //[defaultProfileID release];
}
-(void)runAACWithProfileID:(NSString *)profileID{
  
  UserProfile *userProfile = [[UserProfile alloc] initWithProfileID:profileID];
  
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    
    if(aac_iPhone == nil){
      aac_iPhone = [[AACViewController_iPhone alloc] initWithNibName:@"AACViewController_iPhone" bundle:nil];
    }
    [view addSubview:aac_iPhone.view];
    
    [aac_iPhone loadProfile:userProfile];
    //[aac_iPhone reloadProfile];
    
    
  }else{
    if(aac_iPad==nil){
      aac_iPad = [[AACViewController_iPad alloc] initWithNibName:@"AACViewController_iPad" bundle:nil];
    }
    [view addSubview:aac_iPad.view];
    [aac_iPad loadProfile:userProfile];
    //[aac_iPad reloadProfile];
    
    //UserProfile *userProfile = [[UserProfile alloc] initWithProfileID:TEST_PROFILE_ID];
    //UserProfile *userProfile = [[UserProfile alloc] initWithProfileID:defaultProfileID];
    //[aac_iPad loadProfile:userProfile];
  }
  
  //[defaultProfileID release];
}
-(void)runStarter{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    startingViewController_iPhone = [[StartingViewController_iPhone alloc] initWithNibName:@"StartingViewController_iPhone" bundle:nil];
    [view addSubview:startingViewController_iPhone.view];
  }else{
    startingViewController_iPad = [[StartingViewController_iPad alloc] initWithNibName:@"StartingViewController_iPad" bundle:nil];
    [view addSubview:startingViewController_iPad.view];
  }
}

-(void)runEditAAC{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    
  }else{
    editAAC_iPad = [[EditAACViewController_iPad alloc] initWithNibName:@"EditAACViewController_iPad" bundle:nil];
    [view addSubview:editAAC_iPad.view];
    
    UserProfile *userProfile = [[UserProfile alloc] initWithProfileID:TEST_PROFILE_ID];
    [editAAC_iPad loadProfile:userProfile];
  }
}
-(void)runRecord{
  RecorderViewController *recorder = [[RecorderViewController alloc] init];
  [view addSubview:recorder.view];
}

-(void)runNewCard{
  NSDictionary *profile = [[NSDictionary alloc] initWithDictionary:[ProfileHandler getProfileWithID:TEST_PROFILE_ID]];
  NSDictionary *cardset = [profile objectForKey:@"cardset"];
  
  NSLog(@"%@", cardset);
  [Utils playSoundOfCard:@"s9" withMode:1 withCallBackObject:nil];
  [Utils playSoundofFilePath:[Utils getFullPath:[NSString stringWithFormat:@"profiles/%@/%@.caf",TEST_PROFILE_ID,@"abc"]] withCallBackObject:nil];
  
  
}

-(void)runMiniGame:(NSString *)gameKey
{
  NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
  [data setValue:TEST_PROFILE_ID forKey:@"profile_id"];
  
  if ([gameKey isEqualToString:@"MATCHING"])
  {
    MatchingGameViewController_iPad *gameViewController = [[MatchingGameViewController_iPad alloc] initWithNavigationController:nil ParentController:nil ExtraData:data];
    
    [view addSubview:gameViewController.view];
  }
}

-(void)runEditProfile{
  /*
   profileViewController_iPad = [[ProfileViewController_iPad alloc] init];
   
   [view addSubview:profileViewController_iPad.view];
   */
  
  UserProfile *userProfile = [[UserProfile alloc] initWithProfileID:TEST_PROFILE_ID];
  
  if(profileViewController_iPad==nil){
    profileViewController_iPad = [[ProfileViewController_iPad alloc] initWithUserProfile:userProfile];
  }
  [self.view addSubview:profileViewController_iPad.view];
}
-(void)runSummary;{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    if(summaryViewController_iPhone==nil){
      summaryViewController_iPhone = [[SummaryViewController_iPhone alloc] init];
    }
    [self.view addSubview:summaryViewController_iPhone.view];
    [summaryViewController_iPhone reload];
  }else{
    if(summarViewController_iPad==nil){
      summarViewController_iPad = [[SummaryViewController_iPad alloc] init];
    }
    [self.view addSubview:summarViewController_iPad.view];
    [summarViewController_iPad reload];
  }
}

///////
#pragma handler
-(void) onClickProfileInSummary:(NSNotification *)notification{
  NSString *clickedProfileID = notification.object;
  NSLog(@"clicked : %@",clickedProfileID  );
  [summarViewController_iPad.view removeFromSuperview];
  //[summarViewController_iPad release];
  
  [SettingHandler setSafeImport:FALSE];
  NSLog(@"Tester.m - Not safe to import");
  
  
  [self runAACWithProfileID:clickedProfileID];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLoading" object:self];
}
-(void)onClickStartInStarting:(NSNotification *)notification{
  [self runSummary];
}
-(void)backToSummaryFromAAC:(NSNotification *)notification{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
  
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    [aac_iPhone.view removeFromSuperview];
  }else{
    [aac_iPad.view removeFromSuperview];
  }
  [self performSelector:@selector(runSummary) withObject:nil afterDelay:0.5];
  //[self runSummary];
}
@end
