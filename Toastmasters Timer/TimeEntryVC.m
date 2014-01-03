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
@property (strong, nonatomic) NSMutableDictionary *colors;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) NSMutableDictionary *labelsDictionary;
@property (nonatomic, strong) SGRotaryWheel *rotaryWheel;
@property (strong, nonatomic) IBOutlet UIView *wheelView;
@property (strong, nonatomic) IBOutlet ColorButton *greenButton;
@property (strong, nonatomic) IBOutlet ColorButton *amberButton;
@property (strong, nonatomic) IBOutlet ColorButton *redButton;
@property (strong, nonatomic) IBOutlet ColorButton *bellButton;
@property (nonatomic, strong) NSString *currentColorName;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@end


@implementation TimeEntryVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupDefaults];
    [self setupRotaryWheel];
    [Helper registerForTimerNotificationsWithObject:self];

    

    
    self.currentColorName = GREEN_COLOR_NAME;
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



#pragma mark - Rotary wheel delegates
- (void)wheelDidChangeSectionNumber:(NSInteger)sectionNumber withLevelNumber:(NSInteger)levelNumber{
    NSString *timeString = [Helper stringForLevelNumber:levelNumber andSectionNumber:sectionNumber];
    [self updateCurrentColorButtonTitle:timeString];
}


- (void)updateCurrentColorButtonTitle:(NSString *)title {
    UIButton *buttonToUpdate;
    if ([self.currentColorName isEqualToString:GREEN_COLOR_NAME]) {
        buttonToUpdate = self.greenButton;
    } else if ([self.currentColorName isEqualToString:AMBER_COLOR_NAME]) {
        buttonToUpdate = self.amberButton;
    }
    [Helper updateTitle:title forButton:buttonToUpdate];
}



#pragma mark - Timer Notification
- (void)timerUpdatedSeconds:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *secondsNumber = userInfo[SECONDS_INFO_KEY];
    NSInteger seconds = secondsNumber.integerValue;
    [self updateTimerLabelWithSeconds:seconds];
}

- (void)updateTimerLabelWithSeconds:(NSInteger)seconds {
    self.timerLabel.text = [Helper stringForTotalSeconds:seconds];
}




#pragma mark - Color Buttons 
- (IBAction)greenButtonTapped:(id)sender {
    self.currentColorName = GREEN_COLOR_NAME;
}

- (IBAction)amberButtonTapped:(id)sender {
    self.currentColorName = AMBER_COLOR_NAME;
}



#pragma mark - Save and Cancel
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
