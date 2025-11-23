//
//  UserProfile.m
//  hongchiaac
//
//  Created by OEM on 8/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "UserProfile.h"
#import "../Utils.h"
#import "../Constants.h"
#import "../Handlers/ProfileHandler.h"
#import "../Handlers/SettingHandler.h"

@implementation UserProfile
@synthesize _profileID,_name,_layout,_captionMode,_voiceMode,_cardset,_tappingSpeak,_singleCardMode,_order,_lockSwiping,_captionOnOff,_showSelectFrame;

-(id)initWithProfileID:(NSString *)profileID{
    if(self=[super init]){
    }
    
    _profileID = [[NSString alloc] initWithString:profileID];

    //NSDictionary *profileContent = [[NSDictionary alloc] initWithDictionary:[ProfileHandler getProfileWithID:_profileID]];
    NSDictionary *profileContent = [ProfileHandler getProfileWithID:_profileID];
    
    
    _name = [[NSString alloc] initWithString:[profileContent objectForKey:@"name"]];
    _layout = (int)[[profileContent objectForKey:@"layout"] intValue];
    _captionOnOff = (BOOL)[[profileContent objectForKey:@"caption_onoff"] boolValue];
    _captionMode = (int)[[profileContent objectForKey:@"caption_mode"] intValue];
    _voiceMode = (int)[[profileContent objectForKey:@"voice_mode"] intValue];
    _cardset = [[NSMutableArray alloc] initWithArray:[profileContent objectForKey:@"cardset"] copyItems:YES];
    _tappingSpeak = (BOOL)[[profileContent objectForKey:@"tapping_speak"] boolValue];
    _singleCardMode = (BOOL)[[profileContent objectForKey:@"single_card_mode"] boolValue];
    _order = (int)[[profileContent objectForKey:@"order"] intValue];
    _lockSwiping = (BOOL)[[profileContent objectForKey:@"lock_swiping"] boolValue];
    
    if([profileContent objectForKey:@"show_select_frame"] != nil){
        _showSelectFrame = (BOOL)[[profileContent objectForKey:@"show_select_frame"] boolValue];
    }else{
        _showSelectFrame = YES;
    }
    
    _remark = [[NSString alloc] initWithString:[profileContent objectForKey:@"remark"]];
    
    [profileContent release];
    
    return self;
}


-(id)initWithProfileID:(NSString *)profileID withPlist:(NSDictionary *)plist{
    if(self=[super init]){
    }
    
    
    _profileID = [[NSString alloc] initWithString:profileID];
    
    
    
    //NSDictionary *profileContent = [[NSDictionary alloc] initWithDictionary:[ProfileHandler getProfileWithID:_profileID]];
    
    
    NSDictionary *profileContent = [ProfileHandler getProfileWithID:_profileID withPLIST:plist];
    
    
    _name = [[NSString alloc] initWithString:[profileContent objectForKey:@"name"]];
    _layout = (int)[[profileContent objectForKey:@"layout"] intValue];
    _captionOnOff = (BOOL)[[profileContent objectForKey:@"caption_onoff"] boolValue];
    _captionMode = (int)[[profileContent objectForKey:@"caption_mode"] intValue];
    _voiceMode = (int)[[profileContent objectForKey:@"voice_mode"] intValue];
    _cardset = [[NSMutableArray alloc] initWithArray:[profileContent objectForKey:@"cardset"] copyItems:YES];
    _tappingSpeak = (BOOL)[[profileContent objectForKey:@"tapping_speak"] boolValue];
    _singleCardMode = (BOOL)[[profileContent objectForKey:@"single_card_mode"] boolValue];
    _order = (int)[[profileContent objectForKey:@"order"] intValue];
    _lockSwiping = (BOOL)[[profileContent objectForKey:@"lock_swiping"] boolValue];
    
    if([profileContent objectForKey:@"show_select_frame"] != nil){
        _showSelectFrame = (BOOL)[[profileContent objectForKey:@"show_select_frame"] boolValue];
    }else{
        _showSelectFrame = YES;
    }
    
    _remark = [[NSString alloc] initWithString:[profileContent objectForKey:@"remark"]];
    
    
    [profileContent release];
    return self;
}

-(void)dealloc{

    [_profileID release];
    [_name release];
    [_cardset release];

    
    [super dealloc];
}
//getter////////////////
-(NSString *)getProfileID{
    return _profileID;
}
-(NSString *)getName{
    return _name;
}
-(int)getLayout{
    return _layout;
}
-(BOOL)getCaptionOnOff{
    return _captionOnOff;
}
-(int)getCaptionMode{

    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]]){
        return 0;
    }else{
        return 1;
    }
//    return [SettingHandler getApplicationLanguage];
    //return _captionMode;
}
-(int)getVoiceMode{
    return _voiceMode;
}
-(BOOL)getTappingSpeak{
    return _tappingSpeak;
}
-(BOOL)getSingleCardMode{
    return _singleCardMode;
}
-(int)getOrder{
    return _order;
}
-(BOOL)getLockSwiping{
    return _lockSwiping;
}
-(BOOL)getShowSelectFrame{
    return _showSelectFrame;
}
-(NSMutableArray *)getCardset{
    return _cardset;
}
-(NSString *)getRemark{
    return _remark;
}

-(void) setCardset:(NSMutableArray *)cardset{
    _cardset = cardset;
}
//end getter////////////
-(void)updateProfileName:(NSString *)profileName{
    _name = profileName;
    [ProfileHandler updateProfile:self];
}
-(void)updateLayout:(int)newLayoutID{
    _layout = newLayoutID;
    [ProfileHandler updateProfile:self];
}
-(void)updateVoiceMode:(int)newVoiceMode{
    _voiceMode = newVoiceMode;
    [ProfileHandler updateProfile:self];
}
-(void)updateCaptionOnOff:(BOOL)isOn{
    _captionOnOff = isOn;
    [ProfileHandler updateProfile:self];
}
-(void)updateCaptionMode:(int)newCaptionMode{
    _captionMode = newCaptionMode;
    [ProfileHandler updateProfile:self];
}
-(void)updateTappingSpeak:(BOOL)isOn{
    _tappingSpeak = isOn;
    [ProfileHandler updateProfile:self];
}
-(void)updateSingleCardMode:(BOOL)isOn{
    _singleCardMode = isOn;
    [ProfileHandler updateProfile:self];
}
-(void)updateOrder:(int)newOrder{
    _order = newOrder;
    [ProfileHandler updateProfileWithoutReload:self];
}
-(void)updateLockSwiping:(BOOL)isOn{
    _lockSwiping = isOn;
    [ProfileHandler updateProfile:self];
}
-(void)updateShowSelectFrame:(BOOL)isOn{
    _showSelectFrame = isOn;
    [ProfileHandler updateProfile:self];
}
-(void)updateRemark:(NSString *)remark{
    _remark = remark;
    [ProfileHandler updateProfile:self];
}

-(void)saveCustomImage:(UIImage *)image fileName:(NSString *)fileName{
    //set profile image folder
    NSString *profilePath = @"/profiles/";
    if(![Utils isDirectoryExist:profilePath]){
        [Utils createDirectory:profilePath];
    }
    NSString *path= [[NSString alloc] initWithFormat:@"/profiles/%@/",_profileID];
    
    if(![Utils isDirectoryExist:path]){
        [Utils createDirectory:path];
    }
        
    //save image to own directory
    [Utils saveImage:image imageName:fileName path:path];
    
}
-(void)deleteCustomImageFile:(NSString *)fileName{
    NSString *path= [[NSString alloc] initWithFormat:@"/profiles/%@/",_profileID];
    [Utils deleteImage:fileName path:path];
    [path release];
}

-(void)saveCustomVoice:(NSString *)fileName{
    NSString *profilePath = @"/profiles/";
    if(![Utils isDirectoryExist:profilePath]){
        [Utils createDirectory:profilePath];
    }
    NSString *path= [[NSString alloc] initWithFormat:@"/profiles/%@/",_profileID];
    
    if(![Utils isDirectoryExist:path]){
        [Utils createDirectory:path];
    }
    
    NSString *tempFileName = @"tempRecordedSound";
    NSString *tempFilePath = [Utils getFullPath:[NSString stringWithFormat:@"%@.caf",tempFileName]];
    
	NSString *saveFilePath = [Utils getFullPath:[NSString stringWithFormat:@"/profiles/%@/%@.caf",_profileID,fileName]];
    
	if([[NSFileManager defaultManager] isReadableFileAtPath:tempFilePath]){
		[[NSFileManager defaultManager] removeItemAtPath:saveFilePath error:nil];
		//NSLog(@"save from %@ to %@", tempFilePath, saveFilePath);
        NSLog(@"saved : %@/%@.caf",_profileID,fileName);
		[[NSFileManager defaultManager] copyItemAtPath:tempFilePath toPath:saveFilePath error:nil];
		[[NSFileManager defaultManager] removeItemAtPath:tempFilePath error:nil];
	}else{
		NSLog(@"no saved");
	}
    
    [path release];
    
}
-(void)deleteCustomVoice:(NSString *)fileName{
    NSString *path= [[NSString alloc] initWithFormat:@"/profiles/%@/",_profileID];
    [Utils deleteFile:fileName path:path];
    [path release];
}

-(NSComparisonResult)compare:(UserProfile *)otherObject{
//    return [self getOrder]>[otherObject getOrder];//[NSNumber numberWithInt:[self getOrder] compare:[NSNumber numberWithInt:[otherObject getOrder]]];
    if([self getOrder]>[otherObject getOrder]){
        return NSOrderedDescending;
    }else if([self getOrder]<[otherObject getOrder]){
        return NSOrderedAscending;
    }else{
        return NSOrderedSame;
    }
}

@end
