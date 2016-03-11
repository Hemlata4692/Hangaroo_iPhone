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
    CGFloat messageHeight, messageYValue;
    UIPanGestureRecognizer *drag;
}

@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property UITextField *caption;
@end

@implementation PhotoPreviewViewController
@synthesize postImagesDataArray,previewImageView,caption,postImage,postID,closeBtn;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Photo preview screen";
    self.title=@"Preview photo";
    imageIndex=0;
    previewImageView.image=postImage;
    [previewImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *imageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped)];
    imageViewTap.delegate = self;
    // Drag Gesture for Caption
    drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(captionDrag:)];
    
    [previewImageView addGestureRecognizer:imageViewTap];
    
    [self initCaption:self.view.frame];
    messageYValue=170;
    closeBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    closeBtn.layer.shadowOffset = CGSizeMake(5, 5);
    closeBtn.layer.shadowRadius = 5;
    closeBtn.layer.shadowOpacity = 0.8;
    [self registerForKeyboardNotifications];
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



#pragma mark - Add tagline
- (void) initCaption:(CGRect)frame{
    
    // Caption
    caption = [[UITextField alloc] initWithFrame:CGRectMake(0,
                                                            170,
                                                            frame.size.width,
                                                            30)];
    caption.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    caption.textAlignment = NSTextAlignmentCenter;
    caption.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    caption.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    caption.textColor = [UIColor whiteColor];
    caption.keyboardAppearance = UIKeyboardAppearanceDefault;
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
    
    if (translation.y>170 && translation.y<self.view.frame.size.height-65)
    {
        messageYValue=translation.y;
        if(translation.y < caption.frame.size.height/2)
        {
            caption.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,  caption.frame.size.height/2);
        }
        else if(previewImageView.frame.size.height < translation.y + caption.frame.size.height/2)
        {
            caption.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,  previewImageView.frame.size.height - caption.frame.size.height/2);
        }
        else
        {
            caption.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,  translation.y);
            
        }
        
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
    if (caption.text.length==0) {
        caption.alpha = ([caption.text isEqualToString:@""]) ? 0 : caption.alpha;
    }
    [caption resignFirstResponder];
    return true;
}
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [previewImageView removeGestureRecognizer:drag];
    NSDictionary* info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSLog(@"%f",[aValue CGRectValue].size.height);
    caption.frame = CGRectMake(0, self.view.frame.size.height-[aValue CGRectValue].size.height-10, [aValue CGRectValue].size.width, caption.frame.size.height);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [previewImageView addGestureRecognizer:drag];
    
    caption.frame = CGRectMake(0, messageYValue, self.view.bounds.size.width, caption.frame.size.height);
    
}

#pragma mark - end

#pragma mark - Swipe Images
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
    [myDelegate showIndicator];
    [self performSelector:@selector(uploadPhoto) withObject:nil afterDelay:.1];
    
}
- (IBAction)closeButtonAction:(id)sender
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}
- (BOOL) hidesBottomBarWhenPushed
{
    return (self.navigationController.topViewController == self);
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
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    [[WebService sharedManager]uploadPhoto:postID image:newImage success: ^(id responseObject) {
        [myDelegate stopIndicator];
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[HomeViewController class]])
            {
                CATransition* transition = [CATransition animation];
                transition.duration = 0.4f;
                transition.type = kCATransitionReveal;
                transition.subtype = kCATransitionFromBottom;
                [self.navigationController.view.layer addAnimation:transition
                                                            forKey:kCATransition];
                [self.navigationController popToViewController:controller animated:NO];
                break;
            }
        }
    }
                                   failure:^(NSError *error)
     {
         
     }] ;
    
}
#pragma mark - end
@end
