#import "Kiwi.h"
#import "TimeEntryVC.h"
#import "AlertManager.h"


@interface TimeEntryVC ()
- (IBAction)doneButtonPress:(id)sender;
@end


SPEC_BEGIN(TimeEntryVCSpec)

describe(@"LocalNotifications", ^{
    
    __block TimeEntryVC *subject;
    
    beforeEach(^{
        subject = [TimeEntryVC new];
    });
    
    context(@"when finished changing times when timer is running", ^{
        it(@"the local notifications should be recreated", ^{
            AlertManager *alertManager = [AlertManager new];
            subject.alertManager = alertManager;
            [[alertManager shouldEventually] receive:@selector(recreateNotifications)];
            [subject doneButtonPress:nil];
        });
    });
});

SPEC_END