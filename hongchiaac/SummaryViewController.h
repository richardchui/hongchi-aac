//
//  SummaryViewController.h
//  hongchiaac
//
//  Created by OEM on 6/2/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import "ViewController.h"

@interface SummaryViewController : ViewController <UIScrollViewDelegate>{
    UIScrollView *scrollView;
    
    BOOL pageControlUsed;
    int numOfPage;
    NSMutableArray *arrViewPages;
    NSMutableArray *arrProfiles;
    NSDictionary *dictProfiles;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *arrViewPages;

-(void)reload;
@end
