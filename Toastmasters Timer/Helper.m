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





@end
