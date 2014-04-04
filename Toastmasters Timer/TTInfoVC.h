#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "TTModalDelegate.h"
#import "TTBaseVc.h"


@interface TTInfoVC : TTBaseVc <MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) NSString *currentTimerString;
@property (nonatomic, weak) NSObject<TTModalDelegate> *modalDelegate;
@end
