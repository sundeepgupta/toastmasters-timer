#import "TTInfoVC.h"
#import "TTCommonStrings.h"
#import "TTConstants.h"
#import "TTInAppPurchaseHelper.h"

#import <StoreKit/StoreKit.h>






@interface TTInfoVC ()

<SKProductsRequestDelegate, SKPaymentTransactionObserver>



@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@end


@implementation TTInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [TTHelper registerForTimerNotificationsWithObject:self];
    [self setupTimerLabel];
    [self setupAppNameLabel];
    [self setupVersionLabel];
}

- (void)setupTimerLabel {
    if (self.currentTimerString  &&  self.currentTimerString.length > 0) {
        self.timerLabel.text = self.currentTimerString;
    }
}

- (void)setupAppNameLabel {
    self.appNameLabel.text = [TTHelper bundleName];
}

- (void)setupVersionLabel {
    self.versionLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}



#pragma mark - Timer Notification
- (void)timerUpdatedSecondsWithNotification:(NSNotification *)notification {
    NSInteger seconds = [TTHelper secondsForNotification:notification];
    [self updateTimerLabelWithSeconds:seconds];
}
- (void)updateTimerLabelWithSeconds:(NSInteger)seconds {
    self.timerLabel.text = [TTHelper stringForSeconds:seconds];
}


#pragma mark - Upgrade Button
- (IBAction)upgradeButtonPress:(id)sender {
    [TTAnalyticsInterface sendCategory:GOOGLE_ANALYTICS_CATEGORY_INFO action:GOOGLE_ANALYTICS_ACTION_UPGRADE];

    
    
    NSSet *identifiers = [NSSet setWithObjects:@"ca.sundeepgupta.toastmasterstimer.removeads", nil];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:identifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
//    TTInAppPurchaseHelper *iapHelper = [[TTInAppPurchaseHelper alloc] initWithProductIdentifiers:identifiers];
//    [iapHelper requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
//        if (success) {
//            NSLog(@"%@", products);
//        } else {
//            NSLog(@"products request failed");
//        }
//    }];
    
    
}








- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *products = response.products;
    SKProduct *product = products.firstObject;
    DDLogVerbose(@"Received products. First product: %@", product.productIdentifier);
    [self buyProduct:product];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    DDLogError(@"Failed to fetch products with error: %@\n%s", error.localizedDescription, __PRETTY_FUNCTION__);
}


- (void)buyProduct:(SKProduct *)product {
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)provideContentForProductIdentifier:(NSString *)identifier {
    
}






#pragma mark - Developer Button
- (IBAction)developerButtonPress:(id)sender {
    [self tryToSendEmail];
    [TTAnalyticsInterface sendCategory:GOOGLE_ANALYTICS_CATEGORY_INFO action:GOOGLE_ANALYTICS_ACTION_CONTACT_DEVELOPER];
}

- (void)tryToSendEmail {
    if ([MFMailComposeViewController canSendMail]) {
        [self email];
    } else {
        [TTHelper showAlertWithTitle:STRING_ERROR_TTITLE_GENERAL withMessage:NSLocalizedString(@"Can't sent email message", @"The message in the error when the device can't send emails")];
    }
}

- (void)email {
    MFMailComposeViewController *mailer = [self setupMailer];
    [self presentViewController:mailer animated:YES completion:nil];
}

- (MFMailComposeViewController *)setupMailer {
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    [self setupPropertiesforMailer:mailer];
    return mailer;
}

- (void)setupPropertiesforMailer:(MFMailComposeViewController *)mailer {
    mailer.mailComposeDelegate = self;
    [self setupRecipientsForMailer:mailer];
    [self setupSubjectForMailer:mailer];
}

- (void)setupRecipientsForMailer:(MFMailComposeViewController *)mailer {
    [self setupToRecipientsForMailer:mailer];
}

- (void)setupToRecipientsForMailer:(MFMailComposeViewController *)mailer {
    NSArray *toRecipients = [NSArray arrayWithObject:@"sundeep@sundeepgupta.ca"];
    [mailer setToRecipients:toRecipients];
}

- (void)setupSubjectForMailer:(MFMailComposeViewController *)mailer {
    NSString *subject = [TTHelper bundleName];
    [mailer setSubject:subject];
}

#pragma mark - MFMailComposerViewController Delegate Methods
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Rate App Button
- (IBAction)rateAppButtonPress:(id)sender {
    [TTHelper openAppWithUrlString:self.urlStringForRateApp];
    [TTAnalyticsInterface sendCategory:GOOGLE_ANALYTICS_CATEGORY_INFO action:GOOGLE_ANALYTICS_ACTION_RATE_APP];
}
- (NSString *)urlStringForRateApp {
    return [NSString stringWithFormat:@"%@%@", BASE_URL_RATE_APP, APP_ID];
}



#pragma mark - Share Button
- (IBAction)shareButtonPress:(id)sender {
    NSString *shareMessage = [NSString stringWithFormat:NSLocalizedString(@"Checkout this cool Toastmasters Timer app! %@", nil), APP_STORE_URL];
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:@[shareMessage] applicationActivities:nil];
    [self presentViewController:shareController animated:YES completion:nil];
    [TTAnalyticsInterface sendCategory:GOOGLE_ANALYTICS_CATEGORY_INFO action:GOOGLE_ANALYTICS_ACTION_SHARE];
}



#pragma mark - Done Button
- (IBAction)doneButtonPress:(id)sender {
    [self.modalDelegate modalShouldDismiss];
}




@end
