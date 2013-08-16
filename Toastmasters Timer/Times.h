//
//  Times.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Times : NSObject

@property NSInteger greenMinutes;
@property NSInteger greenSeconds;


- (NSDictionary *)greenUnits;
- (void)saveGreenWithUnits:(NSDictionary *)units;

@end
