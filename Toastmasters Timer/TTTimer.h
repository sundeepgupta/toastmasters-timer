#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, TIMER_STATUS) {
    STOPPED,
    PAUSED,
    RUNNING,
};


@protocol TimerDelegate <NSObject>
@required
- (void)didUpdateWithSeconds:(NSInteger)seconds;
@end


@interface TTTimer : NSObject
@property NSInteger seconds;
@property (weak, nonatomic) id<TimerDelegate> delegate;
@property (strong, nonatomic, readonly) NSDate *startDate;

- (void)startFromStopped;
- (void)pause;
- (void)unpause;
- (void)stop;
- (TIMER_STATUS)status;
@end


