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

@interface PhotoPreviewViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    int imageIndex;
    CGFloat messageHeight, messageYValue, textY;
    UIPanGestureRecognizer *drag;
}
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property UITextView *caption;
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
    //tap gesture on image view
    UITapGestureRecognizer *imageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped)];
    imageViewTap.delegate = self;
    // Drag Gesture for Caption
    drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(captionDrag:)];
    [previewImageView addGestureRecognizer:imageViewTap];
    messageYValue=170;
    closeBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    closeBtn.layer.shadowOffset = CGSizeMake(5, 5);
    closeBtn.layer.shadowRadius = 5;
    closeBtn.layer.shadowOpacity = 0.8;
    caption.translatesAutoresizingMaskIntoConstraints = YES;
    [self initCaption:self.view.frame];
    [self registerForKeyboardNotifications];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    textY=30.0;
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
#pragma mark - Add tagline on image
- (void) initCaption:(CGRect)frame{
    
    // Caption
    caption = [[UITextView alloc] initWithFrame:CGRectMake(0,
                                                           170,
                                                           frame.size.width,
                                                           30)];
    caption.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    caption.textAlignment = NSTextAlignmentCenter;
    caption.textColor = [UIColor whiteColor];
    caption.font=[UIFont fontWithName:@"Roboto-Regular" size:15.0];
    caption.scrollEnabled=NO;
    caption.keyboardAppearance = UIKeyboardAppearanceDefault;
    caption.alpha = 0;
    caption.tintColor = [UIColor whiteColor];
    caption.delegate = self;
    [previewImageView addSubview:caption];
    
}
#pragma mark - end

#pragma mark - Image tapped gesture method
- (void) imageViewTapped{
    
    if([caption isFirstResponder])
    {
        [caption resignFirstResponder];
        caption.alpha = ([caption.text isEqualToString:@""]) ? 0 : caption.alpha;
    }
    else
    {
        [caption becomeFirstResponder];
        caption.alpha = 1;
    }
}
#pragma mark - end
#pragma mark - Drag caption gesture
- (void) captionDrag: (UIGestureRecognizer*)gestureRecognizer{
    CGPoint translation = [gestureRecognizer locationInView:previewImageView];
    if (translation.y>170 && translation.y<self.view.frame.size.height-65)
    {
        messageYValue=translation.y;
        if(translation.y < caption.frame.size.height/2)
        {
            if (((translation.y - (caption.frame.size.height / 2)) > 170) && ((translation.y + (caption.frame.size.height / 2)) < self.view.frame.size.height-65)) {
                caption.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,  translation.y);
            }
        }
        else if(previewImageView.frame.size.height < translation.y + caption.frame.size.height/2)
        {
            if (((translation.y - (caption.frame.size.height / 2)) > 170) && ((translation.y + (caption.frame.size.height / 2)) < self.view.frame.size.height-65)) {
                caption.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,  translation.y);
            }
        }
        else
        {
            if (((translation.y - (caption.frame.size.height / 2)) > 170) && ((translation.y + (caption.frame.size.height / 2)) < self.view.frame.size.height-65)) {
                caption.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,  translation.y);
            }
        }
    }
}
#pragma mark - end

#pragma mark - Textview delegate methods
- (void) textViewDidBeginEditing:(UITextView *)textView {
    [self performSelector:@selector(placeCursorAtEnd:) withObject:textView afterDelay:0.001];
}
- (void)placeCursorAtEnd:(UITextView *)textview {
    NSUInteger length = textview.text.length;
    textview.selectedRange = NSMakeRange(length, 0);
    [textview setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (([caption sizeThatFits:caption.frame.size].height < 500) && ([caption sizeThatFits:caption.frame.size].height > 36)) {
        
        caption.frame = CGRectMake(caption.frame.origin.x, messageHeight- [caption sizeThatFits:caption.frame.size].height+16, caption.frame.size.width, [textView sizeThatFits:caption.frame.size].height);
    }
    if(textView.text.length>=600 && range.length == 0)
    {
        [caption resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textField
{
    if (([caption sizeThatFits:caption.frame.size].height < 500) && ([caption sizeThatFits:caption.frame.size].height > 36)) {
        
        caption.frame = CGRectMake(caption.frame.origin.x, messageHeight- [caption sizeThatFits:caption.frame.size].height+16, caption.frame.size.width, [caption sizeThatFits:caption.frame.size].height);
    }
    else if([caption sizeThatFits:caption.frame.size].height <= 36){
        
        textY = 30.0;
        caption.frame = CGRectMake(caption.frame.origin.x, caption.frame.origin.y, caption.frame.size.width, 30);
    }
    if (textField.text.length >= 600)
    {
        textField.text = [textField.text substringToIndex:600];
        [caption resignFirstResponder];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (caption.text.length==0) {
        caption.alpha = ([caption.text isEqualToString:@""]) ? 0 : caption.alpha;
    }
    [caption resignFirstResponder];
    return true;
}
//register keyboard notifications
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
    messageHeight=self.view.frame.size.height-[aValue CGRectValue].size.height-10;
    caption.frame = CGRectMake(0, messageHeight-[caption sizeThatFits:caption.frame.size].height+16, [aValue CGRectValue].size.width, caption.frame.size.height);
}
- (void)keyboardWillHide:(NSNotification *)notification {
    [previewImageView addGestureRecognizer:drag];
    NSString *messageStr = [caption.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    caption.text=messageStr;
    caption.textAlignment = NSTextAlignmentCenter;
    if ([caption sizeThatFits:caption.frame.size].height != textY) {
        textY = [caption sizeThatFits:caption.frame.size].height - textY;
        messageYValue = messageYValue - textY;
        textY = [caption sizeThatFits:caption.frame.size].height;
    }
    if (messageYValue < 170) {
        
        messageYValue = 170;
    }
    else if (messageYValue + [caption sizeThatFits:caption.frame.size].height > self.view.frame.size.height-65) {
        
        messageYValue = self.view.frame.size.height-65 - [caption sizeThatFits:caption.frame.size].height;
    }
    caption.frame = CGRectMake(0, messageYValue, self.view.bounds.size.width, [caption sizeThatFits:caption.frame.size].height);
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
