//
//  ViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 29/12/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import "TutorialViewController.h"
#import "FXPageControl.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"

@interface TutorialViewController ()<UIGestureRecognizerDelegate>
{
    NSMutableArray *tutorialImages;
    int imageIndex;
}

@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tutorialImageView;
@property (weak, nonatomic) IBOutlet FXPageControl *pageControl;


@end

@implementation TutorialViewController
@synthesize headingLabel,tutorialImageView,pageControl;
#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
 
    // Set the screen name for automatic screenview tracking.
    self.screenName = @"Tutorial screen";
    //Adding images to array
    tutorialImages=[[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"image1.png"],[UIImage imageNamed:@"image2.png"],[UIImage imageNamed:@"image3.png"],[UIImage imageNamed:@"image4.png"],[UIImage imageNamed:@"image5.png"], nil];
    
    [tutorialImageView setUserInteractionEnabled:YES];
    UISwipeGestureRecognizer *swipeImageLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBannerImageLeft:)];
    swipeImageLeft.delegate=self;
    UISwipeGestureRecognizer *swipeImageRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBannerImageRight:)];
    swipeImageRight.delegate=self;
    
    // Setting the swipe direction.
    [swipeImageLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeImageRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [tutorialImageView addGestureRecognizer:swipeImageLeft];
    [tutorialImageView addGestureRecognizer:swipeImageRight];
    imageIndex=0;
    [self swipeImages];


}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[self navigationController] setNavigationBarHidden:NO];
    
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
    tutorialImageView.image=[tutorialImages objectAtIndex:0];
    pageControl.numberOfPages = [tutorialImages count];
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
-(void) swipeBannerImageLeft: (UISwipeGestureRecognizer *)sender
{
    imageIndex++;
    if (imageIndex<tutorialImages.count)
    {
        tutorialImageView.image=[tutorialImages objectAtIndex:imageIndex];
        UIImageView *moveIMageView = tutorialImageView;
        [self addLeftAnimationPresentToView:moveIMageView];
        int page=imageIndex;
        pageControl.currentPage=page;
        [self setHeadingText];
        
    }
    else
    {
        imageIndex--;
//        imageIndex=0;
//        tutorialImageView.image=[tutorialImages objectAtIndex:0];
//        [self setHeadingText];
//        pageControl.currentPage=imageIndex;
    }
}
//Swipe images in right direction
-(void) swipeBannerImageRight: (UISwipeGestureRecognizer *)sender
{
    imageIndex--;
    if (imageIndex<tutorialImages.count)
    {
        tutorialImageView.image=[tutorialImages objectAtIndex:imageIndex];
        UIImageView *moveIMageView = tutorialImageView;
        [self addRightAnimationPresentToView:moveIMageView];
        int page=imageIndex;
        pageControl.currentPage=page;
        [self setHeadingText];
        
    }
    
    else
    {
        imageIndex++;
       //  pageControl.currentPage=imageIndex;
    }
}

-(void)setHeadingText
{
    if (imageIndex==0)
    {
        headingLabel.text=@"Get connected with people from campus.";
    }
    else  if (imageIndex==1)
    {
        headingLabel.text=@"Find you Joey.";
    }
    else  if (imageIndex==3)
    {
        headingLabel.text=@"Share moments with Hangaroo.";
    }
    else  if (imageIndex==2)
    {
        headingLabel.text=@"Chat with the people you have discovered.";
    }
    else  if (imageIndex==4)
    {
        headingLabel.text=@"Do it for the Hangaroo.";
    }
}

#pragma mark - end



#pragma mark - IBActions
- (IBAction)loginButtonAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginView =[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:loginView animated:YES];
}

- (IBAction)signUpButtonAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignUpViewController *loginView =[storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self.navigationController pushViewController:loginView animated:YES];
}

#pragma mark - end

@end
