//
//  EditAACCard.m
//  hongchiaac
//
//  Created by OEM on 31/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "EditAACCard.h"
#import "Handlers/SettingHandler.h"
#import "Constants.h"

@interface EditAACCard ()

@end

@implementation EditAACCard
@synthesize viewHighlightCover;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowAsHighlight:) name:@"showAsHighlight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowAtNormal:) name:@"showAsNormal" object:nil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    switch (_captionMode) {
        case 0:
            lblCaption.text = [self getCaptionTW];
            break;
        case 1:
            lblCaption.text = [self getCaptionCN];
            break;
        default:
            lblCaption.text = @"";
            break;
    }
     */
    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]]){
        lblCaption.text = [self getCaptionTW];
    }else{
        lblCaption.text = [self getCaptionCN];
    }
    // Do any additional setup after loading the view from its nib.
}
-(UIImage *)setupEmtpyCardImage{
    return [UIImage imageNamed:@"empty_card_edit.png"];
}
- (void)viewDidUnload
{
    [viewHighlightCover release];    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}
-(void)dealloc{
    //viewHighlightCover =nil;
    [viewHighlightCover release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showAsHighlight" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showAsNormal" object:nil];
    [super dealloc];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    //return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

#pragma even handler
-(void) onShowAsHighlight:(NSNotification *)notification{
    NSLog(@"a");
    EditAACCard *clickedAACCard = (EditAACCard *)notification.object;
    
    if(![clickedAACCard isEqual:self]){
        CGRect frame = self.view.frame;
        frame.origin.x=0;
        frame.origin.y=0;
        viewHighlightCover.frame = frame;
        [self.view addSubview:viewHighlightCover];
    }
}
-(void) onShowAtNormal:(NSNotification *)notification{
    NSLog(@"b");    
    //EditAACCard *clickedAACCard = (EditAACCard *)notification.object;
    
    //if(![clickedAACCard isEqual:self]){
    //[viewHighlightCover removeFromSuperview];
    //}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //[self cardActiveEffect:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onClickEditAACCard" object:self];
}
@end
