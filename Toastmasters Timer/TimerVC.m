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


@interface TimerVC ()
@property (strong, nonatomic) Timer *timer;
@property (strong, nonatomic) NSDictionary *lastColor;
@property NSInteger totalSeconds;
@property (strong, nonatomic) IBOutlet UILabel *secondsLabel;
@property (strong, nonatomic) IBOutlet UILabel *minutesLabel;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;

@property (strong, nonatomic) IBOutlet UILabel *greenMinutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *greenSecondsLabel;
@property (strong, nonatomic) IBOutlet UILabel *amberMinutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *amberSecondsLabel;


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
    [self setupLastColor];
    [self setupTimer];
    [self setupTotalSeconds];
    [self setupTimesLabels];
    [self resetView];
}
- (void)setupTimer {
    NSNumber *minutes = self.lastColor[@"minutes"];
    NSNumber *seconds = self.lastColor[@"seconds"];
    
    self.timer = [[Timer alloc] initWithMinutes:minutes.integerValue andSeconds:seconds.integerValue];
    self.timer.delegate = self;
}
- (void)setupLastColor {
    self.lastColor = self.colors[@"amber"];
}
- (void)setupTotalSeconds {
    NSNumber *minutes = self.lastColor[@"minutes"];
    NSNumber *seconds = self.lastColor[@"seconds"];
    self.totalSeconds = [Helper totalSecondsForMinutes:minutes.integerValue  andSeconds:seconds.integerValue];
}
- (void)setupTimesLabels {
    NSDictionary *green = self.colors[@"green"];
    NSDictionary *amber = self.colors[@"amber"];
    NSDictionary *red = self.colors[@"red"];
    NSDictionary *bell = self.colors[@"bell"];
    
    self.greenMinutesLabel.text = [Helper unitStringForNumber:green[@"minutes"]];
    self.greenSecondsLabel.text = [Helper unitStringForNumber:green[@"seconds"]];
    self.amberMinutesLabel.text = [Helper unitStringForNumber:amber[@"minutes"]];
    self.amberSecondsLabel.text = [Helper unitStringForNumber:amber[@"seconds"]];
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
