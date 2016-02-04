//
//  CoolNavi.m
//  CoolNaviDemo
//
//  Created by ian on 15/1/19.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import "CoolNavi.h"
#import "SettingViewController.h"

@interface CoolNavi()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGPoint prePoint;


@end


@implementation CoolNavi
@synthesize facebookButton,twitterButton,instaButton,settings;

- (id)initWithFrame:(CGRect)frame backGroudImage:(NSString *)backImageName headerImageURL:(NSString *)headerImageURL title:(NSString *)title facebookBtn:(NSString *)facebookBtn instagramBtn:(NSString *)instagramBtn twitterBtn:(NSString *)twitterBtn settingsBtn:(NSString *)settingsBtn
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -0.5*frame.size.height, frame.size.width, frame.size.height*1.5)];
        _backImageView.backgroundColor=[UIColor blackColor];
        //_backImageView.image = [UIImage imageNamed:backImageName];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -0.5*frame.size.height, frame.size.width, frame.size.height*1.5)];
        
        __weak UIImageView *weakRef = _headerImageView;
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:headerImageURL]
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:60];
        
        [_headerImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"placeholder.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakRef.contentMode = UIViewContentModeScaleAspectFill;
            weakRef.clipsToBounds = YES;
            weakRef.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
       
        
        _headerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_headerImageView addGestureRecognizer:tap];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, frame.size.height-50, frame.size.width-100, 40)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
        _titleLabel.text = title;
        
        settings = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-50, 20, 40, 40)];
        [settings setImage:[UIImage imageNamed:settingsBtn] forState:UIControlStateNormal];
       
        
        facebookButton = [[UIButton alloc] initWithFrame:CGRectMake(20, frame.size.height-110, 30, 30)];
        [facebookButton setImage:[UIImage imageNamed:facebookBtn] forState:UIControlStateNormal];
   
        
        twitterButton = [[UIButton alloc] initWithFrame:CGRectMake(20, frame.size.height-80, 30, 30)];
        [twitterButton setImage:[UIImage imageNamed:twitterBtn] forState:UIControlStateNormal];
    
        
        instaButton = [[UIButton alloc] initWithFrame:CGRectMake(20, frame.size.height-50, 30, 30)];
        [instaButton setImage:[UIImage imageNamed:instagramBtn] forState:UIControlStateNormal];
       
        _titleLabel.textColor = [UIColor whiteColor];
        
        
        [self addSubview:_backImageView];
        [self addSubview:_headerImageView];
        [self addSubview:_titleLabel];
        [self addSubview:facebookButton];
        [self addSubview:twitterButton];
        [self addSubview:instaButton];
        [self addSubview:settings];
        
        self.clipsToBounds = YES;
        
    }
    return self;
    
}



-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:Nil];
    self.scrollView.contentInset = UIEdgeInsetsMake(self.frame.size.height, 0 ,0 , 0);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
}

-(void)deallocHeaderView {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:Nil];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0 ,0 , 0);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGPoint newOffset = [change[@"new"] CGPointValue];
    [self updateSubViewsWithScrollOffset:newOffset];
}

-(void)updateSubViewsWithScrollOffset:(CGPoint)newOffset
{
    
    float destinaOffset = -64;
    float startChangeOffset = -self.scrollView.contentInset.top;
    newOffset = CGPointMake(newOffset.x, newOffset.y<startChangeOffset?startChangeOffset:(newOffset.y>destinaOffset?destinaOffset:newOffset.y));
    
    float titleDestinateOffset = self.frame.size.height-40;
    float newY = -newOffset.y-self.scrollView.contentInset.top;
    float d = destinaOffset-startChangeOffset;
    float alpha = 1-(newOffset.y-startChangeOffset)/d;
    float imageReduce = 1;
    
    self.titleLabel.alpha = alpha;
    self.facebookButton.alpha = alpha;
    self.twitterButton.alpha = alpha;
    self.instaButton.alpha = alpha;
    // self.settings.alpha = alpha;
    self.frame = CGRectMake(0, newY, self.frame.size.width, self.frame.size.height);
    self.backImageView.frame = CGRectMake(0, -0.5*self.frame.size.height+(1.5*self.frame.size.height-64)*(1-alpha), self.backImageView.frame.size.width, self.backImageView.frame.size.height);
    
    CGAffineTransform t = CGAffineTransformMakeTranslation(0,(titleDestinateOffset-0.10*self.frame.size.height)*(1-alpha));
    settings.transform = CGAffineTransformScale(t,
                                                 imageReduce, imageReduce);
    
    // self.titleLabel.frame = CGRectMake(50, 0.6*self.frame.size.height+(titleDestinateOffset-0.45*self.frame.size.height)*(1-alpha), self.frame.size.width, self.frame.size.height*0.2);
}

- (void)tapAction:(id)sender
{
    if (self.imgActionBlock) {
        self.imgActionBlock();
    }
}



@end
