#import "TTAppDelegate.h"
#import "TTTimerVC.h"
#import <Crashlytics/Crashlytics.h>
#import "DDTTYLogger.h"
#import "DDASLLogger.h"
#import "TTAnalyticsInterface.h"


int ddLogLevel;


@interface TTAppDelegate ()
@property (strong, nonatomic) TTTimerVC *timerVc;
@end


@implementation TTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupLogger];
    [self setupStatusBarForApplication:application];
    [self setupTimerVc];
    [self setupDefaults];
    [self clearAppIconBadge];
//    [TTAnalyticsInterface loadAnalytics];

#ifndef DEBUG
    [self setupCrashlytics];
#endif
    
    return YES;
}

- (void)setupLogger {
    [self setupLogLevel];
    [self addLoggers];
}
- (void)setupLogLevel {
    ddLogLevel = LOG_LEVEL_ERROR;
#ifdef DEBUG
    ddLogLevel = LOG_LEVEL_VERBOSE;
#endif
}
- (void)addLoggers {
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

- (void)setupStatusBarForApplication:(UIApplication *)application {
    application.statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)setupTimerVc {
    self.timerVc = (TTTimerVC *)self.window.rootViewController;
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

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.timerVc setupViewForBackground];
    [self clearAppIconBadge];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    [self.timerVc setupViewForReturningToForeground];
    [self clearAppIconBadge];
}

@end
