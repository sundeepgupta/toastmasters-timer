//
//  TimeEntryVC.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "TimeEntryVC.h"
#import "TimerVC.h"

#define SECONDS_INCREMENT 5

@interface TimeEntryVC ()

@property (strong, nonatomic) NSDictionary *colors;
@property (strong, nonatomic) NSMutableDictionary *settings;
@property (strong, nonatomic) IBOutlet UILabel *greenMnutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *greenSecondsLabel;
@property (strong, nonatomic) IBOutlet UILabel *amberMnutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *amberSecondsLabel;
@property (strong, nonatomic) IBOutlet UILabel *redMnutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *redSecondsLabel;
@property (strong, nonatomic) IBOutlet UILabel *bellMnutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *bellSecondsLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *greenButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *amberButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *redButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bellButtons;
@property (strong, nonatomic) IBOutlet UIButton *soundBellButton;

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
    [self setupColors];
    [self setupSettings];
}

- (void)setupColors {
    NSMutableDictionary *green = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *amber = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *red = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *bell = [[NSMutableDictionary alloc] init];
    
    green[@"minutes"] = @0;
    green[@"seconds"] = @0;
    green[@"minutesLabel"] = self.greenMnutesLabel;
    green[@"secondsLabel"] = self.greenSecondsLabel;
    
    amber[@"minutes"] = @0;
    amber[@"seconds"] = @0;
    amber[@"minutesLabel"] = self.amberMnutesLabel;
    amber[@"secondsLabel"] = self.amberSecondsLabel;
    
    red[@"minutes"] = @0;
    red[@"seconds"] = @0;
    red[@"minutesLabel"] = self.redMnutesLabel;
    red[@"secondsLabel"] = self.redSecondsLabel;
    
    bell[@"minutes"] = @0;
    bell[@"seconds"] = @0;
    bell[@"minutesLabel"] = self.bellMnutesLabel;
    bell[@"secondsLabel"] = self.bellSecondsLabel;
    
    self.colors = [NSDictionary dictionaryWithObjectsAndKeys:green,@"green", amber,@"amber", red,@"red", bell,@"bell", nil];
    
    for (NSString *key in self.colors) {
        NSDictionary *color = self.colors[key];
        UILabel *minutesLabel = color[@"minutesLabel"];
        UILabel *secondsLabel = color[@"secondsLabel"];
        minutesLabel.text = [Helper unitStringForNumber:color[@"minutes"]];
        secondsLabel.text = [Helper unitStringForNumber:color[@"seconds"]];
    }
}

- (void)setupSettings {
    self.settings = [[NSMutableDictionary alloc] init];
    self.settings[@"shouldSoundBell"] = @NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupView];
}

- (void)setupView {
    [Helper updateSoundBellButton:self.soundBellButton forSetting:[self.settings[@"shouldSoundBell"] boolValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)increaseMinutesButtonPress:(id)sender {
    NSMutableDictionary *color = [self colorForSender:sender];
    NSInteger minutes = [self integerForUnit:@"minutes" ForColor:color];
    
    NSInteger newMinutes = minutes + 1;
    
    if (newMinutes == 100) {
        newMinutes = 0;
    }
    
    [self updateUnit:@"minutes" withInteger:newMinutes ForColor:color];
}

- (IBAction)decreaseMinutesButtonPress:(id)sender {
    NSMutableDictionary *color = [self colorForSender:sender];
    NSInteger minutes = [self integerForUnit:@"minutes" ForColor:color];
    
    NSInteger newMinutes = minutes - 1;
    
    if (newMinutes == -1) {
        newMinutes = 99;
    }
    
    [self updateUnit:@"minutes" withInteger:newMinutes ForColor:color];
}

- (IBAction)increaseSecondsButtonPress:(id)sender {
    NSMutableDictionary *color = [self colorForSender:sender];
    NSInteger seconds = [self integerForUnit:@"seconds" ForColor:color];
    NSInteger newSeconds = seconds + SECONDS_INCREMENT;

    if (newSeconds >= 60) {
        newSeconds -= 60;
    }
    
    [self updateUnit:@"seconds" withInteger:newSeconds ForColor:color];
}

- (IBAction)decreaseSecondsButtonPress:(id)sender {
    NSMutableDictionary *color = [self colorForSender:sender];
    NSInteger seconds = [self integerForUnit:@"seconds" ForColor:color];
    NSInteger newSeconds = seconds - SECONDS_INCREMENT;

    if (newSeconds < 0) {
        newSeconds += 60;
    }
    
    [self updateUnit:@"seconds" withInteger:newSeconds ForColor:color];
}

- (NSMutableDictionary *)colorForSender:(id)sender {
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
    NSMutableDictionary *dictionary = self.colors[color];
    return dictionary;
}

- (NSInteger)integerForUnit:(NSString *)unit ForColor:(NSDictionary *)color {
    NSNumber *number = color[unit];
    NSInteger integer = number.integerValue;
    return integer;
}

- (void)updateUnit:(NSString *)unit withInteger:(NSInteger)integer ForColor:(NSMutableDictionary *)color {
    NSNumber *number = [NSNumber numberWithInteger:integer];
    color[unit] = number;
    
    NSString *labelString = [NSString stringWithFormat:@"%@Label", unit];
    UILabel *label = color[labelString];
    label.text = [Helper unitStringForNumber:color[unit]];
}



- (IBAction)startButtonPress:(id)sender {
    [self transitionView];
}

- (void)transitionView {
    NSString *vcId = NSStringFromClass([TimerVC class]);
    TimerVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:vcId];
    vc.colors = self.colors;
    vc.settings = self.settings;
    [self.navigationController pushViewController:vc animated:YES];
    [vc toggleTimer];
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
