#import "TTInfoVC.h"
#import "TTCommonStrings.h"
#import "TTConstants.h"
#import "TTInAppPurchaser.h"


@interface TTInfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *upgradeButton;
@property (weak, nonatomic) IBOutlet UILabel *upgradeLabel;
@end


@implementation TTInfoVC

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [TTHelper registerForTimerNotificationsWithObject:self];
    [self setupTimerLabel];
    [self setupAppNameLabel];
    [self setupVersionLabel];
    [self setupUpgradeButton];
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

- (void)setupUpgradeButton {
    if ([TTHelper upgraded]) {
        [self disableUpgradeButton];
    }
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
    //start spinner
    
    [self purchaseUpgrade];
    [TTAnalyticsInterface sendCategory:GOOGLE_ANALYTICS_CATEGORY_INFO action:GOOGLE_ANALYTICS_ACTION_UPGRADE];
}

- (void)purchaseUpgrade {
    [[TTInAppPurchaser sharedInstance] purchaseProductWithIdentifier:REMOVE_ADS_PRODUCT_ID success:^{
        [self setupUpgradeButton];
        
        //stop spinner
        
    } failure:^(NSError *error) {
        NSString *message = [NSString stringWithFormat:@"In app purchased failed with error: %@", error.localizedDescription];
        [TTHelper showAlertWithTitle:@"Error" withMessage:message];
        DDLogError(@"In app purchase failed with error: %@\n%s", error.localizedDescription, __PRETTY_FUNCTION__);
    }];
}

- (void)disableUpgradeButton {
    self.upgradeButton.enabled = NO;
    self.upgradeButton.alpha = 0.5;
    self.upgradeLabel.alpha = 0.5;
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
