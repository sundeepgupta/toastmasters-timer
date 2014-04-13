#import "Kiwi.h"
#import "TTHelper.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"


SPEC_BEGIN(HelperSpec)

describe(@"Helper", ^{
    
    context(@"first launch", ^{
        
        __block NSUserDefaults *defaults;
        
        beforeEach(^{
            defaults = [NSUserDefaults standardUserDefaults];
        });
        
        it(@"should return YES when it is first launch", ^{
            [defaults stub:@selector(objectForKey:) andReturn:nil withArguments:IS_NOT_FIRST_LAUNCH];
            [[theValue([TTHelper isFirstLaunch]) should] equal:theValue(YES)];
        });
        
        it(@"should return NO when it is not first launch", ^{
            [defaults stub:@selector(objectForKey:) andReturn:any() withArguments:IS_NOT_FIRST_LAUNCH];
            [[theValue([TTHelper isFirstLaunch]) should] equal:theValue(NO)];
        });
    });

#warning Test GA
//    context(@"Google Analytics", ^{
//        
//        __block GAI *gai;
//        
//        beforeEach(^{
//            gai = [GAI sharedInstance];
//        });
//      
//        afterEach(^{
//            gai = nil;
//        });
//        
//        it(@"", ^{
//            NSString *category = @"someCat";
//            NSString *action = @"some action";
//            NSString *label = @"some label";
//            NSNumber *value = @999;
//            
//            id trackerMock = [KWMock nullMockForProtocol:@protocol(GAITracker)];
//            [gai stub:@selector(defaultTracker) andReturn:trackerMock];
//            
//            KWCaptureSpy *spy = [trackerMock captureArgument:@selector(send:) atIndex:0];
//            [TTHelper sendTrackingInfoWithCategory:category action:action label:label value:value];
//            
//            NSDictionary *expectedDictionary = [[GAIDictionaryBuilder createEventWithCategory:category action:action label:label value:value] build];
//            [[expectedDictionary should] equal:spy.argument];
//            
//        });
//    });
});

SPEC_END