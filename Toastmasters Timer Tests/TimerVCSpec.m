#import "Kiwi.h"
#import "SpecHelper.h"
#import "TimerVC.h"
#import "TimeEntryVC.h"
#import "AlertManager.h"
#import "ColorButton.h"
#import "Helper.h"
#import "TTStrings.h"
#import "TTModalDelegate.h"
#import "InfoVC.h"


@interface TimerVC ()
@property (nonatomic, strong) AlertManager *alertManager;
@property (strong, nonatomic) IBOutlet ColorButton *greenButton;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;

- (void)presentTimeEntryVcWithIndex:(ColorIndex)index;
- (TimeEntryVC *)timeEntryVcWithIndex:(ColorIndex)index;
- (void)showTips;
- (void)modalShouldDismiss;
- (void)colorTimeDidChangeForIndex:(ColorIndex)index;
- (void)deEmphasizeAllColors;
- (void)deEmphasizeColorWithIndex:(ColorIndex)index;
- (void)presentInfoVC;
- (IBAction)infoButtonPress:(id)sender;
- (void)didResetAllColourTimes;
@end



SPEC_BEGIN(TimerVCSpec)

describe(@"TimerVC", ^{
    
    __block TimerVC *subject;
    
    beforeEach(^{
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [window makeKeyAndVisible];
        subject = (TimerVC *)[SpecHelper vcForClass:[TimerVC class]];
        window.rootViewController = subject;
        [subject view];
    });
    
    context(@"on first launch", ^{

        beforeEach(^{
            [Helper stub:@selector(isFirstLaunch) andReturn:theValue(YES)];
        });
        
        it(@"should let the user know of any tips", ^{
            [[Helper should] receive:@selector(showAlertWithTitle:withMessage:) withArguments:STRING_TIP_TITLE, STRING_TIP_START_TIMER_EARLIER];
            [subject viewDidLoad];
        });
    });
    
    
    context(@"when pressing one of the color buttons", ^{
        it(@"should perform the correct segue", ^{
            [[subject should] receive:@selector(presentTimeEntryVcWithIndex:) withArguments:theValue(GREEN_COLOR_INDEX)];
            [subject.greenButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        });
        
        it(@"it should present the TimeEntryVC", ^{
            [[subject.presentedViewController shouldEventually] beKindOfClass:[TimeEntryVC class]];
            [subject presentTimeEntryVcWithIndex:0];
        });
    });

    context(@"When creating the TimeEntryVC", ^{
        it(@"should be setup correctly", ^{
            subject.timerLabel.text = @"testText";
            TimeEntryVC *timeEntryVc = [subject timeEntryVcWithIndex:AMBER_COLOR_INDEX];
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
            [[subject.presentedViewController shouldEventually] beKindOfClass:[InfoVC class]];
            [subject presentInfoVC];
        });
        
        it(@"should be set as the info VC's delegate", ^{
            [subject stub:@selector(presentViewController:animated:completion:) withArguments:subject, theValue(NO), nil];
            [subject presentInfoVC];
            InfoVC *infoVC = (InfoVC *)subject.presentedViewController;
            [[infoVC.modalDelegate should] equal:subject];
        });
    });;
    
    context(@"When creating the TimeEntryVC", ^{
        it(@"should be setup correctly", ^{
            subject.timerLabel.text = @"testText";
            TimeEntryVC *timeEntryVc = [subject timeEntryVcWithIndex:AMBER_COLOR_INDEX];
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
    
});

SPEC_END