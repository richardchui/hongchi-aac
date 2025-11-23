//
//  Constants.m
//  hongchiaac
//
//  Created by OEM on 6/11/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+(UIColor *) getColorById:(int)i{
  if(i==1) return [UIColor redColor];
  if(i==2) return [UIColor orangeColor];
  if(i==3) return [UIColor yellowColor];
  //if(i==4) return [UIColor greenColor];
  if(i==4) return [UIColor colorWithRed:0 green:0.6 blue:0 alpha:1];
  if(i==5) return [UIColor cyanColor];
  if(i==6) return [UIColor blueColor];
  if(i==7) return [UIColor magentaColor];
  if(i==8) return [UIColor purpleColor];
  
  
  return [UIColor clearColor];
}
+(int)getColorIdByColor:(UIColor *)color{
  CGFloat tmpColor = 0;
  CGFloat greenColor = 0;
  [color getRed:&tmpColor green:&greenColor blue:&tmpColor alpha:&tmpColor];
  
  if([color isEqual:[UIColor redColor]])  return 1;
  if([color isEqual:[UIColor orangeColor]])  return 2;
  if([color isEqual:[UIColor yellowColor]])  return 3;
  //if([color isEqual:[UIColor greenColor]])  return 4;
  if([color isEqual:[UIColor colorWithRed:0 green:0.6 blue:0 alpha:1]]) return 4;
  if([color isEqual:[UIColor cyanColor]])  return 5;
  if([color isEqual:[UIColor blueColor]])  return 6;
  if([color isEqual:[UIColor magentaColor]])  return 7;
  if([color isEqual:[UIColor purpleColor]])  return 8;
  if([color isEqual:[UIColor whiteColor]])  return 0;
  if ((greenColor - 0.6) < 0.01) return 4;  // have to put at the end or will interfere with blue and magneta
  
  return 0;
}
+(double)getDelayLoadingTime{
  return 0.01;
}
+(int)getMaxCardInSentenseBar{
  return 6;
}
+(NSString *)getLanguageCodeTW{
  return @"tw";
}
+(NSString *)getLanguageCodeCN{
  return @"cn";
}
@end
