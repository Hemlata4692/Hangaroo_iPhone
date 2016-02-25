//
//  UITextField+Validations.h
//  WheelerButler
//
//  Created by Ashish A. Solanki on 16/01/15.
//
//

#import <UIKit/UIKit.h>

@interface UITextField (Validations)

- (BOOL)isEmpty;
- (BOOL)isValidEmail;
- (void)setPlaceholderFontSize : (UITextField *)textfield string:(NSString *)string;
@end
