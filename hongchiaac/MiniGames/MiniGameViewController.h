//
//  MiniGameViewController.h
//  hongchiaac
//
//  Created by Ray.Liu on 12/4/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiniGameViewController : UIViewController
{
    
}

@property (nonatomic, retain) UINavigationController *myNavigationController;
@property (nonatomic, retain) UIViewController *myParentController;
@property (nonatomic, retain) NSMutableDictionary *myExtraData;

- (id)initWithNavigationController:(UINavigationController *)navigationController ParentController:(UIViewController *)parentController ExtraData:(NSMutableDictionary *)extraData;

- (void)refresh;

+ (void)fillCardsetArray:(NSMutableArray *)arraylist Cardset:(NSMutableArray *)cardset;

+ (void)randomArray:(NSMutableArray *)arraylist;

+(int)getNumberOfCardPerPageFromLayout:(int)layoutID;
+(int)getColFromLayout:(int)layoutID;
+(int)getRowFromLayout:(int)layoutID;
+(int)getCardSize:(int)layoutID;
+(int)getCardXMargin:(int)layoutID;
+(int)getCardYMargin:(int)layoutID;
+(int)getCardCountByLayout:(int)layoutID;
+ (NSMutableDictionary *)getEmptyCardContent;

@end
