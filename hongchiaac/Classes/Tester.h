//
//  Tester.h
//  hongchiaac
//
//  Created by OEM on 8/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AACViewController_iPad;
@class AACViewController_iPhone;

@class EditAACViewController_iPad;
@class ProfileViewController_iPad;

@class StartingViewController_iPad;
@class StartingViewController_iPhone;

@class SummaryViewController_iPad;
@class SummaryViewController_iPhone;

@interface Tester : NSObject{
    UIView *view;
    AACViewController_iPad *aac_iPad;
    AACViewController_iPhone *aac_iPhone;
    
    EditAACViewController_iPad *editAAC_iPad;

    ProfileViewController_iPad *profileViewController_iPad;
    
    StartingViewController_iPad *startingViewController_iPad;
    StartingViewController_iPhone *startingViewController_iPhone;
    
    SummaryViewController_iPad *summarViewController_iPad;
    SummaryViewController_iPhone *summaryViewController_iPhone;
}

@property (nonatomic, retain) UIView *view;

-(id)initWithView:(UIView *)view;
-(void)run;
-(void)runAACWithProfileID:(NSString *)profileID;
-(void)runEditAAC;
-(void)runRecord;
-(void)runNewCard;
-(void)runMiniGame:(NSString *)gameKey;
-(void)runEditProfile;
-(void)runStarter;
-(void)runSummary;
@end
