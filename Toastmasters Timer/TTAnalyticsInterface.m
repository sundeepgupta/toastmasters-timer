#import "TTAnalyticsInterface.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "TTConstants.h"

@interface TTAnalyticsInterface ()

@end


@implementation TTAnalyticsInterface

#pragma Setup
+ (void)loadAnalytics {
    [self setupAnalytics];
    //setup also starts tracking
}

+ (void)setupAnalytics {
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    [[GAI sharedInstance] trackerWithTrackingId:GOOGLE_ANALYTICS_TRACKING_ID];
}


#pragma mark - Tracking
+ (void)sendCategory:(NSString *)category action:(NSString *)action {
    [self sendCategory:category action:action label:nil];
}

+ (void)sendCategory:(NSString *)category action:(NSString *)action label:(NSString *)label {
    [self sendCategory:category action:action label:label value:nil];
}

+ (void)sendCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value {
    NSDictionary *trackerInfo = [[GAIDictionaryBuilder createEventWithCategory:category action:action label:label value:value] build];
    [[GAI sharedInstance].defaultTracker send:trackerInfo];
    [self dispatchEvents];
}


#pragma mark - Dispatching
+ (void)dispatchEvents {
    [[GAI sharedInstance] dispatch];
}

@end
