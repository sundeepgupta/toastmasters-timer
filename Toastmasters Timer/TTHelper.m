#import "TTHelper.h"
#import "TTColorButton.h"
#import "TTCommonStrings.h"
#import "TTAnalyticsInterface.h"


#define MAX_SECONDS 5995 //99:55


@implementation TTHelper


#pragma mark - App and Url handling
+ (void)openWebsiteWithUrlString:(NSString *)urlString {
    if ([self canOpenAppWithUrlPrefix:@"http://"]) {
        [self openAppWithUrlString:urlString];
    } else {
        [self showAlertWithTitle:STRING_ERROR_TTITLE_GENERAL withMessage:NSLocalizedString(@"can't open link message", @"The message in the error when the device can't open web links.")];
    }
}
+ (BOOL)canOpenAppWithUrlPrefix:(NSString *)urlPrefix {
    BOOL canOpen = NO;
    NSURL *url = [NSURL URLWithString:urlPrefix];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        canOpen = YES;
    }
    return canOpen;
}
+ (void)openAppWithUrlString:(NSString *)urlString {    
    NSURL *url = [NSURL URLWithString:urlString];
    UIApplication *app = [UIApplication sharedApplication];
    [app openURL:url];
}


#pragma mark - Alert views
+ (void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:STRING_ALERT_BUTTON_TITLE_DEFAULT otherButtonTitles:nil, nil];
    [alert show];
}



#pragma mark - Info Plist
+ (NSString *)bundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}




#pragma mark - Strings from seconds and wheel
+ (NSString *)stringForSeconds:(NSInteger)seconds {
    NSInteger adjustedSeconds = [self adjustedSeconds:seconds];
    NSInteger minutes = [self minutesForSeconds:adjustedSeconds];
    NSInteger remainderSeconds = [self remainderSecondsForSeconds:adjustedSeconds];
    NSString *string = [NSString stringWithFormat:@"%02li:%02li", (long)minutes, (long)remainderSeconds];
    return string;
}

+ (NSInteger)adjustedSeconds:(NSInteger)seconds {
    if (seconds < 0) {
        seconds = 0;
    } else if (seconds > MAX_SECONDS) {
        seconds = MAX_SECONDS;
    }
    return seconds;
}



#pragma mark - Convert total seconds to minutes and seconds
+ (NSInteger)minutesForSeconds:(NSInteger)seconds {
    NSInteger minutes = floor(seconds/60);
    return minutes;
}

+ (NSInteger)remainderSecondsForSeconds:(NSInteger)seconds {
    NSInteger remainderSeconds = seconds%60;
    return remainderSeconds;
}




#pragma mark - Seconds from Strings
+ (NSNumber *)secondsNumberForTimeString:(NSString *)timeString {
    NSInteger secondsInteger = [self secondsForTimeString:timeString];
    NSNumber *secondsNumber = [NSNumber numberWithInteger:secondsInteger];
    return secondsNumber;
}
+ (NSInteger)secondsForTimeString:(NSString *)timeString {
    NSArray *components = [timeString componentsSeparatedByString:@":"];
    NSString *minutesString = components[0];
    NSInteger minutes = minutesString.integerValue;
    NSString *secondsString = components[1];
    NSInteger seconds = secondsString.integerValue;
    NSInteger totalSeconds = minutes*60 + seconds;
    return totalSeconds;
}






#pragma mark - Color Buttons
+ (void)setupTitlesForColorButtons:(NSArray *)colorButtons withColorArray:(NSArray *)colorArray{
    for (ColorIndex i = GREEN_COLOR_INDEX; i < COLOR_INDEX_COUNT; i++) {
        NSInteger seconds = [colorArray[i] integerValue];
        TTColorButton *button = colorButtons[i];
        [self setupTitleForColorButton:button withSeconds:seconds];
    }
}
+ (void)setupTitleForColorButton:(TTColorButton *)button withSeconds:(NSInteger)seconds {
    NSString *title = [self stringForSeconds:seconds];
    [self updateTitle:title forButton:button];
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    UIImage *img = nil;
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}



#pragma mark - Timer Notifications
+ (void)registerForTimerNotificationsWithObject:(id)object {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:object selector:@selector(timerUpdatedSecondsWithNotification:) name:TIMER_NOTIFICATION object:nil];
}

+ (NSInteger)secondsForNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *secondsNumber = userInfo[SECONDS_INFO_KEY];
    NSInteger seconds = secondsNumber.integerValue;
    return seconds;
}



#pragma mark - Universal Helpers
+ (void)updateTitle:(NSString *)title forButton:(UIButton *)button {
    [UIView setAnimationsEnabled:NO];
    [button setTitle:title forState:UIControlStateNormal];
    [UIView setAnimationsEnabled:YES];
}

+ (BOOL)isFirstLaunch {
    BOOL isFirstLaunch;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:IS_NOT_FIRST_LAUNCH]) {
        isFirstLaunch = NO;
    } else {
        isFirstLaunch = YES;
        [defaults setObject:@1 forKey:IS_NOT_FIRST_LAUNCH];
    }
    return isFirstLaunch;
}

+ (BOOL)upgraded {
    return [[NSUserDefaults standardUserDefaults] boolForKey:UPGRADED];
}



#pragma mark - Colour button names
+ (NSString *)nameForColorIndex:(ColorIndex)index {
    NSString *name;
    
    switch (index) {
        case GREEN_COLOR_INDEX:
            name = NSLocalizedString(@"green color name", nil);
            break;
        case AMBER_COLOR_INDEX:
            name = NSLocalizedString(@"amber color name", nil);
            break;
        case RED_COLOR_INDEX:
            name = NSLocalizedString(@"red color name", nil);
            break;
        case BELL_COLOR_INDEX:
            name = NSLocalizedString(@"bell color name", nil);
            break;
        default:
            break;
    }
    
    return name;
}



#pragma mark - Analytics
+ (void)sendColorTimeValuesToAnalytics {
    NSArray *times = [[NSUserDefaults standardUserDefaults] arrayForKey:COLOR_TIMES_KEY];
    NSString *label = [NSString stringWithFormat:@"%@,%@,%@,%@", times[GREEN_COLOR_INDEX], times[AMBER_COLOR_INDEX], times[RED_COLOR_INDEX], times[BELL_COLOR_INDEX]];
    [TTAnalyticsInterface sendCategory:GOOGLE_ANALYTICS_CATEGORY_TIME_ENTRY action:GOOGLE_ANALYTICS_ACTION_SAVE_COLOURS label:label];
}


@end
