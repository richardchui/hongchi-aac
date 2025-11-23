//
//  SummaryViewController.m
//  hongchiaac
//
//  Created by OEM on 6/2/13.
//  Copyright (c) 2013 OEM. All rights reserved.
//

#import "SummaryViewController.h"
#import "SummaryItemViewController.h"
#import "Handlers/ProfileHandler.h"
#import "Handlers/SettingHandler.h"
#import "Utils.h"

@interface SummaryViewController ()

@end

@implementation SummaryViewController
@synthesize scrollView;
@synthesize arrViewPages;
#define PROFILE_PER_PAGE 6
#define PLIST_PROFILE @"profiles.plist"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Do any additional setup after loading the view.
  
  /*
   self.arrViewPages = [[NSMutableArray alloc] init];
   
   arrProfiles = [[NSMutableArray alloc] init];
   dictProfiles = [ProfileHandler getAllProfiles];
   
   for(NSString *key in dictProfiles){
   //[arrProfiles addObject:key];
   [arrProfiles addObject:[[UserProfile alloc] initWithProfileID:key]];
   }
   
   [self reorderProfileArray];
   
   numOfPage = ceil((float)[arrProfiles count]/(float)PROFILE_PER_PAGE);
   
   
   [self initScrollView];
   */
  
  // Also need to reload this page when a new profile is imported
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"reloadListForImportedProfile" object:nil];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  [SettingHandler setSafeImport:FALSE];  // may not have been called
}

-(void)viewWillAppear:(BOOL)animated{
  //[self reload];
  
  [super viewWillAppear:animated];
  [SettingHandler setSafeImport:TRUE];
  NSLog(@"Safe to import");
  
  NSLog(@"Setting scrollview");
  [self.scrollView setContentOffset:CGPointZero animated:YES];
  
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [SettingHandler setSafeImport:FALSE];
  NSLog(@"Not safe to import");
  NSLog(@"Summary screen disappearing");
  
}

- (void)dealloc{
  
  
  [scrollView release];
  [arrViewPages release];
  [arrProfiles release];
  [dictProfiles release];
  
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
-(void)reload{
  [arrProfiles release];
  
  arrProfiles = [[NSMutableArray alloc] init];
  dictProfiles = [ProfileHandler getAllProfiles];
  
  NSLog(@"summeryViewController.reload ----------------------");
  NSLog(@"dictProfiles count: %d",[dictProfiles count]);
  
  NSDictionary *content = [Utils getContentFromPlist:PLIST_PROFILE];
  
  for(NSString *key in dictProfiles){
    //[arrProfiles addObject:key];
    [arrProfiles addObject:[[UserProfile alloc] initWithProfileID:key withPlist:content]];
  }
  [self reorderProfileArray];
  
  numOfPage = ceil((float)[arrProfiles count]/(float)PROFILE_PER_PAGE);
  
  for(UIView *subview in [scrollView subviews]) {
    /*
     for(UIView *subSubView in [subview subviews]) {
     [subSubView removeFromSuperview];
     //[subSubView release];
     }
     */
    [subview removeFromSuperview];
    //[subview release];
  }
  
  [self initScrollView];
  
  [content release];
  
  // Need to add this for iPhone
  NSLog(@"Setting scrollview");
  [self.scrollView setContentOffset:CGPointZero animated:YES];
  
  [SettingHandler setSafeImport:TRUE];
  NSLog(@"Safe to import");
}

-(void)initScrollView{
  NSMutableArray *pages = [[NSMutableArray alloc] init];
  for(unsigned i = 0 ; i < numOfPage ; i++){
    [pages addObject:[NSNull null]];
  }
  self.arrViewPages = pages;
  [pages release];
  
  scrollView.pagingEnabled = YES;
  scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height * numOfPage );
  scrollView.showsHorizontalScrollIndicator = NO;
  scrollView.showsVerticalScrollIndicator = YES;
  scrollView.scrollsToTop = NO;
  scrollView.delegate = self;
  
  [self loadScrollViewWithPage:0];
  [self loadScrollViewWithPage:1];
}
-(void)loadScrollViewWithPage:(int)page{
  if(page<0 || page>=numOfPage) return;
  
  UIView *viewPage = [arrViewPages objectAtIndex:page];
  if((NSNull *)viewPage == [NSNull null]){
    viewPage = [[UIView alloc] init];
    [arrViewPages replaceObjectAtIndex:page withObject:viewPage];
    //[viewPage release];
  }
  
  if(nil == viewPage.superview){
    CGRect frame = scrollView.frame;
    frame.origin.x = 0;//frame.size.width * page;
    frame.origin.y = frame.size.height*page;//0;
    viewPage.frame = frame;
    
    [self initPageWithPageNum:page forPage:viewPage];
    
    [scrollView addSubview:viewPage];
  }
}
-(void)initPageWithPageNum:(int)page forPage:(UIView *)viewPage{
  int tempCounter  = 0;
  
  for (int i = (page)*PROFILE_PER_PAGE ; i<((page+1)*PROFILE_PER_PAGE) && i<[arrProfiles count]; i++) {
    
    
    SummaryItemViewController *item = [[SummaryItemViewController alloc] initWithProfileID:[(UserProfile *)[arrProfiles objectAtIndex:i] getProfileID]];
    
    [viewPage addSubview:item.view];
    item.lblProfileName.text = [[dictProfiles objectForKey:[arrProfiles objectAtIndex:i]] objectForKey:@"name"];
    
    NSLog(@"profile : %@", [arrProfiles objectAtIndex:i]);
    
    item.lblProfileName.text = [(UserProfile *)[arrProfiles objectAtIndex:i] getName];
    
    NSString *imagePath = [[NSString alloc] initWithFormat:@"/profiles/%@/%@.jpg",[(UserProfile *)[arrProfiles objectAtIndex:i] getProfileID],@"profilepic"];
    //NSLog(@"profile image path : %@",[Utils getFullPath:imagePath]);
    if([Utils isFileExist:imagePath]){
      //NSLog(@"file exist");
      item.imgProfilePic.image = [Utils resizeImageWithImage:[UIImage imageWithContentsOfFile:[Utils getFullPath:imagePath]] toSize:CGSizeMake(300, 300)];
    }else{
      //NSLog(@"file not exist");
      item.imgProfilePic.image = [Utils resizeImageWithImage:[UIImage imageNamed:@"default_profile_picture.jpg"] toSize:CGSizeMake(300, 300)];
    }
    
    [imagePath release];
    
    
    CGRect frame = item.view.frame;
    frame.origin.x = (tempCounter % 3) * 340 + (viewPage.frame.size.width - frame.size.width * 3)/3/2;
    frame.origin.y = (int)floor(((float)tempCounter / (float)3)) * 380 + (viewPage.frame.size.height - frame.size.height * 2)/2/2;
    
    item.view.frame = frame;
    tempCounter++;
  }
  
  
  
}
-(void)reorderProfileArray{
  
  //NSLog(@"%@",arrProfiles);
  NSMutableArray *sortedArray = [[NSMutableArray alloc] initWithArray:[arrProfiles sortedArrayUsingSelector:@selector(compare:)]];
  //NSLog(@"%@",sortedArray);
  /*
   for(int i=0; i<[sortedArray count]; i++){
   //        [[sortedArray objectAtIndex:i] updateOrder:i];
   
   }
   */
  [arrProfiles release];
  arrProfiles = sortedArray;
  sortedArray = nil;
  
}
#pragma scrollView
-(void)scrollViewDidScroll:(UIScrollView *)_scrollView{
  if(pageControlUsed){
    return;
  }
  
  CGFloat pageHeight = scrollView.frame.size.height;
  int page = floor((scrollView.contentOffset.y - pageHeight /2) / pageHeight) + 1;
  
  [self loadScrollViewWithPage:page-1];
  [self loadScrollViewWithPage:page];
  [self loadScrollViewWithPage:page+1];
  
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  pageControlUsed = NO;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  pageControlUsed = NO;
}

@end
