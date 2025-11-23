//
//  RecorderViewController.m
//  hongchiaac
//
//  Created by OEM on 27/11/12.
//  Copyright (c) 2012 OEM. All rights reserved.
//

#import "RecorderViewController.h"
#import "AudioToolbox/AudioToolbox.h"
#import "Constants.h"
#import "Handlers/SettingHandler.h"
#import "Utils.h"


@interface RecorderViewController ()

@end

@implementation RecorderViewController

@synthesize btnCancel,btnOK,btnStartStop,btnPlay,btnDelete,btnRec,btnStop,imgRec,viewProgressBar,lblSecond;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletedCustomVoice:) name:@"deletedCustomVoice" object:nil];
    
    // Do any additional setup after loading the view from its nib.
    isRecording = NO;
    
    ///////
    audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    
	if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
	[audioSession setActive:YES error:&err];
	err = nil;
	if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
    
    recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    NSString *fileName = @"tempRecordedSound";
    NSString *recorderFilePath = [Utils getFullPath:[NSString stringWithFormat:@"%@.caf",fileName]];
    
    NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
    err = nil;
    
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    if(!recorder){
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: [err localizedDescription]
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }

    
	BOOL audioHWAvailable = audioSession.inputIsAvailable;
	if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: @"Audio input hardware not available"
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [cantRecordAlert show];
        [cantRecordAlert release];
        return;
	}
    //////
    [self setLanguage:[SettingHandler getApplicationLanguage]];
    
    hasCustomVoice = NO;
    isRecorded = NO;
    //customVoicePath = @"";
    
    currentSecond = 0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [imgRec release];
    [btnStop release];
    [btnRec release];
    [btnStartStop release];
    [btnOK release];
    [btnCancel release];
    [btnPlay release];
    
    [recordTimer release];
    [audioPlayer release];
    [recorder release];
    [recordSetting release];
    
    [customVoicePath release];
    
    [viewProgressBar release];
    
    [lblSecond release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deletedCustomVoice" object:nil];
    
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

-(void)resetRecorder{
    NSString *fileName = @"tempRecordedSound.caf";
    [Utils deleteFile:fileName path:@""];
    
    [btnCancel setEnabled:YES];
    [btnOK setEnabled:NO];
    [btnPlay setEnabled:NO];
    [btnStartStop setEnabled:YES];
}
-(void)setCustomVoice:(NSString *)path{
    hasCustomVoice = YES;
    customVoicePath = [[NSString alloc] initWithString:path];

    
    [btnPlay setEnabled:YES];
    [btnDelete setEnabled:YES];
}
///////////
-(IBAction)onClickStartStop:(id)sender{
    [self toggleStartStopRec];
}
-(IBAction)onClickRec:(id)sender{
    if(!isRecording)
        [self startRecord];
}
-(IBAction)onClickStop:(id)sender{
    [self stopRecord];
}
-(IBAction)onClickOK:(id)sender{
    //[self saveAndExit];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
    [self performSelector:@selector(saveAndExit) withObject:nil afterDelay:0.1];
}
-(IBAction)onClickCancel:(id)sender{
    [self exit];
}
-(IBAction)onClickPlay:(id)sender{
    [self playRecord];
}
-(IBAction)onClickDelete:(id)sender{
    [self deleteVoice];
}
/////////////
-(void)toggleStartStopRec{
    /*
    if(isRecording){
        
        [btnOK setEnabled:YES];
        [btnCancel setEnabled:YES];
        [btnPlay setEnabled:YES];
        
        //[btnStartStop setTitle:@"REC" forState:UIControlStateNormal];

            
        if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]])
            [btnStartStop setTitle:[Utils getText:@"錄音" ForLang:[Constants getLanguageCodeTW] atView:@"RecorderViewController"] forState:UIControlStateNormal];
        if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeCN]])
            [btnStartStop setTitle:[Utils getText:@"錄音" ForLang:[Constants getLanguageCodeCN] atView:@"RecorderViewController"] forState:UIControlStateNormal];
        
        [self stopRecord];
         
    }else{
        [btnOK setEnabled:NO];
        [btnCancel setEnabled:NO];
        [btnPlay setEnabled:NO];
        
        [btnStartStop setTitle:@"停止" forState:UIControlStateNormal];
        [self startRecord];
    }
     */
}
-(void)startRecord{
    [btnRec setEnabled:NO];
    [btnStop setEnabled:YES];
    [btnOK setEnabled:NO];
    [btnCancel setEnabled:NO];
    [btnPlay setEnabled:NO];
    [imgRec setImage:[UIImage imageNamed:@"img_recording_rec_on.png"]];
    
    NSString *fileName = @"tempRecordedSound";
    NSString *recorderFilePath = [Utils getFullPath:[NSString stringWithFormat:@"%@.caf",fileName]];
    NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
    
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:NULL];
    [recorder setDelegate:self];
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    [recorder recordForDuration:5];
    isRecording = YES;
    isRecorded = YES;
    
    //start counter
    /*
    [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                  target: self
                                                selector:@selector(updateProgressBar:)
                                                userInfo: nil repeats:NO];
    */
//    [self performSelector:@selector(updateProgressBar:) withObject:nil afterDelay:1.0];
    [NSTimer scheduledTimerWithTimeInterval: 1
                                             target: self
                                           selector: @selector(updateProgressBar)
                                           userInfo: nil
                                            repeats: NO];
    
    CGRect frame = viewProgressBar.frame;
    frame.size.width = 0;
    viewProgressBar.frame = frame;
    
    [lblSecond setText:@"0"];
}
-(void)stopRecord{
    [btnRec setEnabled:YES];
    [btnStop setEnabled:NO];
    [btnOK setEnabled:YES];
    [btnCancel setEnabled:YES];
    [btnPlay setEnabled:YES];
    [imgRec setImage:[UIImage imageNamed:@"img_recording_rec_off.png"]];
    
    [recorder stop];
    
    CGRect frame = viewProgressBar.frame;
    frame.size.width = 0;
    viewProgressBar.frame = frame;
    
    [lblSecond setText:@""];
    currentSecond = 0;
}
-(void)playRecord{
    NSString *fileName = @"tempRecordedSound";
    NSString *tempFilePath = [Utils getFullPath:[NSString stringWithFormat:@"%@.caf",fileName]];

	if([[NSFileManager defaultManager] isReadableFileAtPath:tempFilePath]){
		[audioPlayer stop];
		if(!audioPlayer.isPlaying){
            
			NSURL *url;
			url = [NSURL fileURLWithPath:tempFilePath];
            
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.delegate = self;
			
			[audioPlayer play];
			//[url release];
            
            [btnRec setEnabled:NO];
            [btnStop setEnabled:NO];
            [btnPlay setEnabled:NO];
            //[btnStartStop setEnabled:NO];
            [btnCancel setEnabled:NO];
            [btnOK setEnabled:NO];
             
		}
	}else{
        NSLog(@"nofile");
        if(hasCustomVoice){

			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:customVoicePath] error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.delegate = self;
			
			[audioPlayer play];
            
            [btnRec setEnabled:NO];
            [btnStop setEnabled:NO];
            [btnPlay setEnabled:NO];
            [btnCancel setEnabled:NO];
            [btnOK setEnabled:NO];
        }else{
            NSLog(@"no customvoice ");
        }
    }
}
-(void)exit{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onExitRecorder" object:self];
}
-(void)saveAndExit{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onSaveAndExitRecorder" object:self];
    
}
-(void)deleteVoice{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:actionSheetDelete otherButtonTitles:actionSheetCancel,nil];
    [as setTag:1];
    [as showInView:self.view];
    [as release];

}

-(void)setDeleteButtonEnable:(BOOL)isEnable{
    if(hasCustomVoice){
        [btnDelete setEnabled:YES];
    }else{
        [btnDelete setEnabled:NO];
    }
}
///////////////////////
#pragma mark - record delegate
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
	NSLog(@"audioRecorderDidFinishRecording:Successfully:");
	UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty( kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    
    isRecording = NO;
    
    [btnRec setEnabled:YES];
    [btnStop setEnabled:NO];
    [btnOK setEnabled:YES];
    [btnCancel setEnabled:YES];
    [btnPlay setEnabled:YES];
    
    [imgRec setImage:[UIImage imageNamed:@"img_recording_rec_off.png"]];
//    [btnStartStop setTitle:@"REC" forState:UIControlStateNormal];
//    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeTW]])
        
        //[btnStartStop setTitle:[Utils getText:@"錄音" ForLang:[Constants getLanguageCodeTW] atView:@"RecorderViewController"] forState:UIControlStateNormal];
//    if([[SettingHandler getApplicationLanguage] isEqualToString:[Constants getLanguageCodeCN]])
        //[btnStartStop setTitle:[Utils getText:@"錄音" ForLang:[Constants getLanguageCodeCN] atView:@"RecorderViewController"] forState:UIControlStateNormal];
}
#pragma mark - player delegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [btnRec setEnabled:YES];
    [btnStop setEnabled:NO];
    [btnPlay setEnabled:YES];
//    [btnStartStop setEnabled:YES];
    [btnCancel setEnabled:YES];
    
    if(isRecorded){
        [btnOK setEnabled:YES];
    }else{
        [btnOK setEnabled:NO];
    }
}

-(void)deletedCustomVoice:(NSNotification *)notification{
    NSLog(@"deletedCustomVoice");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLoading" object:self];
}

#pragma actionsheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == 1){
        if(buttonIndex==0){
            //NSLog(@"delete");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"onClickDelSoundFromRecorder" object:self];
            
            if(hasCustomVoice){
                hasCustomVoice=NO;
                [self setDeleteButtonEnable:NO];
            }
        }
    }
}

#pragma language
-(void)onApplicatoinChangeLang:(NSNotification *)notification{
    [self setLanguage:notification.object];   
}
-(void)setLanguage:(NSString *)lang{

    if([lang isEqualToString:[Constants getLanguageCodeTW]]){
        //[btnStartStop setTitle:[Utils getText:@"錄音" ForLang:[Constants getLanguageCodeTW] atView:@"RecorderViewController"] forState:UIControlStateNormal];
       // [btnOK setTitle:[Utils getText:@"確定" ForLang:[Constants getLanguageCodeTW] atView:@"RecorderViewController"] forState:UIControlStateNormal];
        //[btnDelete setTitle:[Utils getText:@"刪除" ForLang:[Constants getLanguageCodeTW] atView:@"RecorderViewController"] forState:UIControlStateNormal];
        
        actionSheetDelete = [Utils getText:@"刪除" ForLang:[Constants getLanguageCodeTW] atView:@"RecorderViewController"];
        actionSheetCancel = [Utils getText:@"取消" ForLang:[Constants getLanguageCodeTW] atView:@"ActionSheet"];
    }
    
    if([lang isEqualToString:[Constants getLanguageCodeCN]]){
        //[btnStartStop setTitle:[Utils getText:@"錄音" ForLang:[Constants getLanguageCodeCN] atView:@"RecorderViewController"] forState:UIControlStateNormal];
        //[btnOK setTitle:[Utils getText:@"確定" ForLang:[Constants getLanguageCodeCN] atView:@"RecorderViewController"] forState:UIControlStateNormal];
        //[btnDelete setTitle:[Utils getText:@"刪除" ForLang:[Constants getLanguageCodeCN] atView:@"RecorderViewController"] forState:UIControlStateNormal];
        
        actionSheetDelete = [Utils getText:@"刪除" ForLang:[Constants getLanguageCodeCN] atView:@"RecorderViewController"];
        actionSheetCancel = [Utils getText:@"取消" ForLang:[Constants getLanguageCodeCN] atView:@"ActionSheet"];
    }
     
    
}

#pragma counter
-(void)updateProgressBar{
    if(![recorder isRecording])return;
    
    currentSecond += 1;
    NSLog(@"counter  :%d",currentSecond);
    
    CGRect frame = viewProgressBar.frame;
    frame.size.width = currentSecond * 40;
    viewProgressBar.frame = frame;
    
    if(currentSecond==5){
        currentSecond = 0;
        [lblSecond setText:@""];
    }else{
        [lblSecond setText:[NSString stringWithFormat:@"%d",currentSecond]];
        [NSTimer scheduledTimerWithTimeInterval: 1
                                         target: self
                                       selector: @selector(updateProgressBar)
                                       userInfo: nil
                                        repeats: NO];
    }
    
}
@end
