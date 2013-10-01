//
//  Toastmasters_TimerTests.m
//  Toastmasters TimerTests
//
//  Created by Sundeep Gupta on 2013-08-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "Toastmasters_TimerTests.h"

@interface Toastmasters_TimerTests ()
@property (strong, nonatomic) NSNumber *singleDigitNumber;

@end

@implementation Toastmasters_TimerTests

- (void)setUp
{
    [super setUp];
    self.singleDigitNumber = @4;
    
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testStringsForUnits
{

    NSNumber *number = @4;
    NSString *string = [Helper unitStringForNumber:number];
    NSString *result = @"04";
    STAssertTrue([string isEqualToString:result], @"%@ should covert to %@", string, result);

    NSNumber *number1 = @55;
    NSString *string1 = [Helper unitStringForNumber:number1];
    NSString *result1 = @"55";
    STAssertTrue([string1 isEqualToString:result1], @"%@ should covert to %@", string1, result1);
}



@end
