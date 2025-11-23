//
//  Utils.m
//  hongchiaac
//
//  Created by OEM on 4/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "Utils.h"
#import <AVFoundation/AVFoundation.h>
#import "AACViewController.h"
#import "AACCard.h"
#import "Constants.h"

#define PLIST_LANGUAGE_RESOURCE @"language_resource.plist"

@implementation Utils
-(id)init{
    if(self=[super init]){
    }
    return self;
}

+(void)writeContentToPlist:(NSString *)_plistName withContent:(NSMutableDictionary *)_content{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *Path = [paths objectAtIndex:0];
    
    //check if the plist is already moved to "local"
    //if not -> move it from "bundle"
    if(![fm fileExistsAtPath:[Path stringByAppendingPathComponent:_plistName]]){
        NSString *pathLocal = [Path stringByAppendingPathComponent:_plistName];
        NSString *pathBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_plistName];
        [Utils skipFullPathDoc:pathLocal];
        [fm copyItemAtPath:pathBundle toPath:pathLocal error:nil];
        

        
        [pathLocal release];
        [pathBundle release];
    }
    
	[_content writeToFile:[Path stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@",_plistName] ] atomically:YES];
    
    Path = nil;
    paths = nil;
    fm = nil;
    [paths release];
    [Path release];
    [fm release];
}
+(NSDictionary *)getContentFromPlist:(NSString *)_plistName{
    NSFileManager *fm = [[NSFileManager defaultManager] autorelease];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *Path = [paths objectAtIndex:0];
    
    //check if the plist is already moved to "local"
    //if not -> move it from "bundle"
    
    //if(![fm fileExistsAtPath:[Path stringByAppendingPathComponent:_plistName]] || [_plistName isEqualToString:@"default_cards.plist"]){
    if(![fm fileExistsAtPath:[Path stringByAppendingPathComponent:_plistName]]){
//        NSLog(@"********* copy again : %@",_plistName);
        
        NSString *pathLocal = [Path stringByAppendingPathComponent:_plistName];
        NSString *pathBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_plistName];
        
        [Utils skipFullPathDoc:pathLocal];
        [fm copyItemAtPath:pathBundle toPath:pathLocal error:nil];
        
      
    }
    
	NSDictionary *tempDict = [[NSDictionary alloc] initWithContentsOfFile:[Path stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@",_plistName] ]];

    //Path = nil;
    //paths = nil;
    //fm = nil;
    //[Path release];
    //[paths release];
    //[fm release];
    
    return tempDict;
}

+(void)copyFileFromBundleToLocal:(NSString *)fileName{
    
    NSFileManager *fm = [[NSFileManager defaultManager] autorelease];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *Path = [paths objectAtIndex:0];
    
    NSString *pathLocal = [Path stringByAppendingPathComponent:fileName];
    NSString *pathBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    
    
    
    //remove the local file first
    NSLog(@"remove file : %@",pathLocal);
    [[NSFileManager defaultManager] removeItemAtPath:pathLocal error:nil];    
    
    //copy now
    NSLog(@"copy file from bundle to local : %@",fileName);
    [fm copyItemAtPath:pathBundle toPath:pathLocal error:nil];
    
    [Utils skipFullPathDoc:pathLocal];
}
+(void)copyDefaultProfileFromBundleToLocal:(NSString *)profileID{


    NSFileManager *fm = [[NSFileManager defaultManager] autorelease];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);    
	NSString *Path = [paths objectAtIndex:0];    
    NSString *pathBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",profileID]];
    
    NSString *profilePath = @"/profiles/";
    if(![Utils isDirectoryExist:profilePath]){
        [Utils createDirectory:profilePath];
    }
    NSString *path= [[NSString alloc] initWithFormat:@"/profiles/%@/",profileID];
    
    if(![Utils isDirectoryExist:path]){
        [Utils createDirectory:path];
    }
    
    NSString *fullPath = [Path stringByAppendingPathComponent:[NSString stringWithFormat:@"profiles/%@/%@.jpg",profileID,@"profilepic"]];
    
    NSLog(@"copying from %@ to %@",pathBundle, fullPath);
    
    [Utils deleteImage:@"profilepic" path:path];
    [fm copyItemAtPath:pathBundle toPath:fullPath error:nil];
    
    [path release];

}

+(void)copyDefaultProfileFileFromBundleToLocal:(NSString *)profileID fileName:(NSString *)fileName{
    NSFileManager *fm = [[NSFileManager defaultManager] autorelease];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *Path = [paths objectAtIndex:0];
    NSString *pathBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    
    NSString *profilePath = @"/profiles/";
    if(![Utils isDirectoryExist:profilePath]){
        [Utils createDirectory:profilePath];
    }
    NSString *path= [[NSString alloc] initWithFormat:@"/profiles/%@/",profileID];
    
    if(![Utils isDirectoryExist:path]){
        [Utils createDirectory:path];
    }
    
    NSString *fullPath = [Path stringByAppendingPathComponent:[NSString stringWithFormat:@"profiles/%@/%@",profileID,fileName]];
    
    NSLog(@"copying from %@ to %@",pathBundle, fullPath);
    
//    [Utils deleteImage:@"profilepic" path:path];
    [fm copyItemAtPath:pathBundle toPath:fullPath error:nil];
    
    [path release];
}

+(void)log:(NSString *)message{
    NSLog(@"%@",message);
}
+(void)logWithFormat:(NSString *)format message:(NSString *)message{
    NSLog(format,message);
}

+(void)removeAllChild:(UIView *)view{
    for(UIView *subview in [view subviews]) {     
        [subview removeFromSuperview];
    }
}
+(void)releaseAllChild:(UIView *)view{
    for(UIView *subview in [view subviews]) {
        //[self releaseAllChild:subview];
        //NSLog(@"it is ... %@",[subview nextResponder]);
        [[subview nextResponder] release];
    }
}
+(void)removeAllChildOfPage:(UIView *)view{
    //int i=1;
    for(UIView *subview in [view subviews]) {
        //NSLog(@"removeAllChildOfPage : number of cards in page %d : %d",i++,[[subview subviews] count]);
        //[self removeAllChild:subview];
        [self releaseAllChild:subview];
        [subview removeFromSuperview];
        [subview release];
    }
}
+(void)revmoeAllChildOfPage:(UIView *)view exceptCard:(AACCard *)card{
    for(UIView *subview in [view subviews]) {

        //[self releaseAllChild:subview];
        
        for(UIView *subsubview in [subview subviews]) {
            if(![[subsubview nextResponder] isEqual:card])
                [[subsubview nextResponder] release];
            
            //[subsubview removeFromSuperview];
        }
        
        [subview removeFromSuperview];
    }
}
+(void) playSoundOfCard:(NSString *)cardID withMode:(int)mode withCallBackObject:(id)callBackObject{
    if(mode==0)return;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *Path = [paths objectAtIndex:0];
    
    
    NSString *soundFileName;
    if(mode==1){
        soundFileName = [[NSString alloc] initWithFormat:@"%@_f.mp3",cardID];
    }else{
        soundFileName = [[NSString alloc] initWithFormat:@"%@_m.mp3",cardID];
    }
    //NSLog(@"snound file : %@",soundFileName);
    //check if existing
    if(![fm fileExistsAtPath:[Path stringByAppendingPathComponent:soundFileName]]){
        NSString *pathLocal = [Path stringByAppendingPathComponent:soundFileName];
        NSString *pathBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:soundFileName];
        [fm copyItemAtPath:pathBundle toPath:pathLocal error:nil];
        //NSLog(@"1");
   
    }
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],soundFileName]];

    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    //AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] init];
    NSLog(@"1 = %p", &audioPlayer);
    audioPlayer.numberOfLoops = 0;
    audioPlayer.delegate = callBackObject;
    [audioPlayer play];
    //[audioPlayer release];
   // [url release];
     
}
+(void)playSoundOfOpenFolder{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *Path = [paths objectAtIndex:0];

    NSString *soundFileName;
    soundFileName = @"open_folder.mp3";

    //check if existing
    if(![fm fileExistsAtPath:[Path stringByAppendingPathComponent:soundFileName]]){
        NSString *pathLocal = [Path stringByAppendingPathComponent:soundFileName];
        NSString *pathBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:soundFileName];
        [fm copyItemAtPath:pathBundle toPath:pathLocal error:nil];
        //NSLog(@"1");
        
    }
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],soundFileName]];
    
    AVAudioPlayer *audioPlayer;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
    [url release];
}
+(void)playSoundofFilePath:(NSString *)filePath withCallBackObject:(id)callBackObject{
    
    //NSLog(@"filepath:%@",filePath);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:filePath]){
        NSLog(@"ok");
    }else{
        NSLog(@"not exist");
        [(AACViewController *)callBackObject finishPlaySoundDueToNoFile];
        return;
    }
    
    
    AVAudioPlayer *audioPlayer;
    NSURL *url = [NSURL fileURLWithPath:filePath];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    audioPlayer.numberOfLoops = 0;
    audioPlayer.delegate = callBackObject;
    [audioPlayer play];
    [url release];
}

+(void)initAudioPlayer{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *Path = [paths objectAtIndex:0];
    
    if(![fm fileExistsAtPath:[Path stringByAppendingPathComponent:@"empty.mp3"]]){
        NSString *pathLocal = [Path stringByAppendingPathComponent:@"empty.mp3"];
        NSString *pathBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"empty.mp3"];
        [fm copyItemAtPath:pathBundle toPath:pathLocal error:nil];
    }
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],@"empty.mp3"]];
    
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
    
}

+(UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor {
    UIGraphicsBeginImageContext(baseImage.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    [theColor set];
    CGContextFillRect(ctx, area);
    CGContextRestoreGState(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextDrawImage(ctx, area, baseImage.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(void) alert:(NSString *)message{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
    [av release];
}

//path
+(NSString *)getFullPath:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fullPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
    
    return fullPath;
}
+(void)deleteFile:(NSString *)fileName path:(NSString *)path{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fullPath;
    if([path length]==0){
        fullPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    }else{
        fullPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",path,fileName]];
    }
    [self logWithFormat:@"deleting file:%@" message:fullPath];
    [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
    
    //[fullPath release]];
}
+(void)deleteFileInGiveFullPath:(NSString *)fileNameInFull{
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *fullPath;
    
    [self logWithFormat:@"deleting file:%@" message:fileNameInFull];
    [[NSFileManager defaultManager] removeItemAtPath:fileNameInFull error:nil];
}

//file
+(BOOL)isFileExist:(NSString *)filePath{
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    
    return [filemgr fileExistsAtPath:[self getFullPath:filePath]];
}
//directory
+(BOOL)isDirectoryExist:(NSString *)dirPath{
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    NSString *filePathAndDirectory = [self getFullPath:dirPath];
    return [filemgr changeCurrentDirectoryPath:filePathAndDirectory];
}
+(void)createDirectory:(NSString *)dirPath{
    NSError *error;
    NSString *filePathAndDirectory = [self getFullPath:dirPath];
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
}
+(void)deleteDirectory:(NSString *)dirPath{
    NSString *filePathAndDirectory = [self getFullPath:dirPath];
    [[NSFileManager defaultManager] removeItemAtPath:filePathAndDirectory error:nil];
}
+(void)listDirectory:(NSString *)sPath{
    BOOL isDir;
    //NSLog(@"list directory \n%@",sPath);
    [[NSFileManager defaultManager] fileExistsAtPath:sPath isDirectory:&isDir];

    if(isDir)
    {
        NSArray *contentOfDirectory=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:sPath error:NULL];
        
        int contentcount = [contentOfDirectory count];
        int i;
        for(i=0;i<contentcount;i++)
        {
            NSString *fileName = [contentOfDirectory objectAtIndex:i];
            NSString *path = [sPath stringByAppendingFormat:@"%@%@",@"/",fileName];
            
            if([[NSFileManager defaultManager] isDeletableFileAtPath:path])
            {
                //NSLog(@"\n-[FOLDER]%@",sPath);
                [self listDirectory:path];
            }
        }
    }
    else
    {
        NSString *msg=[NSString stringWithFormat:@"%@",sPath];
        NSLog(@"\n-[FILE]%@",msg);
    }
}
//for custom image
+(void)saveImage:(UIImage*)image imageName:(NSString*)imageName path:(NSString *)path{
    //NSData *imageData = UIImagePNGRepresentation(image);
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.png",path,imageName]];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.jpg",path,imageName]];
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
}
+(void)deleteImage:(NSString*)imageName path:(NSString *)path{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.jpg",path,imageName]];
    [self logWithFormat:@"deleting image:%@" message:fullPath];
    [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
}
//for resize image
+(UIImage *)resizeImageWithImage:(UIImage *)image toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(UIImage *)resizeImageWithImageVirtually:(UIImage *)image toSize:(CGSize)newSize
{
    /*
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
     */
    //image.size = CGSizeMake(newSize.width, newSize.height);
    return image;
}
+(UIImage *)cropCenterOfImageWithImage:(UIImage *)image
{
    int drawLenght = 0;
    double offsetX = 0;
    double offsetY = 0;
    
    if(image.size.width > image.size.height){
        //landscape
        drawLenght = image.size.height;
        offsetX = (image.size.width - image.size.height)/2;
    }else{
        //portrait or square
        drawLenght = image.size.width;
        offsetY = (image.size.height - image.size.width)/2;
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(offsetX, offsetY, drawLenght, drawLenght));
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return newImage;
}
+(UIImage *) scaleAndRotateImage:(UIImage *)image
{
    int kMaxResolution = 500; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
            }
        }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    NSLog(@"----------------------------------");
    switch(orient) {
            case UIImageOrientationUp: //EXIF = 1
            NSLog(@"1");
            transform = CGAffineTransformIdentity;
            break;
            
            case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            NSLog(@"2");
            break;
            
            case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            NSLog(@"3");
            break;
            
            case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            NSLog(@"4");
            break;
            
            case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            NSLog(@"5");
            break;
            
            case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            NSLog(@"6");
            break;
            
            case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            NSLog(@"7");
            break;
            
            case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            NSLog(@"8");
            break;
            
            default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
        }
    NSLog(@"----------------------------------");    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
        }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
        }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

//language
+(NSString *)getText:(NSString *)text ForLang:(NSString *)langCode atView:(NSString *)viewName{
    if([langCode isEqualToString:[Constants getLanguageCodeTW]]){
        return text;
    }else{
        NSDictionary *tempDict = [Utils getContentFromPlist:PLIST_LANGUAGE_RESOURCE];
        NSDictionary *viewLevel = [tempDict objectForKey:viewName];
        NSDictionary *dictText = [viewLevel objectForKey:text];
        NSString *returnString = [[NSString alloc] initWithString:[dictText objectForKey:langCode]];
        
        [tempDict release];
        return returnString;
        
        //return [dictText objectForKey:langCode];
    }
    
}

+(void)skipDoc:(NSString *)path{

    NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",path]];
    
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnum =
    [localFileManager enumeratorAtPath:docsDir];
    
    NSString *file;
    while (file = [dirEnum nextObject]) {
        NSURL *tempUrl =  [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",docsDir,file]];
        [self addSkipBackupAttributeToItemAtURL:tempUrl];
    }
    [localFileManager release];    //return documentsDirectory;
}

+(void)skipFullPathDoc:(NSString *)path{
    
    NSString *docsDir = path;//[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",path]];
    
    //NSLog(@"skipping : %@",docsDir);
    
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnum =
    [localFileManager enumeratorAtPath:docsDir];
    
    NSString *file;
    while (file = [dirEnum nextObject]) {
        NSURL *tempUrl =  [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",docsDir,file]];
        [self addSkipBackupAttributeToItemAtURL:tempUrl];
    }
    [localFileManager release];    //return documentsDirectory;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{

    //NSLog(@"SKIP :%@",URL);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.1) {
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        
        
        
        NSError *error = nil;
        
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                        
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        
        if(!success){
            
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
            
        }
        
        return success;
    }
    else {
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        
        
        
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        
        
        const char* attrName = "com.apple.MobileBackup";
        
        u_int8_t attrValue = 1;
        
        
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        
        return result == 0;
    }
    
}

@end
