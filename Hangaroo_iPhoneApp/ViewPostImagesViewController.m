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

#define CategorySliderHeight 120

@interface ViewPostImagesViewController ()<UIGestureRecognizerDelegate>
{
    NSMutableArray *photoListingDataArray;
    UIImageView* lastImageView;
    int lastIndex,currentIndex;
    UIButton *button;
    CategorySliderView* imageSliderView;
    NSMutableArray* imageArray,*labelArray;
    int indexValue,value;
    NSMutableArray *postImagesArray;
    int imageIndex;
}
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property(nonatomic,retain) NSString * likeDislikeString;
@property (nonatomic, strong) CategorySliderView *sliderView;
@end

@implementation ViewPostImagesViewController
@synthesize postID,selectedIndex;
@synthesize photoImageView,sliderView,likeCount,closeButton,likeDislikeString;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    photoListingDataArray=[[NSMutableArray alloc]init];
    imageArray=[[NSMutableArray alloc]init];
    labelArray=[[NSMutableArray alloc]init];
    postImagesArray=[[NSMutableArray alloc]init];
    photoImageView.userInteractionEnabled=YES;
    currentIndex = 0;
    value=0;
    imageIndex=selectedIndex;
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
#pragma mark - Swipe Images
-(void)swipeImages
{
    __weak UIImageView *weakRef = photoImageView;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[postImagesArray objectAtIndex:imageIndex]]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [photoImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@""] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFit;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    likeCount.text=[[photoListingDataArray objectAtIndex:imageIndex]likeCountData];
}


//Adding left animation to banner images
- (void)addLeftAnimationPresentToView:(UIView *)viewTobeAnimatedLeft
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.30;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [transition setValue:@"IntroSwipeIn" forKey:@"IntroAnimation"];
    transition.fillMode=kCAFillModeForwards;
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    [viewTobeAnimatedLeft.layer addAnimation:transition forKey:nil];
    
}
//Adding right animation to banner images
- (void)addRightAnimationPresentToView:(UIView *)viewTobeAnimatedRight
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.30;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [transition setValue:@"IntroSwipeIn" forKey:@"IntroAnimation"];
    transition.fillMode=kCAFillModeForwards;
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromLeft;
    [viewTobeAnimatedRight.layer addAnimation:transition forKey:nil];
}
//Swipe images in left direction
-(void) swipeImagesLeft:(UISwipeGestureRecognizer *)sender
{
    imageIndex++;
    if (imageIndex<postImagesArray.count)
    {
        __weak UIImageView *weakRef = photoImageView;
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[postImagesArray objectAtIndex:imageIndex]]
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:60];
        
        [photoImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@""] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakRef.contentMode = UIViewContentModeScaleAspectFit;
            weakRef.clipsToBounds = YES;
            weakRef.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
        [imageSliderView customSlide:currentIndex categorySelection:^(UIImageView *imageview, NSInteger categoryIndex)
         {
             if (lastImageView != nil) {
                 lastImageView.frame=CGRectMake(imageview.frame.origin.x-((categoryIndex - lastIndex)*70), 0, 50, 50);
                 lastImageView.layer.cornerRadius=25.0f;
                 lastImageView.clipsToBounds=YES;
             }
             
             
             imageview.frame=CGRectMake(imageview.frame.origin.x, imageview.frame.origin.y, 60, 60);
             imageview.layer.cornerRadius=30.0f;
             imageview.clipsToBounds=YES;
             
             lastImageView = imageview;
             lastIndex = (int)categoryIndex;
             NSLog(@" cateogry selected at index %ld", (long)categoryIndex);
             currentIndex++;
         }];

        UIImageView *moveImageView = photoImageView;
        [self addLeftAnimationPresentToView:moveImageView];
        likeCount.text=[[photoListingDataArray objectAtIndex:imageIndex]likeCountData];
        
    }
    else
    {
        imageIndex--;
    }
}
//Swipe images in right direction
-(void) swipeImagesRight:(UISwipeGestureRecognizer *)sender
{
    imageIndex--;
    if (imageIndex<postImagesArray.count)
    {
        __weak UIImageView *weakRef = photoImageView;
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[postImagesArray objectAtIndex:imageIndex]]
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:60];
        
        [photoImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@""] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakRef.contentMode = UIViewContentModeScaleAspectFit;
            weakRef.clipsToBounds = YES;
            weakRef.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
        [imageSliderView customSlide:currentIndex categorySelection:^(UIImageView *imageview, NSInteger categoryIndex)
         {
             if (lastImageView != nil) {
                 lastImageView.frame=CGRectMake(imageview.frame.origin.x-((categoryIndex - lastIndex)*70), 0, 60, 60);
                 lastImageView.layer.cornerRadius=30.0f;
                 lastImageView.clipsToBounds=YES;
             }
             
             
             imageview.frame=CGRectMake(imageview.frame.origin.x, imageview.frame.origin.y, 70, 70);
             imageview.layer.cornerRadius=35.0f;
             imageview.clipsToBounds=YES;
             
             lastImageView = imageview;
             lastIndex = (int)categoryIndex;
             NSLog(@" cateogry selected at index %ld", (long)categoryIndex);
             currentIndex++;
         }];

        UIImageView *moveImageView = photoImageView;
        [self addRightAnimationPresentToView:moveImageView];
        likeCount.text=[[photoListingDataArray objectAtIndex:imageIndex]likeCountData];
        
    }
    
    else
    {
        imageIndex++;
        
    }
}

#pragma mark - end



-(void)setImageScroller
{
    
    imageSliderView = [CategorySliderView alloc];
   
   // indexValue =selectedIndex;
    for(int i=0;i<photoListingDataArray.count;i++)
    {
        [imageArray addObject:[self imagewithImage:[[photoListingDataArray objectAtIndex:i]userImageUrl]]];
        [labelArray addObject:[self labelWithText:[[photoListingDataArray objectAtIndex:i]uploadedImageTime]]];
    }
    if (selectedIndex == 0) {
        currentIndex = selectedIndex;
    }
    else{
        currentIndex = selectedIndex -1;
    }
    
    self.sliderView = [imageSliderView initWithSliderHeight:CategorySliderHeight index:(int)indexValue andCategoryViews:imageArray andLabelView:labelArray categorySelectionBlock:^(UIImageView *imageview, NSInteger categoryIndex)
                       {
                           if (lastImageView != nil) {
                               lastImageView.frame=CGRectMake(imageview.frame.origin.x-((categoryIndex - lastIndex)*70), 5, 60, 60);
                               lastImageView.layer.cornerRadius=30.0f;
                               lastImageView.clipsToBounds=YES;
                           }
                           
                           
                           imageview.frame=CGRectMake(imageview.frame.origin.x, imageview.frame.origin.y, 70, 70);
                           imageview.layer.cornerRadius=35.0f;
                           imageview.clipsToBounds=YES;
                           
                           lastImageView = imageview;
                           lastIndex = (int)categoryIndex;
                           currentIndex = (int)categoryIndex;
                           NSLog(@" cateogry selected at index %ld", (long)categoryIndex);
                       }];
    
    
   // self.sliderView.backgroundColor=[UIColor yellowColor];
    [self.sliderView setY:0];
    [self.sliderView moveY:40 duration:0.1 complation:nil];
    [self.view addSubview:self.sliderView];
   

}
- (UIImageView *)imagewithImage:(NSString *)imageUrl {
    
    UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    userImageView.layer.borderWidth=2.0f;
    userImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    if (value==0) {
        userImageView.frame=CGRectMake(0, 0, 70, 70);
        userImageView.layer.cornerRadius=35.0f;
        userImageView.clipsToBounds=YES;
    }
    else if (value==selectedIndex-1) {
        userImageView.frame=CGRectMake(0, 0, 70, 70);
        userImageView.layer.cornerRadius=35.0f;
        userImageView.clipsToBounds=YES;
    }
    else
    {
        userImageView.layer.cornerRadius=30.0f;
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
    float w = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]}].width;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, w, 20)];
    [timeLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [timeLabel setBackgroundColor:[UIColor blueColor]];
    [timeLabel setTextColor:[UIColor whiteColor]];
    [timeLabel setText:text];
    [timeLabel setTextAlignment:NSTextAlignmentCenter];
    return timeLabel;
}

#pragma mark - Webservice PhotoListing
-(void)getPhotoListing
{
    [[WebService sharedManager] photoListing:postID success: ^(id dataArray) {
        
        [myDelegate StopIndicator];
        photoListingDataArray=[dataArray mutableCopy];
        for(int i=0;i<photoListingDataArray.count;i++)
        {
            [postImagesArray addObject:[[photoListingDataArray objectAtIndex:i]postImagesUrl]];
        }

        [self setImageScroller];
        [self swipeImages];
        
    }
                                     failure:^(NSError *error)
     {
         
     }] ;

}
#pragma mark - end

#pragma mark - Webservice LikeDislike
-(void)likeDislike
{
    [[WebService sharedManager] likDislikePhoto:[postImagesArray objectAtIndex:imageIndex] likeDislike:likeDislikeString  success: ^(id responseObject) {
        
        [myDelegate StopIndicator];
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Alert"
                                              message:[responseObject objectForKey:@"message"]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
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

- (IBAction)dislikePhotoButtonAction:(id)sender
{
    likeDislikeString=@"false";
    [myDelegate ShowIndicator];
    [self performSelector:@selector(likeDislike) withObject:nil afterDelay:0.1];

}
- (IBAction)likePhotoButtonAction:(id)sender
{
    likeDislikeString=@"true";
    [myDelegate ShowIndicator];
    [self performSelector:@selector(likeDislike) withObject:nil afterDelay:0.1];
}
#pragma mark - end

@end
