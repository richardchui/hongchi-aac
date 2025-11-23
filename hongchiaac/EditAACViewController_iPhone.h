//
//  EditAACViewController_iPhone.h
//  hongchiaac
//
//  Created by OEM on 7/2/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import "EditAACViewController.h"

@interface EditAACViewController_iPhone : EditAACViewController{
    UIView *viewCardDetail;
    BOOL isAnimating;
}

@property (nonatomic, retain) IBOutlet UIView *viewCardDetail;

-(IBAction)onClickCloseCardDetail:(id)sender;

@end
