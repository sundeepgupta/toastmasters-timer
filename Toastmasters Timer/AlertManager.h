//
//  AlertManager.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-09-20.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TimerVC;
@class Timer;


@interface AlertManager : NSObject

- (id)initWithTimer:(Timer *)timer timerVC:(TimerVC *)timerVC defaults:(NSUserDefaults *)defaults;


- (void)resetLocalNotifications;
- (void)setupLocalNotifications;
- (void)cancelLocalNotifications;

- (void)performAlertForReachedColorName:(NSString *)colorName;

@end
