//
//  AlertManager.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-09-20.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "AlertManager.h"
#import "Timer.h"
#import "TimerVC.h"
#import "Toast+UIView.h"
#import <AudioToolbox/AudioServices.h>


@interface AlertManager ()
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) Timer *timer;
@property (strong, nonatomic) TimerVC *timerVC;
@property (nonatomic, strong) NSArray *colorArray;
@end


@implementation AlertManager

- (id)initWithTimer:(Timer *)timer timerVC:(TimerVC *)timerVC defaults:(NSUserDefaults *)defaults {
    self = [super init];
    if (self) {
        self.defaults = defaults;
        self.timer = timer;
        self.timerVC = timerVC;
        self.colorArray = [self.defaults arrayForKey:COLOR_TIMES_KEY];
    }
    return self;
}


#pragma mark - Local Notifications
- (void)resetLocalNotifications {
    [self cancelLocalNotifications];
    [self setupLocalNotifications];
}
- (void)setupLocalNotifications {
    for (ColorIndex i = GREEN_COLOR_INDEX; i < COLOR_INDEX_COUNT; i++) {
        [self setupNotificationForColorIndex:i];
    }
}
- (void)cancelLocalNotifications {
    UIApplication *app = [UIApplication sharedApplication];
    [app cancelAllLocalNotifications];
}

- (void)setupNotificationForColorIndex:(ColorIndex)index {
    UILocalNotification *notification = [self notificationForColorIndex:index];
    [self scheduleNotification:notification];
}

- (UILocalNotification *)notificationForColorIndex:(ColorIndex)index {
    
    NSInteger timeInterval = [self.colorArray[index] integerValue];
    NSDate *startDate = self.timer.startDate;
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeInterval:timeInterval sinceDate:startDate];
    notification.alertBody = [self alertMessageForColorIndex:index];
    notification.timeZone = [NSTimeZone localTimeZone];
    
    if ([self.defaults boolForKey:SHOULD_AUDIO_ALERT_KEY]) {
        notification.soundName = UILocalNotificationDefaultSoundName;
    } else {
        notification.soundName = nil;
    }
    
    return notification;
}
- (void)scheduleNotification:(UILocalNotification *)notification {
    UIApplication *app = [UIApplication sharedApplication];
    [app scheduleLocalNotification:notification];
}







#pragma mark - Perform Color Alert
- (void)performAlertForColorIndex:(ColorIndex)index {
    [self showAlertForColorIndex:index];
    [self.timerVC toggleEmphasisForColorWithIndex:index];
    
    if ([self.defaults boolForKey:SHOULD_AUDIO_ALERT_KEY]) {
        [self performAudioAlert];
    }
}
- (void)showAlertForColorIndex:(ColorIndex)index {
    NSString *title = @"Attention!";
    NSString *message = [self alertMessageForColorIndex:index];
    UIImage *image = [self visualAlertImageForColorIndex:index];
    [self.timerVC.view makeToast:message duration:TOAST_DURATION position:TOAST_POSITION title:title image:image tag:TOAST_TAG];
}

- (NSString *)alertMessageForColorIndex:(ColorIndex)index {
    NSString *message;
    if (index == BELL_COLOR_INDEX) {
        message = @"Ring the bell.";
    } else {
        NSString *colorName = [Helper nameForColorIndex:index];
        message = [NSString stringWithFormat:@"Turn the %@ light on.", colorName];
    }
    return message;
}

- (UIImage *)visualAlertImageForColorIndex:(ColorIndex)index {
    UIColor *alertColor;
    
    switch (index) {
        case GREEN_COLOR_INDEX:
            alertColor = [UIColor colorWithRed:GREEN_R/255 green:GREEN_G/255 blue:GREEN_B/255 alpha:1];
            break;
        case AMBER_COLOR_INDEX:
            alertColor = [UIColor colorWithRed:AMBER_R/255 green:AMBER_G/255 blue:AMBER_B/255 alpha:1];
            break;
        case RED_COLOR_INDEX:
            alertColor = [UIColor colorWithRed:RED_R/255 green:RED_G/255 blue:RED_B/255 alpha:1];
            break;
        case BELL_COLOR_INDEX:
            alertColor = [UIColor colorWithRed:BELL_R/255 green:BELL_G/255 blue:BELL_B/255 alpha:1];
            break;
        default:
            break;
    }
    
    UIImage *image = [Helper imageWithColor:alertColor];
    return image;
}


- (void)performAudioAlert {
    AudioServicesPlaySystemSound(AUDIO_ALERT_SOUND_ID);
}






@end
