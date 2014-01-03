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
#import "SGRotaryWheel.h"
#import "ColorButton.h"


#define WHEEL_PADDING 0


@interface TimeEntryVC () <SGRotaryWheelDelegate>
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (nonatomic, strong) SGRotaryWheel *rotaryWheel;
@property (strong, nonatomic) IBOutlet UIView *wheelView;
@property (strong, nonatomic) IBOutlet ColorButton *greenButton;
@property (strong, nonatomic) IBOutlet ColorButton *amberButton;
@property (strong, nonatomic) IBOutlet ColorButton *redButton;
@property (strong, nonatomic) IBOutlet ColorButton *bellButton;
@property ColorIndex currentColorIndex;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@end


@implementation TimeEntryVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupDefaults];
    [self setupRotaryWheel];
    [Helper registerForTimerNotificationsWithObject:self];
    [self setupTimerLabel];
    

    
    self.currentColorIndex = GREEN_COLOR_INDEX;
}

- (void)setupDefaults {
    self.defaults = [NSUserDefaults standardUserDefaults];
}

- (void)setupRotaryWheel {
    CGFloat sideLength = self.wheelView.frame.size.width + 2*WHEEL_PADDING;
    CGRect frame = CGRectMake(-WHEEL_PADDING, -WHEEL_PADDING, sideLength, sideLength);
    self.rotaryWheel = [[SGRotaryWheel alloc] initWithFrame:frame delegate:self numberOfSections:60/SECONDS_INCREMENT];
    [self.wheelView addSubview:self.rotaryWheel];
}

- (void)setupTimerLabel {
    if (self.currentTimerString  &&  self.currentTimerString.length > 0) {
        self.timerLabel.text = self.currentTimerString;
    }
}


#pragma mark - Rotary wheel delegates
- (void)wheelDidChangeSectionNumber:(NSInteger)sectionNumber withLevelNumber:(NSInteger)levelNumber{
    NSString *timeString = [Helper stringForLevelNumber:levelNumber andSectionNumber:sectionNumber];
    [self updateCurrentColorButtonTitle:timeString];
}


- (void)updateCurrentColorButtonTitle:(NSString *)title {
    UIButton *buttonToUpdate;
    if (self.currentColorIndex == GREEN_COLOR_INDEX) {
        buttonToUpdate = self.greenButton;
    } else if (self.currentColorIndex == AMBER_COLOR_INDEX) {
        buttonToUpdate = self.amberButton;
    }
    [Helper updateTitle:title forButton:buttonToUpdate];
}



#pragma mark - Timer Notification
- (void)timerUpdatedSecondsWithNotification:(NSNotification *)notification {
    NSInteger seconds = [Helper secondsForNotification:notification];
    [self updateTimerLabelWithSeconds:seconds];
}
- (void)updateTimerLabelWithSeconds:(NSInteger)seconds {
    self.timerLabel.text = [Helper stringForTotalSeconds:seconds];
}




#pragma mark - Color Buttons 
- (IBAction)greenButtonTapped:(id)sender {
    self.currentColorIndex = GREEN_COLOR_INDEX;
}

- (IBAction)amberButtonTapped:(id)sender {
    self.currentColorIndex = AMBER_COLOR_INDEX;
}



#pragma mark - Save and Cancel
- (IBAction)doneButtonPress:(id)sender {
    [self saveColorsToDefaults];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveColorsToDefaults {
//    [self.defaults setObject:self.colors forKey:COLOR_TIMES_KEY];
    [self.defaults synchronize];
}


- (IBAction)cancelButtonPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
