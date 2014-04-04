#import <Foundation/Foundation.h>

@class TTTimerVC;
@class TTTimer;


@interface TTAlertManager : NSObject

- (id)initWithTimer:(TTTimer *)timer timerVC:(TTTimerVC *)timerVC defaults:(NSUserDefaults *)defaults;


- (void)recreateNotifications;
- (void)setupLocalNotifications;
- (void)cancelLocalNotifications;

- (void)performAlertForColorIndex:(ColorIndex)index;
@end
