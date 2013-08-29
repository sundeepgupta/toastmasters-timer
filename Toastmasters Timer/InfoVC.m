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

- (IBAction)twitterButtonPress:(id)sender {
}

- (IBAction)websiteButtonPress:(id)sender {
}

- (IBAction)questionButtonPress:(id)sender {
}

- (IBAction)doneButtonPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
