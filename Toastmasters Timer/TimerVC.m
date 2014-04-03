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
#import "TTStrings.h"


@interface TimerVC () <TTModalDelegate, TTTimeEntryVCDelegate>
@property (strong, nonatomic) Timer *timer;
@property (strong, nonatomic) AlertManager *alertManager;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (nonatomic, strong) NSArray *colorArray;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;
@property (strong, nonatomic) IBOutlet UIButton *audioAlertButton;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet ColorButton *greenButton;
@property (strong, nonatomic) IBOutlet ColorButton *amberButton;
@property (strong, nonatomic) IBOutlet ColorButton *redButton;
@property (strong, nonatomic) IBOutlet ColorButton *bellButton;
@property (nonatomic, strong) NSArray *colorButtonArray;
@end


@implementation TimerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupColorButtonArray];
    [self setupDefaults];
    [self setupTimer];
    [self setupAlertManager];
    [self setupAlertButton];
    [Helper registerForTimerNotificationsWithObject:self];
    
    if ([Helper isFirstLaunch]) {
        [self doFirstLaunchActions];
    }
}

- (void)setupColorButtonArray {
    self.colorButtonArray = @[self.greenButton, self.amberButton, self.redButton, self.bellButton];
}

- (void)setupDefaults {
    self.defaults = [NSUserDefaults standardUserDefaults];
    [self.defaults setBool:NO forKey:SHOULD_AUDIO_ALERT_KEY];
}


- (void)setupTimer {
    self.timer = [[Timer alloc] init];
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


- (void)doFirstLaunchActions {
    [self showTips];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateView];
}

- (void)updateView {
    [self setupColorArray];
    [Helper setupTitlesForColorButtons:self.colorButtonArray withColorArray:self.colorArray];
}

- (void)setupColorArray {
    self.colorArray = [self.defaults arrayForKey:COLOR_TIMES_KEY];
}



#pragma mark - Emphasize Color Labels
- (void)emphasizeColorWithIndex:(ColorIndex)index {
    [self deEmphasizeAllColors];
    ColorButton *button = self.colorButtonArray[index];
    [button emphasize];
}

- (void)deEmphasizeAllColors {
    for (ColorButton *button in self.colorButtonArray) {
        [button deEmphasize];
    }
}

- (void)deEmphasizeColorWithIndex:(ColorIndex)index {
    ColorButton *button = self.colorButtonArray[index];
    [button deEmphasize];
}




#pragma mark - Timer Controls
- (IBAction)pauseButtonPress:(id)sender {
    [self toggleTimer];
}
- (void)toggleTimer {
    TIMER_STATUS status = [self.timer status];
    if (status == RUNNING) {
        [self pauseTimer];
    } else {
        [self startTimerWithStatus:status];
    }
}
- (void)pauseTimer {
    [self.timer pause];
    [self changeButtonToContinueTimer];
    [self.alertManager cancelLocalNotifications];
}

- (void)startTimerWithStatus:(TIMER_STATUS)status {
    if (status == PAUSED) {
        [self.timer unpause];
    } else { //status is stopped
        [self.timer startFromStopped];
    }
    [self changeButtonToPauseTimer];
    [self.alertManager setupLocalNotifications];
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
    [self updateTimerLabel];
    [self changeButtonToContinueTimer];
    [self deEmphasizeAllColors];
    [self.alertManager cancelLocalNotifications];
}



#pragma mark - Timer Notification
- (void)timerUpdatedSecondsWithNotification:(NSNotification *)notification {
    [self updateTimerLabel];
    [self alertColorIfNeeded];
}

- (void)updateTimerLabel {
    self.timerLabel.text = [Helper stringForSeconds:self.timer.seconds];
}


- (void)alertColorIfNeeded {
    NSInteger colorIndexToAlert = [self colorIndexToAlert];
    if (colorIndexToAlert > -1) {
        [self alertColorWithIndex:colorIndexToAlert];
    }
}

- (NSInteger)colorIndexToAlert {
    NSInteger index = -1;
    for (ColorIndex i = GREEN_COLOR_INDEX; i < COLOR_INDEX_COUNT; i++) {
        NSInteger colorSeconds = [self.colorArray[i] integerValue];
        if (self.timer.seconds == colorSeconds) {
            index = i;
        }
    }
    return index;
}

- (void)alertColorWithIndex:(ColorIndex)index {
    [self emphasizeColorWithIndex:index];
    [self.alertManager performAlertForColorIndex:index];
}



#pragma mark - Color Button
- (IBAction)greenButtonTapped:(id)sender {
    [self presentTimeEntryVcWithIndex:GREEN_COLOR_INDEX];
}
- (IBAction)amberButtonTapped:(id)sender {
    [self presentTimeEntryVcWithIndex:AMBER_COLOR_INDEX];
}
- (IBAction)redButtonTapped:(id)sender {
    [self presentTimeEntryVcWithIndex:RED_COLOR_INDEX];
}
- (IBAction)bellButtonTapped:(id)sender {
    [self presentTimeEntryVcWithIndex:BELL_COLOR_INDEX];
}

- (void)presentTimeEntryVcWithIndex:(ColorIndex)index {
    UIViewController *vc = [self timeEntryVcWithIndex:index];
    [self presentViewController:vc animated:YES completion:nil];
}
- (TimeEntryVC *)timeEntryVcWithIndex:(ColorIndex)index {
    NSString *vcClassName = NSStringFromClass([TimeEntryVC class]);
    TimeEntryVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:vcClassName];
    vc.currentTimerString = self.timerLabel.text;
    vc.currentColorIndex = index;
    vc.alertManager = self.alertManager;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalDelegate = self;
    vc.timeEntryDelegate = self;
    return vc;
}


#pragma mark - Audio Alert Button
- (IBAction)toggleAudioAlertButtonPress:(id)sender {
    [self toggleShouldAlert];
    [self.alertManager recreateNotifications];
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
    [self presentInfoVC];
}

- (void)presentInfoVC {
    NSString *vcClassName = NSStringFromClass([InfoVC class]);
    InfoVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:vcClassName];
    vc.currentTimerString = self.timerLabel.text;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - Tips
- (void)showTips {
    [Helper showAlertWithTitle:STRING_TIP_TITLE withMessage:STRING_TIP_START_TIMER_EARLIER];
}



#pragma mark - Time Entry VC Delegate Methods
- (void)colorTimeDidChangeForIndex:(ColorIndex)index {
    [self deEmphasizeColorWithIndex:index];
}

- (void)didResetAllColourTimes {
    [self deEmphasizeAllColors];
}




#pragma mark - Modal Delegate Methods
- (void)modalShouldDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    if (self.timer.status == RUNNING) {
        [self emphasizeCorrectColor];
    }
}

- (void)emphasizeCorrectColor {
    NSInteger index = [self colorIndexToEmphasize];
    if (index > -1) {
        [self emphasizeColorWithIndex:index];
    }
}

- (NSInteger)colorIndexToEmphasize {
    NSInteger colorIndexToEmphasize = -1;
    NSInteger minDifference = REALLY_LARGE_INTEGER;
    
    for (ColorIndex i = GREEN_COLOR_INDEX; i < COLOR_INDEX_COUNT; i++) {
        NSInteger colorSeconds = [self.colorArray[i] integerValue];
        NSInteger difference = self.timer.seconds - colorSeconds;
        BOOL colorTimeWasReached = difference >= 0;
        if (colorTimeWasReached  &&  colorSeconds > 0  &&  difference <= minDifference) {
            minDifference = difference;
            colorIndexToEmphasize = i;
        }
    }
        
    return colorIndexToEmphasize;
}




@end
