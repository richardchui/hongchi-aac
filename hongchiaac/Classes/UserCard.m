//
//  UserCard.m
//  hongchiaac
//
//  Created by OEM on 8/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "UserCard.h"
#import "../Utils.h"
#import "../Handlers/DefaultCardHandler.h"
#import "../Handlers/SettingHandler.h"

@implementation UserCard
@synthesize _captionCustom,_imageCustom,_voiceCustom, _borderColor;

#define CAPTION_MODE_CN 0
#define CAPTION_MODE_TW 1
#define CAPTION_MODE_CUSTOM 2

-(id)initWithContent:(NSMutableDictionary *)content{
    //dictContent = [[NSMutableDictionary alloc] initWithDictionary:content];
    //[dictContent retain];
    dictContent= content;
    if([dictContent objectForKey:@"card_id"]==NULL || [[dictContent objectForKey:@"card_id"]isEqual:@""] || [[dictContent objectForKey:@"card_id"] length] == 0)
    {
        if(self=[super init]){
        }
    }else{
        //NSLog(@"%@, %@",[content objectForKey:@"card_id"], [content objectForKey:@"card_id"]);
        if(self=[super initWithContent:[DefaultCardHandler getCardWithID:[dictContent objectForKey:@"card_id"]] withCardID:[dictContent objectForKey:@"card_id"]]){
        }
    }
    
    _isCard = [[dictContent objectForKey:@"is_card"] boolValue];
    _voiceCustom = [dictContent objectForKey:@"voice_custom"];
    _imageCustom = [dictContent objectForKey:@"image_custom"];
    _captionCustom = [dictContent objectForKey:@"caption_custom"];
    _borderColor = [[dictContent objectForKey:@"border_color_id"] intValue];
    
    if(!_isCard){
        _cardset = [dictContent objectForKey:@"cardset"];
    }else{
        _cardset = NULL;
    }
    
    if([_cardID isEqualToString:@"empty_card"] &&
       [[self getCaptionCustom] isEqualToString:@""] &&
       [[self getVoiceCustom] isEqualToString:@""] &&
       [[self getImageCustom] isEqualToString:@""]
       )
        _isEmpty = YES;
    else
        _isEmpty = NO;
    
    return self;
}
-(id)initWithEmptyContent{
    dictContent = [[NSMutableDictionary alloc] init];
    
    if(self=[super initWithContent:[DefaultCardHandler getCardWithID:@"empty_card"] withCardID:@"empty_card"]){
    }
    
    _isCard = NO;
    _voiceCustom = @"";
    _imageCustom = @"";
    _captionCustom = @"";
    _borderColor = 0;
    _cardset = NULL;
    _isEmpty = YES;

    [dictContent setObject:@"empty_card" forKey:@"card_id"];
    [dictContent setObject:@"" forKey:@"caption_cn"];
    [dictContent setObject:@"" forKey:@"caption_tw"];
    
    //[dictContent setObject:@"NO" forKey:@"is_card"];
    [dictContent setObject:[NSNumber numberWithBool:NO] forKey:@"is_card"];
    [dictContent setObject:@"" forKey:@"voice_custom"];
    [dictContent setObject:@"" forKey:@"image_custom"];
    [dictContent setObject:@"" forKey:@"caption_custom"];
    [dictContent setObject:[NSNumber numberWithInt:0] forKey:@"border_color_id"];
      
    return self;
}
-(void)dealloc{
    //dictContent = nil;
    
    [dictContent release];
    //[_captionCustom release];
    //[_voiceCustom release];
    //[_imageCustom release];
    //[_cardset release];
    
    [super dealloc];    
}
//getter//////////////
-(BOOL) isCard{
    return _isCard;
}
-(BOOL) isEmpty{

    return _isEmpty;
}
-(NSString *) getCaptionCustom{
    return _captionCustom;
}
-(NSString *) getVoiceCustom{
    return _voiceCustom;
}
-(NSString *) getImageCustom{
    return _imageCustom;
}
-(NSArray *)getCardset{
    return _cardset;
}
-(int) getBorderColorID{
    return _borderColor;
}
-(void)setBorderColorID:(int)colorId{
    _borderColorID = colorId;
    [dictContent setValue:[NSNumber numberWithInt:colorId] forKey:@"border_color_id"];
}
-(void)setCardID:(NSString *)cardID{
    _cardID = cardID;
    [dictContent setObject:_cardID forKey:@"card_id"];
    
    if([_cardID length]==0){
        
        NSDictionary *tempDC = [[NSDictionary alloc] initWithDictionary:[DefaultCardHandler getCardWithID:@"empty_card"]];
        
        _captionCN = [tempDC objectForKey:@"caption_cn"];
        _captionTW = [tempDC objectForKey:@"caption_tw"];
        
        [dictContent setObject:_captionCN forKey:@"caption_cn"];
        [dictContent setObject:_captionTW forKey:@"caption_tw"];
        
        [tempDC release];
    }else{
        NSDictionary *tempDC = [[NSDictionary alloc] initWithDictionary:[DefaultCardHandler getCardWithID:_cardID]];
        
        _captionCN = [tempDC objectForKey:@"caption_cn"];
        _captionTW = [tempDC objectForKey:@"caption_tw"];
        
        [dictContent setObject:_captionCN forKey:@"caption_cn"];
        [dictContent setObject:_captionTW forKey:@"caption_tw"];
        
        [tempDC release];
    }
    
    if([_cardID isEqualToString:@"empty_card"] &&
       [[self getCaptionCustom] isEqualToString:@""] &&
       [[self getVoiceCustom] isEqualToString:@""] &&
       [[self getImageCustom] isEqualToString:@""]
       )
        _isEmpty = YES;
    else
        _isEmpty = NO;
}
-(void)setIsCard:(BOOL)b{
    _isCard = b;
    if(b)
        //[dictContent setObject:@"YES" forKey:@"is_card"];
        [dictContent setObject:[NSNumber numberWithBool:YES] forKey:@"is_card"];
    else
//        [dictContent setObject:@"NO" forKey:@"is_card"];
        [dictContent setObject:[NSNumber numberWithBool:NO] forKey:@"is_card"];        
}
-(void)setEmptyCardset{
    _cardset = [[NSArray alloc] init];
   [dictContent setObject:_cardset forKey:@"cardset"];
   [dictContent setObject:@"" forKey:@"card_id"];
}
-(void)setIsEmpty:(BOOL)b{
    _isEmpty = b;
}
-(void)setCaptionCustom:(NSString *)c{
    _captionCustom = c;
    [dictContent setObject:c forKey:@"caption_custom"];
}
-(void)setImageCustom:(NSString *)c{
    _imageCustom = c;
    [dictContent setObject:c forKey:@"image_custom"];
}
-(void)setVoiceCustom:(NSString *)c{
    _voiceCustom = c;
    [dictContent setObject:c forKey:@"voice_custom"];
}
//////////////////////
-(UIImage *)getImageFile:(NSString *)profileID{
    //should show custom first, then defatul, then blank card
    if([_imageCustom length] != 0){
        NSString *imageFullPath = [Utils getFullPath:[NSString stringWithFormat:@"profiles/%@/%@.jpg",profileID,_imageCustom]];        
        return [UIImage imageWithContentsOfFile:imageFullPath];
    }
    
    if([[self _cardID] length] == 0){
        if([_imageCustom length] == 0){
            return [UIImage imageNamed:@"blank_card.jpg"];
        }else{
            return [UIImage imageNamed:_imageCustom];
        }

    }
    //[Utils log:[NSString stringWithFormat:@"%@.jpg",_cardID]];
    if(_isEmpty){
        return [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",_cardID]];
    }
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",_cardID]];
}

-(NSString *)getCaptionWithCaptionMode:(int)m{
    if(m==CAPTION_MODE_CN){
        return [self getCaptionCN];
    }
    else if(m==CAPTION_MODE_TW){
        return [self getCaptionTW];
    }
    else{
        return [self getCaptionCustom];
    }
}
-(NSMutableDictionary *)getDictionaryContent{   
    return dictContent;
}
-(id)copyWithZone:(NSZone *)zone{
    //this function is not yet completed
    id copy = [[[self class] alloc] init];
    
    if(copy){

    }
    return copy;
}
@end
    