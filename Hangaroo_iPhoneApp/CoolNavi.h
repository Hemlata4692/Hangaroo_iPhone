//
//  CoolNavi.h
//  CoolNaviDemo
//
//  Created by ian on 15/1/19.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoolNavi : UIView
@property (nonatomic, strong) UIButton *facebookButton;
@property (nonatomic, strong) UIButton *instaButton;
@property (nonatomic, strong) UIButton *twitterButton;
@property (nonatomic, strong) UIButton *friendsListButton;
@property (nonatomic, strong) UIButton *settings;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *interestLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
// image action
@property (nonatomic, copy) void(^imgActionBlock)();

- (id)initWithFrame:(CGRect)frame backGroudImage:(NSString *)backImageName headerImageURL:(NSString *)headerImageURL title:(NSString *)title facebookBtn:(NSString *)facebookBtn instagramBtn:(NSString *)instagramBtn twitterBtn:(NSString *)twitterBtn settingsBtn:(NSString *)settingsBtn interestLabelFrame:(CGRect)interestLabelFrame interestText:(NSString *)interestText;

-(void)updateSubViewsWithScrollOffset:(CGPoint)newOffset;
-(void)deallocHeaderView;
@end
