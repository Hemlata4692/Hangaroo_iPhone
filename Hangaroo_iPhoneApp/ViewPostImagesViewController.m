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
#import "PhotoListingModel.h"

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
}
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *dislikeCount;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property(nonatomic,retain) NSString * likeDislikeString;
@property (weak, nonatomic) IBOutlet UICollectionView *userCollectionview;
@property (nonatomic, strong) CategorySliderView *sliderView;
@end

@implementation ViewPostImagesViewController
@synthesize postID,selectedIndex,likeButton,dislikeButton,userCollectionview;
@synthesize photoImageView,sliderView,likeCount,closeButton,likeDislikeString,dislikeCount;

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
    [myDelegate showIndicator];
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
    
    [likeButton setImage:[UIImage imageNamed:@"like_selected.png"] forState:UIControlStateSelected];
    [likeButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
    likeButton.selected=NO;
    
    [dislikeButton setImage:[UIImage imageNamed:@"dislike_selected.png"] forState:UIControlStateSelected];
    [dislikeButton setImage:[UIImage imageNamed:@"dislike.png"] forState:UIControlStateNormal];
    dislikeButton.selected=NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
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
    
    [image setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"profileImage.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
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
    
    [photoImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"picture.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    likeCount.text=[[photoListingDataArray objectAtIndex:selectedIndex]likeCountData];
    dislikeCount.text=[[photoListingDataArray objectAtIndex:selectedIndex]dislikeCountData];
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
        dislikeCount.text=[[photoListingDataArray objectAtIndex:selectedIndex]dislikeCountData];
        if ([[[photoListingDataArray objectAtIndex:selectedIndex]isLike] isEqualToString:@"0"]) {
            [likeButton setSelected:NO];
            [dislikeButton setSelected:NO];
        }
        else if ([[[photoListingDataArray objectAtIndex:selectedIndex]isLike] isEqualToString:@"T"])
        {
            [likeButton setSelected:YES];
            [dislikeButton setSelected:NO];
        }
        else if ([[[photoListingDataArray objectAtIndex:selectedIndex]isLike] isEqualToString:@"F"])
        {
            [likeButton setSelected:NO];
            [dislikeButton setSelected:YES];
        }
        
        
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
        UIImageView *moveImageView = photoImageView;
        [self addRightAnimationPresentToView:moveImageView];
        likeCount.text=[[photoListingDataArray objectAtIndex:selectedIndex]likeCountData];
        dislikeCount.text=[[photoListingDataArray objectAtIndex:selectedIndex]dislikeCountData];
        if ([[[photoListingDataArray objectAtIndex:selectedIndex]isLike] isEqualToString:@"0"]) {
            [likeButton setSelected:NO];
            [dislikeButton setSelected:NO];
        }
        else if ([[[photoListingDataArray objectAtIndex:selectedIndex]isLike] isEqualToString:@"T"])
        {
            [likeButton setSelected:YES];
            [dislikeButton setSelected:NO];
        }
        else if ([[[photoListingDataArray objectAtIndex:selectedIndex]isLike] isEqualToString:@"F"])
        {
            [likeButton setSelected:NO];
            [dislikeButton setSelected:YES];
        }
        
        
    }
    
    else
    {
        selectedIndex++;
    }
}

#pragma mark - end

#pragma mark - Webservice photoListing
-(void)getPhotoListing
{
    [[WebService sharedManager] photoListing:postID success: ^(id dataArray) {
        
        [myDelegate stopIndicator];
        photoListingDataArray=[dataArray mutableCopy];
        for(int i=0;i<photoListingDataArray.count;i++)
        {
            [postImagesArray addObject:[[photoListingDataArray objectAtIndex:i]postImagesUrl]];
            [imageArray addObject:[[photoListingDataArray objectAtIndex:i]userImageUrl]];
            [labelArray addObject:[[photoListingDataArray objectAtIndex:i]uploadedImageTime]];
            
        }
        if ([[[photoListingDataArray objectAtIndex:selectedIndex]isLike] isEqualToString:@"0"]) {
            [likeButton setSelected:NO];
            [dislikeButton setSelected:NO];
        }
        else if ([[[photoListingDataArray objectAtIndex:selectedIndex]isLike] isEqualToString:@"T"])
        {
            [likeButton setSelected:YES];
            [dislikeButton setSelected:NO];
        }
        else if ([[[photoListingDataArray objectAtIndex:selectedIndex]isLike] isEqualToString:@"F"])
        {
            [likeButton setSelected:NO];
            [dislikeButton setSelected:YES];
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
        
        [self swipeImages];
    }
                                     failure:^(NSError *error)
     {
         
     }] ;
    
}
#pragma mark - end

#pragma mark - Webservice like dislike
-(void)likeDislike
{
    [[WebService sharedManager] likDislikePhoto:[postImagesArray objectAtIndex:selectedIndex] likeDislike:likeDislikeString  success: ^(id responseObject) {
        
        [myDelegate stopIndicator];
        photoImageView.userInteractionEnabled=YES;
        likeCount.text=[responseObject objectForKey:@"likeCount"];
        dislikeCount.text=[responseObject objectForKey:@"dislikeCount"];
        PhotoListingModel *photoList;
        
        NSMutableArray *tempArray=[photoListingDataArray mutableCopy];
        photoList=[tempArray objectAtIndex:selectedIndex];
        photoList.likeCountData=[responseObject objectForKey:@"likeCount"];
        photoList.dislikeCountData=[responseObject objectForKey:@"dislikeCount"];
        photoList.isLike=[responseObject objectForKey:@"is_like"];
        [tempArray replaceObjectAtIndex:selectedIndex withObject:photoList];
        photoListingDataArray=[tempArray mutableCopy];
    }
                                        failure:^(NSError *error)
     {
         [likeButton setSelected:NO];
         [dislikeButton setSelected:NO];
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
    likeDislikeString=@"F";
    if ([sender isSelected])
    {
        [dislikeButton setSelected:NO];
    }
    else
    {
        [dislikeButton setSelected:YES];
        [likeButton setSelected:NO];
    }
    //[myDelegate showIndicator];
    [self performSelector:@selector(likeDislike) withObject:nil afterDelay:0.1];
    
}
- (IBAction)likePhotoButtonAction:(id)sender
{
    photoImageView.userInteractionEnabled=NO;
    likeDislikeString=@"T";
    if ([sender isSelected])
    {
        [likeButton setSelected:NO];
    }
    else
    {
        [likeButton setSelected:YES];
        [dislikeButton setSelected:NO];
    }
    
    // [myDelegate showIndicator];
    [self performSelector:@selector(likeDislike) withObject:nil afterDelay:0.1];
}
#pragma mark - end

@end
