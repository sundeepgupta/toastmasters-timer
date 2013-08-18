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
#define GREEN_R 0
#define GREEN_G 200
#define GREEN_B 0



@interface Helper : NSObject
+ (NSString *)unitStringForNumber:(NSNumber *)number;
+ (NSString *)unitStringForInteger:(NSInteger)integer;

+ (NSInteger)integerForNumber:(NSNumber *)number;


+ (void)updateSoundBellButton:(UIButton *)button forSetting:(BOOL)setting;

@end
