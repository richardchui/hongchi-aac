//
//  AACViewController_iPad.h
//  hongchiaac
//
//  Created by OEM on 9/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "AACViewController.h"
#import "ProfileViewController_iPad.h"
#import "SettingViewController_iPad.h"

@interface AACViewController_iPad : AACViewController{
    ProfileViewController_iPad *profileViewController;
    SettingViewController_iPad *settingViewController;
}

@end
