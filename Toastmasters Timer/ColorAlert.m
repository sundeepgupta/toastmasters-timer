//
//  ColorAlert.m    
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-18.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "ColorAlert.h"
#import "ColorAlertVC.h"

@implementation ColorAlert

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
    self = [super init];
    if (self)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        ColorAlertVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"ColorAlertVC"];
        [self addSubview:vc.view];
        
        [self performSelector:@selector(dismissAfterDelay) withObject:nil afterDelay:3];
    }
    return self;
}

- (void)dismissAfterDelay
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

@end
