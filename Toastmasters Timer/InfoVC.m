//
//  InfoVC.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-29.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "InfoVC.h"


@interface InfoVC ()
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@end


@implementation InfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Helper registerForTimerNotificationsWithObject:self];
    [self setupTimerLabel];
}

- (void)setupTimerLabel {
    if (self.currentTimerString  &&  self.currentTimerString.length > 0) {
        self.timerLabel.text = self.currentTimerString;
    }
}



#pragma mark - Timer Notification
- (void)timerUpdatedSecondsWithNotification:(NSNotification *)notification {
    NSInteger seconds = [Helper secondsForNotification:notification];
    [self updateTimerLabelWithSeconds:seconds];
}
- (void)updateTimerLabelWithSeconds:(NSInteger)seconds {
    self.timerLabel.text = [Helper stringForTotalSeconds:seconds];
}



- (IBAction)sundeepButtonPress:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        [self email];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Send Mail" message:@"It looks like your device isn't setup to send mail. If your device supports it, make sure you've configured your email account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)email
{
    MFMailComposeViewController *mailer = [self setupMailer];
    [self presentViewController:mailer animated:YES completion:nil];
}

- (MFMailComposeViewController *)setupMailer
{
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    [self setupPropertiesforMailer:mailer];
    return mailer;
}

- (void)setupPropertiesforMailer:(MFMailComposeViewController *)mailer
{
    mailer.mailComposeDelegate = self;
    [self setupRecipientsForMailer:mailer];
    [self setupSubjectForMailer:mailer];
}

- (void)setupRecipientsForMailer:(MFMailComposeViewController *)mailer
{
    [self setupToRecipientsForMailer:mailer];
}

- (void)setupToRecipientsForMailer:(MFMailComposeViewController *)mailer
{
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
                        error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}






- (IBAction)nicoleButtonPress:(id)sender {
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
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
