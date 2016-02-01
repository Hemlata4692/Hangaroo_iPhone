//
//  CoolNavi.h
//  CoolNaviDemo
//
//  Created by ian on 15/1/19.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoolNavi : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
// image action
@property (nonatomic, copy) void(^imgActionBlock)();

- (id)initWithFrame:(CGRect)frame backGroudImage:(NSString *)backImageName headerImageURL:(NSString *)headerImageURL title:(NSString *)title subTitle:(NSString *)subTitle buttonTitle:(NSString *)buttonTitle;

-(void)updateSubViewsWithScrollOffset:(CGPoint)newOffset;

@end