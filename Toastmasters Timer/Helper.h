//
//  Helper.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

#define SECONDS_INCREMENT 5




@interface Helper : NSObject

#pragma mark - Strings from seconds and wheel
+ (NSString *)stringForLevelNumber:(NSInteger)levelNumber andSectionNumber:(NSInteger)sectionNumber;
+ (NSString *)stringForTotalSeconds:(NSInteger)totalSeconds;


#pragma mark - Seconds from Strings
+ (NSInteger)secondsForTimeString:(NSString *)timeString;


#pragma mark - Color Buttons
+ (void)setupTitlesForColorButtons:(NSArray *)colorButtons withColorArray:(NSArray *)colorArray;








+ (UIImage *)imageWithColor:(UIColor *)color;


+ (NSString *)nameForColorIndex:(ColorIndex)index;


#pragma mark - Timer Notifications
+ (void)registerForTimerNotificationsWithObject:(id)object;
+ (NSInteger)secondsForNotification:(NSNotification *)notification;

    
#pragma mark - Universal Helpers
+ (void)updateTitle:(NSString *)title forButton:(UIButton *)button;

@end
