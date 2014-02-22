//
//  AppDelegate.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "AppDelegate.h"
#import "TimerVC.h"
#import <Crashlytics/Crashlytics.h>
#import "DDTTYLogger.h"
#import "DDASLLogger.h"


@interface AppDelegate ()
@property (strong, nonatomic) TimerVC *timerVc;
@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupLogger];
    [self setupStatusBarForApplication:application];
    [self setupTimerVc];
    [self setupDefaults];
    [self clearAppIconBadge];
    [self setupCrashlytics];
    return YES;
}

- (void)setupLogger {
    static int ddLogLevel = LOG_LEVEL_ERROR;
#ifdef DEBUG
    ddLogLevel = LOG_LEVEL_VERBOSE;
#endif

    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

- (void)setupStatusBarForApplication:(UIApplication *)application {
    application.statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)setupTimerVc {
    self.timerVc = (TimerVC *)self.window.rootViewController;
}

- (void)setupDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *colorArray = [defaults arrayForKey:COLOR_TIMES_KEY];
    if (!colorArray  ||  colorArray.count != 4) {
        colorArray = @[@0, @0, @0, @0];
        [defaults setObject:colorArray forKey:COLOR_TIMES_KEY];
        [defaults synchronize];
    }
}

- (void)clearAppIconBadge {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)setupCrashlytics {
    [Crashlytics startWithAPIKey:API_KEY_CRASHLYTICS];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [self clearAppIconBadge];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.timerVc setupViewForBackground];
    [self clearAppIconBadge];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self.timerVc setupViewForReturningToForeground];
    [self clearAppIconBadge];
}

@end
