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


#pragma mark - Setup Local Notifications
- (void)resetLocalNotifications {
    [self cancelLocalNotifications];
    [self setupLocalNotifications];
}
- (void)setupLocalNotifications {
    NSDictionary *colors = [self.defaults dictionaryForKey:COLOR_TIMES_KEY];
    
    for (NSString *colorName in colors) {
        [self setupNotificationForColor:colorName];
    }
}
- (void)cancelLocalNotifications {
    UIApplication *app = [UIApplication sharedApplication];
    [app cancelAllLocalNotifications];
}

- (void)setupNotificationForColor:(NSString *)color {
    NSInteger totalSeconds = [self totalSecondsForColor:color];
    UILocalNotification *notification = [self notificationForColor:color andTimeInterval:totalSeconds];
    [self scheduleNotification:notification];
}
- (NSInteger)totalSecondsForColor:(NSString *)color {
    NSDictionary *colorsDict = [self.defaults dictionaryForKey:COLOR_TIMES_KEY];
    NSDictionary *colorDict = colorsDict[color];
    NSInteger minutes = [colorDict[MINUTES_KEY] integerValue];
    NSInteger seconds = [colorDict[SECONDS_KEY] integerValue];
    NSInteger totalSeconds = minutes*60 + seconds;
    return  totalSeconds;
}
- (UILocalNotification *)notificationForColor:(NSString *)color andTimeInterval:(NSInteger)timeInterval {
    NSDate *startDate = self.timer.startDate;
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeInterval:timeInterval sinceDate:startDate];
    notification.alertBody = [self alertMessageForColor:color];
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







#pragma mark - Perform Alert
- (void)performAlertForReachedColorName:(NSString *)colorName {
    [self showAlertForColor:colorName];
    [self.timerVC toggleEmphasisForLabelsWithAlertedColorName:colorName];
    
    if ([self.defaults boolForKey:SHOULD_AUDIO_ALERT_KEY]) {
        [self performAudioAlert];
    }
}
- (void)showAlertForColor:(NSString *)colorName {
    UIColor *alertColor;
    NSString *title = @"Attention!";
    NSString *message = [self alertMessageForColor:colorName];
    
    if ([colorName isEqualToString:GREEN_COLOR_NAME]) {
        alertColor = [UIColor colorWithRed:GREEN_R/255 green:GREEN_G/255 blue:GREEN_B/255 alpha:1];
    } else if ([colorName isEqualToString:AMBER_COLOR_NAME]){
        alertColor = [UIColor colorWithRed:AMBER_R/255 green:AMBER_G/255 blue:AMBER_B/255 alpha:1];
    } else if ([colorName isEqualToString:RED_COLOR_NAME]){
        alertColor = [UIColor colorWithRed:RED_R/255 green:RED_G/255 blue:RED_B/255 alpha:1];
    } else if ([colorName isEqualToString:BELL_COLOR_NAME]){
        alertColor = [UIColor colorWithRed:BELL_R/255 green:BELL_G/255 blue:BELL_B/255 alpha:1];
        message = @"Ring the bell.";
    }
    
    UIImage *image = [Helper imageWithColor:alertColor];
    [self.timerVC.view makeToast:message duration:TOAST_DURATION position:TOAST_POSITION title:title image:image tag:TOAST_TAG];
}


- (NSString *)alertMessageForColor:(NSString *)color {
    return   [NSString stringWithFormat:@"Turn the %@ light on.", color];
}

- (void)performAudioAlert {
    AudioServicesPlaySystemSound(AUDIO_ALERT_SOUND);
}






@end
