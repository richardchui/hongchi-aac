//
//  AACViewController_iPhone.h
//  hongchiaac
//
//  Created by OEM on 12/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "AACViewController.h"
#import "ProfileViewController_iPhone.h"
#import "SettingViewController_iPhone.h"

@interface AACViewController_iPhone : AACViewController{
    ProfileViewController_iPhone *profileViewController;
    SettingViewController_iPhone *settingViewController;
}

@end
