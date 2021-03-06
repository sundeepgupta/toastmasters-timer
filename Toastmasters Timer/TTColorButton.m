#import "TTColorButton.h"

@interface TTColorButton ()
@end

@implementation TTColorButton

- (void)emphasize {
    [self bold];
    [self glow];
}
- (void)bold {
    UIFont *font = self.titleLabel.font;
    CGFloat fontSize = font.pointSize ;
    UIFont *newFont = [UIFont boldSystemFontOfSize:fontSize];
    self.titleLabel.font = newFont;
}
- (void)glow {
    UIColor *color = self.titleLabel.textColor;
    self.titleLabel.layer.shadowColor = [color CGColor];
    self.titleLabel.layer.shadowRadius = 4.0f;
    self.titleLabel.layer.shadowOpacity = .9;
    self.titleLabel.layer.shadowOffset = CGSizeZero;
    self.titleLabel.layer.masksToBounds = NO;
}


- (void)deEmphasize {
    [self unBold];
    [self unGlow];
}
- (void)unBold {
    UIFont *font = self.titleLabel.font;
    CGFloat fontSize = font.pointSize ;
    UIFont *newFont = [UIFont systemFontOfSize:fontSize];
    self.titleLabel.font = newFont;
}
- (void)unGlow {
    self.titleLabel.layer.shadowOpacity = 0;
}

@end
