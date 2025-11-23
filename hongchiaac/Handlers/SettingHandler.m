//
//  SettingHandler.m
//  hongchiaac
//
//  Created by OEM on 21/1/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import "SettingHandler.h"
#import "../Utils.h"

@implementation SettingHandler

#define PLIST_SETTINGS @"settings.plist"

+(NSString *)getDefaultProfileID{
    NSMutableDictionary *oriContent = [[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_SETTINGS]];
    NSString *returnString = [[NSString alloc] initWithString:[oriContent objectForKey:@"default_profile_id"]];
    [oriContent release];
    return returnString;
    //return [oriContent objectForKey:@"default_profile_id"];
}
+(void)setDefaultProfileWithProfileID:(NSString *)profileID{
    NSMutableDictionary *oriContent = [[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_SETTINGS]];
    [oriContent setObject:profileID forKey:@"default_profile_id"];
    [Utils writeContentToPlist:PLIST_SETTINGS withContent:oriContent];
    [oriContent release];
}
+(NSString *)getApplicationLanguage{
    NSMutableDictionary *oriContent = [[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_SETTINGS]];
    NSString *returnString = [[NSString alloc] initWithString:[oriContent objectForKey:@"language"]];
    [oriContent release];
    return returnString;
    //return [oriContent objectForKey:@"language"];
}
+(void)setApplicationLanguage:(NSString *)langCode{
    NSMutableDictionary *oriContent = [[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_SETTINGS]];
    [oriContent setObject:langCode forKey:@"language"];
    [Utils writeContentToPlist:PLIST_SETTINGS withContent:oriContent];
    [oriContent release];
}
+(BOOL)getSettingLock{
    NSMutableDictionary *oriContent = [[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_SETTINGS]];
    BOOL isLock = [[oriContent objectForKey:@"setting_lock"] boolValue];
    [oriContent release];
    return isLock;
}
+(void)setSettingLock:(BOOL) isLock{
    NSMutableDictionary *oriContent = [[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_SETTINGS]];
    [oriContent setObject:[NSNumber numberWithBool:isLock] forKey:@"setting_lock"];
    [Utils writeContentToPlist:PLIST_SETTINGS withContent:oriContent];
    [oriContent release];
}
+(BOOL)getSafeImport{
  NSMutableDictionary *oriContent = [[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_SETTINGS]];
  BOOL isSafe = [[oriContent objectForKey:@"safe_import"] boolValue];
  [oriContent release];
  return isSafe;
}
+(void)setSafeImport:(BOOL) isSafe{
  NSMutableDictionary *oriContent = [[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_SETTINGS]];
  [oriContent setObject:[NSNumber numberWithBool:isSafe] forKey:@"safe_import"];
  [Utils writeContentToPlist:PLIST_SETTINGS withContent:oriContent];
  [oriContent release];
  
  NSLog(@"Setting safety : %d", isSafe);
}
+(BOOL)getNeedReload{
  NSMutableDictionary *oriContent = [[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_SETTINGS]];
  BOOL isNeeded = [[oriContent objectForKey:@"need_reload"] boolValue];
  [oriContent release];
  return isNeeded;
}
+(void)setNeedReload:(BOOL) isNeeded{
  NSMutableDictionary *oriContent = [[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_SETTINGS]];
  [oriContent setObject:[NSNumber numberWithBool:isNeeded] forKey:@"need_reload"];
  [Utils writeContentToPlist:PLIST_SETTINGS withContent:oriContent];
  [oriContent release];
}

@end
