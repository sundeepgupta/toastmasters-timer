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
@property NSInteger totalSeconds;
@property NSInteger secondsRemaining;
@property NSInteger secondsElasped;

@end


@implementation Timer
- (Timer *)initWithSeconds:(NSInteger)seconds {
    self = [super init];
    if (self) {
        self.totalSeconds = seconds;
        [self setupSeconds];
    }
    return self;
}
- (Timer *)initWithMinutes:(NSInteger)minutes andSeconds:(NSInteger)seconds {
    self = [super init];
    if (self) {
        self.totalSeconds = [Helper totalSecondsForMinutes:minutes andSeconds:seconds];
        [self setupSeconds];
    }
    return self;
}


- (void)setupSeconds {
    self.secondsRemaining = self.totalSeconds;
    [self updateSecondsElasped];
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
    [self setupSeconds];
}
- (void)stop {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateSeconds {
    self.secondsRemaining = self.secondsRemaining - SECONDS_INTERVAL;
    [self updateSecondsElasped];
    [self.delegate updateViewWithSeconds:self.secondsElasped];
}
- (void)updateSecondsElasped {
    self.secondsElasped = self.totalSeconds - self.secondsRemaining;
}



@end
