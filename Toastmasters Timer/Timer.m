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
@property NSInteger secondsRemaining;

@end


@implementation Timer
- (Timer *)initWithSeconds:(NSInteger)seconds {
    self = [super init];
    if (self) {
        self.seconds = seconds;
        [self setupSeconds];
    }
    return self;
}

- (void)setupSeconds {
    self.secondsRemaining = self.seconds;
}

- (void)start {
    self.timer = [NSTimer timerWithTimeInterval:SECONDS_INTERVAL target:self selector:@selector(updateSecondsRemaining) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)pause {
    
}

- (void)stop {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)reset {
    [self stop];
    [self setupSeconds];
}

- (void)updateSecondsRemaining {
    self.secondsRemaining = self.secondsRemaining - SECONDS_INTERVAL;
    
    [self.delegate updateViewWithSecondsRemaining:self.secondsRemaining];

    if (self.secondsRemaining == 0) {
        [self timerFinished];
    }
}

- (void)timerFinished {
    [self reset];
}



@end
