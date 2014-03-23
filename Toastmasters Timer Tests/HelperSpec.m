#import "Kiwi.h"
#import "Helper.h"


SPEC_BEGIN(HelperSpec)

describe(@"Helper", ^{
    
    context(@"first launch", ^{
        
        __block NSUserDefaults *defaults;
        
        beforeEach(^{
            defaults = [NSUserDefaults standardUserDefaults];
        });
        
        it(@"should return YES when it is first launch", ^{
            [defaults stub:@selector(objectForKey:) andReturn:nil withArguments:IS_NOT_FIRST_LAUNCH];
            [[theValue([Helper isFirstLaunch]) should] equal:theValue(YES)];
        });
        
        it(@"should return NO when it is not first launch", ^{
            [defaults stub:@selector(objectForKey:) andReturn:any() withArguments:IS_NOT_FIRST_LAUNCH];
            [[theValue([Helper isFirstLaunch]) should] equal:theValue(NO)];
        });
    });
});

SPEC_END