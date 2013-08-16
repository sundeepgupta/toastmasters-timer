//
//  TimerVC.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerDelegate.h"

@class Times;

@interface TimerVC : UIViewController <TimerDelegate>
@property (strong, nonatomic) Times *times;

- (IBAction)startButtonPress:(id)sender;

@end
