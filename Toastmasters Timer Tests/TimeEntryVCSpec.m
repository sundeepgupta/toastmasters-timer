#import "Kiwi.h"
#import "TimeEntryVC.h"
#import "AlertManager.h"
#import "SpecHelper.h"
#import "ColorButton.h"
#import "Helper.h"


@interface TimeEntryVC ()
@property (strong, nonatomic) IBOutlet ColorButton *greenButton;
@property (strong, nonatomic) IBOutlet ColorButton *amberButton;
@property (strong, nonatomic) IBOutlet ColorButton *redButton;
@property (strong, nonatomic) IBOutlet ColorButton *bellButton;
@property (nonatomic, weak) IBOutlet UIButton *resetButton;

- (IBAction)doneButtonPress:(id)sender;
- (IBAction)resetButtonPress;
@end


SPEC_BEGIN(TimeEntryVCSpec)

describe(@"TimeEntryVC", ^{
    
    __block TimeEntryVC *subject;
    
    beforeEach(^{
        subject = (TimeEntryVC *)[SpecHelper vcForClass:[TimeEntryVC class]];
    });
    
    
    context(@"time resetting", ^{
        
        __block NSArray *actions;
        
        beforeEach(^{
            [subject view];
        });
        
        it(@"should be setup properly", ^{
            [[subject.resetButton should] beKindOfClass:[UIButton class]];
            [[theValue(subject.resetButton.allTargets.count) should] equal:theValue(1)];
            actions = [subject.resetButton actionsForTarget:subject forControlEvent:UIControlEventTouchUpInside];
            [[theValue(actions.count) should] equal:theValue(1)];
            NSString *buttonSelectorName = actions.firstObject;
            NSString *subjectSelectorName = NSStringFromSelector(@selector(resetButtonPress));
            [[buttonSelectorName should] equal:subjectSelectorName];
        });
        
        it(@"reset all of the colours' time to zero ", ^{
            [Helper setupTitleForColorButton:subject.greenButton withSeconds:99];
            [Helper setupTitleForColorButton:subject.amberButton withSeconds:99];
            [Helper setupTitleForColorButton:subject.redButton withSeconds:99];
            [Helper setupTitleForColorButton:subject.bellButton withSeconds:99];
            [subject resetButtonPress];
            [[subject.greenButton.titleLabel.text should] equal:@"00:00"];
            [[subject.amberButton.titleLabel.text should] equal:@"00:00"];
            [[subject.redButton.titleLabel.text should] equal:@"00:00"];
            [[subject.bellButton.titleLabel.text should] equal:@"00:00"];
        });
    });
    
    
    context(@"when changing the times", ^{
        it(@"should allow the user to reset the times to zero", ^{
            
        });
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