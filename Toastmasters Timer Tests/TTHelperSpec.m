#import "Kiwi.h"
#import "TTHelper.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "TTAnalyticsInterface.h"

SPEC_BEGIN(HelperSpec)

describe(@"Helper", ^{
    
    __block NSUserDefaults *defaults;
    
    beforeEach(^{
        defaults = [NSUserDefaults standardUserDefaults];
    });
    

    context(@"first launch", ^{
        
        it(@"should return YES when it is first launch", ^{
            [defaults stub:@selector(objectForKey:) andReturn:nil withArguments:IS_NOT_FIRST_LAUNCH];
            [[theValue([TTHelper isFirstLaunch]) should] equal:theValue(YES)];
        });
        
        it(@"should return NO when it is not first launch", ^{
            [defaults stub:@selector(objectForKey:) andReturn:any() withArguments:IS_NOT_FIRST_LAUNCH];
            [[theValue([TTHelper isFirstLaunch]) should] equal:theValue(NO)];
        });
    });
    
    
    context(@"analytics", ^{
        it(@"should make call the analtyics call indicating all of the colour's times", ^{
            NSArray *times = @[@60, @90, @120, @130];
            [defaults stub:@selector(arrayForKey:) andReturn:times withArguments:COLOR_TIMES_KEY];
            [[TTAnalyticsInterface should] receive:@selector(sendCategory:action:label:) withArguments:GOOGLE_ANALYTICS_CATEGORY_TIME_ENTRY, GOOGLE_ANALYTICS_ACTION_SAVE_COLOURS, @"60,90,120,130"];
            [TTHelper sendColorTimeValuesToAnalytics];
        });
    });

});

SPEC_END