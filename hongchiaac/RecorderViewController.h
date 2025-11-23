//
//  RecorderViewController.h
//  hongchiaac
//
//  Created by OEM on 27/11/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RecorderViewController : UIViewController<AVAudioPlayerDelegate,AVAudioRecorderDelegate, UIActionSheetDelegate>{
    UIButton *btnStartStop;
    
    UIButton *btnRec;
    UIButton *btnStop;
    
    UIButton *btnOK;
    UIButton *btnCancel;
    UIButton *btnPlay;
    UIButton *btnDelete;
    
    NSTimer *recordTimer;
    float counter;
    BOOL isRecording;
    
    UIImageView *imgRec;
    
    AVAudioPlayer *audioPlayer;
    AVAudioSession *audioSession;
    AVAudioRecorder *recorder;
    NSMutableDictionary *recordSetting;
    
    BOOL hasCustomVoice;
    NSString *customVoicePath;
    
    BOOL isRecorded;
    
    UIView * viewProgressBar;
    
    int currentSecond;
    
    UILabel *lblSecond;
    
    NSString *actionSheetDelete;
    NSString *actionSheetCancel;
}

-(void)resetRecorder;
-(void)setCustomVoice:(NSString *)path;

@property (retain,nonatomic)IBOutlet UIButton *btnStartStop;
@property (retain,nonatomic)IBOutlet UIButton *btnOK;
@property (retain,nonatomic)IBOutlet UIButton *btnCancel;
@property (retain,nonatomic)IBOutlet UIButton *btnPlay;
@property (retain,nonatomic)IBOutlet UIButton *btnDelete;

@property (retain,nonatomic)IBOutlet UIButton *btnRec;
@property (retain,nonatomic)IBOutlet UIButton *btnStop;
@property (retain,nonatomic)IBOutlet UIImageView *imgRec;

@property (retain,nonatomic)IBOutlet UIView * viewProgressBar;
@property (retain,nonatomic)IBOutlet UILabel *lblSecond;

@property (retain,nonatomic) AVAudioPlayer *recordPlayer;

-(IBAction)onClickStartStop:(id)sender;
-(IBAction)onClickRec:(id)sender;
-(IBAction)onClickStop:(id)sender;
-(IBAction)onClickOK:(id)sender;
-(IBAction)onClickCancel:(id)sender;
-(IBAction)onClickPlay:(id)sender;
-(IBAction)onClickDelete:(id)sender;

-(void)startRecord;
-(void)stopRecord;
-(void)playRecord;
-(void)exit;

-(void)updateProgressBar;
@end
