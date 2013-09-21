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
#import "Toast+UIView.h"
#import "TimeEntryVC.h"
#import "SGDeepCopy.h"
#import "InfoVC.h"

#define TOAST_DURATION 3
#define TOAST_TAG 999

@interface TimerVC ()
@property (strong, nonatomic) Timer *timer;
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
    [self setupDefaults];
    [self setupColorLabelsDictionary];
    [self setupTimer];
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

- (void)setupAlertButton {
    if ([self.defaults boolForKey:SHOULD_AUDIO_ALERT_KEY]) {
        self.audioAlertButton.alpha = 1;
    } else {
        self.audioAlertButton.alpha = DISABLED_ALPHA;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupColorTimes];
    [self setupColorLabels];
}
- (void)setupColorTimes {
    NSDictionary *savedColors = [self.defaults dictionaryForKey:COLOR_TIMES_KEY];
    if (savedColors) {
        self.colorTimes = [savedColors mutableDeepCopy];
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


- (void)setupLocalNotifications {
    NSDictionary *colors = [self.defaults dictionaryForKey:COLOR_TIMES_KEY];
    NSArray *colorNames = colors.allKeys;
    
    for (NSString *colorName in colorNames) {
        [self setupNotificationForColor:colorName];
    }
}

- (void)setupNotificationForColor:(NSString *)color {
    NSInteger totalSeconds = [self totalSecondsForColor:color];
    UILocalNotification *notification = [self notificationForColor:color andTimeInterval:totalSeconds];
    [self scheduleNotification:notification];
}
- (NSInteger)totalSecondsForColor:(NSString *)color {
    NSDictionary *colorsDict = [self.defaults dictionaryForKey:COLOR_TIMES_KEY];
    NSDictionary *colorDict = colorsDict[color];
    NSInteger minutes = [colorDict[MINUTES_KEY] integerValue];
    NSInteger seconds = [colorDict[SECONDS_KEY] integerValue];
    NSInteger totalSeconds = minutes*60 + seconds;
    return  totalSeconds;
}
- (UILocalNotification *)notificationForColor:(NSString *)color andTimeInterval:(NSInteger)timeInterval {
    NSDate *startDate = self.timer.startDate;
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeInterval:timeInterval sinceDate:startDate];
    notification.alertBody = [self alertMessageForColor:color];
    notification.timeZone = [NSTimeZone localTimeZone];
    
    if ([self.defaults boolForKey:SHOULD_AUDIO_ALERT_KEY]) {
        notification.soundName = UILocalNotificationDefaultSoundName;
    } else {
        notification.soundName = nil;
    }
    
    return notification;
}
- (void)scheduleNotification:(UILocalNotification *)notification {
    UIApplication *app = [UIApplication sharedApplication];
    [app scheduleLocalNotification:notification];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)pauseButtonPress:(id)sender {
    [self toggleTimer];
}
- (void)toggleTimer {
    TIMER_STATUS status = [self.timer status];
    if (status == RUNNING) {
        [self pauseTimer];
        [self cancelLocalNotifications];
    } else {
        [self startTimerWithStatus:status];
        [self setupLocalNotifications];
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
    [self cancelLocalNotifications];
}


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
    self.timeEntryVc.minutesLabel.text = self.minutesLabel.text;
    self.timeEntryVc.secondsLabel.text = self.secondsLabel.text;
}

- (void)updateTimerLabels {
    self.minutesLabel.text = [Helper unitStringForInteger:self.minutes];
    self.secondsLabel.text = [Helper unitStringForInteger:self.seconds];
}

- (void)assertColorChangeForSeconds:(NSInteger)seconds {
    for (NSString *key in self.colorTimes) {
        NSMutableDictionary *color = self.colorTimes[key];
        
        NSInteger minutes = [Helper integerForNumber:color[MINUTES_KEY]];
        NSInteger seconds = [Helper integerForNumber:color[SECONDS_KEY]];
        
        if (minutes == self.minutes  &&  seconds == self.seconds) {
            [self alertReachedColor:key];
        }
    }
}

- (void)alertReachedColor:(NSString *)color {
    [self showAlertForColor:color];
    [self toggleEmphasisForLabelsWithAlertedColor:color];
    
    if ([self.defaults boolForKey:SHOULD_AUDIO_ALERT_KEY]) {
        [self performAudioAlert];
    }
}
- (void)showAlertForColor:(NSString *)color {
    UIColor *alertColor;
    NSString *title = @"Attention!";
    NSString *message = [self alertMessageForColor:color];
    
    if ([color isEqualToString:GREEN_COLOR_NAME]) {
        alertColor = [UIColor colorWithRed:GREEN_R/255 green:GREEN_G/255 blue:GREEN_B/255 alpha:1];
    } else if ([color isEqualToString:AMBER_COLOR_NAME]){
        alertColor = [UIColor colorWithRed:AMBER_R/255 green:AMBER_G/255 blue:AMBER_B/255 alpha:1];
    } else if ([color isEqualToString:RED_COLOR_NAME]){
        alertColor = [UIColor colorWithRed:RED_R/255 green:RED_G/255 blue:RED_B/255 alpha:1];
    } else if ([color isEqualToString:BELL_COLOR_NAME]){
        alertColor = [UIColor colorWithRed:BELL_R/255 green:BELL_G/255 blue:BELL_B/255 alpha:1];
        message = @"Ring the bell.";
    }

    UIImage *image = [Helper imageWithColor:alertColor];
    [self.view makeToast:message duration:TOAST_DURATION position:@"center" title:title image:image tag:TOAST_TAG];
}

- (NSString *)alertMessageForColor:(NSString *)color {
    return   [NSString stringWithFormat:@"Turn the %@ light on.", color];
}

- (void)performAudioAlert {
    AudioServicesPlaySystemSound(1022);
}

- (void)toggleEmphasisForLabelsWithAlertedColor:(NSString *)alertedColor {
    NSArray *colors = self.colorLabelsDictionary.allKeys;
    for (NSString *colorInDict in colors) {
        if ([colorInDict isEqualToString:alertedColor]) {
            [self emphasizeLabelsForColor:alertedColor];
        } else {
            [self deEmphasizeLabelsForColor:colorInDict];
        }
    }
}


- (void)emphasizeLabelsForColor:(NSString *)color {
    NSArray *labels = [self labelsForColor:color];
    for (UILabel *label in labels) {
        [self boldLabel:label];
        [self glowLabel:label];
    }
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
        [self unBoldLabel:label];
        [self unGlowLabel:label];
    }
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
    [self toggleEmphasisForLabelsWithAlertedColor:@""];
}


- (IBAction)setupTimesButtonPress:(id)sender {
    NSString *vcClassName = NSStringFromClass([TimeEntryVC class]);
    TimeEntryVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:vcClassName];
    self.timeEntryVc = vc;
    [self presentViewController:vc animated:YES completion:nil];
    [self updateTimeEntryVc];
}



- (IBAction)toggleAlertButtonPress:(id)sender {
    [self toggleShouldAlert];
    [self resetLocalNotifications];
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


- (void)resetLocalNotifications {
    [self cancelLocalNotifications];
    [self setupLocalNotifications];
}
- (void)cancelLocalNotifications {
    UIApplication *app = [UIApplication sharedApplication];
    [app cancelAllLocalNotifications];
}

- (IBAction)infoButtonPress:(id)sender {
    NSString *vcClassName = NSStringFromClass([InfoVC class]);
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:vcClassName];
    [self presentViewController:vc animated:YES completion:nil];
}



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

    NSString *colorToEmphasize = @"";
    NSInteger minDifference = 999999999;
    
    NSArray *colorNames = self.colorTimes.allKeys;
    for (NSString *colorName in colorNames) {
        NSInteger colorTotalSeconds = [self totalSecondsForColorName:colorName];
        NSInteger difference = totalSeconds - colorTotalSeconds;
        
        BOOL colorTimeWasReached = difference > 0;
        
        if (colorTimeWasReached  &&  difference < minDifference) {
            minDifference = difference;
            colorToEmphasize = colorName;
        }
    }
    
    return colorToEmphasize;
}

- (NSInteger) totalSecondsForColorName:(NSString *)colorName {
    NSDictionary *colorDict = [self.colorTimes objectForKey:colorName];
    NSInteger colorTotalSeconds = [self totalSecondsForColorDict:colorDict];
    return colorTotalSeconds;
}



- (NSInteger)totalSecondsForTimer {
    NSInteger totalSeconds = [Helper totalSecondsForMinutes:self.minutes andSeconds:self.seconds];
    return totalSeconds;
}

- (NSInteger)totalSecondsForColorDict:(NSDictionary *)colorDict {
    NSInteger minutes = [colorDict[MINUTES_KEY] integerValue];
    NSInteger seconds = [colorDict[SECONDS_KEY] integerValue];
    NSInteger totalSeconds = [Helper totalSecondsForMinutes:minutes andSeconds:seconds];
    return totalSeconds;
}






@end
