//
//  Utils.h
//  hongchiaac
//
//  Created by OEM on 4/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/xattr.h>
@class AACCard;

@interface Utils : NSObject{
}

+(void)writeContentToPlist:(NSString *)_plistName withContent:(NSDictionary *)_content;
+(NSDictionary *)getContentFromPlist:(NSString *)_plistName;

+(void)copyFileFromBundleToLocal:(NSString *)fileName;
+(void)copyDefaultProfileFromBundleToLocal:(NSString *)profileID;
+(void)copyDefaultProfileFileFromBundleToLocal:(NSString *)profileID fileName:(NSString *)fileName;

+(void)log:(NSString *)message;
+(void)logWithFormat:(NSString *)format message:(NSString *)message;

+(void)removeAllChild:(UIView *)view;
+(void)removeAllChildOfPage:(UIView *)view;
+(void)revmoeAllChildOfPage:(UIView *)view exceptCard:(AACCard *)card;

+(void)playSoundOfOpenFolder;
+(void) playSoundOfCard:(NSString *)cardID withMode:(int)mode withCallBackObject:(id)callBackObject;
+(void) playSoundofFilePath:(NSString *)filePath withCallBackObject:(id)callBackObject;
+(void) initAudioPlayer;
+(UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor;

+(void) alert:(NSString *)message;

//path
+(NSString *)getFullPath:(NSString *)fileName;
//directory
+(BOOL)isFileExist:(NSString *)filePath;
+(BOOL)isDirectoryExist:(NSString *)dirPath;
+(void)createDirectory:(NSString *)dirPath;
+(void)deleteDirectory:(NSString *)dirPath;
+(void)listDirectory:(NSString *)sPath;
+(void)deleteFile:(NSString *)fileName path:(NSString *)path;
+(void)deleteFileInGiveFullPath:(NSString *)fileNameInFull;
//for custom image
+(void)saveImage:(UIImage*)image imageName:(NSString*)imageName path:(NSString *)path;
+(void)deleteImage:(NSString*)imageName path:(NSString *)path;
//for resize image
+(UIImage *)resizeImageWithImage:(UIImage *)image toSize:(CGSize)newSize;
+(UIImage *)resizeImageWithImageVirtually:(UIImage *)image toSize:(CGSize)newSize;
+(UIImage *)cropCenterOfImageWithImage:(UIImage *)image;
+(UIImage *) scaleAndRotateImage:(UIImage *)image;
//language
+(NSString *)getText:(NSString *)text ForLang:(NSString *)langCode atView:(NSString *)viewName
;
+(void)skipDoc:(NSString *)path;
+(void)skipFullPathDoc:(NSString *)path;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
@end
