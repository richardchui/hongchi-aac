//
//  ProfileHandler.m
//  hongchiaac
//
//  Created by OEM on 4/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "ProfileHandler.h"
#import "../Utils.h"
#import "../Classes/UserProfile.h"
#import "SettingHandler.h"
@implementation ProfileHandler

#define PLIST_PROFILE @"profiles.plist"


+(NSString *)getNewProfileID{
  NSDate* date = [NSDate date];
  NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
  [formatter setDateFormat:@"yyMMddHHmmssSSS"];
  NSString* tempProfileID = [formatter stringFromDate:date];
  
  //check if the profile exists
  int checkCount = 10;
  BOOL isUnique = NO;
  while(checkCount>0 && !isUnique){
    checkCount--;
    
    if(![self isProfileExist:tempProfileID]){
      isUnique = YES;
    }
  }
  
  if(isUnique) return tempProfileID;
  else return @"";
}

+(int)addProfileWithName:(NSString *)name{
  NSString *newProfileID = [self getNewProfileID];
  
  if([newProfileID isEqualToString:@""]){
    return 1;
  }else{
    NSMutableDictionary *oriContent = [[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_PROFILE]];
    
    NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
    [newProfile setValue:name forKey:@"name"];
    [newProfile setValue:[NSNumber numberWithInt:3] forKey:@"layout"];
    [newProfile setValue:[NSNumber numberWithBool:YES] forKey:@"caption_onoff"];
    [newProfile setValue:[NSNumber numberWithInt:1] forKey:@"caption_mode"];
    [newProfile setValue:[NSNumber numberWithInt:1] forKey:@"voice_mode"];
    
    [newProfile setValue:[NSNumber numberWithBool:YES] forKey:@"tapping_speak"];
    [newProfile setValue:[NSNumber numberWithBool:NO] forKey:@"single_card_mode"];
    
    [newProfile setValue:[NSNumber numberWithInt:[oriContent count]] forKey:@"order"];
    
    [newProfile setValue:[NSNumber numberWithBool:NO] forKey:@"lock_swiping"];
    
    [newProfile setValue:[NSNumber numberWithBool:NO] forKey:@"show_select_frame"];
    
    [newProfile setValue:@"" forKey:@"remark"];
    
    [newProfile setValue:[[NSArray alloc] init] forKey:@"cardset"];
    
    
    [oriContent setValue:newProfile forKey:newProfileID];
    
    [Utils writeContentToPlist:PLIST_PROFILE withContent:oriContent];
    
    [newProfile release];
    [oriContent release];
  }
  
  // Reload profileContents just in case
  [SettingHandler setNeedReload:TRUE];
  
  return 0;
}
+(int)addProfileWithName:(NSString *)_name userProfile:(UserProfile *)userProfile {
  NSString *newProfileID = [[NSString alloc] init];
  newProfileID = [self getNewProfileID];
  
  if([newProfileID isEqualToString:@""]){
    return 1;
  }else{
    NSMutableDictionary *oriContent = [[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_PROFILE]];
    
    NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
    [newProfile setValue:_name forKey:@"name"];
    [newProfile setValue:[NSNumber numberWithInt:[userProfile getLayout]] forKey:@"layout"];
    [newProfile setValue:[NSNumber numberWithBool:YES] forKey:@"caption_onoff"];
    [newProfile setValue:[NSNumber numberWithInt:[userProfile getCaptionMode]] forKey:@"caption_mode"];
    [newProfile setValue:[NSNumber numberWithInt:[userProfile getVoiceMode]] forKey:@"voice_mode"];
    [newProfile setValue:[NSNumber numberWithBool:YES] forKey:@"tapping_speak"];
    [newProfile setValue:[NSNumber numberWithBool:NO] forKey:@"single_card_mode"];
    [newProfile setValue:[NSNumber numberWithInt:[oriContent count]] forKey:@"order"];
    [newProfile setValue:[NSNumber numberWithBool:NO] forKey:@"lock_swiping"];
    
    [newProfile setValue:[NSNumber numberWithBool:[userProfile getShowSelectFrame]] forKey:@"show_select_frame"];
    
    [newProfile setValue:@"" forKey:@"remark"];
    [newProfile setValue:[userProfile getCardset] forKey:@"cardset"];
    
    
    [oriContent setValue:newProfile forKey:newProfileID];
    
    [Utils writeContentToPlist:PLIST_PROFILE withContent:oriContent];
  }
  
  //copy all custom file as well
  NSString *allProfilePath = @"/profiles/";
  if(![Utils isDirectoryExist:allProfilePath]){
    [Utils createDirectory:allProfilePath];
  }
  
  NSString *sourceDir = [Utils getFullPath:[NSString stringWithFormat:@"/profiles/%@",[userProfile getProfileID]]];
  NSString *destDir = [Utils getFullPath:[NSString stringWithFormat:@"/profiles/%@",newProfileID]];
  
  NSFileManager *filemgr;
  NSError *dError;
  filemgr = [NSFileManager defaultManager];
  BOOL success = [filemgr copyItemAtPath:sourceDir toPath:destDir error:&dError];
  if(success != YES) NSLog(@"Error: %@", dError);
  
  // Need to reload profileContents
  [SettingHandler setNeedReload:TRUE];
  
  return 0;
}

+(void)removeProfileWithID:(NSString *)profileID{
  NSMutableDictionary *oriContent = [[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_PROFILE]];
  
  NSLog(@"order is : %@", [[oriContent objectForKey:profileID] objectForKey:@"order"]);
  
  
  
  
  //update all profile's order
  
  for (NSString* key in oriContent) {
    if([[[oriContent objectForKey:key] objectForKey:@"order"] intValue] > [[[oriContent objectForKey:profileID] objectForKey:@"order"] intValue]){
      
      NSLog(@"reoder : %@, from %d to %d", [[oriContent objectForKey:profileID] objectForKey:@"name"],[[[oriContent objectForKey:key] objectForKey:@"order"] intValue], ([[[oriContent objectForKey:key] objectForKey:@"order"] intValue]-1));
      
      [[oriContent objectForKey:key] setObject:[NSNumber numberWithInt:([[[oriContent objectForKey:key] objectForKey:@"order"] intValue]-1)] forKey:@"order"];
    }
  }
  
  [oriContent removeObjectForKey:profileID];
  
  if([profileID isEqualToString:[SettingHandler getDefaultProfileID]]){
    [SettingHandler setDefaultProfileWithProfileID:@""];
  }
  
  [Utils writeContentToPlist:PLIST_PROFILE withContent:oriContent];
  
  NSString *dir = [NSString stringWithFormat:@"/profiles/%@",profileID];
  
  [Utils deleteDirectory:dir];
  
}

+(BOOL)isProfileExist:(NSString *)profileID{
  NSDictionary *content = [[NSDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_PROFILE]];
  
  if([content objectForKey:profileID] != nil){
    return YES;
  }else{
    return NO;
  }
}
+(NSDictionary *)getProfileWithID:(NSString *)profileID{
  //NSDictionary *content = [[[NSDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_PROFILE]] autorelease];
  if([profileID isEqualToString:@"130412173655120"]) NSLog(@"read B.1 : %@",profileID);
  NSDictionary *content = [Utils getContentFromPlist:PLIST_PROFILE];
  if([profileID isEqualToString:@"130412173655120"]) NSLog(@"read B.2 : %@",profileID);
  NSDictionary *returnDict = [[NSDictionary alloc] initWithDictionary:[content objectForKey:profileID] copyItems:YES];
  if([profileID isEqualToString:@"130412173655120"]) NSLog(@"read B.3 : %@",profileID);
  [content release];
  return returnDict;
  
  //return [content objectForKey:profileID];
}
+(NSDictionary *)getProfileWithID:(NSString *)profileID withPLIST:(NSDictionary *)plist{
  
  if([profileID isEqualToString:@"130412173655120"]) NSLog(@"read B.1 : %@",profileID);
  
  if([profileID isEqualToString:@"130412173655120"]) NSLog(@"read B.2 : %@",profileID);
  
  NSDictionary *returnDict = [[NSDictionary alloc] initWithDictionary:[plist objectForKey:profileID] copyItems:YES];
  
  if([profileID isEqualToString:@"130412173655120"]) NSLog(@"read B.3 : %@",profileID);
  //[content release];
  return returnDict;
  
  //return [content objectForKey:profileID];
}
+(void)updateProfile:(UserProfile *)profile{
  
  NSMutableDictionary *oriContent = [[NSMutableDictionary alloc] initWithDictionary:[self getProfileWithID:[profile getProfileID]]];
  
  [oriContent setObject:[NSNumber numberWithInt:[profile getLayout]] forKey:@"layout"];
  [oriContent setObject:[profile getName] forKey:@"name" ];
  [oriContent setObject:[NSNumber numberWithBool:[profile getCaptionOnOff]] forKey:@"caption_onoff"];
  [oriContent setObject:[NSNumber numberWithInt:[profile getCaptionMode]] forKey:@"caption_mode"];
  [oriContent setObject:[NSNumber numberWithInt:[profile getVoiceMode]] forKey:@"voice_mode"];
  [oriContent setObject:[NSNumber numberWithBool:[profile getTappingSpeak]] forKey:@"tapping_speak"];
  [oriContent setObject:[NSNumber numberWithBool:[profile getSingleCardMode]] forKey:@"single_card_mode"];
  [oriContent setObject:[NSNumber numberWithInt:[profile getOrder]] forKey:@"order"];
  [oriContent setObject:[NSNumber numberWithBool:[profile getLockSwiping]] forKey:@"lock_swiping"];
  [oriContent setObject:[NSNumber numberWithBool:[profile getShowSelectFrame]] forKey:@"show_select_frame"];
  [oriContent setObject:[profile getRemark] forKey:@"remark"];
  [oriContent setObject:[profile getCardset] forKey:@"cardset"];
  
  NSMutableDictionary *oriProfilePList = [[[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_PROFILE] ] retain];
  
  [oriProfilePList setObject:oriContent forKey:[profile getProfileID]];
  [Utils writeContentToPlist:PLIST_PROFILE withContent:oriProfilePList];
  [oriContent release];
  [oriProfilePList release];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadForUpdatedProfile" object:profile.getProfileID];
}
+(void)updateProfileWithoutReload:(UserProfile *)profile{
  NSLog(@"Start saving profile");
  NSMutableDictionary *oriContent = [[NSMutableDictionary alloc] initWithDictionary:[self getProfileWithID:[profile getProfileID]]];
  
  [oriContent setObject:[NSNumber numberWithInt:[profile getLayout]] forKey:@"layout"];
  [oriContent setObject:[profile getName] forKey:@"name" ];
  [oriContent setObject:[NSNumber numberWithBool:[profile getCaptionOnOff]] forKey:@"caption_onoff"];
  [oriContent setObject:[NSNumber numberWithInt:[profile getCaptionMode]] forKey:@"caption_mode"];
  [oriContent setObject:[NSNumber numberWithInt:[profile getVoiceMode]] forKey:@"voice_mode"];
  [oriContent setObject:[NSNumber numberWithBool:[profile getTappingSpeak]] forKey:@"tapping_speak"];
  [oriContent setObject:[NSNumber numberWithBool:[profile getSingleCardMode]] forKey:@"single_card_mode"];
  [oriContent setObject:[NSNumber numberWithInt:[profile getOrder]] forKey:@"order"];
  [oriContent setObject:[NSNumber numberWithBool:[profile getLockSwiping]] forKey:@"lock_swiping"];
  [oriContent setObject:[NSNumber numberWithBool:[profile getShowSelectFrame]] forKey:@"show_select_frame"];
  [oriContent setObject:[profile getRemark] forKey:@"remark"];
  
  //NSLog(@"remark will be :%@",[profile getRemark]);
  
  [oriContent setObject:[profile getCardset] forKey:@"cardset"];
  
  
  NSMutableDictionary *oriProfilePList = [[[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_PROFILE] ] retain];
  
  [oriProfilePList setObject:oriContent forKey:[profile getProfileID]];
  [Utils writeContentToPlist:PLIST_PROFILE withContent:oriProfilePList];
  [oriContent release];
  [oriProfilePList release];
  NSLog(@"End saving profile");
}
+(void)reorderProfileFromIndex:(int)fromIndex toIndex:(int)toIndex{
  NSMutableDictionary *oriProfilePList = [[[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_PROFILE] ] retain];
  
  NSLog(@"before reorder--------");
  //NSLog(@"%@",oriProfilePList);
  
  for(NSString *tkey in oriProfilePList){
    NSMutableDictionary *profile = [oriProfilePList objectForKey:tkey];
    NSLog(@"profile :%@, order:%@",[profile objectForKey:@"name"], [profile objectForKey:@"order"]);
  }
  
  if(fromIndex < toIndex){
    //move down
    for(NSString *key in oriProfilePList){
      NSMutableDictionary *profile = [oriProfilePList objectForKey:key];
      int order = [[profile objectForKey:@"order"] intValue];
      if(order<fromIndex){
        //remain unchanged
      }else if(order==fromIndex){
        //change to 'toIndex'
        [profile setValue:[NSNumber numberWithInt:toIndex] forKey:@"order"];
      }else if(order>fromIndex && order <=toIndex){
        //all index = index-1
        [profile setValue:[NSNumber numberWithInt:[[profile objectForKey:@"order"] intValue]-1] forKey:@"order"];
      }else{
        //remain unchanged
      }
    }
  }else{
    //move up
    for(NSString *key in oriProfilePList){
      NSMutableDictionary *profile = [oriProfilePList objectForKey:key];
      int order = [[profile objectForKey:@"order"] intValue];
      if(order<toIndex){
        //remain unchanged
      }else if(order>=toIndex && order <fromIndex){
        //all index = index+1
        [profile setValue:[NSNumber numberWithInt:[[profile objectForKey:@"order"] intValue]+1] forKey:@"order"];
      }else if(order==fromIndex){
        //change to 'toIndex';
        [profile setValue:[NSNumber numberWithInt:toIndex] forKey:@"order"];
      }else{
        //remain unchanged
      }
    }
  }
  
  NSLog(@"after reorder-------");
  // NSLog(@"%@",oriProfilePList);
  
  for(NSString *tkey in oriProfilePList){
    NSMutableDictionary *profile = [oriProfilePList objectForKey:tkey];
    NSLog(@"profile :%@, order:%@",[profile objectForKey:@"name"], [profile objectForKey:@"order"]);
  }
  
  [Utils writeContentToPlist:PLIST_PROFILE withContent:oriProfilePList];
  [oriProfilePList release];
  
}
+(NSDictionary *)getAllProfiles{
  return [Utils getContentFromPlist:PLIST_PROFILE];
}

@end
