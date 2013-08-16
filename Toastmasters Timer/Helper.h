//
//  Helper.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MINUTES_KEY @"min"
#define SECONDS_KEY @"sec"



@interface Helper : NSObject
+ (NSString *)stringForInteger:(NSInteger)integer;
+ (NSString *)unitStringForInteger:(NSInteger)integer;

+ (NSDictionary *)unitsForSeconds:(NSInteger)seconds;
+ (NSDictionary *)unitsForMinutes:(NSInteger)minutes andSeconds:(NSInteger)seconds;
@end
