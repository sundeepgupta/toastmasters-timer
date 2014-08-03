#import <Foundation/Foundation.h>


@interface TTInAppPurchaser : NSObject
+ (instancetype)sharedInstance;
- (void)purchaseProductWithIdentifier:(NSString *)identifier success:(void (^)())sucess failure:(void (^)(NSError *error))failure;
@end