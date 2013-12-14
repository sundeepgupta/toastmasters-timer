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







+ (NSString *)unitStringForNumber:(NSNumber *)number {
    NSInteger integer = number.integerValue;
    NSString *string = [self unitStringForInteger:integer];
    return string;
}
+ (NSString *)unitStringForInteger:(NSInteger)integer {
    NSString *string = [NSString stringWithFormat:@"%02d", integer];
    return string;
}


+ (NSInteger)integerForNumber:(NSNumber *)number {
    return number.integerValue;
}


+ (UIImage *)imageWithColor:(UIColor *)color
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


+ (void)setupLabels:(NSMutableDictionary *)labels forColors:(NSMutableDictionary *)colors {
    NSArray *colorKeys = labels.allKeys;
    
    for (NSString *colorKey in colorKeys) {
        NSMutableDictionary *colorDict = colors[colorKey];
        NSNumber *minutes = colorDict[MINUTES_KEY];
        NSNumber *seconds = colorDict[SECONDS_KEY];
        
        NSMutableDictionary *labelDict = labels[colorKey];
        UILabel *minutesLabel = labelDict[MINUTES_KEY];
        UILabel *secondsLabel = labelDict[SECONDS_KEY];
        minutesLabel.text = [self unitStringForNumber:minutes];
        secondsLabel.text = [self unitStringForNumber:seconds];
    }
}



+ (NSInteger)totalSecondsForColorDict:(NSDictionary *)colorDict {
    NSInteger minutes = [colorDict[MINUTES_KEY] integerValue];
    NSInteger seconds = [colorDict[SECONDS_KEY] integerValue];
    NSInteger totalSeconds = [self totalSecondsForMinutes:minutes andSeconds:seconds];
    return totalSeconds;
}

+ (NSInteger)totalSecondsForMinutes:(NSInteger)minutes andSeconds:(NSInteger)seconds {
    NSInteger totalSeconds = minutes*60 + seconds;
    return totalSeconds;
}




#pragma mark - Universal Helpers 
+ (void)updateTitle:(NSString *)title forButton:(UIButton *)button {
    [UIView setAnimationsEnabled:NO];
    [button setTitle:title forState:UIControlStateNormal];
    [UIView setAnimationsEnabled:YES];
}


@end
