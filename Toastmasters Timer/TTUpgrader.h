#import <Foundation/Foundation.h>


@interface TTUpgrader : NSObject
+ (instancetype)sharedInstance;
- (void)purchaseProductWithIdentifier:(NSString *)identifier success:(void (^)())sucess failure:(void (^)(NSError *error))failure;
@end