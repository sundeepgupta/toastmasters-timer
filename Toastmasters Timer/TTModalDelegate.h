#import <Foundation/Foundation.h>

@protocol TTModalDelegate <NSObject>
@required
- (void)modalShouldDismiss;
@end
