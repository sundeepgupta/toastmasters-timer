//
//  Timer.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "Timer.h"


#define SECONDS_INTERVAL 1


@interface Timer()
@property (strong, nonatomic) NSTimer *timer;
@property NSInteger seconds;
@property (strong, nonatomic, readwrite) NSDate *startDate;
@property (strong, nonatomic) NSDate *pauseDate;
@end


@implementation Timer
- (Timer *)init {
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
    [self.delegate updateElaspedSeconds:self.seconds];
}


- (NSString *)status {
    NSString *status;
    if (self.seconds == -1) {
        status = @"stopped";
    } else if (!self.timer) {
        status = @"paused";
    } else {
        status = @"running";
    }
    return status;
}


@end
