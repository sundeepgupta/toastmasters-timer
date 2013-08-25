//
//  Helper.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DISABLED_ALPHA 0.3

#define GREY_RGB 237

#define GREEN_R 0.
#define GREEN_G 200.
#define GREEN_B 0.

#define AMBER_R 255.0
#define AMBER_G 199.0
#define AMBER_B 0.0

#define RED_R 255.
#define RED_G 0.
#define RED_B 0.

#define BELL_R 255.
#define BELL_G 246.
#define BELL_B 0.


@interface Helper : NSObject
+ (NSString *)unitStringForNumber:(NSNumber *)number;
+ (NSString *)unitStringForInteger:(NSInteger)integer;

+ (NSInteger)integerForNumber:(NSNumber *)number;


+ (UIImage *)imageWithColor:(UIColor *)color;


+ (void)setupLabels:(NSDictionary *)labels forColors:(NSDictionary *)colors;
@end
