//
//  SGDeepCopy.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-25.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SGDeepCopy)

- (NSArray *) deepCopy;
- (NSMutableArray *) mutableDeepCopy;

@end

@interface NSDictionary (SGDeepCopy)

- (NSDictionary *) deepCopy;
- (NSMutableDictionary *) mutableDeepCopy;

@end

