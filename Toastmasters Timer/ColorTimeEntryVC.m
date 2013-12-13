//
//  ColorTimeEntryVC.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 11/11/2013.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "ColorTimeEntryVC.h"
#import "SGRotaryWheel.h"

@interface ColorTimeEntryVC () <SGRotaryWheelDelegate>
@property (nonatomic, strong) SGRotaryWheel *rotaryWheel;
@property (strong, nonatomic) IBOutlet UIView *wheelView;
@property (strong, nonatomic) IBOutlet UILabel *minutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondsLabel;
@end

@implementation ColorTimeEntryVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupRotaryWheel];
}

- (void)setupRotaryWheel {
    self.rotaryWheel = [[SGRotaryWheel alloc] initWithView:self.wheelView delegate:self numberOfSections:12];
    [self.wheelView addSubview:self.rotaryWheel];
}



#pragma mark - Rotary wheel delegates
- (void)wheelDidChangeSectionNumber:(NSInteger)sectionNumber withLevelNumber:(NSInteger)levelNumber{
    self.minutesLabel.text = [NSString stringWithFormat:@"%i", sectionNumber];
    self.secondsLabel.text = [NSString stringWithFormat:@"%i", levelNumber];
}


@end
