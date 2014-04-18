#import "TTInfoVC.h"
#import "TTStrings.h"


@interface TTInfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@end


@implementation TTInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [TTHelper registerForTimerNotificationsWithObject:self];
    [self setupTimerLabel];
}

- (void)setupTimerLabel {
    if (self.currentTimerString  &&  self.currentTimerString.length > 0) {
        self.timerLabel.text = self.currentTimerString;
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



#pragma mark - Rate App Button
- (IBAction)rateAppButtonPress:(id)sender {
    [TTHelper openAppWithUrlString:self.urlStringForRateApp];
    [TTAnalyticsInterface sendTrackingInfoWithCategory:GOOGLE_ANALYTICS_CATEGORY_GENERAL action:GOOGLE_ANALYTICS_ACTION_RATE_APP];
}
- (NSString *)urlStringForRateApp {
    return [NSString stringWithFormat:@"%@%@", BASE_URL_RATE_APP, APP_ID];
}


#pragma mark - Developer Button


- (IBAction)developerButtonPress:(id)sender {
    [self tryToSendEmail];
    [TTAnalyticsInterface sendTrackingInfoWithCategory:GOOGLE_ANALYTICS_CATEGORY_GENERAL action:GOOGLE_ANALYTICS_ACTION_CONTACT_DEVELOPER];
}

- (void)tryToSendEmail {
    if ([MFMailComposeViewController canSendMail]) {
        [self email];
    } else {
        [TTHelper showAlertWithTitle:STRING_ERROR_TTITLE_CANT_SEND_MAIL withMessage:STRING_ERROR_MESSAGE_CANT_SEND_MAIL];
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
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *appName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *subject = [NSString stringWithFormat:@"%@ App", appName];
    [mailer setSubject:subject];
}

#pragma mark - MFMailComposerViewController Delegate Methods
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Designer Button
- (IBAction)designerButtonPress:(id)sender {
    NSString *urlString = @"http://www.redconservatory.com";
    NSURL *url = [NSURL URLWithString:urlString];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Open Link" message:@"It looks like your device can't open the website link." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}







- (IBAction)doneButtonPress:(id)sender {
    [self.modalDelegate modalShouldDismiss];
}




@end
