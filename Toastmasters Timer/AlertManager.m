//
//  AlertManager.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-09-20.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "AlertManager.h"

@interface AlertManager ()
@property (strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation AlertManager

- (id)init {
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}



- (BOOL)shouldAudioAlert {
    BOOL shouldAlert = [self.defaults boolForKey:SHOULD_AUDIO_ALERT_KEY];
    return shouldAlert;
}

@end
