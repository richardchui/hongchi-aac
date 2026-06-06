//
//  LibCard.m
//  hongchiaac
//
//  Created by OEM on 7/11/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "LibCard.h"
#import "Classes/Card.h"
#import "Utils.h"

@interface LibCard ()

@end

@implementation LibCard
@synthesize imgCard;
@synthesize lblCaption;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithCard:(Card *)content;{
    self = [super initWithNibName:@"LibCard" bundle:nil];
    if (self) {
        _content = content;
    }
    return self;
}
- (void)viewDidLoad
{
    
    //[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",_cardID]]
    [imgCard setImage:[UIImage imageNamed:[self getCardImageName]]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc{
    //[[imgCard image] release];
    [imgCard release];
    [_content release];
    [lblCaption release];
    
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
///////
-(NSString *)getCardID{
    return [_content getCardID];
}
-(UIImage *)getCardImage{
    return [imgCard image];
}
-(NSString *)getCardImageName{
    return [NSString stringWithFormat:@"%@.jpg",[_content getCardID]];
}
-(NSString *)getCaptionCN{
    return [_content getCaptionCN];
};
-(NSString *)getCaptionTW{
    return [_content getCaptionTW];
};

-(void)setDisplayCaption:(NSString *)caption{
    [lblCaption setText:caption];
}
///////
#pragma touch events
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onClickLibCard" object:self];
}
///////
-(void)resizeImageToSize:(int)height{
    if(height<=30)return;
    
//    int width = (int)(height/8*7);
    
    int width = (int)(height/15*13);

    
    CGRect frame = self.view.frame;
    frame.size.width = width;
    frame.size.height = height;
    self.view.frame = frame;
    
    frame.size.height = width;
    imgCard.frame = frame;
    
    frame.size.height = height-width;
    frame.origin.y = width + 1;
    lblCaption.frame = frame;
    
    
   [imgCard setImage:[Utils resizeImageWithImage:[imgCard image] toSize:CGSizeMake(width,width)]]; 
}
@end
