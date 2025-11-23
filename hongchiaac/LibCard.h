//
//  LibCard.h
//  hongchiaac
//
//  Created by OEM on 7/11/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Card;

@interface LibCard : UIViewController{
    UIImageView *imgCard;
    UILabel *lblCaption;
    
    Card *_content;
}

@property (nonatomic, retain) IBOutlet UIImageView *imgCard;
@property (nonatomic, retain) IBOutlet UILabel *lblCaption;

-(id)initWithCard:(Card *)content;
-(UIImage *)getCardImage;
-(NSString *)getCardImageName;
-(NSString *)getCardID;
-(NSString *)getCaptionTW;
-(NSString *)getCaptionCN;

-(void)setDisplayCaption:(NSString *)caption;

-(void)resizeImageToSize:(int)height;
@end
