#import <Foundation/Foundation.h>
#import "TTConstants.h"


@class TTColorButton;


#define SECONDS_INCREMENT 5


@interface TTHelper : NSObject



+ (void)openWebsiteWithUrlString:(NSString *)urlString;
+ (void)openAppWithUrlString:(NSString *)urlString;

+ (void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message;



#pragma mark - Strings from seconds and wheel
+ (NSString *)stringForSeconds:(NSInteger)totalSeconds;


#pragma mark - Seconds from Strings
+ (NSNumber *)secondsNumberForTimeString:(NSString *)timeString;
+ (NSInteger)secondsForTimeString:(NSString *)timeString;


#pragma mark - Color Buttons
+ (void)setupTitlesForColorButtons:(NSArray *)colorButtons withColorArray:(NSArray *)colorArray;
+ (void)setupTitleForColorButton:(TTColorButton *)button withSeconds:(NSInteger)seconds;


#pragma mark - Info Plist
+ (NSString *)bundleName;




+ (UIImage *)imageWithColor:(UIColor *)color;


+ (NSString *)nameForColorIndex:(ColorIndex)index;


#pragma mark - Timer Notifications
+ (void)registerForTimerNotificationsWithObject:(id)object;
+ (NSInteger)secondsForNotification:(NSNotification *)notification;

    
#pragma mark - Universal Helpers
+ (void)updateTitle:(NSString *)title forButton:(UIButton *)button;
+ (BOOL)isFirstLaunch;


#pragma mark - Analytics
+ (void)sendColorTimeValuesToAnalytics;

@end
