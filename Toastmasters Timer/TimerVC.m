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


@interface TimerVC ()
@property (strong, nonatomic) Timer *timer;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) NSMutableDictionary *labelsDictionary;
@property (strong, nonatomic) NSMutableDictionary *colors;
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
    [self setupLabelsDictionary];
    [self setupTimer];
    [self resetTimerUnits];
}
- (void)setupDefaults {
    self.defaults = [NSUserDefaults standardUserDefaults];
}

- (void)setupLabelsDictionary {
    NSMutableDictionary *green = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *amber = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *red = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *bell = [[NSMutableDictionary alloc] init];
    
    green[@"minutes"] = self.greenMinutesLabel;
    green[@"seconds"] = self.greenSecondsLabel;
    
    amber[@"minutes"] = self.amberMinutesLabel;
    amber[@"seconds"] = self.amberSecondsLabel;
    
    red[@"minutes"] = self.redMinutesLabel;
    red[@"seconds"] = self.redSecondsLabel;
    
    bell[@"minutes"] = self.bellMinutesLabel;
    bell[@"seconds"] = self.bellSecondsLabel;
    
    self.labelsDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:green,@"green", amber,@"amber", red,@"red", bell,@"bell", nil];
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


- (void)viewWillAppear:(BOOL)animated {
    [self setupColors];
    [self setupColorsLabels];
}
- (void)setupColors {
    NSDictionary *savedColors = [self.defaults dictionaryForKey:@"colors"];
    if (savedColors) {
        self.colors = [savedColors mutableDeepCopy];
    } else {
        [self setupColorsForFirstTime];
    }
}
- (void)setupColorsForFirstTime {
    NSMutableDictionary *green = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *amber = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *red = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *bell = [[NSMutableDictionary alloc] init];
    
    green[@"minutes"] = @0;
    green[@"seconds"] = @0;
    
    amber[@"minutes"] = @0;
    amber[@"seconds"] = @0;
    
    red[@"minutes"] = @0;
    red[@"seconds"] = @0;
    
    bell[@"minutes"] = @0;
    bell[@"seconds"] = @0;
    
    self.colors = [NSMutableDictionary dictionaryWithObjectsAndKeys:green,@"green", amber,@"amber", red,@"red", bell,@"bell", nil];
}

- (void)setupColorsLabels {
    [Helper setupLabels:self.labelsDictionary forColors:self.colors];
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

- (IBAction)stopButtonPress:(id)sender {
    [self.timer reset];
    [self resetTimerUnits];
    [self changeButtonToContinueTimer];
    [self deEmphasizeLabelsForColors];
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
}
- (void)showAlertForColor:(NSString *)color {
    UIColor *alertColor;
    NSString *title = @"Attention!";
    NSString *message = [NSString stringWithFormat:@"Turn the %@ light on.", color];
    
    if ([color isEqualToString:@"green"]) {
        alertColor = [UIColor colorWithRed:GREEN_R/255 green:GREEN_G/255 blue:GREEN_B/255 alpha:1];
    } else if ([color isEqualToString:@"amber"]){
        alertColor = [UIColor colorWithRed:AMBER_R/255 green:AMBER_G/255 blue:AMBER_B/255 alpha:1];
    } else if ([color isEqualToString:@"red"]){
        alertColor = [UIColor colorWithRed:RED_R/255 green:RED_G/255 blue:RED_B/255 alpha:1];
    } else if ([color isEqualToString:@"bell"]){
        alertColor = [UIColor colorWithRed:BELL_R/255 green:BELL_G/255 blue:BELL_B/255 alpha:1];
        message = @"Ring the bell.";
    }

    UIImage *image = [Helper imageWithColor:alertColor];
    [self.view makeToast:message duration:3 position:@"center" title:title image:image];

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

- (void)deEmphasizeLabelsForColors {
    [self unBoldLabels:self.greenLabels];
    [self unBoldLabels:self.amberLabels];
    [self unBoldLabels:self.redLabels];
    [self unBoldLabels:self.bellLabels];
}
- (void)unBoldLabels:(NSArray *)labels {
    for (UILabel *label in labels) {
        UIFont *font = label.font;
        CGFloat fontSize = font.pointSize ;
        UIFont *newFont = [UIFont systemFontOfSize:fontSize];
        label.font = newFont;
    }
}


- (IBAction)setupTimesButtonPress:(id)sender {
    TimeEntryVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeEntryVC"];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
