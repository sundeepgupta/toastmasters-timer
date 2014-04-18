#import "TTBaseVc.h"


@implementation TTBaseVc

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = [self className];
    [TTAnalyticsInterface dispatchEvents];
}

- (NSString *)className {
    return NSStringFromClass([self class]);
}

@end
