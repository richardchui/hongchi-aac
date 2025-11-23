//
//  Constants.h
//  hongchiaac
//
//  Created by OEM on 6/11/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

+(UIColor *) getColorById:(int)i;
+(int)getColorIdByColor:(UIColor *)color;
+(double)getDelayLoadingTime;
+(int)getMaxCardInSentenseBar;

+(NSString *)getLanguageCodeTW;
+(NSString *)getLanguageCodeCN;
@end
