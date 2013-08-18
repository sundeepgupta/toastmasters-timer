//
//  Helper.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface Helper : NSObject
+ (NSString *)unitStringForNumber:(NSNumber *)number;
+ (NSString *)unitStringForInteger:(NSInteger)integer;

+ (NSInteger)integerForNumber:(NSNumber *)number;


@end
