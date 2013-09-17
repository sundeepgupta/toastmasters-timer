//
//  InfoVC.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-29.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "InfoVC.h"

@interface InfoVC ()

@end

@implementation InfoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)sundeepButtonPress:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        [self email];
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
    NSString *appName = [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
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
    [app openURL:url];
}







- (IBAction)doneButtonPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
