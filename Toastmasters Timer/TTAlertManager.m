#import "TTAlertManager.h"
#import "TTTimer.h"
#import "TTTimerVC.h"
#import "Toast+UIView.h"
#import <AudioToolbox/AudioServices.h>


@interface TTAlertManager ()
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) TTTimer *timer;
@property (strong, nonatomic) TTTimerVC *timerVC;
@property (nonatomic, strong) NSArray *colorArray;
@end


@implementation TTAlertManager

- (id)initWithTimer:(TTTimer *)timer timerVC:(TTTimerVC *)timerVC defaults:(NSUserDefaults *)defaults {
    self = [super init];
    if (self) {
        self.defaults = defaults;
        self.timer = timer;
        self.timerVC = timerVC;
        [self cancelLocalNotifications];
    }
    return self;
}
 

#pragma mark - Local Notifications
- (void)recreateNotifications {
    [self cancelLocalNotifications];
    [self setupLocalNotifications];
}
- (void)setupLocalNotifications {
    self.colorArray = [self.defaults arrayForKey:COLOR_TIMES_KEY];
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
    if (notification) {
        [self scheduleNotification:notification];
    }
}

- (UILocalNotification *)notificationForColorIndex:(ColorIndex)index {
    UILocalNotification *notification;
    
    NSInteger timeInterval = [self.colorArray[index] integerValue];
    
    if (timeInterval > 0) {
        NSDate *startDate = self.timer.startDate;

        notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate dateWithTimeInterval:timeInterval sinceDate:startDate];
        notification.alertBody = [self alertMessageForColorIndex:index];
        notification.timeZone = [NSTimeZone localTimeZone];
        notification.soundName = [self notificationSoundName];
    }
    return notification;
}

- (NSString *)notificationSoundName {
    NSString *name = nil;
    if ([self.defaults boolForKey:SHOULD_AUDIO_ALERT_KEY]) {
        name = UILocalNotificationDefaultSoundName;
    }
    return name;
}

- (void)scheduleNotification:(UILocalNotification *)notification {
    UIApplication *app = [UIApplication sharedApplication];
    [app scheduleLocalNotification:notification];
}







#pragma mark - Perform Color Alert
- (void)performAlertForColorIndex:(ColorIndex)index {
    [self showAlertForColorIndex:index];
    
    if ([self.defaults boolForKey:SHOULD_AUDIO_ALERT_KEY]) {
        [self performAudioAlert];
    }
}
- (void)showAlertForColorIndex:(ColorIndex)index {
    NSString *title = NSLocalizedString(@"color alert title", nil);
    NSString *message = [self alertMessageForColorIndex:index];
    UIImage *image = [self visualAlertImageForColorIndex:index];
    UIViewController *vcForToast = [self currentViewController];
    [vcForToast.view makeToast:message duration:TOAST_DURATION position:TOAST_POSITION title:title image:image tag:TOAST_TAG];
}

- (UIViewController *)currentViewController {
    UIViewController *currentVc;
    UIViewController *modalVc = self.timerVC.presentedViewController;
    if (modalVc) {
        currentVc = modalVc;
    } else {
        currentVc = self.timerVC;
    }
    return currentVc;
}

- (NSString *)alertMessageForColorIndex:(ColorIndex)index {
    NSString *message;
    if (index == BELL_COLOR_INDEX) {
        message = NSLocalizedString(@"ring bell alert message", nil);
    } else {
        NSString *colorName = [TTHelper nameForColorIndex:index];
        message = [NSString stringWithFormat:NSLocalizedString(@"turn color light on message", nil), colorName];
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
    
    UIImage *image = [TTHelper imageWithColor:alertColor];
    return image;
}


- (void)performAudioAlert {
    AudioServicesPlaySystemSound(AUDIO_ALERT_SOUND_ID);
}






@end
