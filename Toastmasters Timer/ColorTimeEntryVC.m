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
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@end

@implementation ColorTimeEntryVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupRotaryWheel];
}

- (void)setupRotaryWheel {
    self.rotaryWheel = [[SGRotaryWheel alloc] initWithFrame:CGRectMake(0, 0, 300, 300) delegate:self numberOfSections:12];
    [self.view addSubview:self.rotaryWheel];
}



#pragma mark - Rotary wheel delegates
- (void)wheelDidChangeSectionNumber:(NSInteger)sectionNumber withLevelNumber:(NSInteger)levelNumber{
    self.label.text = [NSString stringWithFormat:@"Section %i", sectionNumber];
    self.levelLabel.text = [NSString stringWithFormat:@"Level %i", levelNumber];
}


@end
