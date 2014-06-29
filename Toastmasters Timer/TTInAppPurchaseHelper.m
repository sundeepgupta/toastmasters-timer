#import "TTInAppPurchaseHelper.h"
#import <StoreKit/StoreKit.h>

@interface TTInAppPurchaseHelper() <SKProductsRequestDelegate>
@property (nonatomic, strong) SKProductsRequest *productsRequest;
@property (nonatomic, strong) RequestProductsCompletionHandler completionHandler;
@property (nonatomic, strong) NSSet *productIdentifiers;
@property (nonatomic, strong) NSMutableSet *purchasedProductIdentifiers;
@end


@implementation TTInAppPurchaseHelper

- (instancetype)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    self = [super init];
    if (self) {
        self.productIdentifiers = productIdentifiers;
        
        self.purchasedProductIdentifiers = [NSMutableSet new];
        for (NSString *identifier in self.productIdentifiers) {
            BOOL productIsPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:identifier];
            if (productIsPurchased) {
                [self.purchasedProductIdentifiers addObject:identifier];
            }
        }
    }
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
//    self.completionHandler = [completionHandler copy];
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:self.productIdentifiers];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    self.productsRequest = nil;
//    self.completionHandler(YES, response.products);
//    self.completionHandler = nil;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    self.productsRequest = nil;
//    self.completionHandler(NO, nil);
//    self.completionHandler = nil;
}

@end
