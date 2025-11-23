//
//  ProfileViewController_iPad.h
//  hongchiaac
//
//  Created by OEM on 22/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditAACViewController_iPad.h"


@interface ProfileViewController_iPad : ProfileViewController{
    EditAACViewController_iPad *_viewEditAAC;
}
- (id)initWithUserProfile:(UserProfile *)userProfile;
-(void)deleteUserProfile:(UserProfile *)profile;
@end
