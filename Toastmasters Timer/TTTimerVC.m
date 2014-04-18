#import "TTTimerVC.h"
#import "TTTimer.h"
#import "TTTimeEntryVC.h"
#import "SGDeepCopy.h"
#import "TTInfoVC.h"
#import "TTAlertManager.h"
#import "TTColorButton.h"
#import "TTStrings.h"
#import "TTAnalyticsInterface.h"




@interface TTTimerVC () <TTModalDelegate, TTTimeEntryVCDelegate>
@property (strong, nonatomic) TTTimer *timer;
@property (strong, nonatomic) TTAlertManager *alertManager;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (nonatomic, strong) NSArray *colorArray;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *audioAlertButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet TTColorButton *greenButton;
@property (weak, nonatomic) IBOutlet TTColorButton *amberButton;
@property (weak, nonatomic) IBOutlet TTColorButton *redButton;
@property (weak, nonatomic) IBOutlet TTColorButton *bellButton;
@property (nonatomic, strong) NSArray *colorButtonArray;
@end


@implementation TTTimerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupColorButtonArray];
    [self setupDefaults];
    [self setupTimer];
    [self setupAlertManager];
    [self setupAlertButton];
    [TTHelper registerForTimerNotificationsWithObject:self];
    
    if ([TTHelper isFirstLaunch]) {
        [self doFirstLaunchActions];
    }
}

- (void)setupColorButtonArray {
    self.colorButtonArray = @[self.greenButton, self.amberButton, self.redButton, self.bellButton];
}

- (void)setupDefaults {
    self.defaults = [NSUserDefaults standardUserDefaults];
    [self.defaults setBool:NO forKey:SHOULD_AUDIO_ALERT_KEY];
}


- (void)setupTimer {
    self.timer = [[TTTimer alloc] init];
}


- (void)setupAlertManager {
    self.alertManager = [[TTAlertManager alloc] initWithTimer:self.timer timerVC:self defaults:self.defaults];
}

- (void)setupAlertButton {
    if ([self.defaults boolForKey:SHOULD_AUDIO_ALERT_KEY]) {
        self.audioAlertButton.alpha = 1;
    } else {
        self.audioAlertButton.alpha = DISABLED_ALPHA;
    }
}


- (void)doFirstLaunchActions {
    [self showTips];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateView];
}

- (void)updateView {
    [self setupColorArray];
    [TTHelper setupTitlesForColorButtons:self.colorButtonArray withColorArray:self.colorArray];
}

- (void)setupColorArray {
    self.colorArray = [self.defaults arrayForKey:COLOR_TIMES_KEY];
}



#pragma mark - Emphasize Color Labels
- (void)emphasizeColorWithIndex:(ColorIndex)index {
    [self deEmphasizeAllColors];
    TTColorButton *button = self.colorButtonArray[index];
    [button emphasize];
}

- (void)deEmphasizeAllColors {
    for (TTColorButton *button in self.colorButtonArray) {
        [button deEmphasize];
    }
}

- (void)deEmphasizeColorWithIndex:(ColorIndex)index {
    TTColorButton *button = self.colorButtonArray[index];
    [button deEmphasize];
}




#pragma mark - Timer Controls
- (IBAction)pauseButtonPress:(id)sender {
    [self toggleTimer];
    
    
}
- (void)toggleTimer {
    TIMER_STATUS status = [self.timer status];
    if (status == RUNNING) {
        [self pauseTimer];
    } else {
        [self startTimerWithStatus:status];
    }
}
- (void)pauseTimer {
    [self.timer pause];
    [self changeButtonToContinueTimer];
    [self.alertManager cancelLocalNotifications];
}

- (void)startTimerWithStatus:(TIMER_STATUS)status {
    if (status == PAUSED) {
        [self.timer unpause];
    } else { //status is stopped
        [self.timer startFromStopped];
    }
    [self changeButtonToPauseTimer];
    [self.alertManager setupLocalNotifications];
}


- (void)changeButtonToContinueTimer {
    [self setPauseButtonImageWithName:@"play.png"];
}
- (void)changeButtonToPauseTimer {
    [self setPauseButtonImageWithName:@"pause.png"];
}
- (void)setPauseButtonImageWithName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    [self.pauseButton setBackgroundImage:image forState:UIControlStateNormal];
}

- (IBAction)stopButtonPress:(id)sender {
    [self.timer stop];
    [self updateTimerLabel];
    [self changeButtonToContinueTimer];
    [self deEmphasizeAllColors];
    [self.alertManager cancelLocalNotifications];
}



#pragma mark - Timer Notification
- (void)timerUpdatedSecondsWithNotification:(NSNotification *)notification {
    [self updateTimerLabel];
    [self alertColorIfNeeded];
}

- (void)updateTimerLabel {
    self.timerLabel.text = [TTHelper stringForSeconds:self.timer.seconds];
}


- (void)alertColorIfNeeded {
    NSInteger colorIndexToAlert = [self colorIndexToAlert];
    if (colorIndexToAlert > -1) {
        [self alertColorWithIndex:colorIndexToAlert];
    }
}

- (NSInteger)colorIndexToAlert {
    NSInteger index = -1;
    for (ColorIndex i = GREEN_COLOR_INDEX; i < COLOR_INDEX_COUNT; i++) {
        NSInteger colorSeconds = [self.colorArray[i] integerValue];
        if (self.timer.seconds == colorSeconds) {
            index = i;
        }
    }
    return index;
}

- (void)alertColorWithIndex:(ColorIndex)index {
    [self emphasizeColorWithIndex:index];
    [self.alertManager performAlertForColorIndex:index];
}



#pragma mark - Color Button
- (IBAction)greenButtonTapped:(id)sender {
    [self handleColorButtonPressForIndex:GREEN_COLOR_INDEX];
}
- (IBAction)amberButtonTapped:(id)sender {
    [self handleColorButtonPressForIndex:AMBER_COLOR_INDEX];
}
- (IBAction)redButtonTapped:(id)sender {
    [self handleColorButtonPressForIndex:RED_COLOR_INDEX];
}
- (IBAction)bellButtonTapped:(id)sender {
    [self handleColorButtonPressForIndex:BELL_COLOR_INDEX];
}

- (void)handleColorButtonPressForIndex:(ColorIndex)index {
    [self presentTimeEntryVcWithIndex:index];
}

- (void)presentTimeEntryVcWithIndex:(ColorIndex)index {
    UIViewController *vc = [self timeEntryVcWithIndex:index];
    [self presentViewController:vc animated:YES completion:nil];
}
- (TTTimeEntryVC *)timeEntryVcWithIndex:(ColorIndex)index {
    NSString *vcClassName = NSStringFromClass([TTTimeEntryVC class]);
    TTTimeEntryVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:vcClassName];
    vc.currentTimerString = self.timerLabel.text;
    vc.currentColorIndex = index;
    vc.alertManager = self.alertManager;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalDelegate = self;
    vc.timeEntryDelegate = self;
    return vc;
}


#pragma mark - Audio Alert Button
- (IBAction)toggleAudioAlertButtonPress:(id)sender {
    [self toggleShouldAudioAlert];
    [self.alertManager recreateNotifications];
}
- (void)toggleShouldAudioAlert {
    BOOL shouldAlert = [self.defaults boolForKey:SHOULD_AUDIO_ALERT_KEY];
    if (shouldAlert) {
        [self disableAudioAlert];
    } else {
        [self enableAudioAlert];
    }
}
- (void)disableAudioAlert {
    self.audioAlertButton.alpha = DISABLED_ALPHA;
    [self.defaults setBool:NO forKey:SHOULD_AUDIO_ALERT_KEY];
    [TTAnalyticsInterface sendTrackingInfoWithCategory:GOOGLE_ANALYTICS_CATEGORY_GENERAL action:GOOGLE_ANALYTICS_ACTION_AUDIO_DISABLED];
}
- (void)enableAudioAlert {
    self.audioAlertButton.alpha = 1;
    [self.defaults setBool:YES forKey:SHOULD_AUDIO_ALERT_KEY];
    [TTAnalyticsInterface sendTrackingInfoWithCategory:GOOGLE_ANALYTICS_CATEGORY_GENERAL action:GOOGLE_ANALYTICS_ACTION_AUDIO_ENABLED];
}



#pragma mark - Info Button
- (IBAction)infoButtonPress:(id)sender {
    [self presentInfoVC];
}

- (void)presentInfoVC {
    NSString *vcClassName = NSStringFromClass([TTInfoVC class]);
    TTInfoVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:vcClassName];
    vc.currentTimerString = self.timerLabel.text;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - Tips
- (void)showTips {
    [TTHelper showAlertWithTitle:STRING_TIP_TITLE withMessage:STRING_TIP_START_TIMER_EARLIER];
}



#pragma mark - Time Entry VC Delegate Methods
- (void)colorTimeDidChangeForIndex:(ColorIndex)index {
    [self deEmphasizeColorWithIndex:index];
}

- (void)didResetAllColourTimes {
    [self deEmphasizeAllColors];
}




#pragma mark - Modal Delegate Methods
- (void)modalShouldDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Prepare for Background
- (void)setupViewForBackground {
    self.timerLabel.hidden = YES;
    [self deEmphasizeAllColors];
    [self removeToast];
}

- (void)removeToast {
    NSArray *subviews = self.view.subviews;
    for (UIView *subview in subviews) {
        if (subview.tag == TOAST_TAG) {
            [subview removeFromSuperview];
        }
    }
}



#pragma mark - Return to Foreground
- (void)setupViewForReturningToForeground {
    self.timerLabel.hidden = NO;
    
    if (self.timer.status == RUNNING) {
        [self emphasizeCorrectColor];
    }
}

- (void)emphasizeCorrectColor {
    NSInteger index = [self colorIndexToEmphasize];
    if (index > -1) {
        [self emphasizeColorWithIndex:index];
    }
}

- (NSInteger)colorIndexToEmphasize {
    NSInteger colorIndexToEmphasize = -1;
    NSInteger minDifference = REALLY_LARGE_INTEGER;
    
    for (ColorIndex i = GREEN_COLOR_INDEX; i < COLOR_INDEX_COUNT; i++) {
        NSInteger colorSeconds = [self.colorArray[i] integerValue];
        NSInteger difference = self.timer.seconds - colorSeconds;
        BOOL colorTimeWasReached = difference >= 0;
        if (colorTimeWasReached  &&  colorSeconds > 0  &&  difference <= minDifference) {
            minDifference = difference;
            colorIndexToEmphasize = i;
        }
    }
        
    return colorIndexToEmphasize;
}



@end
