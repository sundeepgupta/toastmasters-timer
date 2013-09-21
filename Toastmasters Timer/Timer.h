//
//  Timer.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimerDelegate.h"


typedef NS_ENUM(NSInteger, TIMER_STATUS) {
    STOPPED,
    PAUSED,
    RUNNING,
};


@interface Timer : NSObject

@property (weak, nonatomic) id<TimerDelegate> delegate;
@property (strong, nonatomic, readonly) NSDate *startDate;

- (void)startFromStopped;
- (void)pause;
- (void)unpause;
- (void)stop;
- (TIMER_STATUS)status;

@end


