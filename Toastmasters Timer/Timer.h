//
//  Timer.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimerDelegate.h"

@interface Timer : NSObject

@property (weak, nonatomic) id<TimerDelegate> delegate;

- (void)start;
- (void)pause;
- (void)reset;
- (BOOL)isRunning;


@end


