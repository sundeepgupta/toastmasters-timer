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
@property NSInteger minutes;
@property NSInteger seconds;
@property (strong, nonatomic) IBOutlet UILabel *minutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondsLabel;
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
    self.minutes = DEFAULT_MINUTES;
    self.seconds = DEFAULT_SECONDS;
}
- (void)setupTimes {
    self.times = [[Times alloc] init];
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
   
    
    
    if ([self.greenButtons containsObject:sender]) {
        NSLog(@"green");
    } else if ([self.amberButtons containsObject:sender]) {
        NSLog(@"amber");
    }
    
    
    
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
        [self rollUpMinutes];
    } else {
        self.seconds = self.seconds + SECONDS_INCREMENT;
    }
    [self updateLabels];
}
- (IBAction)decreaseSecondsButtonPress:(id)sender {
    if (self.seconds - SECONDS_INCREMENT >= 0) {
        self.seconds = self.seconds - SECONDS_INCREMENT;
    } else {
        [self rollDownMinutes];
    }
    [self updateLabels];
}

- (void)rollUpMinutes {
    self.seconds = (self.seconds + SECONDS_INCREMENT)%60;
    self.minutes++;
}

- (void)rollDownMinutes {
    if (self.minutes > 0) {
        self.minutes--;
        self.seconds = self.seconds - SECONDS_INCREMENT + 60;
    }
}


- (void)updateLabels {
    [self updateMinutesLabel];
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
    self.times.greenMinutes = self.minutes;
    self.times.greenSeconds = self.seconds;
}

- (void)transitionView {
    NSString *vcId = NSStringFromClass([TimerVC class]);
    TimerVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:vcId];
    vc.times = self.times;
    [self.navigationController pushViewController:vc animated:YES];
    [vc toggleTimer];
}




@end
