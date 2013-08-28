//
//  Helper.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "Helper.h"

@implementation Helper
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
        NSNumber *minutes = colorDict[@"minutes"];
        NSNumber *seconds = colorDict[@"seconds"];
        
        NSMutableDictionary *labelDict = labels[colorKey];
        UILabel *minutesLabel = labelDict[@"minutes"];
        UILabel *secondsLabel = labelDict[@"seconds"];
        minutesLabel.text = [self unitStringForNumber:minutes];
        secondsLabel.text = [self unitStringForNumber:seconds];
    }
}





@end
