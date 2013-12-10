//
//  SGSector.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 12/9/2013.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SGSector.h"

@implementation SGSector

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"%i  |  %f, %f, %f", self.sector, self.minValue, self.midValue, self.maxValue];
    return description;
}
@end
