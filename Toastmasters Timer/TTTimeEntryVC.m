#import "TTTimeEntryVC.h"
#import "SGDeepCopy.h"
#import "SGScrollWheel.h"
#import "TTColorButton.h"
#import "TTAlertManager.h"
#import "TTAnalyticsInterface.h"
#import "TTHelper.h"

#define WHEEL_PADDING 0


@interface TTTimeEntryVC () <SGScrollWheelDelegate>
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) SGScrollWheel *scrollWheel;
@property (weak, nonatomic) IBOutlet UIView *wheelView;
@property (weak, nonatomic) IBOutlet TTColorButton *greenButton;
@property (weak, nonatomic) IBOutlet TTColorButton *amberButton;
@property (weak, nonatomic) IBOutlet TTColorButton *redButton;
@property (weak, nonatomic) IBOutlet TTColorButton *bellButton;
@property (nonatomic, strong) NSArray *colorButtonArray;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wheelImageView;
@property (nonatomic, weak) IBOutlet UIButton *resetButton;
@end


@implementation TTTimeEntryVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupDefaults];
    [self setupColorButtonArray];
    [self setupColorArray];
    [TTHelper setupTitlesForColorButtons:self.colorButtonArray withColorArray:self.colorArray];
    [self setupScrollWheel];
    [TTHelper registerForTimerNotificationsWithObject:self];
    [self setupTimerLabel];
    [self setupWheelImageView];
}

- (void)setupDefaults {
    self.defaults = [NSUserDefaults standardUserDefaults];
}

- (void)setupColorButtonArray {
    self.colorButtonArray = @[self.greenButton, self.amberButton, self.redButton, self.bellButton];
}

- (void)setupColorArray {
    self.colorArray = [self.defaults arrayForKey:COLOR_TIMES_KEY];
}


- (void)setupScrollWheel {
    CGFloat sideLength = self.wheelView.frame.size.width + 2*WHEEL_PADDING;
    CGRect frame = CGRectMake(-WHEEL_PADDING, -WHEEL_PADDING, sideLength, sideLength);
    self.scrollWheel = [[SGScrollWheel alloc] initWithFrame:frame delegate:self numberOfSections:60/SECONDS_INCREMENT];
    [self.wheelView addSubview:self.scrollWheel];
}


- (void)setupTimerLabel {
    if (self.currentTimerString  &&  self.currentTimerString.length > 0) {
        self.timerLabel.text = self.currentTimerString;
    }
}

- (void)setupViewWithColorIndex:(ColorIndex)index {
    self.currentColorIndex = index;
    [self setupWheelImageView];
}

- (void)setupWheelImageView {
    NSString *imageName = [self wheelImageNameForCurrentColorIndex];
    UIImage *image = [UIImage imageNamed:imageName];
    self.wheelImageView.image = image;
}




#pragma mark - Scroll wheel delegates
- (void)wheelDidTurnClockwise:(BOOL)didTurnClockwise {
    [self updateCurrentButtonTitleShouldIncrement:didTurnClockwise];
    [self.timeEntryDelegate colorTimeDidChangeForIndex:self.currentColorIndex];
}
- (void)updateCurrentButtonTitleShouldIncrement:(BOOL)shouldIncrement {
    TTColorButton *button = [self buttonForCurrentColorIndex];
    NSInteger currentSeconds = [TTHelper secondsForTimeString:button.titleLabel.text];
    
    NSInteger newSeconds;
    if (shouldIncrement) {
        newSeconds = currentSeconds + SECONDS_INCREMENT;
    } else {
        newSeconds = currentSeconds - SECONDS_INCREMENT;
    }
    
    [TTHelper setupTitleForColorButton:button withSeconds:newSeconds];
}



#pragma mark - Resetting colours
- (IBAction)resetButtonPress {
    [self resetColors];
    [self.timeEntryDelegate didResetAllColourTimes];
    [TTAnalyticsInterface sendCategory:GOOGLE_ANALYTICS_CATEGORY_TIME_ENTRY action: GOOGLE_ANALYTICS_ACTION_RESET_COLOURS];
}
- (void)resetColors {
    for (TTColorButton *button in self.colorButtonArray) {
        [TTHelper setupTitleForColorButton:button withSeconds:0];
    }
}


- (TTColorButton *)buttonForCurrentColorIndex {
    TTColorButton *button;
    switch (self.currentColorIndex) {
        case GREEN_COLOR_INDEX:
            button = self.greenButton;
            break;
        case AMBER_COLOR_INDEX:
            button = self.amberButton;
            break;
        case RED_COLOR_INDEX:
            button = self.redButton;
            break;
        case BELL_COLOR_INDEX:
            button = self.bellButton;
            break;
        default:
            break;
    }
    return button;
}





#pragma mark - Timer Notification
- (void)timerUpdatedSecondsWithNotification:(NSNotification *)notification {
    NSInteger seconds = [TTHelper secondsForNotification:notification];
    [self updateTimerLabelWithSeconds:seconds];
}
- (void)updateTimerLabelWithSeconds:(NSInteger)seconds {
    self.timerLabel.text = [TTHelper stringForSeconds:seconds];
}




#pragma mark - Color Buttons 
- (IBAction)greenButtonTapped:(id)sender {
    [self setupViewWithColorIndex:GREEN_COLOR_INDEX];
}
- (IBAction)amberButtonTapped:(id)sender {
    [self setupViewWithColorIndex:AMBER_COLOR_INDEX];
}
- (IBAction)redButtonTapped:(id)sender {
    [self setupViewWithColorIndex:RED_COLOR_INDEX];
}
- (IBAction)bellButtonTapped:(id)sender {
    [self setupViewWithColorIndex:BELL_COLOR_INDEX];
}



- (NSString *)wheelImageNameForCurrentColorIndex {
    NSString *name;
    switch (self.currentColorIndex) {
        case GREEN_COLOR_INDEX:
            name = @"greenWheel";
            break;
        case AMBER_COLOR_INDEX:
            name = @"amberWheel";
            break;
        case RED_COLOR_INDEX:
            name = @"redWheel";
            break;
        case BELL_COLOR_INDEX:
            name = @"bellWheel";
            break;
        default:
            break;
    }
    return name;
}



#pragma mark - Save and Cancel
- (IBAction)doneButtonPress:(id)sender {
    [self saveColorsToDefaults];
    [self.alertManager recreateNotifications];
    [self.modalDelegate modalShouldDismiss];
    [TTHelper sendColorTimeValuesToAnalytics];
}
- (void)saveColorsToDefaults {
    NSArray *colorArray = [self newColorArray];
    [self saveColorArray:colorArray];
}
- (NSArray *)newColorArray {
    NSNumber *greenNumber = [TTHelper secondsNumberForTimeString:self.greenButton.titleLabel.text];
    NSNumber *amberNumber = [TTHelper secondsNumberForTimeString:self.amberButton.titleLabel.text];
    NSNumber *redNumber = [TTHelper secondsNumberForTimeString:self.redButton.titleLabel.text];
    NSNumber *bellNumber = [TTHelper secondsNumberForTimeString:self.bellButton.titleLabel.text];
    NSArray *colorArray = @[greenNumber, amberNumber, redNumber, bellNumber];
    return colorArray;
}
- (void)saveColorArray:(NSArray *)colorArray {
    [self.defaults setObject:colorArray forKey:COLOR_TIMES_KEY];
    [self.defaults synchronize];
}


@end
