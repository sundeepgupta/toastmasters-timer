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
+ (NSString *)stringForLevelNumber:(NSInteger)levelNumber andSectionNumber:(NSInteger)sectionNumber;
+ (NSString *)stringForTotalSeconds:(NSInteger)totalSeconds;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (NSString *)nameForColorIndex:(ColorIndex)index;


#pragma mark - Universal Helpers
+ (void)updateTitle:(NSString *)title forButton:(UIButton *)button;

@end
