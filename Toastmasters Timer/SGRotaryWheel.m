//
//  SGRotaryWheel.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 11/11/2013.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SGRotaryWheel.h"
#import <QuartzCore/QuartzCore.h>
#import "SGSector.h"


static CGFloat deltaAngle;

@interface SGRotaryWheel ()
@property CGAffineTransform startTransform;
@property (nonatomic) CGFloat angleSize;
@property (nonatomic, strong) NSMutableArray *sectors;
@end


@implementation SGRotaryWheel

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate numberOfSections:(NSInteger)numberOfSections;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
    
        self.numberOfSections = numberOfSections;
        self.delegate = delegate;
        [self drawWheel];
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
}
- (void)setupLabels {
    self.angleSize = 2*M_PI/self.numberOfSections;
    for (NSInteger i = 0; i < self.numberOfSections; i++) {
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
    label.transform = CGAffineTransformMakeRotation(self.angleSize*section);
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
    [self logTracking];
    CGPoint touchPoint = [touch locationInView:self];
    [self transformToPoint:touchPoint];
    return YES;
}
- (void)logTracking {
    CGFloat radians = atan2f(self.containerView.transform.b, self.containerView.transform.a);
    NSLog(@"rad is %f", radians);
}
- (void)transformToPoint:(CGPoint)point {
    CGFloat dx = point.x - self.containerView.center.x;
    CGFloat dy = point.y - self.containerView.center.y;
    CGFloat angle = atan2(dy, dx);
    CGFloat angleDifference = angle - deltaAngle;
    self.containerView.transform = CGAffineTransformRotate(self.startTransform, angleDifference);
}


@end
