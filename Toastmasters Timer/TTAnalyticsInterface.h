#import <Foundation/Foundation.h>

@interface TTAnalyticsInterface : NSObject

+ (void)loadAnalytics;
+ (void)sendTrackingInfoWithCategory:(NSString *)category action:(NSString *)action;
+ (void)dispatchEvents;

@end
