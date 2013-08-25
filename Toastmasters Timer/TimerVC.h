//
//  TimerVC.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerDelegate.h"

@interface TimerVC : UIViewController <TimerDelegate>
@property (strong, nonatomic) NSDictionary *colors;

@end
