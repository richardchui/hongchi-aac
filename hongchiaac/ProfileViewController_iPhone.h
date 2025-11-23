//
//  ProfileViewController_iPhone.h
//  hongchiaac
//
//  Created by OEM on 22/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditAACViewController_iPhone.h"


@interface ProfileViewController_iPhone : ProfileViewController<UIScrollViewDelegate>{

    UIButton *btnBack;
    UIScrollView *scrollViewProfileDetail;
    
    EditAACViewController_iPhone *_viewEditAAC;
}

- (id)initWithUserProfile:(UserProfile *)userProfile;

@property (nonatomic, retain) IBOutlet UIButton *btnBack;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollViewProfileDetail;

-(IBAction)onClickBack:(id)sender;

@end
