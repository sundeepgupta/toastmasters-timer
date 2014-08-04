#import "TTUpgrader.h"
#import <StoreKit/StoreKit.h>
#import "TTConstants.h"


@interface TTUpgrader() <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (nonatomic, strong) NSString *productIdentifier;
@property (nonatomic, copy) void (^successBlock)();
@property (nonatomic, copy) void (^failureBlock)(NSError *);
@end


@implementation TTUpgrader

#pragma mark - Public
+ (instancetype)sharedInstance {
    static TTUpgrader *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:instance];
    });
    return instance;
}

- (void)purchaseProductWithIdentifier:(NSString *)identifier success:(void (^)())sucess failure:(void (^)(NSError *))failure {
    self.productIdentifier = identifier;
    self.successBlock = sucess;
    self.failureBlock = failure;
    [self requestPurchase];
}



#pragma mark - Private
#pragma mark - Fetch Product
- (void)requestPurchase {
    NSSet *identifiers = [NSSet setWithObject:self.productIdentifier];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:identifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    DDLogVerbose(@"Requested products available for in-app purchases");
}



#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *products = response.products;
    SKProduct *product = [self productFromFetchedProducts:products];
    [self purchaseProduct:product];
    DDLogVerbose(@"Successfully fetched matching product to purchase");
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    if (self.failureBlock) {
        self.failureBlock(error);
    }
    DDLogError(@"Failed to fetch products with error: %@\n%s", error.localizedDescription, __PRETTY_FUNCTION__);
}


- (SKProduct *)productFromFetchedProducts:(NSArray *)products {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productIdentifier == %@", self.productIdentifier];
    NSArray *filteredProducts = [products filteredArrayUsingPredicate:predicate];
    SKProduct *product = filteredProducts.firstObject;
    return product;
}



#pragma mark - Purchase Product
- (void)purchaseProduct:(SKProduct *)product {
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}



#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self handleFailedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self completeTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [self handleUpgrade];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)handleFailedTransaction:(SKPaymentTransaction *)transaction {
    DDLogVerbose(@"Transaction failed.");
    if (transaction.error.code != SKErrorPaymentCancelled) {
        if (self.failureBlock) {
            self.failureBlock(transaction.error);
        }
        DDLogError(@"Transaction failed due to error: %@\n%s", transaction.error.localizedDescription, __PRETTY_FUNCTION__);
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}



#pragma mark - Upgrading
- (void)handleUpgrade {
    [self saveUpgradeStatus];
    if (self.successBlock) {
        self.successBlock();
    }
}

- (void)saveUpgradeStatus {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:UPGRADED];
    [defaults synchronize];
    DDLogVerbose(@"Saved upgrade status");
}


@end
