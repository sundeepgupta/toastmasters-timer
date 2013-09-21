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

@end

@implementation AlertManager

- (id)initWithTimer:(Timer *)timer timerVC:(TimerVC *)timerVC defaults:(NSUserDefaults *)defaults {
    self = [super init];
    if (self) {
        self.defaults = defaults;
        self.timer = timer;
        self.timerVC = timerVC;
    }
    return self;
}


#pragma mark - Local Notifications
- (void)resetLocalNotifications {
    [self cancelLocalNotifications];
    [self setupLocalNotifications];
}
- (void)setupLocalNotifications {
    NSDictionary *colorNames = [self.defaults dictionaryForKey:COLOR_TIMES_KEY];
    
    for (NSString *colorName in colorNames) {
        [self setupNotificationForColorName:colorName];
    }
}
- (void)cancelLocalNotifications {
    UIApplication *app = [UIApplication sharedApplication];
    [app cancelAllLocalNotifications];
}

- (void)setupNotificationForColorName:(NSString *)colorName {
    NSInteger totalSeconds = [self.timerVC totalSecondsForColorName:colorName];
    UILocalNotification *notification = [self notificationForColorName:colorName andTimeInterval:totalSeconds];
    [self scheduleNotification:notification];
}

- (UILocalNotification *)notificationForColorName:(NSString *)colorName andTimeInterval:(NSInteger)timeInterval {
    NSDate *startDate = self.timer.startDate;
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeInterval:timeInterval sinceDate:startDate];
    notification.alertBody = [self alertMessageForColorName:colorName];
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
- (void)performAlertForReachedColorName:(NSString *)colorName {
    [self showAlertForColorName:colorName];
    [self.timerVC toggleEmphasisForLabelsWithAlertedColorName:colorName];
    
    if ([self.defaults boolForKey:SHOULD_AUDIO_ALERT_KEY]) {
        [self performAudioAlert];
    }
}
- (void)showAlertForColorName:(NSString *)colorName {
    NSString *title = @"Attention!";
    NSString *message = [self alertMessageForColorName:colorName];
    UIImage *image = [self visualAlertImageForColorName:colorName];
    [self.timerVC.view makeToast:message duration:TOAST_DURATION position:TOAST_POSITION title:title image:image tag:TOAST_TAG];
}

- (NSString *)alertMessageForColorName:(NSString *)colorName {
    NSString *message;
    if ([colorName isEqualToString:BELL_COLOR_NAME]) {
        message = @"Ring the bell.";
    } else {
        message = [NSString stringWithFormat:@"Turn the %@ light on.", colorName];
    }
    return message;
}

- (UIImage *)visualAlertImageForColorName:(NSString *)colorName {
    UIColor *alertColor;
    if ([colorName isEqualToString:GREEN_COLOR_NAME]) {
        alertColor = [UIColor colorWithRed:GREEN_R/255 green:GREEN_G/255 blue:GREEN_B/255 alpha:1];
    } else if ([colorName isEqualToString:AMBER_COLOR_NAME]){
        alertColor = [UIColor colorWithRed:AMBER_R/255 green:AMBER_G/255 blue:AMBER_B/255 alpha:1];
    } else if ([colorName isEqualToString:RED_COLOR_NAME]){
        alertColor = [UIColor colorWithRed:RED_R/255 green:RED_G/255 blue:RED_B/255 alpha:1];
    } else if ([colorName isEqualToString:BELL_COLOR_NAME]){
        alertColor = [UIColor colorWithRed:BELL_R/255 green:BELL_G/255 blue:BELL_B/255 alpha:1];
    }
    UIImage *image = [Helper imageWithColor:alertColor];
    return image;
}


- (void)performAudioAlert {
    AudioServicesPlaySystemSound(AUDIO_ALERT_SOUND_ID);
}






@end
