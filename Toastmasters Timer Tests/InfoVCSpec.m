#import "Kiwi.h"
#import "SpecHelper.h"
#import "InfoVC.h"
#import "Helper.h"


@interface InfoVC ()
- (IBAction)rateAppButtonPress:(id)sender;
- (IBAction)doneButtonPress:(id)sender;
@end



SPEC_BEGIN(InfoVCSpec)

describe(@"InfoVC", ^{
    
    __block InfoVC *subject;
    
    beforeEach(^{
        subject = (InfoVC *)[SpecHelper vcForClass:[InfoVC class]];
        [subject view];
    });
    
    context(@"when the rate me button is pressed", ^{
        it(@"should open the correct website", ^{
            [[Helper should] receive:@selector(openAppWithUrlString:) withArguments:@"itms-apps://itunes.apple.com/app/id708807408"];
            [subject rateAppButtonPress:nil];
        });
    });
    
    context(@"when the done button is pressed", ^{
        it(@"it should notify the delegate", ^{
            NSObject *mockDelegate = [KWMock nullMockForProtocol:@protocol(TTModalDelegate)];
            [subject stub:@selector(modalDelegate) andReturn:mockDelegate];
            [[subject.modalDelegate should] receive:@selector(modalShouldDismiss)];
            [subject doneButtonPress:nil];
        });
    });
    
    
});

SPEC_END