//
//  Helper.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>


#define SECONDS_INCREMENT 5




@interface Helper : NSObject
+ (NSString *)stringForLevelNumber:(NSInteger)levelNumber andSectionNumber:(NSInteger)sectionNumber;
+ (NSString *)stringForTotalSeconds:(NSInteger)totalSeconds;




+ (NSString *)unitStringForNumber:(NSNumber *)number;
+ (NSString *)unitStringForInteger:(NSInteger)integer;

+ (NSInteger)integerForNumber:(NSNumber *)number;


+ (UIImage *)imageWithColor:(UIColor *)color;


+ (void)setupLabels:(NSMutableDictionary *)labels forColors:(NSMutableDictionary *)colors;


+ (NSInteger)totalSecondsForColorDict:(NSDictionary *)colorDict;
+ (NSInteger)totalSecondsForMinutes:(NSInteger)minutes andSeconds:(NSInteger)seconds;



#pragma mark - Universal Helpers 
+ (void)updateTitle:(NSString *)title forButton:(UIButton *)button;

@end
