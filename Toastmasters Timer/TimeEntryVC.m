//
//  TimeEntryVC.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "TimeEntryVC.h"
#import "Times.h"
#import "TimerVC.h"

#define MINUTES_INCREMENT 1 //If this is not 1, the seconds incremntor will break this.
#define SECONDS_INCREMENT 5
#define DEFAULT_MINUTES 1
#define DEFAULT_SECONDS 0

@interface TimeEntryVC ()



@property (strong, nonatomic) Times *times;
@property NSInteger greenMinutes;
@property NSInteger greenSeconds;
@property (strong, nonatomic) IBOutlet UILabel *greenMnutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *greenSecondsLabel;
@property NSInteger amberMinutes;
@property NSInteger amberSeconds;
@property (strong, nonatomic) IBOutlet UILabel *amberMnutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *amberSecondsLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *greenButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *amberButtons;
@end

@implementation TimeEntryVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupDefaults];
    [self setupTimes];
    [self setupView];
    
}
- (void)setupDefaults {
    self.greenMinutes = DEFAULT_MINUTES;
    self.greenSeconds = DEFAULT_SECONDS;
    self.amberMinutes = DEFAULT_MINUTES;
    self.amberSeconds = DEFAULT_SECONDS;
}
- (void)setupTimes {
    self.times = [[Times alloc] init];
}
- (void)setupView {
    self.greenMnutesLabel.text = [Helper unitStringForInteger:self.greenMinutes];
    self.greenSecondsLabel.text = [Helper unitStringForInteger:self.greenSeconds];
    self.amberMnutesLabel.text = [Helper unitStringForInteger:self.amberMinutes];
    self.amberSecondsLabel.text = [Helper unitStringForInteger:self.amberSeconds];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)increaseMinutesButtonPress:(id)sender {
    if ([self.greenButtons containsObject:sender]) {
        self.greenMinutes += MINUTES_INCREMENT;
    } else if ([self.amberButtons containsObject:sender]) {
        self.amberMinutes += MINUTES_INCREMENT;
    }
    [self updateMinutesLabels];
}

- (IBAction)decreaseMinutesButtonPress:(id)sender {
    if (self.greenMinutes - MINUTES_INCREMENT >= 0) {
        self.greenMinutes = self.greenMinutes - MINUTES_INCREMENT;
    }
    [self updateMinutesLabels];
}
- (IBAction)increaseSecondsButtonPress:(id)sender {
    if (self.greenSeconds + SECONDS_INCREMENT >= 60) {
        [self rollUpMinutes];
    } else {
        self.greenSeconds = self.greenSeconds + SECONDS_INCREMENT;
    }
    [self updateLabels];
}
- (IBAction)decreaseSecondsButtonPress:(id)sender {
    if (self.greenSeconds - SECONDS_INCREMENT >= 0) {
        self.greenSeconds = self.greenSeconds - SECONDS_INCREMENT;
    } else {
        [self rollDownMinutes];
    }
    [self updateLabels];
}

- (NSString *)colorForSender:(id)sender {
    NSString *color;
    if ([self.greenButtons containsObject:sender]) {
        color = @"green";
    } else if ([self.amberButtons containsObject:sender]) {
        color = @"amber";
    }
    return color;
}

- (void)rollUpMinutes {
    self.greenSeconds = (self.greenSeconds + SECONDS_INCREMENT)%60;
    self.greenMinutes++;
}
- (void)rollDownMinutes {
    if (self.greenMinutes > 0) {
        self.greenMinutes--;
        self.greenSeconds = self.greenSeconds - SECONDS_INCREMENT + 60;
    }
}


- (void)updateLabels {
    [self updateMinutesLabels];
    [self updateSecondsLabel];
}
- (void)updateMinutesLabels {
    self.greenMnutesLabel.text = [Helper unitStringForInteger:self.greenMinutes];
    self.amberMnutesLabel.text = [Helper unitStringForInteger:self.amberMinutes];
}
- (void)updateSecondsLabel {
    self.greenSecondsLabel.text = [Helper unitStringForInteger:self.greenSeconds];
    self.amberSecondsLabel.text = [Helper unitStringForInteger:self.amberSeconds];
}

- (IBAction)startButtonPress:(id)sender {
    [self saveTimes];
    [self transitionView];
}

- (void)saveTimes {
    self.times.greenMinutes = self.greenMinutes;
    self.times.greenSeconds = self.greenSeconds;
    self.times.amberMinutes = self.amberMinutes;
    self.times.amberSeconds = self.amberSeconds;
}

- (void)transitionView {
    NSString *vcId = NSStringFromClass([TimerVC class]);
    TimerVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:vcId];
    vc.times = self.times;
    [self.navigationController pushViewController:vc animated:YES];
    [vc toggleTimer];
}




@end
