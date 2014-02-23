#import "SpecHelper.h"


@interface SpecHelper ()

@end


@implementation SpecHelper
+ (UIViewController *)vcForClass:(Class)aClass {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    NSString *className = NSStringFromClass(aClass);
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:className];
    return vc;
}
@end
