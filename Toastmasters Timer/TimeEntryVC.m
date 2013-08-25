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

- (void)setupColors {
    NSDictionary *savedColors = [self.defaults dictionaryForKey:@"colors"];
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
    NSInteger minutes = [self integerForUnit:@"minutes" forColor:color];
    
    NSInteger newMinutes = minutes + 1;
    
    if (newMinutes == 100) {
        newMinutes = 0;
    }
    
    [self updateUnit:@"minutes" withInteger:newMinutes ForColor:color];
}

- (IBAction)decreaseMinutesButtonPress:(id)sender {
    NSString *color = [self colorForSender:sender];
    NSInteger minutes = [self integerForUnit:@"minutes" forColor:color];
    
    NSInteger newMinutes = minutes - 1;
    
    if (newMinutes == -1) {
        newMinutes = 99;
    }
    
    [self updateUnit:@"minutes" withInteger:newMinutes ForColor:color];
}

- (IBAction)increaseSecondsButtonPress:(id)sender {
    NSString *color = [self colorForSender:sender];
    NSInteger seconds = [self integerForUnit:@"seconds" forColor:color];
    
    NSInteger newSeconds = seconds + SECONDS_INCREMENT;

    if (newSeconds >= 60) {
        newSeconds -= 60;
    }
    
    [self updateUnit:@"seconds" withInteger:newSeconds ForColor:color];
}

- (IBAction)decreaseSecondsButtonPress:(id)sender {
    NSString *color = [self colorForSender:sender];
    NSInteger seconds = [self integerForUnit:@"seconds" forColor:color];

    NSInteger newSeconds = seconds - SECONDS_INCREMENT;

    if (newSeconds < 0) {
        newSeconds += 60;
    }
    
    [self updateUnit:@"seconds" withInteger:newSeconds ForColor:color];
}

- (NSString *)colorForSender:(id)sender {
    NSString *color;
    if ([self.greenButtons containsObject:sender]) {
        color = @"green";
    } else if ([self.amberButtons containsObject:sender]) {
        color = @"amber";
    } else if ([self.redButtons containsObject:sender]) {
        color = @"red";
    } else {
        color = @"bell";
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
    [self.defaults setObject:self.colors forKey:@"colors"];
    [self.defaults synchronize];
}


- (IBAction)cancelButtonPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
