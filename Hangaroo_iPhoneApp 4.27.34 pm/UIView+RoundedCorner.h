//
//  UIView+RoundedCorner.h
//  WheelerButler
//
//  Created by Ashish A. Solanki on 24/01/15.
//
//

#import <UIKit/UIKit.h>

@interface UIView (RoundedCorner)


- (void)setCornerRadius:(CGFloat)radius;

- (void)setTextBorder:(UILabel *)textLabel color:(UIColor *)color;

- (void)setViewBorder: (UIView *)view color:(UIColor *)color;

-(void)setBottomBorder: (UIView *)view color:(UIColor *)color;
@end
