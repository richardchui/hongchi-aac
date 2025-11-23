//
//  SummaryItemViewController.h
//  hongchiaac
//
//  Created by OEM on 6/2/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryItemViewController : UIViewController{
    UIImageView *imgProfilePic;
    UILabel *lblProfileName;
    
    NSString *profileID;
}

@property (nonatomic, retain) IBOutlet UIImageView *imgProfilePic;
@property (nonatomic, retain) IBOutlet UILabel *lblProfileName;

- (id)initWithProfileID:(NSString *)pid;

-(void)resizeImageToSize:(int)length;
@end
