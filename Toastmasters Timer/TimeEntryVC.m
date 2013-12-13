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

#define SECONDS_INCREMENT 5
#define WHEEL_PADDING 15

@interface TimeEntryVC () <SGRotaryWheelDelegate>
@property (strong, nonatomic) NSMutableDictionary *colors;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) NSMutableDictionary *labelsDictionary;
@property (nonatomic, strong) SGRotaryWheel *rotaryWheel;
@property (strong, nonatomic) IBOutlet UIView *wheelView;
@property (strong, nonatomic) IBOutlet UILabel *colorMinutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *colorSecondsLabel;
@end

@implementation TimeEntryVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupDefaults];
    [self setupRotaryWheel];
}

- (void)setupDefaults {
    self.defaults = [NSUserDefaults standardUserDefaults];
}

- (void)setupRotaryWheel {
    CGFloat sideLength = self.wheelView.frame.size.width + 2*WHEEL_PADDING;
    CGRect frame = CGRectMake(-WHEEL_PADDING, -WHEEL_PADDING, sideLength, sideLength);
    
    self.rotaryWheel = [[SGRotaryWheel alloc] initWithFrame:frame delegate:self numberOfSections:12];
    [self.wheelView addSubview:self.rotaryWheel];
}



#pragma mark - Rotary wheel delegates
- (void)wheelDidChangeSectionNumber:(NSInteger)sectionNumber withLevelNumber:(NSInteger)levelNumber{
    self.colorMinutesLabel.text = [NSString stringWithFormat:@"%i", sectionNumber];
    self.colorSecondsLabel.text = [NSString stringWithFormat:@"%i", levelNumber];
}


//- (IBAction)increaseMinutesButtonPress:(id)sender {
//    NSString *color = [self colorForSender:sender];
//    NSInteger minutes = [self integerForUnit:MINUTES_KEY forColor:color];
//    
//    NSInteger newMinutes = minutes + 1;
//    
//    if (newMinutes == 100) {
//        newMinutes = 0;
//    }
//    
//    [self updateUnit:MINUTES_KEY withInteger:newMinutes ForColor:color];
//}
//
//- (IBAction)decreaseMinutesButtonPress:(id)sender {
//    NSString *color = [self colorForSender:sender];
//    NSInteger minutes = [self integerForUnit:MINUTES_KEY forColor:color];
//    
//    NSInteger newMinutes = minutes - 1;
//    
//    if (newMinutes == -1) {
//        newMinutes = 99;
//    }
//    
//    [self updateUnit:MINUTES_KEY withInteger:newMinutes ForColor:color];
//}
//
//- (IBAction)increaseSecondsButtonPress:(id)sender {
//    NSString *color = [self colorForSender:sender];
//    NSInteger seconds = [self integerForUnit:SECONDS_KEY forColor:color];
//    
//    NSInteger newSeconds = seconds + SECONDS_INCREMENT;
//
//    if (newSeconds >= 60) {
//        newSeconds -= 60;
//    }
//    
//    [self updateUnit:SECONDS_KEY withInteger:newSeconds ForColor:color];
//}
//
//- (IBAction)decreaseSecondsButtonPress:(id)sender {
//    NSString *color = [self colorForSender:sender];
//    NSInteger seconds = [self integerForUnit:SECONDS_KEY forColor:color];
//
//    NSInteger newSeconds = seconds - SECONDS_INCREMENT;
//
//    if (newSeconds < 0) {
//        newSeconds += 60;
//    }
//    
//    [self updateUnit:SECONDS_KEY withInteger:newSeconds ForColor:color];
//}


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
