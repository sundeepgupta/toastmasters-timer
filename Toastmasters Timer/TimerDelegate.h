//
//  TimerDelegate.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TimerDelegate <NSObject>

@required
-(void)updateViewWithSecondsRemaining:(NSInteger)secondsRemaining;


@end
