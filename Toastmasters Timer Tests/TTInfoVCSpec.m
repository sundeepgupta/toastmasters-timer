#import "Kiwi.h"
#import "TTSpecHelper.h"
#import "TTInfoVC.h"
#import "TTHelper.h"
#import "TTAnalyticsInterface.h"
#import <MessageUI/MessageUI.h>


@interface TTInfoVC ()
- (IBAction)rateAppButtonPress:(id)sender;
- (IBAction)doneButtonPress:(id)sender;
- (IBAction)developerButtonPress:(id)sender;
- (IBAction)designerButtonPress:(id)sender;
@end



SPEC_BEGIN(InfoVCSpec)

describe(@"InfoVC", ^{
    
    __block TTInfoVC *subject;
    
    beforeEach(^{
        subject = (TTInfoVC *)[SpecHelper vcForClass:[TTInfoVC class]];
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [window makeKeyAndVisible];
        window.rootViewController = subject;
        [subject view];
    });
    
    
    context(@"when the rate me button is pressed", ^{
        it(@"should open the correct website", ^{
            [[TTHelper should] receive:@selector(openAppWithUrlString:) withArguments:@"itms-apps://itunes.apple.com/app/id708807408"];
            [subject rateAppButtonPress:nil];
        });
        
        it(@"should send an analytics event", ^{
            [[TTAnalyticsInterface should] receive:@selector(sendCategory:action:) withArguments:GOOGLE_ANALYTICS_CATEGORY_INFO, GOOGLE_ANALYTICS_ACTION_RATE_APP];
            [subject rateAppButtonPress:nil];
        });
    });
    

    context(@"when the developer button is pressed", ^{
        
        context(@"when the app can send mail", ^{
            
            __block KWCaptureSpy *spy;
            
            beforeEach(^{
                [MFMailComposeViewController stub:@selector(canSendMail) andReturn:theValue(YES)];
                spy = [subject captureArgument:@selector(presentViewController:animated:completion:) atIndex:0];
            });
            
            it(@"should open the email composer", ^{
                [[subject should] receive:@selector(presentViewController:animated:completion:)];
                [subject developerButtonPress:nil];
                id presentedVc = spy.argument;
                [[presentedVc should] beKindOfClass:[MFMailComposeViewController class]];
            });
            
        });
        
        context(@"when the app can't send mail", ^{
            
            beforeEach(^{
                [MFMailComposeViewController stub:@selector(canSendMail) andReturn:theValue(NO)];
            });
            
            it(@"should display an alert", ^{
                [[TTHelper should] receive:@selector(showAlertWithTitle:withMessage:)];
                [subject developerButtonPress:nil];
            });
        });
        
        
        it(@"should send an analytics event", ^{
            [[TTAnalyticsInterface should] receive:@selector(sendCategory:action:) withArguments:GOOGLE_ANALYTICS_CATEGORY_INFO, GOOGLE_ANALYTICS_ACTION_CONTACT_DEVELOPER];
            [subject developerButtonPress:nil];
        });
    });

    
    context(@"when the designer button is pressed", ^{
        
        it(@"should open the email composer", ^{
            [[TTHelper should] receive:@selector(openWebsiteWithUrlString:) withArguments:URL_DESIGNER];
            [subject designerButtonPress:nil];
        });
        
        it(@"should send an analytics event", ^{
            [[TTAnalyticsInterface should] receive:@selector(sendCategory:action:) withArguments:GOOGLE_ANALYTICS_CATEGORY_INFO, GOOGLE_ANALYTICS_ACTION_CONTACT_DESIGNER];
            [subject designerButtonPress:nil];
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