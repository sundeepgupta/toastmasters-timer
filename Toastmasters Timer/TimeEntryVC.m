//
//  TimeEntryVC.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "TimeEntryVC.h"
#import "TimerVC.h"
#import "SGDeepCopy.h"

#define SECONDS_INCREMENT 5

@interface TimeEntryVC ()

@property (strong, nonatomic) NSMutableDictionary *colors;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) NSMutableDictionary *labelsDictionary;
@property (strong, nonatomic) IBOutlet UILabel *greenMinutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *greenSecondsLabel;
@property (strong, nonatomic) IBOutlet UILabel *amberMinutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *amberSecondsLabel;
@property (strong, nonatomic) IBOutlet UILabel *redMinutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *redSecondsLabel;
@property (strong, nonatomic) IBOutlet UILabel *bellMinutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *bellSecondsLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *greenButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *amberButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *redButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bellButtons;


@end

@implementation TimeEntryVC

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
    [self setupColors];
    [self setupColorsLabels];
}

- (void)setupDefaults {
    self.defaults = [NSUserDefaults standardUserDefaults];
}

- (void)setupLabelsDictionary {
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
    
    self.labelsDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:green,GREEN_COLOR_NAME, amber,AMBER_COLOR_NAME, red,RED_COLOR_NAME, bell,BELL_COLOR_NAME, nil];
}

- (void)setupColors {
    NSDictionary *savedColors = [self.defaults dictionaryForKey:COLOR_TIMES_KEY];
    self.colors = [savedColors mutableDeepCopy];
}

- (void)setupColorsLabels {
    [Helper setupLabels:self.labelsDictionary forColors:self.colors];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)increaseMinutesButtonPress:(id)sender {
    NSString *color = [self colorForSender:sender];
    NSInteger minutes = [self integerForUnit:MINUTES_KEY forColor:color];
    
    NSInteger newMinutes = minutes + 1;
    
    if (newMinutes == 100) {
        newMinutes = 0;
    }
    
    [self updateUnit:MINUTES_KEY withInteger:newMinutes ForColor:color];
}

- (IBAction)decreaseMinutesButtonPress:(id)sender {
    NSString *color = [self colorForSender:sender];
    NSInteger minutes = [self integerForUnit:MINUTES_KEY forColor:color];
    
    NSInteger newMinutes = minutes - 1;
    
    if (newMinutes == -1) {
        newMinutes = 99;
    }
    
    [self updateUnit:MINUTES_KEY withInteger:newMinutes ForColor:color];
}

- (IBAction)increaseSecondsButtonPress:(id)sender {
    NSString *color = [self colorForSender:sender];
    NSInteger seconds = [self integerForUnit:SECONDS_KEY forColor:color];
    
    NSInteger newSeconds = seconds + SECONDS_INCREMENT;

    if (newSeconds >= 60) {
        newSeconds -= 60;
    }
    
    [self updateUnit:SECONDS_KEY withInteger:newSeconds ForColor:color];
}

- (IBAction)decreaseSecondsButtonPress:(id)sender {
    NSString *color = [self colorForSender:sender];
    NSInteger seconds = [self integerForUnit:SECONDS_KEY forColor:color];

    NSInteger newSeconds = seconds - SECONDS_INCREMENT;

    if (newSeconds < 0) {
        newSeconds += 60;
    }
    
    [self updateUnit:SECONDS_KEY withInteger:newSeconds ForColor:color];
}

- (NSString *)colorForSender:(id)sender {
    NSString *color;
    if ([self.greenButtons containsObject:sender]) {
        color = GREEN_COLOR_NAME;
    } else if ([self.amberButtons containsObject:sender]) {
        color = AMBER_COLOR_NAME;
    } else if ([self.redButtons containsObject:sender]) {
        color = RED_COLOR_NAME;
    } else {
        color = BELL_COLOR_NAME;
    }
    return color;
}

- (NSInteger)integerForUnit:(NSString *)unit forColor:(NSString *)color {
    NSMutableDictionary *colorDict = self.colors[color];
    NSNumber *number = colorDict[unit];
    NSInteger integer = number.integerValue;
    return integer;
}

- (void)updateUnit:(NSString *)unit withInteger:(NSInteger)integer ForColor:(NSString *)color {
    NSMutableDictionary *colorDict = self.colors[color];
    NSNumber *number = [NSNumber numberWithInteger:integer];
    colorDict[unit] = number;
    
    NSMutableDictionary *labelDict = self.labelsDictionary[color];
    UILabel *label = labelDict[unit];
    
    label.text = [Helper unitStringForNumber:colorDict[unit]];
}



- (IBAction)doneButtonPress:(id)sender {
    [self saveColorsToDefaults];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)saveColorsToDefaults {
    [self.defaults setObject:self.colors forKey:COLOR_TIMES_KEY];
    [self.defaults synchronize];
}


- (IBAction)cancelButtonPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
