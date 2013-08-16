//
//  TimerVC.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "TimerVC.h"
#import <AudioToolbox/AudioServices.h>
#import "Timer.h"
#import "Times.h"

@interface TimerVC ()
@property (strong, nonatomic) Timer *timer;
@property NSInteger totalSeconds;
@property (strong, nonatomic) IBOutlet UILabel *secondsLabel;
@property (strong, nonatomic) IBOutlet UILabel *minutesLabel;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;
@end

@implementation TimerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTimer];
    [self setupTotalSeconds];
    [self resetView];
}
- (void)setupTimer {
    self.timer = [[Timer alloc] initWithMinutes:self.times.greenMinutes andSeconds:self.times.greenSeconds];
    self.timer.delegate = self;
}
- (void)setupTotalSeconds {
    self.totalSeconds = [Helper totalSecondsForMinutes:self.times.greenMinutes andSeconds:self.times.greenSeconds];
}
- (void)resetView {
    self.minutesLabel.text = [Helper unitStringForInteger:0];
    self.secondsLabel.text = [Helper unitStringForInteger:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)pauseButtonPress:(id)sender {
    [self toggleTimer];
}
- (void)toggleTimer {
    if ([self.timer isRunning]) {
        [self.timer pause];
        [self changeButtonToContinueTimer];
    } else {
        [self.timer start];
        [self changeButtonToPauseTimer];
    }
}

- (void)changeButtonToContinueTimer {
    [self.pauseButton setTitle:@"Continue" forState:UIControlStateNormal]; 
}
- (void)changeButtonToPauseTimer {
    [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
}
- (void)changeButtonToStartTimer {
    [self.pauseButton setTitle:@"Start" forState:UIControlStateNormal];
}

- (IBAction)resetButtonPress:(id)sender {
    [self.timer reset];
    [self resetView];
    [self changeButtonToStartTimer];
}


- (void)updateViewWithSeconds:(NSInteger)seconds {
    self.secondsLabel.text = [Helper unitStringForInteger:seconds];
    if (seconds >= self.totalSeconds) {
        [self handleFinishedTimer];
    }
}

- (void)handleFinishedTimer {
    [self alertUser];
    [self.timer reset];
    [self resetView];
}

- (void)alertUser {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Timer done" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}



@end
