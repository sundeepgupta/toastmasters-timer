#import "Kiwi.h"
#import "SpecHelper.h"
#import "TimerVC.h"
#import "TimeEntryVC.h"
#import "AlertManager.h"


@interface TimerVC ()
@property (nonatomic, strong) AlertManager *alertManager;
- (TimeEntryVC *)timeEntryVcWithIndex:(ColorIndex)index;
@end



SPEC_BEGIN(TimerVCSpec)

describe(@"TimerVC", ^{
    
    __block TimerVC *subject;
    
    beforeEach(^{
        subject = (TimerVC *)[SpecHelper vcForClass:[TimerVC class]];
        [subject view];
    });
    
    context(@"When presenting TimeEntryVC", ^{
        it(@"should pass TimeEntryVC reference to its AlertManager", ^{
            TimeEntryVC *timeEntryVc = [subject timeEntryVcWithIndex:0];
            [[timeEntryVc.alertManager should] equal:subject.alertManager];
        });
    });
});

SPEC_END