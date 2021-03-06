#import "TTTimer.h"


#define SECONDS_INTERVAL 1


@interface TTTimer()
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic, readwrite) NSDate *startDate;
@property (strong, nonatomic) NSDate *pauseDate;
@end


@implementation TTTimer
- (TTTimer *)init {
    self = [super init];
    if (self) {
        [self resetSeconds];
    }
    return self;
}

- (void)resetSeconds {
    self.seconds = -1;
}

- (void)startFromStopped {
    [self initializeTimer];
    [self saveStartDate];
}
- (void)initializeTimer {
    self.timer = [NSTimer timerWithTimeInterval:SECONDS_INTERVAL target:self selector:@selector(updateSeconds) userInfo:nil repeats:YES];
    NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
    [currentRunLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)saveStartDate {
    self.startDate = [NSDate date];
}

- (void)pause {
    [self destroyTimer];
    self.pauseDate = [NSDate date];
}

- (void)unpause {
    [self setupStartDateForUnpause];
    [self initializeTimer];
}
     
- (void)setupStartDateForUnpause {
    NSDate *currentDate = [NSDate date];
    NSDate *adjustedStartDate = [currentDate dateByAddingTimeInterval:-self.seconds];
    self.startDate = adjustedStartDate;
}

- (void)stop {
    [self destroyTimer];
    [self resetSeconds];
}
- (void)destroyTimer {
    [self.timer invalidate];
    self.timer = nil;
}


- (void)updateSeconds {
    NSTimeInterval secondsElasped = -[self.startDate timeIntervalSinceNow];
    self.seconds = round(secondsElasped);
    [self postNotification];
    [self callDelegate];
}

- (void)postNotification {
    NSDictionary *info = [self notificationInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:TIMER_NOTIFICATION object:self userInfo:info];
}

- (void)callDelegate {
    if (self.delegate) {
        [self.delegate didUpdateWithSeconds:self.seconds];
    }
}

- (NSDictionary *)notificationInfo {
    NSNumber *secondsNumber = [NSNumber numberWithInteger:self.seconds];
    NSDictionary *info = @{SECONDS_INFO_KEY:secondsNumber};
    return info;
}

- (TIMER_STATUS)status {
    TIMER_STATUS status;
    if (self.seconds == -1) {
        status = STOPPED;
    } else if (!self.timer) {
        status = PAUSED;
    } else {
        status = RUNNING;
    }
    return status;
}


@end
