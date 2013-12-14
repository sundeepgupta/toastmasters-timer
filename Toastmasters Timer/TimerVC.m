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


@interface TimerVC ()
@property (strong, nonatomic) Timer *timer;
@property (strong, nonatomic) AlertManager *alertManager;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) NSMutableDictionary *colorLabelsDictionary;
@property (strong, nonatomic) NSMutableDictionary *colorTimes;
@property NSInteger seconds;
@property NSInteger minutes;
@property (strong, nonatomic) IBOutlet UILabel *secondsLabel;
@property (strong, nonatomic) IBOutlet UILabel *minutesLabel;
@property (strong, nonatomic) TimeEntryVC *timeEntryVc;
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
@property (strong, nonatomic) IBOutlet UIButton *audioAlertButton;
@end

@implementation TimerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupDefaults];
    [self setupColorLabelsDictionary];
    [self setupTimer];
    [self setupAlertManager];
    [self resetTimerUnits];
    [self setupAlertButton];
}

- (void)setupDefaults {
    self.defaults = [NSUserDefaults standardUserDefaults];
    [self.defaults setBool:NO forKey:SHOULD_AUDIO_ALERT_KEY];
}

- (void)setupColorLabelsDictionary {
    NSMutableDictionary *green = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *amber = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *red = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *bell = [[NSMutableDictionary alloc] init];
    
    green[MINUTES_KEY] = self.greenMinutesLabel;
    green[SECONDS_KEY] = self.greenSecondsLabel;
    
    amber[MINUTES_KEY] = self.amberMinutesLabel;
    amber[SECONDS_KEY] = self.amberSecondsLabel;
    
    red[MINUTES_KEY] = self.redMinutesLabel;
    red[SECONDS_KEY] = self.redSecondsLabel;
    
    bell[MINUTES_KEY] = self.bellMinutesLabel;
    bell[SECONDS_KEY] = self.bellSecondsLabel;
    
    self.colorLabelsDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:green,GREEN_COLOR_NAME, amber,AMBER_COLOR_NAME, red,RED_COLOR_NAME, bell,BELL_COLOR_NAME, nil];
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
    [self setupColorTimes];
    [self setupColorLabels];
}
- (void)setupColorTimes {
    NSDictionary *savedColorTimes = [self.defaults dictionaryForKey:COLOR_TIMES_KEY];
    if (savedColorTimes) {
        self.colorTimes = [savedColorTimes mutableDeepCopy];
    } else {
        [self initializeColorTimes];
        [self saveColorTimesToDefaults];
    }
}
- (void)initializeColorTimes {
    NSMutableDictionary *green = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *amber = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *red = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *bell = [[NSMutableDictionary alloc] init];
    
    green[MINUTES_KEY] = @0;
    green[SECONDS_KEY] = @0;
    
    amber[MINUTES_KEY] = @0;
    amber[SECONDS_KEY] = @0;
    
    red[MINUTES_KEY] = @0;
    red[SECONDS_KEY] = @0;
    
    bell[MINUTES_KEY] = @0;
    bell[SECONDS_KEY] = @0;
    
    self.colorTimes = [NSMutableDictionary dictionaryWithObjectsAndKeys:green,GREEN_COLOR_NAME, amber,AMBER_COLOR_NAME, red,RED_COLOR_NAME, bell,BELL_COLOR_NAME, nil];
}
- (void)saveColorTimesToDefaults {
    [self.defaults setObject:self.colorTimes forKey:COLOR_TIMES_KEY];
    [self.defaults synchronize];
}

- (void)setupColorLabels {
    [Helper setupLabels:self.colorLabelsDictionary forColors:self.colorTimes];
}



#pragma mark - Emphasize Color Labels
- (void)emphasizeLabelsForColor:(NSString *)color {
    NSArray *labels = [self labelsForColor:color];
    for (UILabel *label in labels) {
        [self emphasizeLabel:label];
    }
}

- (void)emphasizeLabel:(UILabel *)label {
    [self boldLabel:label];
    [self glowLabel:label];
}

- (void)boldLabel:(UILabel *)label {
    UIFont *font = label.font;
    CGFloat fontSize = font.pointSize ;
    UIFont *newFont = [UIFont boldSystemFontOfSize:fontSize];
    label.font = newFont;
}
- (void)glowLabel:(UILabel *)label {
    UIColor *color = label.textColor;
    label.layer.shadowColor = [color CGColor];
    label.layer.shadowRadius = 4.0f;
    label.layer.shadowOpacity = .9;
    label.layer.shadowOffset = CGSizeZero;
    label.layer.masksToBounds = NO;
}

- (void)deEmphasizeLabelsForColor:(NSString *)color {
    NSArray *labels = [self labelsForColor:color];
    for (UILabel *label in labels) {
        [self deEmphasizeLabel:label];
    }
}

- (void)deEmphasizeLabel:(UILabel *)label {
    [self unBoldLabel:label];
    [self unGlowLabel:label];
}

- (void)unBoldLabel:(UILabel *)label {
    UIFont *font = label.font;
    CGFloat fontSize = font.pointSize ;
    UIFont *newFont = [UIFont systemFontOfSize:fontSize];
    label.font = newFont;
}
- (void)unGlowLabel:(UILabel *)label {
    label.layer.shadowOpacity = 0;
}

- (NSArray *)labelsForColor:(NSString *)color {
    NSMutableDictionary *colorDict = self.colorLabelsDictionary[color];
    NSArray *labels = colorDict.allValues;
    return labels;
}

- (void)deEmphasizeLabelsForAllColors {
    [self toggleEmphasisForLabelsWithAlertedColorName:@""];
}

- (void)toggleEmphasisForLabelsWithAlertedColorName:(NSString *)alertedColorName {
    for (NSString *colorName in self.colorLabelsDictionary) {
        if ([colorName isEqualToString:alertedColorName]) {
            [self emphasizeLabelsForColor:alertedColorName];
        } else {
            [self deEmphasizeLabelsForColor:colorName];
        }
    }
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
    [self deEmphasizeLabelsForAllColors];
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
    self.minutes = floor(seconds/60);
    if (self.minutes == 100) {
        [self rollMinutesOver];
    }
    
    self.seconds = seconds%60;
    
    [self updateTimerLabels];
}
- (void)rollMinutesOver {
    self.minutes = 0;
    [self.timer stop];
    [self.timer startFromStopped];
}

- (void)updateTimeEntryVc {
    self.timeEntryVc.timerMinutesLabel.text = self.minutesLabel.text;
    self.timeEntryVc.timerSecondsLabel.text = self.secondsLabel.text;
}

- (void)updateTimerLabels {
    self.minutesLabel.text = [Helper unitStringForInteger:self.minutes];
    self.secondsLabel.text = [Helper unitStringForInteger:self.seconds];
}

- (void)assertColorChangeForSeconds:(NSInteger)seconds {
    for (NSString *colorName in self.colorTimes) {
        NSMutableDictionary *color = self.colorTimes[colorName];
        
        NSInteger minutes = [Helper integerForNumber:color[MINUTES_KEY]];
        NSInteger seconds = [Helper integerForNumber:color[SECONDS_KEY]];
        
        if (minutes == self.minutes  &&  seconds == self.seconds) {
            [self.alertManager performAlertForReachedColorName:colorName];
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
    [self hideTimerLabels];
    [self deEmphasizeLabelsForAllColors];
    [self removeToast];
}
- (void)hideTimerLabels {
    for (UILabel *label in self.timerLabels) {
        label.hidden = YES;
    }
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
    [self showTimerLabels];
    [self emphasizeCorrectColorLabels];
}

- (void)showTimerLabels {
    for (UILabel *label in self.timerLabels) {
        label.hidden = NO;
    }
}

- (void)emphasizeCorrectColorLabels {
    NSInteger totalSeconds = [self totalSecondsForTimer];
    NSString *colorToEmphasize = [self colorToEmphasizeForTotalSeconds:totalSeconds];
    [self emphasizeLabelsForColor:colorToEmphasize];
}

- (NSString *)colorToEmphasizeForTotalSeconds:(NSInteger)totalSeconds {
    NSString *colorToEmphasize;
    NSInteger minDifference = REALLY_LARGE_INTEGER;
    
    for (NSString *colorName in self.colorTimes) {
        NSInteger colorTotalSeconds = [self totalSecondsForColorName:colorName];
        NSInteger difference = totalSeconds - colorTotalSeconds;
        BOOL colorTimeWasReached = difference >= 0;
        if (colorTimeWasReached  &&  colorTotalSeconds > 0  &&  difference <= minDifference) {
            minDifference = difference;
            colorToEmphasize = colorName;
        }
    }
    return colorToEmphasize;
}

- (NSInteger) totalSecondsForColorName:(NSString *)colorName {
    NSDictionary *colorDict = [self.colorTimes objectForKey:colorName];
    NSInteger colorTotalSeconds = [Helper totalSecondsForColorDict:colorDict];
    return colorTotalSeconds;
}
- (NSInteger)totalSecondsForTimer {
    NSInteger totalSeconds = [Helper totalSecondsForMinutes:self.minutes andSeconds:self.seconds];
    return totalSeconds;
}




@end
