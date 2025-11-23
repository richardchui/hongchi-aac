//
//  Card.h
//  hongchiaac
//
//  Created by OEM on 8/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject{
    NSString *_cardID;
    NSString *_captionCN;
    NSString *_captionTW;

}

@property (retain, nonatomic) NSString *_cardID;
@property (retain, nonatomic) NSString *_captionCN;
@property (retain, nonatomic) NSString *_captionTW;

-(id)initWithContent:(NSDictionary *)content withCardID:(NSString *)cardID;
-(NSString *)getCardID;
-(NSString *)getCaptionCN;
-(NSString *)getCaptionTW;

@end
