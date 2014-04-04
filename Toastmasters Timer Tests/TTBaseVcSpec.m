#import "Kiwi.h"
#import "TTBaseVc.h"


SPEC_BEGIN(TTBaseVcSpec)

describe(@"TTBaseVc", ^{
    
    __block TTBaseVc *subject;
    
    beforeEach(^{
        subject = [TTBaseVc new];
    });
    
    context(@"when it appears", ^{
        
        it(@"should set its screen name to its class name", ^{
            [subject viewWillAppear:NO];
            [[subject.screenName should] equal:NSStringFromClass([subject class])];
        });
    });
});

SPEC_END