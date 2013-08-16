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


#define START_TIME 5


@interface TimerVC ()
@property (strong, nonatomic) Timer *timer;
@property (strong, nonatomic) IBOutlet UILabel *secondsRemainingLabel;
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
}
- (void)setupTimer {
    self.timer = [[Timer alloc] initWithSeconds:START_TIME];
    self.timer.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self resetView];
}
- (void)resetView {
    self.secondsRemainingLabel.text = [NSString stringWithFormat:@"%d", START_TIME];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)startButtonPress:(id)sender {
    [self.timer start];
}
- (IBAction)pauseButtonPress:(id)sender {
    [self.timer pause];
}

- (IBAction)resetButtonPress:(id)sender {
    [self.timer reset];
    [self resetView];
}


- (void)updateViewWithSecondsRemaining:(NSInteger)secondsRemaining {
    self.secondsRemainingLabel.text = [NSString stringWithFormat:@"%d", secondsRemaining];
    if (secondsRemaining == 0) {
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
