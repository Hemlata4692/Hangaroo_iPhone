//
//  UIView+RoundedCorner.m
//  WheelerButler
//
//  Created by Ashish A. Solanki on 24/01/15.
//
//

#import "UIView+RoundedCorner.h"

@implementation UIView (RoundedCorner)



- (void)setCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;

}

- (void)setTextBorder:(UILabel *)textLabel color:(UIColor *)color
{
    textLabel.shadowColor = color;
    textLabel.shadowOffset = CGSizeMake(0.0, 1.0);

}

- (void)setViewBorder: (UIView *)view  color:(UIColor *)color {
   
    view.layer.borderColor =color.CGColor;
    view.layer.borderWidth = 1.5f;
}

-(void)setBottomBorder: (UIView *)view color:(UIColor *)color
{
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0, view.frame.size.height-1, view.frame.size.width, 2.0f);
    
    bottomBorder.backgroundColor = color.CGColor;
    
    [view.layer addSublayer:bottomBorder];
}
@end
