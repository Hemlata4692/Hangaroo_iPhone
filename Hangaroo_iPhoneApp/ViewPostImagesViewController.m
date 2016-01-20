//
//  ViewPoatImagesViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 18/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ViewPostImagesViewController.h"
#import "CategorySliderView.h"
#import "PhotoListingModel.h"
#import <UIImageView+AFNetworking.h>

#define CategorySliderHeight 100

@interface ViewPostImagesViewController ()<UIGestureRecognizerDelegate>
{
    NSMutableArray *photoListingDataArray;
    UIImageView* lastImageView;
    int lastIndex,currentIndex;
    UIButton *button;
    CategorySliderView* imageSliderView;
    NSMutableArray* imageArray,*labelArray;
    int indexValue,value;
}
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) CategorySliderView *sliderView;
@end

@implementation ViewPostImagesViewController
@synthesize postID,selectedIndex;
@synthesize photoImageView,sliderView,likeCount;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    photoListingDataArray=[[NSMutableArray alloc]init];
    imageArray=[[NSMutableArray alloc]init];
    labelArray=[[NSMutableArray alloc]init];

   
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getPhotoListing) withObject:nil afterDelay:0.1];
    
        UISwipeGestureRecognizer *swipeImageLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeImagesLeft:)];
        swipeImageLeft.delegate=self;
        UISwipeGestureRecognizer *swipeImageRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeImagesRight:)];
        swipeImageRight.delegate=self;
   //  Setting the swipe direction.
        [swipeImageLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [swipeImageRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
        [photoImageView addGestureRecognizer:swipeImageLeft];
        [photoImageView addGestureRecognizer:swipeImageRight];
    
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)statusHide
{
    [UIView animateWithDuration:0.1 animations:^() {
        [self setNeedsStatusBarAppearanceUpdate];
    }completion:^(BOOL finished){}];
}

#pragma mark - end
-(void)setImageScroller
{
    currentIndex = 0;
    value=0;
    imageSliderView = [CategorySliderView alloc];
   
    indexValue =selectedIndex;
    for(int i=0;i<photoListingDataArray.count;i++)
    {
        [imageArray addObject:[self imagewithImage:[[photoListingDataArray objectAtIndex:i]userImageUrl]]];
        [labelArray addObject:[self labelWithText:[[photoListingDataArray objectAtIndex:i]uploadedImageTime]]];
    }
    if (indexValue == 0) {
        currentIndex = indexValue;
    }
    else{
        currentIndex = indexValue -1;
    }
    
    self.sliderView = [imageSliderView initWithSliderHeight:CategorySliderHeight index:(int)indexValue andCategoryViews:imageArray andLabelView:labelArray categorySelectionBlock:^(UIImageView *imageview, NSInteger categoryIndex)
                       {
                           if (lastImageView != nil) {
                               lastImageView.frame=CGRectMake(imageview.frame.origin.x-((categoryIndex - lastIndex)*70), 5, 50, 50);
                               lastImageView.layer.cornerRadius=25.0f;
                               lastImageView.clipsToBounds=YES;
                           }
                           
                           
                           imageview.frame=CGRectMake(imageview.frame.origin.x, imageview.frame.origin.y, 60, 60);
                           imageview.layer.cornerRadius=30.0f;
                           imageview.clipsToBounds=YES;
                           
                           lastImageView = imageview;
                           lastIndex = (int)categoryIndex;
                           currentIndex = (int)categoryIndex;
                           NSLog(@" cateogry selected at index %ld", (long)categoryIndex);
                       }];
    
    
    self.sliderView.backgroundColor=[UIColor yellowColor];
    [self.sliderView setY:100];
    [self.sliderView moveY:20 duration:0.5 complation:nil];
    [self.view addSubview:self.sliderView];

}
- (UIImageView *)imagewithImage:(NSString *)imageUrl {
    
    UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    if (value==indexValue-1) {
        userImageView.frame=CGRectMake(0, 0, 60, 60);
        userImageView.layer.cornerRadius=30.0f;
        userImageView.clipsToBounds=YES;
    }
    else
    {
        userImageView.layer.cornerRadius=25;
        userImageView.clipsToBounds=YES;
    }
    __weak UIImageView *weakRef = userImageView;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [userImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];

    
    value++;
    return userImageView;
}


- (UILabel *)labelWithText:(NSString *)text {
    float w = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, w, 20)];
    [lbl setFont:[UIFont systemFontOfSize:15]];
    [lbl setText:text];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    return lbl;
}

#pragma mark - Webservice
-(void)getPhotoListing
{
    [[WebService sharedManager] photoListing:postID success: ^(id dataArray) {
        
        [myDelegate StopIndicator];
        photoListingDataArray=[dataArray mutableCopy];
        [self setImageScroller];
        
    }
                                     failure:^(NSError *error)
     {
         
     }] ;

}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)closeButtonAction:(id)sender
{
      [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dislikePhotoButtonAction:(id)sender {
}
- (IBAction)likePhotoButtonAction:(id)sender {
}
#pragma mark - end

@end
