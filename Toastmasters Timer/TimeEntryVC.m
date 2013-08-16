//
//  TimeEntryVC.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "TimeEntryVC.h"
#import "Times.h"

#define MINUTES_INCREMENT 1 //If this is not 1, the seconds incremntor will break this.
#define SECONDS_INCREMENT 5

@interface TimeEntryVC ()
@property (strong, nonatomic) Times *times;
@property NSInteger minutes;
@property NSInteger seconds;
@property (strong, nonatomic) IBOutlet UILabel *minutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondsLabel;
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
    [self setupTimes];
    [self setupView];
    
}
- (void)setupTimes {
    self.times = [[Times alloc] init];
    NSDictionary *units = [self.times greenUnits];
    self.minutes = [[units valueForKey:MINUTES_KEY] integerValue];
    self.seconds = [[units valueForKey:SECONDS_KEY] integerValue];
}
- (void)setupView {
    self.minutesLabel.text = [Helper unitStringForInteger:self.minutes];
    self.secondsLabel.text = [Helper unitStringForInteger:self.seconds];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)increaseMinutesButtonPress:(id)sender {
    self.minutes = self.minutes + MINUTES_INCREMENT;
    [self updateMinutesLabel];
}
- (IBAction)decreaseMinutesButtonPress:(id)sender {
    if (self.minutes - MINUTES_INCREMENT >= 0) {
        self.minutes = self.minutes - MINUTES_INCREMENT;
    }
    [self updateMinutesLabel];
}
- (IBAction)increaseSecondsButtonPress:(id)sender {
    if (self.seconds + SECONDS_INCREMENT >= 60) {
        self.seconds = (self.seconds + SECONDS_INCREMENT)%60;
        self.minutes = self.minutes + MINUTES_INCREMENT;
        [self updateMinutesLabel];
    } else {
        self.seconds = self.seconds + SECONDS_INCREMENT;
    }
    [self updateSecondsLabel];
}
- (IBAction)decreaseSecondsButtonPress:(id)sender {
    if (self.seconds - SECONDS_INCREMENT >= 0) {
        self.seconds = self.seconds - SECONDS_INCREMENT;
    }
    [self updateSecondsLabel];
}


- (void)updateMinutesLabel {
    self.minutesLabel.text = [Helper unitStringForInteger:self.minutes];
}
- (void)updateSecondsLabel {
    self.secondsLabel.text = [Helper unitStringForInteger:self.seconds];
}


- (IBAction)startButtonPress:(id)sender {
    [self saveTimes];
    [self transitionView];
}

- (void)saveTimes {
    NSDictionary *units = [Helper unitsForMinutes:self.minutes andSeconds:self.seconds];
    [self.times saveGreenWithUnits:units];
    
}

- (void)transitionView {
    
}




@end
