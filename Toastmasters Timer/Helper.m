//
//  Helper.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (NSString *)stringForLevelNumber:(NSInteger)levelNumber andSectionNumber:(NSInteger)sectionNumber {
    NSInteger totalSeconds = [self totalSecondsForLevelNumber:levelNumber andSectionNumber:sectionNumber];
    NSString *string = [self stringForTotalSeconds:totalSeconds];
    return string;
}
+ (NSInteger)totalSecondsForLevelNumber:(NSInteger)levelNumber andSectionNumber:(NSInteger)sectionNumber {
    NSInteger totalSeconds = 60*levelNumber + SECONDS_INCREMENT*sectionNumber;
    return totalSeconds;
}
+ (NSString *)stringForTotalSeconds:(NSInteger)totalSeconds {
    NSInteger minutes = floor(totalSeconds/60);
    NSInteger seconds = totalSeconds%60;
    NSString *string = [NSString stringWithFormat:@"%02i:%02i", minutes, seconds];
    return string;
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
        case kGreen:
            name = @"green";
            break;
        case kAmber:
            name = @"amber";
            break;
        case kRed:
            name = @"red";
            break;
        case kBell:
            name = @"bell";
            break;
        default:
            break;
    }

    return name;
}


+ (void)registerForTimerNotificationsWithObject:(id)object {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:object selector:@selector(timerUpdatedSeconds:) name:TIMER_NOTIFICATION object:nil];
}



#pragma mark - Universal Helpers 
+ (void)updateTitle:(NSString *)title forButton:(UIButton *)button {
    [UIView setAnimationsEnabled:NO];
    [button setTitle:title forState:UIControlStateNormal];
    [UIView setAnimationsEnabled:YES];
}


@end
