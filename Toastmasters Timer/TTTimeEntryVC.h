#import <UIKit/UIKit.h>
#import "TTConstants.h"
#import "TTModalDelegate.h"
#import "TTBaseVc.h"


@protocol TTTimeEntryVCDelegate <NSObject>
@required
- (void)colorTimeDidChangeForIndex:(ColorIndex)index;
- (void)didResetAllColourTimes;
@end

@class TTAlertManager;

@interface TTTimeEntryVC : TTBaseVc
@property (nonatomic, strong) NSString *currentTimerString;
@property ColorIndex currentColorIndex;
@property (nonatomic, strong) TTAlertManager *alertManager;
@property (nonatomic, weak) NSObject<TTModalDelegate> *modalDelegate;
@property (nonatomic, weak) NSObject<TTTimeEntryVCDelegate> *timeEntryDelegate;
@end
