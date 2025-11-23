//
//  DefaultCardHandler.m
//  hongchiaac
//
//  Created by OEM on 8/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "DefaultCardHandler.h"
#import "AppDelegate.h"
#import "../Utils.h"

@implementation DefaultCardHandler

#define PLIST_DEFAULT_CARD @"default_cards.plist"

+(NSDictionary *)getCardWithID:(NSString *)cardID{
    
//    NSDictionary *plist = [Utils getContentFromPlist:PLIST_DEFAULT_CARD];
//    NSDictionary *returnDict = [[NSDictionary alloc] initWithDictionary:[appDelegate.plist objectForKey:cardID] copyItems:YES];
//    [plist release];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSDictionary *returnDict = [[NSDictionary alloc] initWithDictionary:[appDelegate.defaultCardsPlist objectForKey:cardID] copyItems:YES];
    return returnDict;
}

+(NSDictionary *)getCardWithID:(NSString *)cardID withPlist:(NSDictionary *)plist{
    
    //NSMutableDictionary *plist = [[[NSMutableDictionary alloc] initWithDictionary:[Utils getContentFromPlist:PLIST_DEFAULT_CARD]] autorelease] ;
    //NSMutableDictionary *plist = [[Utils getContentFromPlist:PLIST_DEFAULT_CARD] mutableCopy];
    //NSDictionary *plist = [Utils getContentFromPlist:PLIST_DEFAULT_CARD];
    NSDictionary *returnDict = [[NSDictionary alloc] initWithDictionary:[plist objectForKey:cardID] copyItems:YES];
    //[plist release];
    return returnDict;
    
    //return [plist objectForKey:cardID];
}

@end
