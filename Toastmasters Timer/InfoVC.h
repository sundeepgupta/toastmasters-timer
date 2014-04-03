//
//  InfoVC.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-29.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "TTModalDelegate.h"

@interface InfoVC : UIViewController <MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) NSString *currentTimerString;
@property (nonatomic, weak) NSObject<TTModalDelegate> *modalDelegate;
@end
