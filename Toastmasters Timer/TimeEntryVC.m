#import "TimeEntryVC.h"
#import "SGDeepCopy.h"
#import "SGScrollWheel.h"
#import "ColorButton.h"
#import "AlertManager.h"


#define WHEEL_PADDING 0


@interface TimeEntryVC () <SGScrollWheelDelegate>
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) SGScrollWheel *scrollWheel;
@property (strong, nonatomic) IBOutlet UIView *wheelView;
@property (strong, nonatomic) IBOutlet ColorButton *greenButton;
@property (strong, nonatomic) IBOutlet ColorButton *amberButton;
@property (strong, nonatomic) IBOutlet ColorButton *redButton;
@property (strong, nonatomic) IBOutlet ColorButton *bellButton;
@property (nonatomic, strong) NSArray *colorButtonArray;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet UIImageView *wheelImageView;
@property (nonatomic, weak) IBOutlet UIButton *resetButton;
@end


@implementation TimeEntryVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupDefaults];
    [self setupColorButtonArray];
    [self setupColorArray];
    [Helper setupTitlesForColorButtons:self.colorButtonArray withColorArray:self.colorArray];
    [self setupScrollWheel];
    [Helper registerForTimerNotificationsWithObject:self];
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
    ColorButton *button = [self buttonForCurrentColorIndex];
    NSInteger currentSeconds = [Helper secondsForTimeString:button.titleLabel.text];
    
    NSInteger newSeconds;
    if (shouldIncrement) {
        newSeconds = currentSeconds + SECONDS_INCREMENT;
    } else {
        newSeconds = currentSeconds - SECONDS_INCREMENT;
    }
    
    [Helper setupTitleForColorButton:button withSeconds:newSeconds];
}



#pragma mark - Resetting colours
- (IBAction)resetButtonPress {
    [self resetColors];
    [self.timeEntryDelegate didResetAllColourTimes];
}
- (void)resetColors {
    for (ColorButton *button in self.colorButtonArray) {
        [Helper setupTitleForColorButton:button withSeconds:0];
    }
}


- (ColorButton *)buttonForCurrentColorIndex {
    ColorButton *button;
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
    NSInteger seconds = [Helper secondsForNotification:notification];
    [self updateTimerLabelWithSeconds:seconds];
}
- (void)updateTimerLabelWithSeconds:(NSInteger)seconds {
    self.timerLabel.text = [Helper stringForSeconds:seconds];
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
}
- (void)saveColorsToDefaults {
    NSArray *colorArray = [self newColorArray];
    [self saveColorArray:colorArray];
}
- (NSArray *)newColorArray {
    NSNumber *greenNumber = [Helper secondsNumberForTimeString:self.greenButton.titleLabel.text];
    NSNumber *amberNumber = [Helper secondsNumberForTimeString:self.amberButton.titleLabel.text];
    NSNumber *redNumber = [Helper secondsNumberForTimeString:self.redButton.titleLabel.text];
    NSNumber *bellNumber = [Helper secondsNumberForTimeString:self.bellButton.titleLabel.text];
    NSArray *colorArray = @[greenNumber, amberNumber, redNumber, bellNumber];
    return colorArray;
}
- (void)saveColorArray:(NSArray *)colorArray {
    [self.defaults setObject:colorArray forKey:COLOR_TIMES_KEY];
    [self.defaults synchronize];
}


@end
