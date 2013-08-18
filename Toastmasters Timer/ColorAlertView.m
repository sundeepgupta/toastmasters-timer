//
//  ColorAlertView.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-18.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "ColorAlertView.h"

@implementation ColorAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithTitle:(NSString *)title
{
    self = [super initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"Dismiss now" otherButtonTitles:nil, nil];
    if (self)
    {
        [self performSelector:@selector(dismissAfterDelay) withObject:nil afterDelay:3];
    }
    return self;
}

- (void)dismissAfterDelay
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

@end
