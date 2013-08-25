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
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSUserDefaults *defaults;

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
    self.seconds = 0;
}

- (void)start {
    self.timer = [NSTimer timerWithTimeInterval:SECONDS_INTERVAL target:self selector:@selector(updateSeconds) userInfo:nil repeats:YES];
    NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
    [currentRunLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
    
   [self saveStartDate];
}

- (void)pause {
    [self stop];
}

- (void)unpause {
    
}

- (void)reset {
    [self stop];
    [self resetSeconds];
}
- (void)stop {
    [self.timer invalidate];
    self.timer = nil;
}
- (void)restart {
    [self reset];
    [self start];
}

- (void)updateSeconds {
    NSTimeInterval secondsElasped = -[self.startDate timeIntervalSinceNow];
    self.seconds = round(secondsElasped);
    [self.delegate updateElaspedSeconds:self.seconds];
    NSLog(@"Timer: %d", self.seconds);
}

- (BOOL)isRunning {
    return (BOOL)self.timer;
}


- (void)saveStartDate {
    self.startDate = [NSDate date];
}

@end
