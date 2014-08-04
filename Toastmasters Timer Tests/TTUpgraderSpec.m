#import "Kiwi.h"
#import "TTUpgrader.h"
#import <StoreKit/StoreKit.h>
#import "TTConstants.h"



@interface TTUpgrader ()
@property (nonatomic, strong) NSString *productIdentifier;

- (void)requestPurchase;
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response;
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
@end


SPEC_BEGIN(TTUpgraderSpec)

describe(@"TTUpgrader", ^{
    
    __block TTUpgrader *subject;
    __block BOOL successBlockInvoked = NO;
    __block BOOL failureBlockInvoked = NO;
    
    beforeEach(^{
        subject = [TTUpgrader new];
        [subject stub:@selector(requestPurchase)];
        [subject purchaseProductWithIdentifier:REMOVE_ADS_PRODUCT_ID success:^{
            successBlockInvoked = YES;
        } failure:^(NSError *error) {
            failureBlockInvoked = YES;
        }];
    });
    
    context(@"when requesting products receives a response (delegate call)", ^{
        
        __block SKProductsResponse *response;
        
        beforeEach(^{
            SKProduct *product = [SKProduct new];
            [product stub:@selector(productIdentifier) andReturn:REMOVE_ADS_PRODUCT_ID];
            response = [SKProductsResponse new];
            [response stub:@selector(products) andReturn:@[product]];
        });
        
        it(@"tries to make a payment", ^{
            [[[SKPaymentQueue defaultQueue] should] receive:@selector(addPayment:)];
            [subject productsRequest:nil didReceiveResponse:response];
        });
        
        it(@"makes a payment for the correct product", ^{
            KWCaptureSpy *spy = [[SKPaymentQueue defaultQueue] captureArgument:@selector(addPayment:) atIndex:0];
            [subject productsRequest:nil didReceiveResponse:response];
            SKPayment *payment = spy.argument;
            [[payment.productIdentifier should] equal:REMOVE_ADS_PRODUCT_ID];
        });
    });
    
    context(@"when payment succeeds", ^{
        
        __block NSArray *transactions;
        
        beforeEach(^{
            SKPaymentTransaction *transaction = [SKPaymentTransaction new];
            [transaction stub:@selector(transactionState) andReturn:theValue(SKPaymentTransactionStatePurchased)];
            transactions = @[transaction];
        });
        
        it(@"saves the upgrade status", ^{
            [subject paymentQueue:nil updatedTransactions:transactions];
            BOOL upgraded = [[NSUserDefaults standardUserDefaults] boolForKey:UPGRADED];
            [[theValue(upgraded) should] equal:theValue(YES)];
        });
        
        it(@"executes the success block", ^{
            [subject paymentQueue:nil updatedTransactions:transactions];
            [[theValue(successBlockInvoked) should] equal:theValue(YES)];
        });
        
        it(@"finishes the transaction", ^{
            [[[SKPaymentQueue defaultQueue] should] receive:@selector(finishTransaction:) withArguments:transactions.firstObject];
            [subject paymentQueue:nil updatedTransactions:transactions];
        });
    });
});

SPEC_END