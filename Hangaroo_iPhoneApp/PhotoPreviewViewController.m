//
//  PhotoPreviewViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 07/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "PhotoPreviewViewController.h"

@interface PhotoPreviewViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    int imageIndex;
}

@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property UITextField *caption;
@end

@implementation PhotoPreviewViewController
@synthesize postImagesDataArray,previewImageView,caption;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title=@"Preview photo";
    
    [previewImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *imageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped)];
    imageViewTap.delegate = self;
    imageViewTap.numberOfTapsRequired=2;
    
    UISwipeGestureRecognizer *swipeImageLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBannerImageLeft:)];
    swipeImageLeft.delegate=self;
    UISwipeGestureRecognizer *swipeImageRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBannerImageRight:)];
    swipeImageRight.delegate=self;
    
      UIPanGestureRecognizer *drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(captionDrag:)];
    
    // Setting the swipe direction.
    [swipeImageLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeImageRight setDirection:UISwipeGestureRecognizerDirectionRight];
  // Drag Gesture for Caption
    [previewImageView addGestureRecognizer:drag];
    [previewImageView addGestureRecognizer:imageViewTap];

    // Adding the swipe gesture on image view
    [previewImageView addGestureRecognizer:swipeImageLeft];
    [previewImageView addGestureRecognizer:swipeImageRight];
    imageIndex=0;
    
    
    //[self swipeImages];
    previewImageView.image=[postImagesDataArray objectAtIndex:0];
  
    
    [self initCaption:previewImageView.frame];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - end

#pragma mark - Add tagline
- (void) initCaption:(CGRect)frame{
    
    // Caption
    caption = [[UITextField alloc] initWithFrame:CGRectMake(0,
                                                            previewImageView.frame.size.height/2,
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
//    UIToolbar *toolbar = [[UIToolbar alloc] init];
//    toolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
//    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(sendAction)];
//    
//    UIBarButtonItem *button2=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction)];
//    
//    [toolbar setItems:[[NSArray alloc] initWithObjects:button1,button2, nil]];
//    [self.view addSubview:toolbar];
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

- (IBAction)uploadImagesButtonAction:(id)sender {
}

@end
