//
//  CategorySliderView.m
//  CategorySliderView
//
//  Created by Cem Olcay on 04/07/14.
//  Copyright (c) 2014 questamobile. All rights reserved.
//

#import "CategorySliderView.h"

#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height

@interface CategorySliderView ()
{
    int arrayCount;
    int countvalue;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *categoryViews;
@property (nonatomic, strong) NSMutableArray *andLabelView;
@end

@implementation CategorySliderView

- (instancetype)initWithFrame:(CGRect)frame andSliderDirection:(SliderDirection)direction {
    if ((self = [self initWithFrame:frame index:(int)5 andCategoryViews:nil andLabelView:nil sliderDirection:direction categorySelectionBlock:nil])) {
    
    }
    return self;
}


- (instancetype)initWithSliderHeight:(CGFloat)height index:(int)indexValue andCategoryViews:(NSMutableArray *)categoryViews andLabelView:(NSMutableArray *)andLabelView categorySelectionBlock:(categorySelected)block
{
      arrayCount=(int)categoryViews.count;
    if ((self = [self initWithFrame:CGRectMake(0, 0, ScreenWidth, height) index:(int)indexValue andCategoryViews:categoryViews andLabelView:andLabelView sliderDirection:SliderDirectionHorizontal categorySelectionBlock:block])) {
        
    }
    return self;
}

- (instancetype)initWithSliderWidth:(CGFloat)width andCategoryViews:(NSMutableArray *)categoryViews categorySelectionBlock:(categorySelected)block {
//    if ((self = [self initWithFrame:CGRectMake(0, 0, width, ScreenHeight) andCategoryViews:categoryViews sliderDirection:SliderDirectionVertical categorySelectionBlock:block])) {
//        
//    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame index:(int)indexValue andCategoryViews:(NSMutableArray *)categoryViews andLabelView:(NSMutableArray *)andLabelView sliderDirection:(SliderDirection)direction categorySelectionBlock:(categorySelected)block {
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
        countvalue = -1;
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self.scrollView setDelegate:self];
        self.scrollView.scrollEnabled=NO;
//        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        [self.scrollView setBackgroundColor:[UIColor clearColor]];
        
        self.sliderDirection = direction;
        self.categorySelectedBlock = block;
        self.categoryViews = [[NSMutableArray alloc] init];
        self.andLabelView = [[NSMutableArray alloc] init];
        self.categoryViewPadding = 20;
      
        
        for (UIImageView *v in categoryViews) {
            [self addCategotyView:v];
        }
        for (UILabel *l in andLabelView) {
            [self addCategotyLabel:l];
        }
        [self.scrollView setContentOffset:CGPointMake( self.scrollView.contentOffset.x+(indexValue*55), self.scrollView.contentOffset.y) animated:YES];
    }
    return self;
}

-(void)slideScrollView{
    
    [self.scrollView setContentOffset:CGPointMake( self.scrollView.contentOffset.x+70, self.scrollView.contentOffset.y)
                        animated:YES];

}

- (void )customSlide:(int)index categorySelection:(categorySelected)block
{
    [self.scrollView setContentOffset:CGPointMake( self.scrollView.contentOffset.x+70, self.scrollView.contentOffset.y) animated:YES];
    if (countvalue == -1) {
        countvalue = index;
    }
     countvalue++;
    UIImageView *v = [self.categoryViews objectAtIndex:countvalue];
   
          self.categorySelectedBlock (v, countvalue);
   
}

#pragma mark - Slider

- (void)addCategotyView:(UIImageView *)view {
    
    if (self.sliderDirection == SliderDirectionHorizontal) {
        float w = 0;
        if (self.categoryViews.count > 0) {
            UIImageView *lastView = [self.categoryViews lastObject];
            w = lastView.frame.origin.x+lastView.frame.size.width+self.categoryViewPadding;
        }
        else {
            w = [self width]/2 - view.frame.size.width/2;
        }
        
        UILabel *seplabel;
        if (self.categoryViews.count< arrayCount-1) {
            seplabel=[[UILabel alloc]initWithFrame:CGRectMake(w+1, view.frame.size.height/2+8, 120, 1)];
            seplabel.backgroundColor=[UIColor whiteColor];
            [self.scrollView addSubview:seplabel];
        }
        
        
        [self.scrollView addSubview:view];
        
        [self.scrollView bringSubviewToFront:view];
        [view setFrame:CGRectMake(w, 5, view.frame.size.width, view.frame.size.height)];
        [seplabel setFrame:CGRectMake(w+view.frame.size.width, view.frame.size.height/2+10, 20,1)];

        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryViewTapped:)];
        [tap setNumberOfTapsRequired:1];
        [view setUserInteractionEnabled:YES];
        [view addGestureRecognizer:tap];
        [view setTag:self.categoryViews.count];
        
        w += [self width]/2 + view.frame.size.width/2;
        [self.scrollView setContentSize:CGSizeMake(w, self.scrollView.contentSize.height)];
        [self.categoryViews addObject:view];
       
    }
}


- (void)addCategotyLabel:(UILabel *)view {
    
    if (self.sliderDirection == SliderDirectionHorizontal) {
        float w = 0;
        if (self.andLabelView.count > 0) {
            UILabel *lastView = [self.andLabelView lastObject];
            w = lastView.frame.origin.x+lastView.frame.size.width+self.categoryViewPadding;
        }
        else {
            w = [self width]/2 - view.frame.size.width/2;
        }
        
        [self.scrollView addSubview:view];
        [view setFrame:CGRectMake(w+10, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryViewTapped:)];
        [tap setNumberOfTapsRequired:1];
        [view setUserInteractionEnabled:YES];
        [view addGestureRecognizer:tap];
        [view setTag:self.andLabelView.count];
        
        w += [self width]/2 + view.frame.size.width/2;
        [self.scrollView setContentSize:CGSizeMake(w, self.scrollView.contentSize.height)];
        [self.andLabelView addObject:view];
    }
}



- (void)setBackgroundImage:(UIImage *)image {
    _backgroundImage = image;
    
    UIImageView *imageView = (UIImageView *)[self viewWithTag:100];
    if (imageView) {
        [imageView setImage:image];
    }
    else {
        imageView = [[UIImageView alloc] initWithFrame:self.frame];
        [imageView setImage:image];
        [imageView setTag:100];
        [self addSubview:imageView];
        
        [self bringSubviewToFront:self.scrollView];
    }
}

- (void)categoryViewTapped:(UITapGestureRecognizer *)tap {
    [self slideItemAtIndex:tap.view.tag animated:YES];
    
    if (self.categorySelectedBlock && !self.shouldAutoSelectScrolledCategory)
        self.categorySelectedBlock ([self.categoryViews objectAtIndex:tap.view.tag], tap.view.tag);
}


#pragma mark - UIView

- (void)setX:(CGFloat)x {
    [self setFrame:CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
}

- (void)setY:(CGFloat)y {
    [self setFrame:CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height)];
}

- (void)moveX:(CGFloat)x duration:(NSTimeInterval)duration complation:(void(^)(void))complation {
    [UIView animateWithDuration:duration animations:^{
        [self setX:x];
    } completion:^(BOOL finished) {
        if (complation)
            complation();
    }];
}

- (void)moveY:(CGFloat)y duration:(NSTimeInterval)duration complation:(void(^)(void))complation {
    [UIView animateWithDuration:duration animations:^{
        [self setY:y];
    } completion:^(BOOL finished) {
        if (complation)
            complation();
    }];
}


- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)contentWidth {
    return self.scrollView.contentSize.width;
}

- (CGFloat)contentHeight {
    return self.scrollView.contentSize.height;
}


#pragma mark - Sliding
- (void)slideItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    UIImageView *v = [self.categoryViews objectAtIndex:index];
    
    if (self.shouldAutoSelectScrolledCategory)
        if (self.categorySelectedBlock)
            self.categorySelectedBlock (v, index);
}


- (void)slideItemAtIndex1:(NSInteger)index animated:(BOOL)animated {
    UIImageView *v = [self.categoryViews objectAtIndex:index];
    
    if (self.sliderDirection == SliderDirectionHorizontal)
        [self.scrollView setContentOffset:CGPointMake( self.scrollView.contentOffset.x+70, self.scrollView.contentOffset.y)
                                 animated:YES];
    else if (self.sliderDirection == SliderDirectionVertical)
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, v.center.y - [self height]/2) animated:animated];
    
    if (self.shouldAutoSelectScrolledCategory)
        if (self.categorySelectedBlock)
            self.categorySelectedBlock (v, index);
}

- (void)stopScroll {
    CGPoint offset = self.scrollView.contentOffset;
    [self.scrollView setContentOffset:offset animated:NO];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    countvalue=-1;
    if (!self.shouldAutoScrollSlider)
        return;
    
    if (self.sliderDirection == SliderDirectionHorizontal) {
        if (velocity.x == 0)
        {
            NSLog(@"---------%f---------",scrollView.contentOffset.x);
            float x = scrollView.contentOffset.x + [self width]/2;
            float distance = 1000;
            int closest = -1;
            
            for (int i = 0; i < self.categoryViews.count; i++)
            {
                UIView *view = (UIView*)[self.categoryViews objectAtIndex:i];
                
                if (fabs(x - view.center.x) < distance)
                {
                    distance = fabs(x-view.center.x);
                    closest = i;
                }
            }
            
            [self slideItemAtIndex:closest animated:YES];
        }
    }
    else if (self.sliderDirection == SliderDirectionVertical) {
        if (velocity.x == 0)
        {
            float y = scrollView.contentOffset.y + [self height]/2;
            float distance = 1000;
            int closest = -1;
            
            for (int i = 0; i < self.categoryViews.count; i++)
            {
                UIView *view = (UIView*)[self.categoryViews objectAtIndex:i];
                
                if (fabs(y - view.center.y) < distance)
                {
                    distance = fabs(y-view.center.y);
                    closest = i;
                }
            }
            
            [self slideItemAtIndex:closest animated:YES];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!self.shouldAutoScrollSlider)
        return;
   
    if (self.sliderDirection == SliderDirectionHorizontal) {
        float x = scrollView.contentOffset.x + [self width]/2;
        float distance = 1000;
        int closest = -1;
        
        for (int i = 0; i < self.categoryViews.count; i++)
        {
            UIView *view = (UIView*)[self.categoryViews objectAtIndex:i];
            
            if (fabs(x - view.center.x) < distance)
            {
                distance = fabs(x-view.center.x);
                closest = i;
            }
        }
        
        [self slideItemAtIndex:closest animated:YES];
    }
    else if (self.sliderDirection == SliderDirectionVertical) {
        float y = scrollView.contentOffset.y + [self height]/2;
        float distance = 1000;
        int closest = -1;
        
        for (int i = 0; i < self.categoryViews.count; i++)
        {
            UIView *view = (UIView*)[self.categoryViews objectAtIndex:i];
            
            if (fabs(y - view.center.y) < distance)
            {
                distance = fabs(y-view.center.y);
                closest = i;
            }
        }
        
        [self slideItemAtIndex:closest animated:YES];
    }
}



@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
