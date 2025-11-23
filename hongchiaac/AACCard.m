//
//  AACCardViewController.m
//  hongchiaac
//
//  Created by OEM on 9/10/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//


#import "AACCard.h"
#import "Classes/UserCard.h"
#import "Classes/UserProfile.h"
#import "Utils.h"
#import "Constants.h"
#import "Handlers/SettingHandler.h"

@interface AACCard ()

@end

@implementation AACCard

#define BORDER_SIZE_RATIO 1/15

@synthesize viewCardBorder, imgFolderBG, imgCard,lblCaption;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  //_isCard = false;
  return self;
}

-(id)initWithUserCard:(UserCard *)userCard cardIndex:(int)cardIndex profileID:(NSString *)profileID{
  self = [super init];
  if (self) {
  }
  
  //_isCard = NO;
  _cardIndex = cardIndex;
  _profileID = [[NSString alloc] initWithString:profileID];
  //if([userCard isCard]) _isCard = YES;
  
  _userCard = userCard;
  return self;
}
-(id)initWithUserCard:(UserCard *)userCard cardIndex:(int)cardIndex profileID:(NSString *)profileID withPlist:(NSDictionary *)plist{
  self = [super init];
  if (self) {
  }
  
  //_isCard = NO;
  _cardIndex = cardIndex;
  _profileID = [[NSString alloc] initWithString:profileID];
  //if([userCard isCard]) _isCard = YES;
  _plist = plist;
  
  _userCard = userCard;
  return self;
}

- (void)viewDidLoad
{
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCheckIfAlive:) name:@"onCheckIfAlive" object:nil];
  
  if(![_userCard isEmpty])
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeLang:) name:@"changeLang" object:nil];
  
//  UserProfile *userProfile = [[UserProfile alloc] initWithProfileID:_profileID withPlist:_plist];
  UserProfile *userProfile = [[UserProfile alloc] initWithProfileID:_profileID];
  _captionMode = [userProfile getCaptionMode];
  
  //if([userProfile getCaptionOnOff] || [[_userCard getCardID] isEqualToString:@"empty_card"]){
  //if([userProfile getCaptionOnOff] && [[_userCard getCardID] isEqualToString:@"empty_card"]){
//  if([userProfile getCaptionOnOff]){
//    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]]){
//      lblCaption.text = [self getCaptionTW];
//    }else{
//      lblCaption.text = [self getCaptionCN];
//    }
//  }else{
//    lblCaption.text = @"";
//  }
//  //for folder
//  if(([_userCard getCardID] == nil) && ![_userCard isCard] && ![_userCard isEmpty]){
//    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]]){
//      lblCaption.text = [self getCaptionTW];
//    }else{
//      lblCaption.text = [self getCaptionCN];
//    }
//  }
  
    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]]){
        lblCaption.text = [self getCaptionTW];
    }else{
        lblCaption.text = [self getCaptionCN];
    }
    
    //for folder
    if(([_userCard getCardID] == nil) && ![_userCard isCard] && ![_userCard isEmpty]){
        if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]]){
            lblCaption.text = [self getCaptionTW];
        }else{
            lblCaption.text = [self getCaptionCN];
        }
    }
    
    //check if need to show caption
    if ([userProfile getCaptionOnOff]) {
        lblCaption.hidden = false;
    } else {
        lblCaption.hidden = true;
    }

    
  [userProfile release];
  //lblCaption.text = [self getCaptionTW]; // [_userCard getCaptionTW];
  
  if(![_userCard isEmpty]){
    if([_userCard isCard]){
      [imgCard setImage:[_userCard getImageFile:_profileID]];
      
      CGRect frame = imgCard.frame;
      frame.origin.x = (viewCardBorder.frame.size.width - imgCard.frame.size.width)/2;
      frame.origin.y = (viewCardBorder.frame.size.height - imgCard.frame.size.height)/2;
      imgCard.frame = frame;
      
      if([_userCard isEmpty])
        [viewCardBorder setBackgroundColor:[UIColor clearColor]];
      else{
        [viewCardBorder setBackgroundColor:[Constants getColorById:[_userCard getBorderColorID]]];
      }
      
      [self.view addSubview:viewCardBorder];
      [self.view addSubview:imgCard];
      [super viewDidLoad];
      
      
    }else{
      [imgCard setImage:[_userCard getImageFile:_profileID]];
      
      CGRect frame = imgFolderBG.frame;
      frame.size.width = self.view.frame.size.width;
      frame.size.height = self.view.frame.size.height;
      imgFolderBG.frame = frame;
      
      frame = imgCard.frame;
      frame.origin.x = 4;//(viewCardBorder.frame.size.width - imgCard.frame.size.width)/2;
      frame.origin.y = 27;//(viewCardBorder.frame.size.height - imgCard.frame.size.height)/2;
      frame.size.width = 108;
      frame.size.height = 108;
      imgCard.frame = frame;
      
      //[viewCardBorder setBackgroundColor:[UIColor clearColor]];
      if([_userCard isEmpty])
        [viewCardBorder setBackgroundColor:[UIColor clearColor]];
      else{
        [viewCardBorder setBackgroundColor:[Constants getColorById:[_userCard getBorderColorID]]];
      }
      [viewCardBorder addSubview:imgFolderBG];
      
      [self.view addSubview:viewCardBorder];
      [self.view addSubview:imgFolderBG];
      [self.view addSubview:imgCard];
      [super viewDidLoad];
    }
    
  }else{
    [imgCard setImage:[self setupEmtpyCardImage]];
    CGRect frame = imgCard.frame;
    
    frame.origin.x = (viewCardBorder.frame.size.width - imgCard.frame.size.width)/2;
    frame.origin.y = (viewCardBorder.frame.size.height - imgCard.frame.size.height)/2;
    imgCard.frame = frame;
    
    if([_userCard isEmpty])
      [viewCardBorder setBackgroundColor:[UIColor clearColor]];
    else{
      [viewCardBorder setBackgroundColor:[Constants getColorById:[_userCard getBorderColorID]]];
    }
    
    [self.view addSubview:viewCardBorder];
    [self.view addSubview:imgCard];
    [super viewDidLoad];
  }
}
-(UIImage *)setupEmtpyCardImage{
  return [_userCard getImageFile:_profileID];
}
- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  
  // [viewCardBorder release];
  // [imgFolderBG release];
  // [imgCard release];
  // [lblCaption release];
}
-(void)dealloc{
  
  //viewCardBorder =nil;
  //imgFolderBG = nil;
  //imgCard = nil;
  //lblCaption = nil;
  
  //_userCard = nil;
  
  [viewCardBorder release];
  [imgFolderBG release];
  [imgCard release];
  [lblCaption release];
  [_userCard release];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeLang" object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"unsetAACCardActiveEffect" object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onCheckIfAlive" object:nil];
  
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

//getter
-(UserCard *)getUserCard{
  return _userCard;
}
-(NSArray *)getCardset{
  return [_userCard getCardset];
}
-(BOOL) isCard{
  return [_userCard isCard];
}
-(BOOL) isEmpty{
  return [_userCard isEmpty];
}
-(NSNumber *)getCardIndex{
  return [NSNumber numberWithInt:_cardIndex];
}
-(void)setCardIndex:(int)i{
  _cardIndex = i;
}
-(UIImage *)getCardImage{
  return [_userCard getImageFile:_profileID];
}
-(NSString *)getCardID{
  return [_userCard getCardID];
}
-(void)setBordColorID:(int)colorID{
  [_userCard setBorderColorID:colorID];
}
-(NSMutableDictionary *)getUserCardContent{
  return [_userCard getDictionaryContent];
}
-(void)setCardID:(NSString *)cardID{
  [_userCard setCardID:cardID ];
}
-(void)setIsCard:(BOOL)b{
  //_isCard = b;
  [_userCard setIsCard:b];
}
-(void)setEmptyCardset{
  [_userCard setEmptyCardset];
}
-(void)setIsEmpty:(BOOL)b{
  [_userCard setIsEmpty:b];
}
-(NSString *)getCaptionCN{
  if([[_userCard getCaptionCustom] length]>0)
    return [_userCard getCaptionCustom];
  
  if([[_userCard getCardID] length]>0){
    //return [_userCard _captionCN];
    return [_userCard getCaptionCN];
  }else
    return @"";
};
-(NSString *)getCaptionTW{
  if([[_userCard getCaptionCustom] length]>0)
    return [_userCard getCaptionCustom];
  
  if([[_userCard getCardID] length]>0){
    //return [_userCard _captionTW];
    return [_userCard getCaptionTW];
  }else
    return @"";
};
-(NSString *)getCaptionRawCN{
  if([[_userCard getCardID] length]>0)
    return [_userCard _captionCN];
  else
    return @"";
}
-(NSString *)getCaptionRawTW{
  if([[_userCard getCardID] length]>0)
    return [_userCard _captionTW];
  else
    return @"";
}
-(NSString *)getCaptionRawCustom{
  if([[_userCard getCaptionCustom] length]>0)
    return [_userCard getCaptionCustom];
  else
    return @"";
}
-(NSString *)getVoiceCustom{
  return [_userCard getVoiceCustom];
}
-(BOOL)haveDefaultCard{
  if([[self getCardID] length]>0 && ![[self getCardID] isEqualToString:@"empty_card"]){
    return YES;
  }else
    return NO;
}
/////////////////////////////////////
-(void)resizeImageToSize:(int)height{
  if(height<=30)return;
  
  int width = (int)(height/8*7);
  
  int colorBorderWidth = floor(width * BORDER_SIZE_RATIO);
  CGRect frame = viewCardBorder.frame;
  frame.size.width = width;
  frame.size.height = width;
  viewCardBorder.frame = frame;
  
  frame.size.height =height;
  self.view.frame = frame;
  
  //set caption size
  frame.size.width =width;
  frame.size.height=height-width;
  frame.origin.x=0;
  frame.origin.y=width;
  
  lblCaption.frame=frame;
  
  if([_userCard isCard] || [_userCard isEmpty]){
    frame = imgCard.frame;
    frame.size.width = width - colorBorderWidth*2;
    frame.size.height = width - colorBorderWidth*2;
    frame.origin.x = colorBorderWidth;
    frame.origin.y = colorBorderWidth;
    imgCard.frame = frame;
    
    [imgCard setImage:[Utils resizeImageWithImage:[imgCard image] toSize:CGSizeMake(width-colorBorderWidth*2, width-colorBorderWidth*2)]];
    //[imgCard setImage:[Utils resizeImageWithImage:[imgCard image] toSize:CGSizeMake(10, 10)]];
  }else{
    imgFolderBG.frame =viewCardBorder.frame;
    
    //imgFolderBG.frame = frame;
    
    frame = imgCard.frame;
    frame.origin.x = ceil(width/30);
    frame.origin.y = ceil(width/30);
    frame.size.width = floor(width *5/6)+2;
    frame.size.height = floor(width *5/6)+2;
    imgCard.frame = frame;
    
    [imgCard setImage:[Utils resizeImageWithImage:[imgCard image] toSize:CGSizeMake(floor(width *5/6)+2, floor(width *5/6)+2)]];
    //[imgCard setImage:[Utils resizeImageWithImage:[imgCard image] toSize:CGSizeMake(10,10)]];
  }
  
  if(height-width>16){
    lblCaption.font = [UIFont systemFontOfSize:(height-width)];
  }else{
    lblCaption.font = [UIFont systemFontOfSize:12];
  }
  
  //if no image, then move the caption to the center
  
  if([[_userCard getCardID] isEqualToString:@"empty_card"] && [_userCard isCard]){
//    NSLog(@"~~~~~~ name : %@",[_userCard getImageCustom]);
    if([[_userCard getImageCustom] length] == 0){
//      NSLog(@"~~~~~!!!! %d",[[_userCard getImageCustom] length]);
      
      frame = imgCard.frame;
      
      //        frame.size.width =width;
      //        frame.size.height=frame.size.height/2;
      
      //        frame.origin.x=0;
      switch (lblCaption.text.length) {
        case 1:
          ;
          break;
        case 2:
          if([self isIPhone])
            frame.origin.y=-4;
          else
            frame.origin.y=-10;
          break;
        case 3:
          if([self isIPhone])
            frame.origin.y=-9;
          else
            frame.origin.y=-25;
          break;
        case 4:
          if([self isIPhone])
            frame.origin.y=-10;
          else
            frame.origin.y=-30;
          break;
        case 5:
          if([self isIPhone])
            frame.origin.y=-12;
          else
            frame.origin.y=-35;
          break;
        case 6:
          if([self isIPhone])
            frame.origin.y=-12;
          else
            frame.origin.y=-40;
          break;
        case 7:
          if([self isIPhone])
            frame.origin.y=-15;
          else
            frame.origin.y=-40;
          break;
        case 8:
          if([self isIPhone])
            frame.origin.y=-15;
          else
            frame.origin.y=-45;
          break;
        default:
          break;
      }
      
      
      //lblCaption.frame=imgCard.frame;
      lblCaption.frame=frame;
      lblCaption.font = [UIFont systemFontOfSize:width];
      [lblCaption setMinimumFontSize:12];  // have to set this otherwise won't work in ios 7
      lblCaption.textColor = [UIColor blackColor];
        lblCaption.hidden = false;  // may have been hidden if show caption is OFF
      
      [imgCard setImage:[UIImage imageNamed:@"empty_card_white.png"]];
      
      [self.view bringSubviewToFront:lblCaption];
    }else{
      
    }
  }
  if(([_userCard getCardID] == nil) && ![_userCard isCard] && ![_userCard isEmpty]){
    if([[_userCard getImageCustom] length] == 0){
      
      frame = imgCard.frame;
      
      switch (lblCaption.text.length) {
        case 1:
          ;
          break;
        case 2:
          if([self isIPhone])
            frame.origin.y=-4;
          else
            frame.origin.y=-10;
          break;
        case 3:
          if([self isIPhone])
            frame.origin.y=-9;
          else
            frame.origin.y=-25;
          break;
        case 4:
          if([self isIPhone])
            frame.origin.y=-10;
          else
            frame.origin.y=-30;
          break;
        case 5:
          if([self isIPhone])
            frame.origin.y=-12;
          else
            frame.origin.y=-35;
          break;
        case 6:
          if([self isIPhone])
            frame.origin.y=-12;
          else
            frame.origin.y=-40;
          break;
        case 7:
          if([self isIPhone])
            frame.origin.y=-15;
          else
            frame.origin.y=-40;
          break;
        case 8:
          if([self isIPhone])
            frame.origin.y=-15;
          else
            frame.origin.y=-45;
          break;
        default:
          break;
      }
      
      lblCaption.frame=frame;
      lblCaption.font = [UIFont systemFontOfSize:width];
      [lblCaption setMinimumFontSize:12];
      lblCaption.textColor = [UIColor blackColor];
      [imgCard setImage:[UIImage imageNamed:@"empty_card_white.png"]];
      [self.view bringSubviewToFront:lblCaption];
    }else{
      
    }
  }
  
  /////////////////////////////////////////////////
  
}
-(void)resizeImageToSizeVirtually:(int)height{
  if(height<=30)return;
  
  int width = (int)(height/8*7);
  
  int colorBorderWidth = floor(width * BORDER_SIZE_RATIO);
  CGRect frame = viewCardBorder.frame;
  frame.size.width = width;
  frame.size.height = width;
  viewCardBorder.frame = frame;
  
  frame.size.height =height;
  self.view.frame = frame;
  
  //set caption size
  frame.size.width =width;
  frame.size.height=height-width;
  frame.origin.x=0;
  frame.origin.y=width;
  
  lblCaption.frame=frame;
  
  if([_userCard isCard] || [_userCard isEmpty]){
    frame = imgCard.frame;
    frame.size.width = width - colorBorderWidth*2;
    frame.size.height = width - colorBorderWidth*2;
    frame.origin.x = colorBorderWidth;
    frame.origin.y = colorBorderWidth;
    imgCard.frame = frame;
    
    //[imgCard setImage:[Utils resizeImageWithImage:[imgCard image] toSize:CGSizeMake(width-colorBorderWidth*2, width-colorBorderWidth*2)]];
    CGRect frame2 = imgCard.frame;
    frame2.size.width = (width-colorBorderWidth*2);
    frame2.size.height= (width-colorBorderWidth*2);
    imgCard.frame = frame2;
  }else{
    imgFolderBG.frame =viewCardBorder.frame;
    
    //imgFolderBG.frame = frame;
    
    frame = imgCard.frame;
    frame.origin.x = ceil(width/30);
    frame.origin.y = ceil(width/30);
    frame.size.width = floor(width *5/6)+2;
    frame.size.height = floor(width *5/6)+2;
    imgCard.frame = frame;
    
    //[imgCard setImage:[Utils resizeImageWithImage:[imgCard image] toSize:CGSizeMake(floor(width *5/6)+2, floor(width *5/6)+2)]];
    CGRect frame2 = imgCard.frame;
    frame2.size.width = (width-colorBorderWidth*2);
    frame2.size.height= (width-colorBorderWidth*2);
    imgCard.frame = frame2;
  }
  
  if(height-width>16){
    lblCaption.font = [UIFont systemFontOfSize:(height-width)];
  }else{
    lblCaption.font = [UIFont systemFontOfSize:12];
  }
  
  //if no image, then move the caption to the center
  
  if([[_userCard getCardID] isEqualToString:@"empty_card"] && [_userCard isCard]){
    NSLog(@"~~~~~~ name : %@",[_userCard getImageCustom]);
    if([[_userCard getImageCustom] length] == 0){
      NSLog(@"~~~~~!!!! %d",[[_userCard getImageCustom] length]);
      
      frame = imgCard.frame;
      
      //        frame.size.width =width;
      //        frame.size.height=frame.size.height/2;
      
      //        frame.origin.x=0;
      switch (lblCaption.text.length) {
        case 1:
          ;
          break;
        case 2:
          if([self isIPhone])
            frame.origin.y=-4;
          else
            frame.origin.y=-10;
          break;
        case 3:
          if([self isIPhone])
            frame.origin.y=-9;
          else
            frame.origin.y=-25;
          break;
        case 4:
          if([self isIPhone])
            frame.origin.y=-10;
          else
            frame.origin.y=-30;
          break;
        case 5:
          if([self isIPhone])
            frame.origin.y=-12;
          else
            frame.origin.y=-35;
          break;
        case 6:
          if([self isIPhone])
            frame.origin.y=-12;
          else
            frame.origin.y=-40;
          break;
        case 7:
          if([self isIPhone])
            frame.origin.y=-15;
          else
            frame.origin.y=-40;
          break;
        case 8:
          if([self isIPhone])
            frame.origin.y=-15;
          else
            frame.origin.y=-45;
          break;
        default:
          break;
      }
      
      
      //lblCaption.frame=imgCard.frame;
      lblCaption.frame=frame;
      lblCaption.font = [UIFont systemFontOfSize:width];
      [lblCaption setMinimumFontSize:12];  // have to add this or won't work in ios 7
      lblCaption.textColor = [UIColor blackColor];
      
      [imgCard setImage:[UIImage imageNamed:@"empty_card_white.png"]];
      
      [self.view bringSubviewToFront:lblCaption];
    }else{
      
    }
  }
  if(([_userCard getCardID] == nil) && ![_userCard isCard] && ![_userCard isEmpty]){
    if([[_userCard getImageCustom] length] == 0){
      
      frame = imgCard.frame;
      
      switch (lblCaption.text.length) {
        case 1:
          ;
          break;
        case 2:
          if([self isIPhone])
            frame.origin.y=-4;
          else
            frame.origin.y=-10;
          break;
        case 3:
          if([self isIPhone])
            frame.origin.y=-9;
          else
            frame.origin.y=-25;
          break;
        case 4:
          if([self isIPhone])
            frame.origin.y=-10;
          else
            frame.origin.y=-30;
          break;
        case 5:
          if([self isIPhone])
            frame.origin.y=-12;
          else
            frame.origin.y=-35;
          break;
        case 6:
          if([self isIPhone])
            frame.origin.y=-12;
          else
            frame.origin.y=-40;
          break;
        case 7:
          if([self isIPhone])
            frame.origin.y=-15;
          else
            frame.origin.y=-40;
          break;
        case 8:
          if([self isIPhone])
            frame.origin.y=-15;
          else
            frame.origin.y=-45;
          break;
        default:
          break;
      }
      
      lblCaption.frame=frame;
      lblCaption.font = [UIFont systemFontOfSize:width];
      lblCaption.textColor = [UIColor blackColor];
      [imgCard setImage:[UIImage imageNamed:@"empty_card_white.png"]];
      [self.view bringSubviewToFront:lblCaption];
    }else{
      
    }
  }
  
  /////////////////////////////////////////////////
}
/////////////////////////////////////
#pragma touch events
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  //[self cardActiveEffect:YES];
  
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
  //[self cardActiveEffect:NO];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
  //[self cardActiveEffect:NO];
  NSLog(@"clicked aaccard");
  if(![_userCard isEmpty]){
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onClickAACCard" object:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"unsetAACCardActiveEffect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUnsetAACCardActiveEffect:) name:@"unsetAACCardActiveEffect" object:nil];
  }else{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onClickAACEmtpyCardForGame" object:self];
  }
  
}
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event

-(void)onChangeLang:(NSNotification *)notification{
  
}

-(void)cardActiveEffect:(BOOL)isActive{
  
  if(isActive){
    [self.view setAlpha:0.7];
    [self.view setBackgroundColor:[UIColor greenColor]];
  }else{
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.view setAlpha:1];
  }
}

-(void) onUnsetAACCardActiveEffect:(NSNotification *)notification{
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"unsetAACCardActiveEffect" object:nil];
  
  [self cardActiveEffect:NO];
  
}

-(void) onCheckIfAlive:(NSNotification *)notification{
//  NSLog(@"alive!");
}

-(BOOL)isIPhone{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return YES;
  }else{
    return NO;
  }
}
@end
