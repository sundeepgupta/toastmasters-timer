#import <Foundation/Foundation.h>

@interface TTAnalyticsInterface : NSObject

+ (void)loadAnalytics;

+ (void)sendCategory:(NSString *)category action:(NSString *)action;
+ (void)sendCategory:(NSString *)category action:(NSString *)action label:(NSString *)label;
+ (void)sendCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value;

+ (void)dispatchEvents;

@end
