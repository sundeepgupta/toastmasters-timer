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
#import "ColorAlertView.h"




@interface TimerVC ()
@property (strong, nonatomic) Timer *timer;
@property NSInteger seconds;
@property NSInteger minutes;
@property (strong, nonatomic) IBOutlet UILabel *secondsLabel;
@property (strong, nonatomic) IBOutlet UILabel *minutesLabel;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;
@property (strong, nonatomic) IBOutlet UILabel *greenMinutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *greenSecondsLabel;
@property (strong, nonatomic) IBOutlet UILabel *amberMinutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *amberSecondsLabel;
@property (strong, nonatomic) IBOutlet UILabel *redMinutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *redSecondsLabel;
@property (strong, nonatomic) IBOutlet UILabel *bellMinutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *bellSecondsLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *timerLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *greenLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *amberLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *redLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *bellLabels;
@property (strong, nonatomic) IBOutlet UIButton *soundBellButton;
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
    [self resetTimerUnits];
    [self setupTimesLabels];
    [self setupView];
}


- (void)setupTimer {
    self.timer = [[Timer alloc] init];
    self.timer.delegate = self;
}

- (void)resetTimerUnits {
    self.seconds = 0;
    self.minutes = 0;
    [self updateTimerLabels];
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
    self.redMinutesLabel.text = [Helper unitStringForNumber:red[@"minutes"]];
    self.redSecondsLabel.text = [Helper unitStringForNumber:red[@"seconds"]];
    self.bellMinutesLabel.text = [Helper unitStringForNumber:bell[@"minutes"]];
    self.bellSecondsLabel.text = [Helper unitStringForNumber:bell[@"seconds"]];
}

- (void)setupView {
    [Helper updateSoundBellButton:self.soundBellButton forSetting:[self.settings[@"shouldSoundBell"] boolValue]];
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
    [self setPauseButtonImageWithName:@"play.png"];
}
- (void)changeButtonToPauseTimer {
    [self setPauseButtonImageWithName:@"pause.png"];
}
- (void)setPauseButtonImageWithName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    [self.pauseButton setBackgroundImage:image forState:UIControlStateNormal];
}

- (IBAction)resetButtonPress:(id)sender {
    [self.timer reset];
    [self resetTimerUnits];
    [self changeButtonToContinueTimer];
}


- (void)updateElaspedSeconds:(NSInteger)seconds {
    [self updateTimerLabelsWithSeconds:seconds];
    [self assertColorChangeForSeconds:seconds];
}
- (void)updateTimerLabelsWithSeconds:(NSInteger)seconds {
    self.minutes = floor(seconds/60);
    if (self.minutes == 100) {
        [self rollMinutesOver];
    }
    
    self.seconds = seconds%60;
    
    [self updateTimerLabels];
}
- (void)rollMinutesOver {
    self.minutes = 0;
    [self.timer restart];
}

- (void)updateTimerLabels {
    self.minutesLabel.text = [Helper unitStringForInteger:self.minutes];
    self.secondsLabel.text = [Helper unitStringForInteger:self.seconds];
}

- (void)assertColorChangeForSeconds:(NSInteger)seconds {
    for (NSString *key in self.colors) {
        NSMutableDictionary *color = self.colors[key];
        
        NSInteger minutes = [Helper integerForNumber:color[@"minutes"]];
        NSInteger seconds = [Helper integerForNumber:color[@"seconds"]];
        
        if (minutes == self.minutes  &&  seconds == self.seconds) {
            [self alertReachedColor:key];
        }
    }
}

- (void)alertReachedColor:(NSString *)color {
    [self showAlertForColor:color];
    [self vibrateDevice];
    [self emphasizeLabelsForColor:color];
    
    if ([color isEqualToString:@"bell"]) {
        [self processAlertForBell];
    }
}
- (void)showAlertForColor:(NSString *)color {
    NSString *title = [NSString stringWithFormat:@"Turn %@ on", color];
    ColorAlertView *alert = [[ColorAlertView alloc] initWithTitle:title];
    [alert show];
}
- (void)vibrateDevice {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
- (void)emphasizeLabelsForColor:(NSString *)color {
    if ([color isEqualToString:@"green"]) {
        [self boldLabels:self.greenLabels];
    } else if ([color isEqualToString:@"amber"]){
        [self boldLabels:self.amberLabels];
    } else if ([color isEqualToString:@"red"]){
        [self boldLabels:self.redLabels];
    } else if ([color isEqualToString:@"bell"]){
        [self boldLabels:self.bellLabels];
    }
}
- (void)boldLabels:(NSArray *)labels {
    for (UILabel *label in labels) {
        UIFont *font = label.font;
        CGFloat fontSize = font.pointSize ;
        UIFont *newFont = [UIFont boldSystemFontOfSize:fontSize];
        label.font = newFont;
    }
}
- (void)processAlertForBell {
    NSNumber *shouldSoundBellNumber = self.settings[@"shouldSoundBell"];
    BOOL shouldSoundBell = shouldSoundBellNumber.boolValue;
    if (shouldSoundBell) {
        [self soundBell];
    }
}
- (void)soundBell {
    AudioServicesPlaySystemSound(1025);
}

- (IBAction)backButtonPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)soundBellButtonPress:(id)sender {
    [self toggleSoundBell];
    [Helper updateSoundBellButton:self.soundBellButton forSetting:[self.settings[@"shouldSoundBell"] boolValue]];
}
- (void)toggleSoundBell {
    BOOL shouldSoundBell = [self.settings[@"shouldSoundBell"] boolValue];
    if (shouldSoundBell) {
        self.settings[@"shouldSoundBell"] = @NO;
    } else {
        self.settings[@"shouldSoundBell"] = @YES;
    }
}

@end
