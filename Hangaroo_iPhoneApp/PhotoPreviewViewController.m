//
//  PhotoPreviewViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 07/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "PhotoPreviewViewController.h"
#import "MeTooUserProfileViewController.h"
#import "HomeViewController.h"

@interface PhotoPreviewViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    int imageIndex;
}

@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property UITextField *caption;
@end

@implementation PhotoPreviewViewController
@synthesize postImagesDataArray,previewImageView,caption,postImage,postID;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"Preview photo";
 
    previewImageView.image=postImage;
    [previewImageView setUserInteractionEnabled:YES];
  
    UITapGestureRecognizer *imageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped)];
    imageViewTap.delegate = self;
    
    //    UISwipeGestureRecognizer *swipeImageLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBannerImageLeft:)];
    //    swipeImageLeft.delegate=self;
    //    UISwipeGestureRecognizer *swipeImageRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBannerImageRight:)];
    //    swipeImageRight.delegate=self;
    // Setting the swipe direction.
    //    [swipeImageLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    //    [swipeImageRight setDirection:UISwipeGestureRecognizerDirectionRight];
  
    // Adding the swipe gesture on image view
    //    [previewImageView addGestureRecognizer:swipeImageLeft];
    //    [previewImageView addGestureRecognizer:swipeImageRight];

      // Drag Gesture for Caption
    UIPanGestureRecognizer *drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(captionDrag:)];
    
  
    [previewImageView addGestureRecognizer:drag];
    [previewImageView addGestureRecognizer:imageViewTap];
    
       imageIndex=0;
    
    
    //[self swipeImages];
    // previewImageView.image=[postImagesDataArray objectAtIndex:0];
    
    
    [self initCaption:self.view.frame];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //  [[self navigationController] setNavigationBarHidden:YES];
    //  self.tabBarController.tabBar.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(BOOL)prefersStatusBarHidden
//{
//    return YES;
//}
//- (void)statusHide
//{
//    [UIView animateWithDuration:0.1 animations:^() {
//        [self setNeedsStatusBarAppearanceUpdate];
//    }completion:^(BOOL finished){}];
//}
#pragma mark - end

#pragma mark - Add tagline
- (void) initCaption:(CGRect)frame{
    
    // Caption
    caption = [[UITextField alloc] initWithFrame:CGRectMake(0,
                                                            120,
                                                            frame.size.width,
                                                            32)];
    caption.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    caption.textAlignment = NSTextAlignmentCenter;
    caption.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    caption.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    caption.textColor = [UIColor whiteColor];
    caption.keyboardAppearance = UIKeyboardAppearanceDark;
    caption.alpha = 0;
    caption.tintColor = [UIColor whiteColor];
    caption.delegate = self;
    [previewImageView addSubview:caption];
    
}

- (void) imageViewTapped{
    
    caption.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    caption.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    if([caption isFirstResponder]){
        [caption resignFirstResponder];
        caption.alpha = ([caption.text isEqualToString:@""]) ? 0 : caption.alpha;
    } else {
        [caption becomeFirstResponder];
        caption.alpha = 1;
    }
}

- (void) captionDrag: (UIGestureRecognizer*)gestureRecognizer{
    
    CGPoint translation = [gestureRecognizer locationInView:previewImageView];
    
    if(translation.y < caption.frame.size.height/2){
        caption.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,  caption.frame.size.height/2);
    } else if(previewImageView.frame.size.height < translation.y + caption.frame.size.height/2){
        caption.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,  previewImageView.frame.size.height - caption.frame.size.height/2);
    } else {
        caption.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,  translation.y);
    }
    
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string{
    
    NSString *text = textField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    CGSize textSize = [text sizeWithAttributes: @{NSFontAttributeName:textField.font}];
    return (textSize.width + 10 < textField.bounds.size.width) ? true : false;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [caption resignFirstResponder];
    return true;
}
#pragma mark - end

#pragma mark - Swipe Images
//-(void)swipeImages
//{
//    previewImageView.image=[postImagesDataArray objectAtIndex:0];
////    pageControl.numberOfPages = [tutorialImages count];
//}


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
-(void) swipeBannerImageLeft: (UISwipeGestureRecognizer *)sender
{
    imageIndex++;
    if (imageIndex<postImagesDataArray.count)
    {
        previewImageView.image=[postImagesDataArray objectAtIndex:imageIndex];
        UIImageView *moveImageView = previewImageView;
        [self addLeftAnimationPresentToView:moveImageView];
        
    }
    else
    {
        imageIndex--;
    }
}
//Swipe images in right direction
-(void) swipeBannerImageRight: (UISwipeGestureRecognizer *)sender
{
    imageIndex--;
    if (imageIndex<postImagesDataArray.count)
    {
        previewImageView.image=[postImagesDataArray objectAtIndex:imageIndex];
        UIImageView *moveImageView = previewImageView;
        [self addRightAnimationPresentToView:moveImageView];
    }
    
    else
    {
        imageIndex++;
        
    }
}

#pragma mark - end

#pragma mark - IBActions
- (IBAction)uploadImagesButtonAction:(id)sender
{
    [myDelegate ShowIndicator];
    [self performSelector:@selector(uploadPhoto) withObject:nil afterDelay:.1];
    
}
#pragma mark - end

#pragma mark - Webservice
-(void)uploadPhoto
{
    
    UIGraphicsBeginImageContextWithOptions(previewImageView.frame.size, YES, 0.0);
    
    for (UIView * view in [previewImageView subviews]){
        [view removeFromSuperview];
    }
    
    [previewImageView addSubview:caption];
    [previewImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    NSLog(@"post id is %@",postID);
    [[WebService sharedManager]uploadPhoto:postID image:newImage success: ^(id responseObject) {
        
        [myDelegate StopIndicator];
        NSLog(@"post id is %@",responseObject);
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeViewController * homeView = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [self.navigationController pushViewController:homeView animated:YES];
        
    }
                                   failure:^(NSError *error)
     {
         
     }] ;
    
}
#pragma mark - end
@end
