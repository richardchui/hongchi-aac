//
//  Card.m
//  hongchiaac
//
//  Created by OEM on 8/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "Card.h"

@implementation Card

@synthesize _cardID;
@synthesize _captionCN,_captionTW;

-(id)init{
    if(self=[super init]){
    }
    return self;
}
-(id)initWithContent:(NSDictionary *)content withCardID:(NSString *)cardID{
    if(self=[super init]){
    }

    _cardID = [[NSString alloc] initWithString:cardID];
    _captionCN =[[NSString alloc] initWithString:[content objectForKey:@"caption_cn"]];
    _captionTW =[[NSString alloc] initWithString:[content objectForKey:@"caption_tw"]];
    
    
    return self;
}
-(void)dealloc{
    [_cardID release];
    [_captionCN release];
    [_captionTW release];
    
    [super dealloc];
}

-(NSString *)getCardID{
    return _cardID;
}
-(NSString *)getCaptionCN{
    return _captionCN;
};
-(NSString *)getCaptionTW{
    return _captionTW;
};

@end
