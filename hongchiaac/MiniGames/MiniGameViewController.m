//
//  MiniGameViewController.m
//  hongchiaac
//
//  Created by Ray.Liu on 12/4/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "MiniGameViewController.h"

#pragma mark - UIViewController

@implementation MiniGameViewController

@synthesize myNavigationController;
@synthesize myParentController;
@synthesize myExtraData;

#pragma - UIViewController

- (id)initWithNavigationController:(UINavigationController *)navigationController ParentController:(UIViewController *)parentController ExtraData:(NSMutableDictionary *)extraData
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {
        myNavigationController = navigationController;
        myParentController = parentController;
        myExtraData = extraData;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    
}

- (void)dealloc
{
    [myNavigationController release];
    [myParentController release];
    [myExtraData release];
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

#pragma - MiniGameController

- (void)refresh
{
    
}

+ (void)fillCardsetArray:(NSMutableArray *)arraylist Cardset:(NSMutableArray *)cardset
{
    //NSLog(@"card count:%i", [cardset count]);
    
    for (int i = 0; i < [cardset count]; i++)
    {
        if ([[cardset objectAtIndex:i] objectForKey:@"cardset"] == nil)
        {
            NSMutableDictionary *card = [cardset objectAtIndex:i];
            NSString *card_id = [card objectForKey:@"card_id"];
            NSString *caption_tw = [card objectForKey:@"caption_tw"];
            NSString *caption_custom = [card objectForKey:@"caption_custom"];
            NSString *image_custom = [card objectForKey:@"image_custom"];
            NSString *voice_custom = [card objectForKey:@"voice_custom"];
            
            if (!([card_id isEqualToString:@"empty_card"] && [caption_custom isEqualToString:@""] && [caption_tw isEqualToString:@""] && [image_custom isEqualToString:@""] && [voice_custom isEqualToString:@""]))
            {
                //NSLog(@"array count:%i", [arraylist count]);
                if ([arraylist count] == 0)
                {
                    //NSLog(@"add %@", [[cardset objectAtIndex:i] objectForKey:@"card_id"]);
                    [arraylist addObject:[cardset objectAtIndex:i]];
                }
                else
                {
                    BOOL isRepeat = NO;
                    
                    for (int j = 0; j < [arraylist count]; j++)
                    {
                        //NSLog(@"check %i: %@ == %@",j , [[cardset objectAtIndex:i] objectForKey:@"card_id"], [[arraylist objectAtIndex:j] objectForKey:@"card_id"]);
                        
                        NSMutableDictionary *c_card = [arraylist objectAtIndex:j];
                        NSString *c_card_id = [c_card objectForKey:@"card_id"];
                        NSString *c_caption_tw = [c_card objectForKey:@"caption_tw"];
                        NSString *c_caption_custom = [c_card objectForKey:@"caption_custom"];
                        NSString *c_image_custom = [c_card objectForKey:@"image_custom"];
                        NSString *c_voice_custom = [c_card objectForKey:@"voice_custom"];
                        //NSString *c_is_card = [c_card objectForKey:@"is_card"];
                        
                        if ([card_id isEqualToString:c_card_id] && [caption_custom isEqualToString:c_caption_custom] && [caption_tw isEqualToString:c_caption_tw] && [voice_custom isEqualToString:c_voice_custom] && [image_custom isEqualToString:c_image_custom])
                        {
                            [card release];
                            [c_card release];
                            
                            isRepeat = YES;
                            break;
                        }
                        
                        /*
                        if ([[[cardset objectAtIndex:i] objectForKey:@"card_id"] isEqualToString:[[arraylist objectAtIndex:j] objectForKey:@"card_id"]])
                        {
                            //NSLog(@"same %@",[[cardset objectAtIndex:i] objectForKey:@"card_id"]);
                            isRepeat = YES;
                            break;
                        }
                        */
                    }
                    
                    if (!isRepeat)
                    {
                        //NSLog(@"add %@", [[cardset objectAtIndex:i] objectForKey:@"card_id"]);
                        [arraylist addObject:[cardset objectAtIndex:i]];
                    }
                }
            }
        }
        else
        {
            //NSLog(@"loop folder");
            [self fillCardsetArray:arraylist Cardset:[[cardset objectAtIndex:i] objectForKey:@"cardset"]];
        }
    }
}

+ (void)randomArray:(NSMutableArray *)arraylist
{
    NSUInteger count = [arraylist count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (arc4random() % nElements) + i;
        [arraylist exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

+ (NSMutableDictionary *)getEmptyCardContent
{
    NSMutableDictionary *emptyCardContent = [[NSMutableDictionary alloc] init];
    [emptyCardContent setValue:@"0" forKey:@"border_color_id"];
    [emptyCardContent setValue:@"" forKey:@"caption_custom"];
    [emptyCardContent setValue:@"empty_card" forKey:@"card_id"];
    [emptyCardContent setValue:@"" forKey:@"image_custom"];
    [emptyCardContent setValue:@"1" forKey:@"is_card"];
    [emptyCardContent setValue:@"" forKey:@"voice_custom"];
    
    return emptyCardContent;
}

#pragma utils_functions

#define LAYOUT_1X1  1
#define LAYOUT_1X2  2
#define LAYOUT_1X3  3
#define LAYOUT_2X4  4
#define LAYOUT_2x6  5
#define LAYOUT_3X6  6
+(int)getNumberOfCardPerPageFromLayout:(int)layoutID{
    
    if(layoutID == LAYOUT_1X1) return 1;
    if(layoutID == LAYOUT_1X2) return 2;
    if(layoutID == LAYOUT_1X3) return 3;
    if(layoutID == LAYOUT_2X4) return 8;
    if(layoutID == LAYOUT_2x6) return 12;
    if(layoutID == LAYOUT_3X6) return 18;
    
    return 0;
}
+(int)getColFromLayout:(int)layoutID{
    
    if(layoutID == LAYOUT_1X1) return 1;
    if(layoutID == LAYOUT_1X2) return 2;
    if(layoutID == LAYOUT_1X3) return 3;
    if(layoutID == LAYOUT_2X4) return 4;
    if(layoutID == LAYOUT_2x6) return 6;
    if(layoutID == LAYOUT_3X6) return 6;
    
    return 1;
}
+(int)getRowFromLayout:(int)layoutID{
    
    if(layoutID == LAYOUT_1X1) return 1;
    if(layoutID == LAYOUT_1X2) return 1;
    if(layoutID == LAYOUT_1X3) return 1;
    if(layoutID == LAYOUT_2X4) return 2;
    if(layoutID == LAYOUT_2x6) return 2;
    if(layoutID == LAYOUT_3X6) return 3;
    
    return 1;
}
+(int)getCardSize:(int)layoutID{
    if(layoutID == LAYOUT_1X1) return 500;
    if(layoutID == LAYOUT_1X2) return 460;
    if(layoutID == LAYOUT_1X3) return 380;
    if(layoutID == LAYOUT_2X4) return 240;
    if(layoutID == LAYOUT_2x6) return 190;
    if(layoutID == LAYOUT_3X6) return 166;
    
    return 1;
}
+(int)getCardXMargin:(int)layoutID{
    if(layoutID == LAYOUT_1X1) return 460;
    if(layoutID == LAYOUT_1X2) return 460;
    if(layoutID == LAYOUT_1X3) return 340;
    if(layoutID == LAYOUT_2X4) return 250;
    if(layoutID == LAYOUT_2x6) return 170;
    if(layoutID == LAYOUT_3X6) return 170;
    
    return 1;
}
+(int)getCardYMargin:(int)layoutID{
    if(layoutID == LAYOUT_1X1) return 460;
    if(layoutID == LAYOUT_1X2) return 460;
    if(layoutID == LAYOUT_1X3) return 460;
    if(layoutID == LAYOUT_2X4) return 260;
    if(layoutID == LAYOUT_2x6) return 240;
    if(layoutID == LAYOUT_3X6) return 166;
    
    return 1;
}
+(int)getCardCountByLayout:(int)layoutID{
    if(layoutID == LAYOUT_1X1) return 1;
    if(layoutID == LAYOUT_1X2) return 2;
    if(layoutID == LAYOUT_1X3) return 3;
    if(layoutID == LAYOUT_2X4) return 8;
    if(layoutID == LAYOUT_2x6) return 12;
    if(layoutID == LAYOUT_3X6) return 18;
    return 1;
}

@end
