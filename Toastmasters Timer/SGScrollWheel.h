//
//  SGScrollWheel.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 11/11/2013.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SGScrollWheelDelegate <NSObject>
@required
- (void)wheelDidTurnClockwise;
- (void)wheelDidTurnCounterClockwise;
@end


@interface SGScrollWheel : UIControl
@property (weak) id <SGScrollWheelDelegate> delegate;
@property (nonatomic, strong) UIView *containerView;
@property NSInteger sectionCount;

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate numberOfSections:(NSInteger)numberOfSections;
@end
