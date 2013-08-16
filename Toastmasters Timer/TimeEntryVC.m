//
//  TimeEntryVC.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "TimeEntryVC.h"

@interface TimeEntryVC ()
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
    self.minutes = 0;
    self.seconds = 0;
    [self updateMinutesLabel];
    [self updateSecondsLabel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.minutesLabel.text = [NSString stringWithFormat:@"%d", self.minutes];
}
- (void)updateSecondsLabel {
    self.secondsLabel.text = [NSString stringWithFormat:@"%d", self.seconds];
}


@end
