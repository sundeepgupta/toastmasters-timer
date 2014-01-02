//
//  TimerVC.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "TimerVC.h"
#import "Timer.h"
#import "TimeEntryVC.h"
#import "SGDeepCopy.h"
#import "InfoVC.h"
#import "AlertManager.h"
#import "ColorButton.h"


@interface TimerVC ()
@property (strong, nonatomic) Timer *timer;
@property (strong, nonatomic) AlertManager *alertManager;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (nonatomic, strong) NSArray *colorArray;
@property NSInteger timerSeconds;
@property (strong, nonatomic) TimeEntryVC *timeEntryVc;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;
@property (strong, nonatomic) IBOutlet UIButton *audioAlertButton;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet ColorButton *greenButton;
@property (strong, nonatomic) IBOutlet ColorButton *amberButton;
@property (strong, nonatomic) IBOutlet ColorButton *redButton;
@property (strong, nonatomic) IBOutlet ColorButton *bellButton;
@property (nonatomic, strong) NSArray *colorButtons;
@end


@implementation TimerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupColorButtons];
    [self setupDefaults];
    [self setupTimer];
    [self setupAlertManager];
    [self resetTimerUnits];
    [self setupAlertButton];
}

- (void)setupColorButtons {
    self.colorButtons = @[self.greenButton, self.amberButton, self.redButton, self.bellButton];
}

- (void)setupDefaults {
    self.defaults = [NSUserDefaults standardUserDefaults];
    [self.defaults setBool:NO forKey:SHOULD_AUDIO_ALERT_KEY];
}


- (void)setupTimer {
    self.timer = [[Timer alloc] init];
    self.timer.delegate = self;
}
- (void)resetTimerUnits {
    self.timerSeconds = 0;
    [self updateTimerLabel];
}

- (void)setupAlertManager {
    self.alertManager = [[AlertManager alloc] initWithTimer:self.timer timerVC:self defaults:self.defaults];
}

- (void)setupAlertButton {
    if ([self.defaults boolForKey:SHOULD_AUDIO_ALERT_KEY]) {
        self.audioAlertButton.alpha = 1;
    } else {
        self.audioAlertButton.alpha = DISABLED_ALPHA;
    }
}

#pragma mark - View Will Appear
- (void)viewWillAppear:(BOOL)animated {
    [self setupColorArray];
    [self setupColorLabels];
}

- (void)setupColorArray {
    self.colorArray = [self.defaults arrayForKey:COLOR_TIMES_KEY];
}

- (void)setupColorLabels {
    for (ColorIndex i = kGreen; i < kColorIndexCount; i++) {
        [self setupColorLabelForColorName:i];
    }
}
- (void)setupColorLabelForColorName:(ColorIndex)i {
    NSInteger seconds = [self.colorArray[i] integerValue];
    ColorButton *button = self.colorButtons[i];
    [self setupTitleForButton:button withSeconds:seconds];
}
- (void)setupTitleForButton:(ColorButton *)button withSeconds:(NSInteger)seconds {
    NSString *title = [Helper stringForTotalSeconds:seconds];
    [Helper updateTitle:title forButton:button];
}

#pragma mark - Emphasize Color Labels
- (void)emphasizeColorWithIndex:(ColorIndex)index {
    ColorButton *button = self.colorButtons[index];
    [button emphasize];
}

- (void)deEmphasizeColorWithIndex:(ColorIndex)index {
    ColorButton *button = self.colorButtons[index];
    [button deEmphasize];
}

- (void)deEmphasizeAllColors {
    for (ColorButton *button in self.colorButtons) {
        [button deEmphasize];
    }
}

- (void)toggleEmphasisForColorWithIndex:(ColorIndex)index {
    ColorButton *button = self.colorButtons[index];
    [button toggleEmphasis];
}



#pragma mark - Timer Controls
- (IBAction)pauseButtonPress:(id)sender {
    [self toggleTimer];
}
- (void)toggleTimer {
    TIMER_STATUS status = [self.timer status];
    if (status == RUNNING) {
        [self pauseTimer];
        [self.alertManager cancelLocalNotifications];
    } else {
        [self startTimerWithStatus:status];
        [self.alertManager setupLocalNotifications];
    }
}
- (void)pauseTimer {
    [self.timer pause];
    [self changeButtonToContinueTimer];
}

- (void)startTimerWithStatus:(TIMER_STATUS)status {
    if (status == PAUSED) {
        [self.timer unpause];
    } else { //status is stopped
        [self.timer startFromStopped];
    }
    [self changeButtonToPauseTimer];
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

- (IBAction)stopButtonPress:(id)sender {
    [self.timer stop];
    [self resetTimerUnits];
    [self changeButtonToContinueTimer];
    [self deEmphasizeAllColors];
    [self.alertManager cancelLocalNotifications];
}



#pragma mark - Timer Delegate
- (void)updateElaspedSeconds:(NSInteger)seconds {
    [self updateTimerLabelsWithSeconds:seconds];
    [self assertColorChangeForSeconds:seconds];
    if (self.timeEntryVc) {
        [self updateTimeEntryVc];
    }
}
- (void)updateTimerLabelsWithSeconds:(NSInteger)seconds {
    self.timerSeconds = seconds;
    [self updateTimerLabel];
}



- (void)updateTimeEntryVc {
//    self.timeEntryVc.timerMinutesLabel.text = self.minutesLabel.text;
//    self.timeEntryVc.timerSecondsLabel.text = self.secondsLabel.text;
}

- (void)updateTimerLabel {
    self.timerLabel.text = [Helper stringForTotalSeconds:self.timerSeconds];
}

- (void)assertColorChangeForSeconds:(NSInteger)seconds {
    for (ColorIndex i = kGreen; i < kColorIndexCount; i++) {
        NSInteger colorSeconds = [self.colorArray[i] integerValue];
        if (seconds == colorSeconds) {
            [self.alertManager performAlertForColorIndex:i];
        }
    }
}




#pragma mark - Settings Button
- (IBAction)settingsButtonPress:(id)sender {
    NSString *vcClassName = NSStringFromClass([TimeEntryVC class]);
    TimeEntryVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:vcClassName];

    self.timeEntryVc = vc;
    [self presentViewController:vc animated:YES completion:nil];
    [self updateTimeEntryVc];
}



#pragma mark - Audio Alert Button
- (IBAction)toggleAudioAlertButtonPress:(id)sender {
    [self toggleShouldAlert];
    [self.alertManager resetLocalNotifications];
}
- (void)toggleShouldAlert {
    BOOL shouldAlert = [self.defaults boolForKey:SHOULD_AUDIO_ALERT_KEY];
    if (shouldAlert) {
        [self disableAlert];
    } else {
        [self enableAlert];
    }
}
- (void)disableAlert {
    self.audioAlertButton.alpha = DISABLED_ALPHA;
    [self.defaults setBool:NO forKey:SHOULD_AUDIO_ALERT_KEY];
}
- (void)enableAlert {
    self.audioAlertButton.alpha = 1;
    [self.defaults setBool:YES forKey:SHOULD_AUDIO_ALERT_KEY];
}



#pragma mark - Info Button
- (IBAction)infoButtonPress:(id)sender {
    NSString *vcClassName = NSStringFromClass([InfoVC class]);
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:vcClassName];
    [self presentViewController:vc animated:YES completion:nil];
}




#pragma mark - Prepare for Background
- (void)setupViewForBackground {
    self.timerLabel.hidden = YES;
    [self deEmphasizeAllColors];
    [self removeToast];
}

- (void)removeToast {
    NSArray *subviews = self.view.subviews;
    for (UIView *subview in subviews) {
        if (subview.tag == TOAST_TAG) {
            [subview removeFromSuperview];
        }
    }
}




#pragma mark - Return to Foreground
- (void)setupViewForReturningToForeground {
    self.timerLabel.hidden = NO;
    [self emphasizeCorrectColor];
}

- (void)emphasizeCorrectColor {
    ColorIndex index = [self colorIndexToEmphasize];
    [self emphasizeColorWithIndex:index];
}

- (ColorIndex)colorIndexToEmphasize {
    ColorIndex colorIndexToEmphasize;
    NSInteger minDifference = REALLY_LARGE_INTEGER;
    
    for (ColorIndex i = kGreen; i < kColorIndexCount; i++) {
        NSInteger colorSeconds = [self.colorArray[i] integerValue];
        NSInteger difference = self.timerSeconds - colorSeconds;
        BOOL colorTimeWasReached = difference >= 0;
        if (colorTimeWasReached  &&  colorSeconds > 0  &&  difference <= minDifference) {
            minDifference = difference;
            colorIndexToEmphasize = i;
        }
    }
    return colorIndexToEmphasize;
}




@end
