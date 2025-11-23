//
//  AACCardViewController.h
//  hongchiaac
//
//  Created by OEM on 9/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Classes/UserCard.h"

@interface AACCard : UIViewController{
    UIView *viewCardBorder;
    UIImageView *imgFolderBG;
    UIImageView *imgCard;
    UILabel *lblCaption;
        
    //BOOL _isCard;
    NSString *_profileID;
    int _cardIndex;
    UserCard *_userCard;
    int _captionMode;
    
    NSDictionary *_plist;
}

-(id)initWithUserCard:(UserCard *)userCard cardIndex:(int)cardIndex profileID:(NSString *)profileID;
-(id)initWithUserCard:(UserCard *)userCard cardIndex:(int)cardIndex profileID:(NSString *)profileID withPlist:(NSDictionary *)plist;

@property (retain, nonatomic) IBOutlet UIView *viewCardBorder;
@property (retain, nonatomic) IBOutlet UIImageView *imgFolderBG;
@property (retain, nonatomic) IBOutlet UIImageView *imgCard;
@property (retain, nonatomic) IBOutlet UILabel *lblCaption;

-(UserCard *)getUserCard;
-(NSArray *)getCardset;
-(BOOL) isCard;
-(BOOL) isEmpty;
-(NSNumber *) getCardIndex;
-(UIImage *)getCardImage;
-(void)resizeImageToSize:(int)length;
-(void)resizeImageToSizeVirtually:(int)length;
-(NSString *)getCardID;
-(NSString *)getCaptionCN;
-(NSString *)getCaptionTW;
-(NSString *)getCaptionRawCN;
-(NSString *)getCaptionRawTW;
-(NSString *)getCaptionRawCustom;
-(NSString *)getVoiceCustom;
-(BOOL)haveDefaultCard;
////
-(NSMutableDictionary *)getUserCardContent;
////

-(void)setCardIndex:(int)i;
-(void)setBordColorID:(int)colorID;
-(void)setCardID:(NSString *)cardID;
-(void)setIsCard:(BOOL)b;
-(void)setEmptyCardset;
-(void)setIsEmpty:(BOOL)b;

-(void)cardActiveEffect:(BOOL)isActive;
@end
