//
//  TimeEntryVC.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "TTModalDelegate.h"


@protocol TTTimeEntryVCDelegate <NSObject>
@required
- (void)colorTimeDidChangeForIndex:(ColorIndex)index;
- (void)didResetAllColourTimes;
@end

@class AlertManager;

@interface TimeEntryVC : UIViewController
@property (nonatomic, strong) NSString *currentTimerString;
@property ColorIndex currentColorIndex;
@property (nonatomic, strong) AlertManager *alertManager;
@property (nonatomic, weak) NSObject<TTModalDelegate> *modalDelegate;
@property (nonatomic, weak) NSObject<TTTimeEntryVCDelegate> *timeEntryDelegate;
@end
