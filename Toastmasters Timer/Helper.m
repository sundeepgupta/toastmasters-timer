//
//  Helper.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "Helper.h"
#import "ColorButton.h"


#define MAX_SECONDS 5995 //99:55


@implementation Helper

#pragma mark - Strings from seconds and wheel
+ (NSString *)stringForSeconds:(NSInteger)seconds {
    NSInteger adjustedSeconds = [self adjustedSeconds:seconds];
    NSInteger minutes = [self minutesForSeconds:adjustedSeconds];
    NSInteger remainderSeconds = [self remainderSecondsForSeconds:adjustedSeconds];
    NSString *string = [NSString stringWithFormat:@"%02i:%02i", minutes, remainderSeconds];
    return string;
}

+ (NSInteger)adjustedSeconds:(NSInteger)seconds {
    if (seconds < 0) {
        seconds = 0;
    } else if (seconds > MAX_SECONDS) {
        seconds = MAX_SECONDS;
    }
    return seconds;
}



#pragma mark - Convert total seconds to minutes and seconds
+ (NSInteger)minutesForSeconds:(NSInteger)seconds {
    NSInteger minutes = floor(seconds/60);
    return minutes;
}

+ (NSInteger)remainderSecondsForSeconds:(NSInteger)seconds {
    NSInteger remainderSeconds = seconds%60;
    return remainderSeconds;
}




#pragma mark - Seconds from Strings
+ (NSNumber *)secondsNumberForTimeString:(NSString *)timeString {
    NSInteger secondsInteger = [self secondsForTimeString:timeString];
    NSNumber *secondsNumber = [NSNumber numberWithInteger:secondsInteger];
    return secondsNumber;
}
+ (NSInteger)secondsForTimeString:(NSString *)timeString {
    NSArray *components = [timeString componentsSeparatedByString:@":"];
    NSString *minutesString = components[0];
    NSInteger minutes = minutesString.integerValue;
    NSString *secondsString = components[1];
    NSInteger seconds = secondsString.integerValue;
    NSInteger totalSeconds = minutes*60 + seconds;
    return totalSeconds;
}






#pragma mark - Color Buttons
+ (void)setupTitlesForColorButtons:(NSArray *)colorButtons withColorArray:(NSArray *)colorArray{
    for (ColorIndex i = GREEN_COLOR_INDEX; i < COLOR_INDEX_COUNT; i++) {
        NSInteger seconds = [colorArray[i] integerValue];
        ColorButton *button = colorButtons[i];
        [self setupTitleForColorButton:button withSeconds:seconds];
    }
}
+ (void)setupTitleForColorButton:(ColorButton *)button withSeconds:(NSInteger)seconds {
    NSString *title = [self stringForSeconds:seconds];
    [self updateTitle:title forButton:button];
}











+ (UIImage *)imageWithColor:(UIColor *)color {
    UIImage *img = nil;
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}












+ (NSString *)nameForColorIndex:(ColorIndex)index {
    NSString *name;
    
    switch (index) {
        case GREEN_COLOR_INDEX:
            name = @"green";
            break;
        case AMBER_COLOR_INDEX:
            name = @"amber";
            break;
        case RED_COLOR_INDEX:
            name = @"red";
            break;
        case BELL_COLOR_INDEX:
            name = @"bell";
            break;
        default:
            break;
    }

    return name;
}








#pragma mark - Timer Notifications
+ (void)registerForTimerNotificationsWithObject:(id)object {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:object selector:@selector(timerUpdatedSecondsWithNotification:) name:TIMER_NOTIFICATION object:nil];
}

+ (NSInteger)secondsForNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *secondsNumber = userInfo[SECONDS_INFO_KEY];
    NSInteger seconds = secondsNumber.integerValue;
    return seconds;
}



#pragma mark - Universal Helpers 
+ (void)updateTitle:(NSString *)title forButton:(UIButton *)button {
    [UIView setAnimationsEnabled:NO];
    [button setTitle:title forState:UIControlStateNormal];
    [UIView setAnimationsEnabled:YES];
}


@end
