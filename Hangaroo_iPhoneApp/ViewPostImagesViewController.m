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
    int lastIndex;
    UIButton *button;
    CategorySliderView* imageSliderView;
    NSMutableArray* imageArray,*labelArray;
    int indexValue;
    NSMutableArray *postImagesArray;
 
    bool like;
    bool dislike;
}
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property(nonatomic,retain) NSString * likeDislikeString;
@property (weak, nonatomic) IBOutlet UICollectionView *userCollectionview;
@property (nonatomic, strong) CategorySliderView *sliderView;
@end

@implementation ViewPostImagesViewController
@synthesize postID,selectedIndex,likeButton,dislikeButton,userCollectionview;
@synthesize photoImageView,sliderView,likeCount,closeButton,likeDislikeString;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.screenName = @"View Post screen";
    photoListingDataArray=[[NSMutableArray alloc]init];
    imageArray=[[NSMutableArray alloc]init];
    labelArray=[[NSMutableArray alloc]init];
    postImagesArray=[[NSMutableArray alloc]init];
    photoImageView.userInteractionEnabled=YES;
  
   [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self addShadow];
    
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
-(void)addShadow
{
    likeCount.shadowColor = [UIColor blackColor];
    likeCount.shadowOffset = CGSizeMake(0.0, 1.5);
    
//    likeButton.layer.shadowColor = [UIColor blackColor].CGColor;
//    likeButton.layer.shadowOffset = CGSizeMake(1, 1);
//    likeButton.layer.shadowRadius = 5;
//    likeButton.layer.shadowOpacity = 1.0;
//    
//    dislikeButton.layer.shadowColor = [UIColor blackColor].CGColor;
//    dislikeButton.layer.shadowOffset = CGSizeMake(5, 5);
//    dislikeButton.layer.shadowRadius = 5;
//    dislikeButton.layer.shadowOpacity = 0.8;
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
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - end

#pragma mark - Collection view
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *myCell = [collectionView1
                                    dequeueReusableCellWithReuseIdentifier:@"userCell"
                                    forIndexPath:indexPath];
    
    
    UIImageView *image = (UIImageView*)[myCell viewWithTag:1];
    __weak UIImageView *weakRef = image;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[imageArray objectAtIndex:indexPath.row]]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [image setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    image.layer.borderColor = [UIColor whiteColor].CGColor;
    image.layer.borderWidth = 1.0;
    
    UILabel* separatorLabel1 =  (UILabel*)[myCell viewWithTag:2];
    UILabel* timeLabel =  (UILabel*)[myCell viewWithTag:3];
    UILabel* separatorLabel2 =  (UILabel*)[myCell viewWithTag:4];
    if (indexPath.row == 0)
    {
        separatorLabel2.hidden = YES;
        separatorLabel1.hidden = NO;
    }
    else if (indexPath.row == imageArray.count-1) {
        separatorLabel2.hidden = NO;
        separatorLabel1.hidden = YES;
    }
    else{
        separatorLabel2.hidden = NO;
        separatorLabel1.hidden = NO;
    }

    timeLabel.text=[labelArray objectAtIndex:indexPath.row];
    timeLabel.shadowColor = [UIColor blackColor];
    timeLabel.shadowOffset = CGSizeMake(0.0, 1.5);
    image.translatesAutoresizingMaskIntoConstraints = YES;
    
    
    if ((int)selectedIndex == indexPath.row) {
        image.frame = CGRectMake((80/2) - 35, 0 , 70, 70);
        image.layer.cornerRadius = 35;
    }
    else{
        image.frame = CGRectMake((80/2) - 25, 10 , 50, 50);
        image.layer.cornerRadius = 25;
    }
    return myCell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    index = indexPath.row;
    //    int value = ((index*100) + 40) -self.view.frame.size.width/2 ;
    //    NSLog(@"-----%d---------",value);
    //    if (value < 0) {
    //
    //        [_myCollectionView setContentOffset:CGPointMake(value, 0) animated:YES];
    //        [_myCollectionView reloadData];
    //
    //    }
    //    else{
    //        [_myCollectionView setContentOffset:CGPointMake(value, 0) animated:YES];
    //        [_myCollectionView reloadData];
    //        
    //        
    //    }
    
}
#pragma mark - end
#pragma mark - Swipe Images
-(void)swipeImages
{
    __weak UIImageView *weakRef = photoImageView;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[postImagesArray objectAtIndex:selectedIndex]]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [photoImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@""] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    likeCount.text=[[photoListingDataArray objectAtIndex:selectedIndex]likeCountData];
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
    selectedIndex++;
    if (selectedIndex<postImagesArray.count)
    {
        __weak UIImageView *weakRef = photoImageView;
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[postImagesArray objectAtIndex:selectedIndex]]
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:60];
        
        [photoImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@""] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakRef.contentMode = UIViewContentModeScaleAspectFill;
            weakRef.clipsToBounds = YES;
            weakRef.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
//        [imageSliderView customSlide:currentIndex categorySelection:^(UIImageView *imageview, NSInteger categoryIndex)
//         {
//             if (lastImageView != nil) {
//                 lastImageView.frame=CGRectMake(imageview.frame.origin.x-((categoryIndex - lastIndex)*70), 0, 50, 50);
//                 lastImageView.layer.cornerRadius=25.0f;
//                 lastImageView.clipsToBounds=YES;
//             }
//             
//             
//             imageview.frame=CGRectMake(imageview.frame.origin.x, imageview.frame.origin.y, 60, 60);
//             imageview.layer.cornerRadius=30.0f;
//             imageview.clipsToBounds=YES;
//             
//             lastImageView = imageview;
//             lastIndex = (int)categoryIndex;
//             NSLog(@" cateogry selected at index %ld", (long)categoryIndex);
//             currentIndex++;
//         }];

//        if (selectedIndex>=0) {
        
            int value = ((selectedIndex*80) + 35) -self.view.frame.size.width/2 ;
            if (value < 0) {
                [userCollectionview setContentOffset:CGPointMake(value, 0) animated:YES];
                [userCollectionview reloadData];
            }
            else{
                [userCollectionview setContentOffset:CGPointMake(value, 0) animated:YES];
                [userCollectionview reloadData];
                
            }
    //    }

        UIImageView *moveImageView = photoImageView;
        [self addLeftAnimationPresentToView:moveImageView];
        likeCount.text=[[photoListingDataArray objectAtIndex:selectedIndex]likeCountData];
        dislikeButton.enabled=YES;
        likeButton.enabled=YES;
        
    }
    else
    {
        selectedIndex--;
    }
}
//Swipe images in right direction
-(void) swipeImagesRight:(UISwipeGestureRecognizer *)sender
{
    selectedIndex--;
    if (selectedIndex<postImagesArray.count)
    {
        __weak UIImageView *weakRef = photoImageView;
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[postImagesArray objectAtIndex:selectedIndex]]
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:60];
        
        [photoImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@""] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakRef.contentMode = UIViewContentModeScaleAspectFill;
            weakRef.clipsToBounds = YES;
            weakRef.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
//        [imageSliderView customSlide:currentIndex categorySelection:^(UIImageView *imageview, NSInteger categoryIndex)
//         {
//             if (lastImageView != nil) {
//                 lastImageView.frame=CGRectMake(imageview.frame.origin.x-((categoryIndex - lastIndex)*70), 0, 60, 60);
//                 lastImageView.layer.cornerRadius=30.0f;
//                 lastImageView.clipsToBounds=YES;
//             }
//             
//             
//             imageview.frame=CGRectMake(imageview.frame.origin.x, imageview.frame.origin.y, 70, 70);
//             imageview.layer.cornerRadius=35.0f;
//             imageview.clipsToBounds=YES;
//             
//             lastImageView = imageview;
//             lastIndex = (int)categoryIndex;
//             NSLog(@" cateogry selected at index %ld", (long)categoryIndex);
//             currentIndex++;
//         }];
        UIImageView *moveImageView = photoImageView;
        [self addRightAnimationPresentToView:moveImageView];
        likeCount.text=[[photoListingDataArray objectAtIndex:selectedIndex]likeCountData];
        dislikeButton.enabled=YES;
        likeButton.enabled=YES;

        int value = ((selectedIndex*80) + 35) -self.view.frame.size.width/2 ;
        NSLog(@"-----%d---------",value);
        
        if (value < 0) {
            
            [userCollectionview setContentOffset:CGPointMake(value, 0) animated:YES];
            [userCollectionview reloadData];
            
        }
        else{
            [userCollectionview setContentOffset:CGPointMake(value, 0) animated:YES];
            [userCollectionview reloadData];
            
            
        }
       
        
    }
    
    else
    {
        selectedIndex++;
        
    }
}

#pragma mark - end



//-(void)setImageScroller
//{
//    
//    imageSliderView = [CategorySliderView alloc];
//   
//   // indexValue =selectedIndex;
//    for(int i=0;i<photoListingDataArray.count;i++)
//    {
//        [imageArray addObject:[self imagewithImage:[[photoListingDataArray objectAtIndex:i]userImageUrl]]];
//        [labelArray addObject:[self labelWithText:[[photoListingDataArray objectAtIndex:i]uploadedImageTime]]];
//    }
//    if (selectedIndex == 0) {
//        currentIndex = selectedIndex;
//    }
//    else{
//        currentIndex = selectedIndex -1;
//    }
//    
//    self.sliderView = [imageSliderView initWithSliderHeight:CategorySliderHeight index:(int)indexValue andCategoryViews:imageArray andLabelView:labelArray categorySelectionBlock:^(UIImageView *imageview, NSInteger categoryIndex)
//                       {
//                           if (lastImageView != nil) {
//                               lastImageView.frame=CGRectMake(imageview.frame.origin.x-((categoryIndex - lastIndex)*70), 5, 60, 60);
//                               lastImageView.layer.cornerRadius=30.0f;
//                               lastImageView.clipsToBounds=YES;
//                           }
//                           
//                           
//                           imageview.frame=CGRectMake(imageview.frame.origin.x, imageview.frame.origin.y, 70, 70);
//                           imageview.layer.cornerRadius=35.0f;
//                           imageview.clipsToBounds=YES;
//                           
//                           lastImageView = imageview;
//                           lastIndex = (int)categoryIndex;
//                           currentIndex = (int)categoryIndex;
//                           NSLog(@" cateogry selected at index %ld", (long)categoryIndex);
//                       }];
//    
//    
//   // self.sliderView.backgroundColor=[UIColor yellowColor];
//    [self.sliderView setY:0];
//    [self.sliderView moveY:40 duration:0.1 complation:nil];
//    [self.view addSubview:self.sliderView];
//   
//
//}
//- (UIImageView *)imagewithImage:(NSString *)imageUrl {
//    
//    UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
//    userImageView.layer.borderWidth=2.0f;
//    userImageView.layer.borderColor=[UIColor whiteColor].CGColor;
//    if (value==0) {
//        userImageView.frame=CGRectMake(0, 0, 70, 70);
//        userImageView.layer.cornerRadius=35.0f;
//        userImageView.clipsToBounds=YES;
//    }
//    else if (value==selectedIndex-1) {
//        userImageView.frame=CGRectMake(0, 0, 70, 70);
//        userImageView.layer.cornerRadius=35.0f;
//        userImageView.clipsToBounds=YES;
//    }
//    else
//    {
//        userImageView.layer.cornerRadius=30.0f;
//        userImageView.clipsToBounds=YES;
//    }
//    __weak UIImageView *weakRef = userImageView;
//    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]
//                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
//                                              timeoutInterval:60];
//    
//    [userImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//        weakRef.contentMode = UIViewContentModeScaleAspectFill;
//        weakRef.clipsToBounds = YES;
//        weakRef.image = image;
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//        
//    }];
//
//    
//    value++;
//    return userImageView;
//}
//
//
//- (UILabel *)labelWithText:(NSString *)text {
//    float w = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]}].width;
//    
//    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, w, 20)];
//    [timeLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
//    [timeLabel setBackgroundColor:[UIColor blueColor]];
//    [timeLabel setTextColor:[UIColor whiteColor]];
//    [timeLabel setText:text];
//    [timeLabel setTextAlignment:NSTextAlignmentCenter];
//    return timeLabel;
//}

#pragma mark - Webservice PhotoListing
-(void)getPhotoListing
{
    [[WebService sharedManager] photoListing:postID success: ^(id dataArray) {
        
        [myDelegate StopIndicator];
        photoListingDataArray=[dataArray mutableCopy];
        for(int i=0;i<photoListingDataArray.count;i++)
        {
            [postImagesArray addObject:[[photoListingDataArray objectAtIndex:i]postImagesUrl]];
            [imageArray addObject:[[photoListingDataArray objectAtIndex:i]userImageUrl]];
            [labelArray addObject:[[photoListingDataArray objectAtIndex:i]uploadedImageTime]];
        }

        userCollectionview.contentInset = UIEdgeInsetsMake(0, (self.view.frame.size.width/2) - 35, 0, (self.view.frame.size.width/2) - 80);
        int spaceValue = ((selectedIndex*80) + 35) -self.view.frame.size.width/2 ;
        NSLog(@"-----%d---------",spaceValue);
        
        if (spaceValue < 0) {
            
            [userCollectionview setContentOffset:CGPointMake(spaceValue, 0) animated:YES];
            [userCollectionview reloadData];
            
        }
        else{
            [userCollectionview setContentOffset:CGPointMake(spaceValue, 0) animated:YES];
            [userCollectionview reloadData];
            
            
        }

       // [self setImageScroller];
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
    [[WebService sharedManager] likDislikePhoto:[postImagesArray objectAtIndex:selectedIndex] likeDislike:likeDislikeString  success: ^(id responseObject) {
        
        [myDelegate StopIndicator];
        likeCount.text=[responseObject objectForKey:@"likeCount"];
        if (like) {
            likeButton.enabled=NO;
            dislikeButton.enabled=YES;
        }
        else if (dislike)
        {
            dislikeButton.enabled=NO;
            likeButton.enabled=YES;
        }
        
      
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
    dislike=true;
    like=false;
    //[myDelegate ShowIndicator];
    [self performSelector:@selector(likeDislike) withObject:nil afterDelay:0.1];

}
- (IBAction)likePhotoButtonAction:(id)sender
{
    likeDislikeString=@"true";
    like=true;
    dislike=false;
   // [myDelegate ShowIndicator];
    [self performSelector:@selector(likeDislike) withObject:nil afterDelay:0.1];
}
#pragma mark - end

@end
