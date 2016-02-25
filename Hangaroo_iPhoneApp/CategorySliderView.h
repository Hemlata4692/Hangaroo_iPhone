//
//  CategorySliderView.h
//  CategorySliderView
//
//  Created by Cem Olcay on 04/07/14.
//  Copyright (c) 2014 questamobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SliderDirection) {
    SliderDirectionHorizontal,
    SliderDirectionVertical,
};

typedef void(^categorySelected)(UIImageView *imageView, NSInteger categoryIndex);

@interface CategorySliderView : UIView <UIScrollViewDelegate>

@property (copy) categorySelected categorySelectedBlock;

@property (nonatomic, strong) UIImage *backgroundImage;
@property (assign) SliderDirection sliderDirection;
@property (assign) NSInteger categoryViewPadding; //default 20
@property (assign) BOOL shouldAutoScrollSlider; // default YES auto scrolls closest category after scroll drag ends
@property (assign) BOOL shouldAutoSelectScrolledCategory; // default YES auto selects the slided category

- (instancetype)initWithFrame:(CGRect)frame andSliderDirection:(SliderDirection)direction;
- (instancetype)initWithFrame:(CGRect)frame index:(int)indexValue andCategoryViews:(NSArray *)categoryViews andLabelView:(NSArray *)andLabelView sliderDirection:(SliderDirection)direction categorySelectionBlock:(categorySelected)block;
- (instancetype)initWithSliderHeight:(CGFloat)height index:(int)indexValue andCategoryViews:(NSArray *)categoryViews andLabelView:(NSArray *)andLabel categorySelectionBlock:(categorySelected)block;
- (instancetype)initWithSliderWidth:(CGFloat)width andCategoryViews:(NSArray *)categoryViews categorySelectionBlock:(categorySelected)block;

- (void)addCategotyView:(UIView *)view;

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;

- (void)moveX:(CGFloat)x duration:(NSTimeInterval)duration complation:(void(^)(void))complation;
- (void)moveY:(CGFloat)y duration:(NSTimeInterval)duration complation:(void(^)(void))complation;

-(void)slideScrollView;

- (void )customSlide:(int)index categorySelection:(categorySelected)block;
@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
