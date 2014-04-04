#import "TTBaseVc.h"


@interface TTBaseVc ()

@end


@implementation TTBaseVc

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = [self className];
}

- (NSString *)className {
    return NSStringFromClass([self class]);
}

@end
