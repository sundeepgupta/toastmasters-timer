#import "Kiwi.h"
#import "SpecHelper.h"
#import "InfoVC.h"
#import "Helper.h"


@interface InfoVC ()
- (IBAction)rateAppButtonPress:(id)sender;
@end



SPEC_BEGIN(InfoVCSpec)

describe(@"InfoVC", ^{
    
    __block InfoVC *subject;
    
    beforeEach(^{
        subject = (InfoVC *)[SpecHelper vcForClass:[InfoVC class]];
        [subject view];
    });
    
    context(@"rate me button", ^{
        it(@"opens the correct website", ^{
            [[Helper shouldEventually] receive:@selector(openAppWithUrlString:) withArguments:@"itms-apps://itunes.apple.com/app/id708807408"];
            [subject rateAppButtonPress:nil];
        });
    });
    

    
    
    
});

SPEC_END