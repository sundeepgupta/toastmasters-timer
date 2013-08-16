//
//  Times.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "Times.h"

#define DEFAULT_GREEN_SECONDS 300

@interface Times()
@property NSInteger green;
@property NSInteger amber;
@property NSInteger red;
@property NSInteger bell;
@end


@implementation Times

- (Times *)init {
    self = [super init];
    if (self) {
        self.green = DEFAULT_GREEN_SECONDS;
        self.amber = DEFAULT_GREEN_SECONDS;
        self.red = DEFAULT_GREEN_SECONDS;
        self.bell = DEFAULT_GREEN_SECONDS;
    }
    return self;
}

- (NSDictionary *)greenUnits {
    NSDictionary *units = [self unitsFromSeconds:self.green];
    return units;
}

- (NSDictionary *)unitsFromSeconds:(NSInteger)seconds {
    NSInteger minutes = (NSInteger)floor(seconds/60);
    NSInteger clockSeconds = seconds%60;
    
    NSNumber *minutesNumber = [NSNumber numberWithInteger:minutes];
    NSNumber *clockSecondsNumber = [NSNumber numberWithInteger:clockSeconds];
    
    NSDictionary *units = [NSDictionary dictionaryWithObjectsAndKeys:minutesNumber, MINUTES_KEY, clockSecondsNumber, SECONDS_KEY, nil];
    return  units;
}

@end
