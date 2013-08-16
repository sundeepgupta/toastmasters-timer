//
//  Times.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "Times.h"

#define DEFAULT_GREEN_MINUTES 1
#define DEFAULT_GREEN_SECONDS 0

@interface Times()

@end


@implementation Times

- (Times *)init {
    self = [super init];
    if (self) {
        self.greenMinutes = DEFAULT_GREEN_MINUTES;
        self.greenSeconds = DEFAULT_GREEN_SECONDS;
    }
    return self;
}



@end
