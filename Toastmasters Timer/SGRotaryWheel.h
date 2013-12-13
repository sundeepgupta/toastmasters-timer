//
//  SGRotaryWheel.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 11/11/2013.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SGRotaryWheelDelegate <NSObject>
@required
- (void)wheelDidChangeSectionNumber:(NSInteger)sectionNumber withLevelNumber:(NSInteger)levelNumber;
@end


@interface SGRotaryWheel : UIControl
@property (weak) id <SGRotaryWheelDelegate> delegate;
@property (nonatomic, strong) UIView *containerView;
@property NSInteger sectionCount;

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate numberOfSections:(NSInteger)numberOfSections;

@end
