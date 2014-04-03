//
//  TTModalDelegate.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2014-04-02.
//  Copyright (c) 2014 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTModalDelegate <NSObject>
@required
- (void)modalShouldDismiss;
@end
