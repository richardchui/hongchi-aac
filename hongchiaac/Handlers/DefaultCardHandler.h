//
//  DefaultCardHandler.h
//  hongchiaac
//
//  Created by OEM on 8/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultCardHandler : NSObject

+(NSDictionary *)getCardWithID:(NSString *)cardID;
+(NSDictionary *)getCardWithID:(NSString *)cardID withPlist:(NSDictionary *)plist;
@end
