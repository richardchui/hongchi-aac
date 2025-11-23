//
//  UserProfile.h
//  hongchiaac
//
//  Created by OEM on 8/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject{
    NSString *_profileID;
    NSString *_name;
    int _layout;
    BOOL _captionOnOff;
    int _captionMode;
    int _voiceMode;
    BOOL _tappingSpeak;
    BOOL _singleCardMode;
    int _order;
    BOOL _lockSwiping;
    BOOL _showSelectFrame;
    NSString *_remark;
    
    
    NSMutableArray *_cardset;
}

-(id)initWithProfileID:(NSString *)profileID;
-(id)initWithProfileID:(NSString *)profileID withPlist:(NSDictionary *)plist;

@property (retain,nonatomic) NSString *_profileID;
@property (retain,nonatomic) NSString *_name;
@property int _layout;
@property BOOL _captionOnOff;
@property int _captionMode;
@property int _voiceMode;
@property BOOL _tappingSpeak;
@property BOOL _singleCardMode;
@property int _order;
@property BOOL _lockSwiping;
@property BOOL _showSelectFrame;
@property (retain,nonatomic) NSMutableArray *_cardset;

-(NSString *)getProfileID;
-(NSString *)getName;
-(int)getLayout;
-(BOOL)getCaptionOnOff;
-(int)getCaptionMode;
-(int)getVoiceMode;
-(BOOL)getTappingSpeak;
-(BOOL)getSingleCardMode;
-(int)getOrder;
-(BOOL)getLockSwiping;
-(BOOL)getShowSelectFrame;
-(NSString *)getRemark;

-(NSMutableArray *)getCardset;

-(void) setCardset:(NSMutableArray *)cardset;

-(void)updateProfileName:(NSString *)profileName;
-(void)updateLayout:(int)newLayoutID;
-(void)updateVoiceMode:(int)newVoiceMode;
-(void)updateCaptionOnOff:(BOOL)isOn;
-(void)updateCaptionMode:(int)newCaptionMode;
-(void)updateTappingSpeak:(BOOL)isOn;
-(void)updateSingleCardMode:(BOOL)isOn;
-(void)updateOrder:(int)newOrder;
-(void)updateLockSwiping:(BOOL)isOn;
-(void)updateShowSelectFrame:(BOOL)isOn;
-(void)updateRemark:(NSString *)remark;

-(void)saveCustomImage:(UIImage *)image fileName:(NSString *)fileName;
-(void)deleteCustomImageFile:(NSString *)fileName;

-(void)saveCustomVoice:(NSString *)fileName;
-(void)deleteCustomVoice:(NSString *)fileName;

-(NSComparisonResult)compare:(UserProfile *)otherObject;
@end
