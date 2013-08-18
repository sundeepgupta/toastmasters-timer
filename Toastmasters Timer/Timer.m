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
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)pause {
    [self stop];
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
    self.seconds += SECONDS_INTERVAL;
    [self.delegate updateElaspedSeconds:self.seconds];
}

- (BOOL)isRunning {
    return (BOOL)self.timer;
}

@end
