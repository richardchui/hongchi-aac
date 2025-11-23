//
//  ProfileHandler.h
//  hongchiaac
//
//  Created by OEM on 4/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Classes/UserProfile.h"

@interface ProfileHandler : NSObject

+(NSString *)getNewProfileID;

+(int)addProfileWithName:(NSString *)name;

+(int)addProfileWithName:(NSString *)_name userProfile:(UserProfile *)userProfile;

+(void)removeProfileWithID:(NSString *)profileID;

+(NSDictionary *)getProfileWithID:(NSString *)profileID;
+(NSDictionary *)getProfileWithID:(NSString *)profileID withPLIST:(NSDictionary *)plist;
+(BOOL)isProfileExist:(NSString *)profileID;

+(void)updateProfile:(UserProfile *)profile;
+(void)updateProfileWithoutReload:(UserProfile *)profile;

+(void)reorderProfileFromIndex:(int)fromIndex toIndex:(int)toIndex;

+(NSDictionary *)getAllProfiles;


@end
