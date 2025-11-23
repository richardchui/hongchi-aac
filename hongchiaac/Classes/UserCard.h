//
//  UserCard.h
//  hongchiaac
//
//  Created by OEM on 8/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "Card.h"

@interface UserCard : Card <NSCopying> {
    NSMutableDictionary *dictContent;
    NSString *_captionCustom;
    NSString *_voiceCustom;
    NSString *_imageCustom;
    int _borderColorID;
    NSArray *_cardset;
    BOOL _isCard;
    BOOL _isEmpty;
}

-(id)initWithContent:(NSMutableDictionary *)content;
-(id)initWithEmptyContent;
-(BOOL) isCard;
-(BOOL) isEmpty;
-(NSString *) getCaptionCustom;
-(NSString *) getVoiceCustom;
-(NSString *) getImageCustom;
-(NSArray *)getCardset;
-(int) getBorderColorID;

-(void)setBorderColorID:(int)colorId;
-(void)setCardID:(NSString *)cardID;
-(void)setIsCard:(BOOL)b;
-(void)setEmptyCardset;
-(void)setIsEmpty:(BOOL)b;
-(void)setCaptionCustom:(NSString *)c;
-(void)setImageCustom:(NSString *)c;
-(void)setVoiceCustom:(NSString *)c;
////////
-(UIImage *)getImageFile:(NSString *)profileID;
-(NSMutableDictionary *)getDictionaryContent;
////////
@property (retain, nonatomic) NSString *_captionCustom;
@property (retain, nonatomic) NSString *_voiceCustom;
@property (retain, nonatomic) NSString *_imageCustom;
@property int _borderColor;

@end
