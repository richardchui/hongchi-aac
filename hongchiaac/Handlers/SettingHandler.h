//
//  SettingHandler.h
//  hongchiaac
//
//  Created by OEM on 21/1/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingHandler : NSObject

+(NSString *)getDefaultProfileID;
+(void)setDefaultProfileWithProfileID:(NSString *)profileID;
+(NSString *)getApplicationLanguage;
+(void)setApplicationLanguage:(NSString *)langCode;
+(BOOL)getSettingLock;
+(void)setSettingLock:(BOOL) isLock;
+(BOOL)getSafeImport;
+(void)setSafeImport:(BOOL) isSafe;
+(BOOL)getNeedReload;
+(void)setNeedReload:(BOOL) isNeeded;
@end
