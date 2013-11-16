//
//  SGRotaryWheel.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 11/11/2013.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SGRotaryWheel.h"
#import <QuartzCore/QuartzCore.h>


static CGFloat deltaAngle;

@interface SGRotaryWheel ()
@property CGAffineTransform startTransform;
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
    self.containerView = [[UIView alloc] initWithFrame:self.frame];
    self.containerView.userInteractionEnabled = NO;
    self.containerView.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat angleSize = 2*M_PI/self.numberOfSections;
    
    for (NSInteger i = 0; i < self.numberOfSections; i++) {
        UILabel *im = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
        im.userInteractionEnabled = NO;
        im.backgroundColor = [UIColor redColor];
        im.text = [NSString stringWithFormat:@"%d", i];
        im.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        im.layer.position = CGPointMake(self.containerView.bounds.size.width/2.0, self.containerView.bounds.size.height/2.0);
        im.transform = CGAffineTransformMakeRotation(angleSize*i);
        im.tag = i;
        [self.containerView addSubview:im];
    }
    
    [self addSubview:self.containerView]; //this is already drawn via storyboard, no need to draw it again
}

- (void)rotate {
    CGAffineTransform transform = CGAffineTransformRotate(self.containerView.transform, -0.78);
    self.containerView.transform = transform;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL beginTracking;
    
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat distanceFromCenter = [self distanceFromCenterForPoint:touchPoint];
    
    if (distanceFromCenter < 40  ||  distanceFromCenter > 100) {
        beginTracking = NO;
    } else {
        CGFloat dx = touchPoint.x - self.containerView.center.x;
        CGFloat dy = touchPoint.y - self.containerView.center.y;
        deltaAngle = atan2f(dy, dx);
        self.startTransform = self.containerView.transform;
        beginTracking = YES;
    }
    
    return beginTracking;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    
    CGFloat dx = touchPoint.x - self.containerView.center.x;
    CGFloat dy = touchPoint.y - self.containerView.center.y;
    
    CGFloat angle = atan2(dy, dx);
    CGFloat angleDifference = angle - deltaAngle;
    
    self.containerView.transform = CGAffineTransformRotate(self.startTransform, angleDifference);
    
    return YES;
}

- (CGFloat)distanceFromCenterForPoint:(CGPoint)point {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat dx = point.x - center.x;
    CGFloat dy = point.y - center.y;
    return sqrt(dx*dx + dy*dy);
}



@end
