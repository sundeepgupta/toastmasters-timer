//
//  TimerVC.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TimerVC : UIViewController

- (void)toggleEmphasisForColorWithIndex:(ColorIndex)index;

- (void)setupViewForBackground;
- (void)setupViewForReturningToForeground;



@end
