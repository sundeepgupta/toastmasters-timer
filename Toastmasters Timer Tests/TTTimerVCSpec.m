#import "Kiwi.h"
#import "TTSpecHelper.h"
#import "TTTimerVC.h"
#import "TTTimeEntryVC.h"
#import "TTAlertManager.h"
#import "TTColorButton.h"
#import "TTHelper.h"
#import "TTCommonStrings.h"
#import "TTModalDelegate.h"
#import "TTInfoVC.h"
#import "TTAnalyticsInterface.h"
#import <iAd/iAd.h>

@interface TTTimerVC ()
@property (nonatomic, strong) TTAlertManager *alertManager;
@property (weak, nonatomic) IBOutlet TTColorButton *greenButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *audioAlertButton;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (weak, nonatomic) IBOutlet ADBannerView *adView;

- (void)presentTimeEntryVcWithIndex:(ColorIndex)index;
- (TTTimeEntryVC *)timeEntryVcWithIndex:(ColorIndex)index;
- (void)showTips;
- (void)modalShouldDismiss;
- (void)colorTimeDidChangeForIndex:(ColorIndex)index;
- (void)deEmphasizeAllColors;
- (void)deEmphasizeColorWithIndex:(ColorIndex)index;
- (void)presentInfoVC;
- (IBAction)infoButtonPress:(id)sender;
- (void)didResetAllColourTimes;
- (BOOL)shouldAudioAlert;
- (void)bannerViewDidLoadAd:(ADBannerView *)banner;
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error;
@end



SPEC_BEGIN(TimerVCSpec)

describe(@"TimerVC", ^{
    
    __block TTTimerVC *subject;
    
    beforeEach(^{
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [window makeKeyAndVisible];
        subject = (TTTimerVC *)[SpecHelper vcForClass:[TTTimerVC class]];
        window.rootViewController = subject;
        [subject view];
    });
    
    
    context(@"on first launch", ^{

        beforeEach(^{
            [TTHelper stub:@selector(isFirstLaunch) andReturn:theValue(YES)];
        });
        
        it(@"should let the user know of any tips", ^{
            [[TTHelper should] receive:@selector(showAlertWithTitle:withMessage:)];
            [subject viewDidLoad];
        });
    });
    
    
    context(@"when the view will appears", ^{
        it(@"hides the ads if the user has upgraded", ^{
            [[NSUserDefaults standardUserDefaults] stub:@selector(boolForKey:) andReturn:theValue(YES) withArguments:UPGRADED];
            [[theValue(subject.adView.hidden) should] equal:theValue(YES)];
        });
    });
    
    
    context(@"when pressing the audio alert button", ^{
        
        context(@"when audio is currently disabled", ^{
            
            beforeEach(^{
                [subject stub:@selector(shouldAudioAlert) andReturn:theValue(NO)];
            });
            
            it(@"should enable audio alerts", ^{
                [subject.audioAlertButton sendActionsForControlEvents:UIControlEventTouchDown];
                BOOL shouldAudioAlert = [subject.defaults boolForKey:SHOULD_AUDIO_ALERT_KEY];
                [[theValue(shouldAudioAlert) should] equal:theValue(YES)];
            });
            
            it(@"should send an analytics tracking event", ^{
                [[TTAnalyticsInterface should] receive:@selector(sendCategory:action:) withArguments:GOOGLE_ANALYTICS_CATEGORY_TIMER, GOOGLE_ANALYTICS_ACTION_AUDIO_ENABLE];
                [subject.audioAlertButton sendActionsForControlEvents:UIControlEventTouchDown];
            });
        });
        
        context(@"when audio is currently enabled", ^{
            
            beforeEach(^{
                [subject stub:@selector(shouldAudioAlert) andReturn:theValue(YES)];
            });
            
            it(@"should disable audio alerts", ^{
                [subject.audioAlertButton sendActionsForControlEvents:UIControlEventTouchDown];
                BOOL shouldAudioAlert = [subject.defaults boolForKey:SHOULD_AUDIO_ALERT_KEY];
                [[theValue(shouldAudioAlert) should] equal:theValue(NO)];
            });
            
            it(@"should send an analytics tracking event", ^{
                [[TTAnalyticsInterface should] receive:@selector(sendCategory:action:) withArguments:GOOGLE_ANALYTICS_CATEGORY_TIMER, GOOGLE_ANALYTICS_ACTION_AUDIO_DISABLE];
                [subject.audioAlertButton sendActionsForControlEvents:UIControlEventTouchDown];
            });
        });
        
        it(@"should recreate the local notifications", ^{
            [[subject.alertManager should] receive:@selector(recreateNotifications)];
            [subject.audioAlertButton sendActionsForControlEvents:UIControlEventTouchDown];
        });
    });
    
    
    context(@"when pressing one of the color buttons", ^{
        it(@"should perform the correct segue", ^{
            [[subject should] receive:@selector(presentTimeEntryVcWithIndex:) withArguments:theValue(GREEN_COLOR_INDEX)];
            [subject.greenButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        });
        
        it(@"should present the TimeEntryVC", ^{
            [[subject.presentedViewController shouldEventually] beKindOfClass:[TTTimeEntryVC class]];
            [subject presentTimeEntryVcWithIndex:0];
        });
    });


    context(@"When creating the TimeEntryVC", ^{
        it(@"should be setup correctly", ^{
            subject.timerLabel.text = @"testText";
            TTTimeEntryVC *timeEntryVc = [subject timeEntryVcWithIndex:AMBER_COLOR_INDEX];
            [[theValue(timeEntryVc.currentColorIndex) should] equal:theValue(AMBER_COLOR_INDEX)];
            [[timeEntryVc.currentTimerString should] equal:@"testText"];
            [[timeEntryVc.alertManager should] equal:subject.alertManager];
            [[theValue(timeEntryVc.modalTransitionStyle) should] equal:theValue(UIModalTransitionStyleCrossDissolve)];
            [[subject should] conformToProtocol:@protocol(TTModalDelegate)];
            [[subject should] conformToProtocol:@protocol(TTTimeEntryVCDelegate)];
            [[timeEntryVc.modalDelegate should] equal:subject];
            [[timeEntryVc.timeEntryDelegate should] equal:subject];
        });
    });
    
    
    context(@"when pressing the info button", ^{
        it(@"should perform the correct segue", ^{
            [[subject should] receive:@selector(presentInfoVC)];
            [subject infoButtonPress:nil];
        });
        
        it(@"it should present the info view", ^{
            [[subject.presentedViewController shouldEventually] beKindOfClass:[TTInfoVC class]];
            [subject presentInfoVC];
        });
        
        it(@"should be set as the info VC's delegate", ^{
            [subject stub:@selector(presentViewController:animated:completion:) withArguments:subject, theValue(NO), nil];
            [subject presentInfoVC];
            TTInfoVC *infoVC = (TTInfoVC *)subject.presentedViewController;
            [[infoVC.modalDelegate should] equal:subject];
        });
    });;
    
    
    context(@"When creating the TimeEntryVC", ^{
        it(@"should be setup correctly", ^{
            subject.timerLabel.text = @"testText";
            TTTimeEntryVC *timeEntryVc = [subject timeEntryVcWithIndex:AMBER_COLOR_INDEX];
            [[theValue(timeEntryVc.currentColorIndex) should] equal:theValue(AMBER_COLOR_INDEX)];
            [[timeEntryVc.currentTimerString should] equal:@"testText"];
            [[timeEntryVc.alertManager should] equal:subject.alertManager];
            [[theValue(timeEntryVc.modalTransitionStyle) should] equal:theValue(UIModalTransitionStyleCrossDissolve)];
            [[subject should] conformToProtocol:@protocol(TTModalDelegate)];
            [[subject should] conformToProtocol:@protocol(TTTimeEntryVCDelegate)];
            [[timeEntryVc.modalDelegate should] equal:subject];
            [[timeEntryVc.timeEntryDelegate should] equal:subject];
        });
    });

    
    
    context(@"when the time entry VC's notifies us that its done button was pressed", ^{
        it(@"should dismiss the time entry VC modal", ^{
            [[subject should] receive:@selector(dismissViewControllerAnimated:completion:) withArguments:theValue(YES), nil];
            [subject modalShouldDismiss];
        });
        
        it(@"should de-emphasize all colours", ^{
            [[subject shouldNot] receive:@selector(deEmphasizeAllColors)];
            [subject modalShouldDismiss];
        });
    });
    
    
    context(@"when the colour time did change", ^{
        it(@"should de-emphasize that colour", ^{
            [[subject should] receive:@selector(deEmphasizeColorWithIndex:) withArguments:theValue(AMBER_COLOR_INDEX)];
            [subject colorTimeDidChangeForIndex:AMBER_COLOR_INDEX];
        });
    });
    
    
    context(@"when the reset all colours button was pressed", ^{
        it(@"should de-emphasize that colour", ^{
            [[subject should] receive:@selector(deEmphasizeAllColors)];
            [subject didResetAllColourTimes];
        });
    });
    
    
    context(@"when ad is hidden", ^{
        
        beforeEach(^{
            subject.adView.alpha = 0;
        });
        
        context(@"when an ad loads successfully", ^{
            it(@"shows the ad", ^{
                [subject bannerViewDidLoadAd:subject.adView];
                [[theValue(subject.adView.alpha) should] equal:theValue(1)];
            });
        });
    });
    
    context(@"when ad is showing", ^{
        
        beforeEach(^{
            subject.adView.alpha = 1;
        });
        
        context(@"when an ad fails", ^{
            it(@"hides the ad", ^{
                [subject bannerView:subject.adView didFailToReceiveAdWithError:nil];
                [[theValue(subject.adView.alpha) should] equal:theValue(0)];
            });
        });
    });

    
});

SPEC_END