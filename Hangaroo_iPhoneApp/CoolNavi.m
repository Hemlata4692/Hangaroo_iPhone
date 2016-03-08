//
//  CoolNavi.m
//  CoolNaviDemo
//
//  Created by ian on 15/1/19.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import "CoolNavi.h"
#import "SettingViewController.h"

@interface CoolNavi(){
    CIContext *context;
    CIImage *inputImage;
    CIFilter *filter;
    CIImage *result;
    CGImageRef cgImage;
    UIImage *returnImage;
    float mysize;
    NSString *interestString;
}

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGPoint prePoint;
@property (nonatomic, strong) UIImageView *locationImage;
@property (nonatomic, strong) UILabel *interestTitleLabel;
@property (nonatomic, strong) UILabel *seperatorLabel;
@property (nonatomic, strong) UIView *locationView;
@property (nonatomic, strong) UIView *interestView;
@end


@implementation CoolNavi
@synthesize facebookButton,twitterButton,instaButton,settings,friendsListButton;
@synthesize interestLabel,interestTitleLabel,locationImage,locationLabel,interestView,locationView,seperatorLabel;

- (id)initWithFrame:(CGRect)frame backGroudImage:(NSString *)backImageName headerImageURL:(NSString *)headerImageURL title:(NSString *)title facebookBtn:(NSString *)facebookBtn instagramBtn:(NSString *)instagramBtn twitterBtn:(NSString *)twitterBtn settingsBtn:(NSString *)settingsBtn interestLabelFrame:(CGRect)interestLabelFrame interestText:(NSString *)interestText
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 300)];
        mysize = frame.size.height;
        _backImageView.backgroundColor=[UIColor whiteColor];
        
        _backImageView.contentMode = UIViewContentModeScaleAspectFit;
        __weak UIImageView *weakRef1 = _backImageView;
        __weak id selfWeak = self;
        NSURLRequest *imageRequest1 = [NSURLRequest requestWithURL:[NSURL URLWithString:backImageName]
                                                       cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                   timeoutInterval:60];
        [_backImageView setImageWithURLRequest:imageRequest1 placeholderImage:[UIImage imageNamed:@""] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakRef1.contentMode = UIViewContentModeScaleAspectFill;
            weakRef1.clipsToBounds = YES;
            weakRef1.image = image;
            weakRef1.image=[selfWeak blur: weakRef1.image];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
        
        
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 300)];
        _headerImageView.contentMode=UIViewContentModeScaleAspectFit;
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
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, _headerImageView.frame.size.height-50, frame.size.width-100, 40)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
        _titleLabel.text = title;
        
        settings = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-50, 20, 40, 40)];
        [settings setImage:[UIImage imageNamed:settingsBtn] forState:UIControlStateNormal];
        
        
        facebookButton = [[UIButton alloc] initWithFrame:CGRectMake(20, _headerImageView.frame.size.height-120, 35, 35)];
        [facebookButton setImage:[UIImage imageNamed:facebookBtn] forState:UIControlStateNormal];
        
        twitterButton = [[UIButton alloc] initWithFrame:CGRectMake(20, _headerImageView.frame.size.height-85, 35, 35)];
        [twitterButton setImage:[UIImage imageNamed:twitterBtn] forState:UIControlStateNormal];
        
        instaButton = [[UIButton alloc] initWithFrame:CGRectMake(20, _headerImageView.frame.size.height-50, 35, 35)];
        [instaButton setImage:[UIImage imageNamed:instagramBtn] forState:UIControlStateNormal];

        _titleLabel.textColor = [UIColor whiteColor];
        
        locationView = [[UIView alloc] initWithFrame:CGRectMake(0, _headerImageView.frame.size.height, frame.size.width, 45)];
        locationView.backgroundColor = [UIColor whiteColor];
        [self addSubview:locationView];
        
        interestView = [[UIView alloc] initWithFrame:CGRectMake(0, _headerImageView.frame.size.height+45, frame.size.width, interestLabelFrame.size.height+10)];
        interestView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:interestView];
        seperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _headerImageView.frame.size.height+locationView.frame.size.height-2, frame.size.width, 1)];
        seperatorLabel.backgroundColor = [UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0];
        
        locationImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, locationView.frame.origin.y+12, 22, 22)];
        locationImage.image=[UIImage imageNamed:@"location_profile.png"];
        
        locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, locationView.frame.origin.y, 145, 45)];
        locationLabel.textAlignment = NSTextAlignmentLeft;
        locationLabel.textColor=[UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0];
        locationLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12.0];
        
        friendsListButton = [[UIButton alloc] initWithFrame:CGRectMake(locationView.frame.size.width-100, locationView.frame.origin.y, 85, 45)];
        friendsListButton.titleLabel.textColor=[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0];
        friendsListButton.titleLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:12.0];
        
        interestTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, interestView.frame.origin.y+5, 55, 19)];
        interestTitleLabel.textAlignment = NSTextAlignmentLeft;
        interestTitleLabel.text=@"Interest:";
        interestTitleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14.0];
        
        interestLabel = [[UILabel alloc] initWithFrame:CGRectMake(interestTitleLabel.frame.size.width+20, interestView.frame.origin.y, frame.size.width-10, interestLabelFrame.size.height)];
        interestLabel.textAlignment = NSTextAlignmentLeft;
        interestLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0];

        [self addSubview:_backImageView];
        [self addSubview:_headerImageView];
        [self addSubview:_titleLabel];
        [self addSubview:facebookButton];
        [self addSubview:twitterButton];
        [self addSubview:instaButton];
        [self addSubview:settings];
        [self addSubview:seperatorLabel];
        [self addSubview:locationLabel];
        [self addSubview:locationImage];
        [self addSubview:friendsListButton];
        [self addSubview:interestTitleLabel];
        [self addSubview:interestLabel];
        
        if ([interestText isEqualToString:@""]) {
            interestTitleLabel.hidden=YES;
            interestLabel.hidden=YES;
            interestView.hidden=YES;
        }
        else
        {
            interestTitleLabel.hidden=NO;
            interestLabel.hidden=NO;
            interestView.hidden=NO;
        }
        self.clipsToBounds = YES;
    }
    interestString=interestText;
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
    float destinaOffset = 300  - mysize -64;
    // float destinaOffset = -64;
    float startChangeOffset = -self.scrollView.contentInset.top;
    newOffset = CGPointMake(newOffset.x, newOffset.y<startChangeOffset?startChangeOffset:(newOffset.y>destinaOffset?destinaOffset:newOffset.y));
    
    float titleDestinateOffset = self.frame.size.height-40;
    float newY = -newOffset.y-self.scrollView.contentInset.top;
    float d = destinaOffset-startChangeOffset;
    float alpha = 1-(newOffset.y-startChangeOffset)/d;
    float imageReduce = 1;
    self.facebookButton.alpha = alpha;
    self.twitterButton.alpha = alpha;
    self.instaButton.alpha = alpha;
    self.frame = CGRectMake(0, newY, self.frame.size.width, self.frame.size.height);
    CGAffineTransform t;
    if ([interestString isEqualToString:@""]) {
        t = CGAffineTransformMakeTranslation(0,(titleDestinateOffset-0.23*self.frame.size.height)*(1-alpha));
    }
    else
    {
        t = CGAffineTransformMakeTranslation(0,(titleDestinateOffset-0.34*self.frame.size.height)*(1-alpha));
    }
    settings.transform = CGAffineTransformScale(t,
                                                imageReduce, imageReduce);
    
    self.headerImageView.alpha=alpha;
}


- (UIImage*) blur:(UIImage*)theImage
{
    // create our blurred image
    context = [CIContext contextWithOptions:nil];
    inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:5.0f] forKey:@"inputRadius"];
    result = [filter valueForKey:kCIOutputImageKey];
    cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    returnImage = [UIImage imageWithCGImage:cgImage];
    return returnImage;
 
}

- (void)tapAction:(id)sender
{
    if (self.imgActionBlock) {
        self.imgActionBlock();
    }
}



@end
