//
//  SGRotaryWheel.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 11/11/2013.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SGRotaryWheel.h"
#import <QuartzCore/QuartzCore.h>
#import "SGSection.h"


#define kRadiansOffset M_PI/2 //put 0 on top instead of on left


static CGFloat deltaAngle;


@interface SGRotaryWheel ()
@property CGAffineTransform startTransform;
@property (nonatomic) CGFloat sectionAngleSize;
@property (nonatomic, strong) NSMutableArray *sections;
@property NSInteger previousSectionNumber;
@property NSInteger currentSectionNumber;
@property NSInteger currentLevelNumber;
@property BOOL isRotatingClockwise;

@end


@implementation SGRotaryWheel

#pragma mark - Initialize
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate numberOfSections:(NSInteger)numberOfSections;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        
        self.sectionCount = numberOfSections;
        self.delegate = delegate;
        [self drawWheel];
        [self setupSections];
        self.currentLevelNumber = 0;
    }
    return self;
}
- (void)drawWheel {
    [self setupContainerView];
    [self setupLabels];
    [self addSubview:self.containerView];
}
- (void)setupContainerView {
    self.containerView = [[UIView alloc] initWithFrame:self.frame];
    self.containerView.userInteractionEnabled = NO;
    self.containerView.backgroundColor = [UIColor lightGrayColor];
    self.containerView.transform = CGAffineTransformMakeRotation(kRadiansOffset);
}
- (void)setupLabels {
    self.sectionAngleSize = 2*M_PI/self.sectionCount;
    for (NSInteger i = 0; i < self.sectionCount; i++) {
        UILabel *label = [self labelForSection:i];
        [self.containerView addSubview:label];
    }
}
- (UILabel *)labelForSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    label.userInteractionEnabled = NO;
    label.backgroundColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"%d", section];
    label.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
    label.layer.position = CGPointMake(self.containerView.bounds.size.width/2.0, self.containerView.bounds.size.height/2.0);
    label.transform = CGAffineTransformMakeRotation(self.sectionAngleSize*section);
    label.tag = section;
    return label;
}



#pragma mark - Begin Tracking
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat distanceFromCenter = [self distanceFromCenterForPoint:touchPoint];
    BOOL shouldTrack = [self shouldTrackForDistanceFromCenter:distanceFromCenter];
    if (shouldTrack) {
        [self updateStartTransformWithPoint:touchPoint];
    }
    return shouldTrack;
}
- (CGFloat)distanceFromCenterForPoint:(CGPoint)point {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat dx = point.x - center.x;
    CGFloat dy = point.y - center.y;
    return sqrt(dx*dx + dy*dy);
}
- (BOOL)shouldTrackForDistanceFromCenter:(CGFloat)distanceFromCenter {
    BOOL shouldTrack = YES;
    if (distanceFromCenter < 40  ||  distanceFromCenter > 100) {
        shouldTrack = NO;
    }
    return shouldTrack;
}
- (void)updateStartTransformWithPoint:(CGPoint)point {
    CGFloat dx = point.x - self.containerView.center.x;
    CGFloat dy = point.y - self.containerView.center.y;
    deltaAngle = atan2f(dy, dx);
    self.startTransform = self.containerView.transform;
}



#pragma mark - Continue Tracking
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    [self transformToPoint:touchPoint];
    [self updateValues];
    return YES;
}


- (void)transformToPoint:(CGPoint)point {
    CGFloat dx = point.x - self.containerView.center.x;
    CGFloat dy = point.y - self.containerView.center.y;
    CGFloat angle = atan2(dy, dx);
    CGFloat angleDifference = angle - deltaAngle;
    self.containerView.transform = CGAffineTransformRotate(self.startTransform, angleDifference);
}

- (void)updateValues {
    NSInteger newSectionNumber = [self sectionNumberForCurrentRadians];
    if (newSectionNumber != self.currentSectionNumber) {
        [self updateCurrentValuesWithNewSectionNumber:newSectionNumber];
        [self.delegate wheelDidChangeSectionNumber:self.currentSectionNumber withLevelNumber:self.currentLevelNumber];
    }
}


- (NSInteger)sectionNumberForCurrentRadians {
    CGFloat radians = [self currentRadians];
    NSInteger sectionNumber;
    for (NSInteger i = 0; i < self.sections.count; i++) {
        SGSection *section = self.sections[i];
        if ([self radians:radians isInSection:section]) {
            sectionNumber = i;
        }
    }
    
    NSLog(@"Radians: %f, Section: %i", radians, self.currentSectionNumber);
    return sectionNumber;
}

- (void)updateCurrentValuesWithNewSectionNumber:(NSInteger)newSectionNumber {
    NSInteger newSectionNumberDifference = abs(newSectionNumber - self.currentSectionNumber);
    if (newSectionNumberDifference > 1) {
        [self updateCurrentLevelWithNewSectionNumber:newSectionNumber];
    }
    self.currentSectionNumber = newSectionNumber;
}


- (void)updateCurrentLevelWithNewSectionNumber:(NSInteger)newSectionNumber {
    if (newSectionNumber == 0) {
        self.currentLevelNumber++;
    } else {
        self.currentLevelNumber--;
    }
}


- (BOOL)radians:(CGFloat)radians isInSection:(SGSection *)section {
    BOOL isInSection = NO;
    
    if (section.minValue > 0  &&  section.maxValue < 0) { //anomaly case
        if (radians > section.minValue  ||  radians < section.maxValue) {
            isInSection = YES;
        }
    } else if (radians > section.minValue  &&  radians < section.maxValue) {
        isInSection = YES;
    }
    return isInSection;
}

- (CGFloat)currentRadians {
    CGFloat radians = atan2f(self.containerView.transform.b, self.containerView.transform.a);
    return radians;
}



#pragma mark - Sectors
- (void)setupSections {
    self.sections = [NSMutableArray arrayWithCapacity:self.sectionCount];
    if (self.sectionCount%2 == 0) {
        [self buildEvenNumberOfSections];
    } else {
//        [self buildOddNumberOfSections];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Odd number of wheel sections not supported yet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)buildEvenNumberOfSections {
    CGFloat midValue = kRadiansOffset;
    for (NSInteger i = 0; i < self.sectionCount; i++) {
        SGSection *section = [self sectionWithMidValue:midValue andSectionNumber:i];
        
        if (section.maxValue > M_PI) {
            midValue = -M_PI;
            section.midValue = midValue;
            section.maxValue = -section.minValue;
        }
        midValue += self.sectionAngleSize;
        
        [self.sections addObject:section];
        NSLog(@"Created section: %@", section);
    }
}

//this is broken, so don't use it
//- (void)buildOddNumberOfSections {
//    CGFloat midValue = kRadiansOffset;
//    for (NSInteger i = 0; i < self.sectionCount; i++) {
//        SGSection *section = [self sectionWithMidValue:midValue andSectionNumber:i];
//        
//        midValue += self.sectionAngleSize;
//        if (section.maxValue > M_PI) {
//            midValue = -midValue;
//            midValue += self.sectionAngleSize;
//        }
//        
//        [self.sections addObject:section];
//        NSLog(@"Created section: %@", section);
//    }
//}



- (SGSection *)sectionWithMidValue:(CGFloat)midValue andSectionNumber:(NSInteger)sectionNumber {
    SGSection *section = [SGSection new];
    section.midValue = midValue;
    section.minValue = midValue - self.sectionAngleSize/2;
    section.maxValue = midValue + self.sectionAngleSize/2;
    section.sectionNumber = sectionNumber;
    return section;
}

@end
