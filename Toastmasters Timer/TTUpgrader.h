#import <Foundation/Foundation.h>


@interface TTUpgrader : NSObject
+ (instancetype)sharedInstance;
- (void)purchaseProductWithIdentifier:(NSString *)identifier
                              success:(void (^)())sucess
                               cancel:(void (^)())cancel
                              failure:(void (^)(NSError *))failure;
@end