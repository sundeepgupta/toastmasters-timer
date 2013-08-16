//
//  TimeEntryVC.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "TimeEntryVC.h"
#import "Times.h"

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
    self.minutes++;
    [self updateMinutesLabel];
}
- (IBAction)decreaseMinutesButtonPress:(id)sender {
    self.minutes--;
    [self updateMinutesLabel];
}
- (IBAction)increaseSecondsButtonPress:(id)sender {
    self.seconds = self.seconds + 5;
    [self updateSecondsLabel];
}
- (IBAction)decreaseSecondsButtonPress:(id)sender {
    self.seconds = self.seconds - 5;
    [self updateSecondsLabel];
}


- (void)updateMinutesLabel {
    self.minutesLabel.text = [Helper unitStringForInteger:self.minutes];
}
- (void)updateSecondsLabel {
    self.secondsLabel.text = [Helper unitStringForInteger:self.seconds];
}


- (IBAction)startButtonPress:(id)sender {
    
}


@end
