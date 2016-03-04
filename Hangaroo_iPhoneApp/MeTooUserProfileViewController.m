//
//  MeTooUserProfileViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 07/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MeTooUserProfileViewController.h"
#import "UIView+RoundedCorner.h"
#import <UIImageView+AFNetworking.h>
#import "SettingViewController.h"
#import "UIView+Toast.h"
#import "PersonalChatViewController.h"
#import "HomeViewController.h"
#import "JoinedUserDataModel.h"
#import "OtherUserProfileViewController.h"
#import "MyProfileViewController.h"

@interface MeTooUserProfileViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *followedUserLabel;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIButton *tapToSeeOutBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property(nonatomic,retain) NSString * postedPostId;
@property (weak, nonatomic) IBOutlet UIView *tutorialView;
@end

@implementation MeTooUserProfileViewController
@synthesize postLabel,followedUserLabel,userNameLabel,postedPostId;
@synthesize userImageView,mainContainerView,tapToSeeOutBtn,joineUserId,userDataArray;
@synthesize userName,userProfileImageUrl,post,postID,followedUser,chatBtn,selectedIndex,tutorialView;

#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.screenName = @"Me too user profile screen";
    [mainContainerView setCornerRadius:3.0f];
     userImageView.userInteractionEnabled=YES;
    UISwipeGestureRecognizer *swipeImageLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeImagesLeft:)];
    swipeImageLeft.delegate=self;
    UISwipeGestureRecognizer *swipeImageRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeImagesRight:)];
    swipeImageRight.delegate=self;
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    tapImage.delegate=self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapGesture.delegate=self;
    [swipeImageLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeImageRight setDirection:UISwipeGestureRecognizerDirectionRight];
   
    // Adding the swipe gesture on image view
    [userImageView addGestureRecognizer:swipeImageLeft];
    [userImageView addGestureRecognizer:swipeImageRight];
    [userImageView addGestureRecognizer:tapImage];
    [tutorialView addGestureRecognizer:tapGesture];
    [self swipeImages];
    
    if (![[UserDefaultManager getValue:@"tutorialCompleted"] isEqualToString:@"true"]) {
        myDelegate.tutorialCompleted=@"true";
        [UserDefaultManager setValue:myDelegate.tutorialCompleted key:@"tutorialCompleted"];
        tutorialView.hidden=NO;
    }
    else
    {
        tutorialView.hidden=YES;
    }
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
#pragma mark - Swipe Images
-(void) tapImage:(UITapGestureRecognizer *)sender
{
    if ([[UserDefaultManager getValue:@"userId"] isEqualToString:[[userDataArray objectAtIndex:selectedIndex] joinedUserId]])
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MyProfileViewController *otherUserProfile =[storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
        [self.navigationController pushViewController:otherUserProfile animated:YES];
    }
    else
    {
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherUserProfileViewController *otherUserProfile =[storyboard instantiateViewControllerWithIdentifier:@"OtherUserProfileViewController"];
    otherUserProfile.otherUserId=[[userDataArray objectAtIndex:selectedIndex] joinedUserId];
    [self.navigationController pushViewController:otherUserProfile animated:YES];
    }
}
-(void) tap:(UITapGestureRecognizer *)sender
{
    tutorialView.hidden=YES;
}
-(void)swipeImages
{
    postLabel.text=post;
    postedPostId=postID;
    followedUserLabel.text=followedUser;
    __weak UIImageView *weakRef = userImageView;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[userDataArray objectAtIndex:selectedIndex] joinedUserImage]]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [userImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"picture.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
     userNameLabel.text=[[userDataArray objectAtIndex:selectedIndex] joinedUserName];
    if ([[[userDataArray objectAtIndex:selectedIndex] joinedUserId] isEqualToString:[UserDefaultManager getValue:@"userId"]]) {
        tapToSeeOutBtn.enabled=NO;
        chatBtn.enabled=NO;
    }
    else
    {
        tapToSeeOutBtn.enabled=YES;
        chatBtn.enabled=YES;
    }
}

//Adding left animation to banner images
- (void)addLeftAnimationPresentToView:(UIView *)viewTobeAnimatedLeft
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.40;
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
    transition.duration = 0.40;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [transition setValue:@"IntroSwipeIn" forKey:@"IntroAnimation"];
    transition.fillMode=kCAFillModeForwards;
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromLeft;
    [viewTobeAnimatedRight.layer addAnimation:transition forKey:nil];
}

-(void) swipeImagesLeft:(UISwipeGestureRecognizer *)sender
{
    selectedIndex++;
    if (selectedIndex<userDataArray.count)
    {
        __weak UIImageView *weakRef = userImageView;
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[userDataArray objectAtIndex:selectedIndex] joinedUserImage]]
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:60];
        [userImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"picture.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakRef.contentMode = UIViewContentModeScaleAspectFill;
            weakRef.clipsToBounds = YES;
            weakRef.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
        UIImageView *moveImageView = userImageView;
        [self addLeftAnimationPresentToView:moveImageView];
         userNameLabel.text=[[userDataArray objectAtIndex:selectedIndex] joinedUserName];
        if ([[[userDataArray objectAtIndex:selectedIndex] joinedUserId] isEqualToString:[UserDefaultManager getValue:@"userId"]]) {
            tapToSeeOutBtn.enabled=NO;
            chatBtn.enabled=NO;
        }
        else
        {
            tapToSeeOutBtn.enabled=YES;
            chatBtn.enabled=YES;
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
    if (selectedIndex<userDataArray.count)
    {
        __weak UIImageView *weakRef = userImageView;
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[userDataArray objectAtIndex:selectedIndex] joinedUserImage]]
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:60];
        
        [userImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"picture.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakRef.contentMode = UIViewContentModeScaleAspectFill;
            weakRef.clipsToBounds = YES;
            weakRef.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
        UIImageView *moveImageView = userImageView;
        [self addRightAnimationPresentToView:moveImageView];
         userNameLabel.text=[[userDataArray objectAtIndex:selectedIndex] joinedUserName];
        if ([[[userDataArray objectAtIndex:selectedIndex] joinedUserId] isEqualToString:[UserDefaultManager getValue:@"userId"]]) {
            tapToSeeOutBtn.enabled=NO;
            chatBtn.enabled=NO;
        }
        else
        {
            tapToSeeOutBtn.enabled=YES;
            chatBtn.enabled=YES;
        }
    }
    else
    {
        selectedIndex++;
    }
}
#pragma mark - end

#pragma mark - IBActions
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

- (IBAction)chatButtonAction:(id)sender
{

    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalChatViewController *otherUserProfile =[storyboard instantiateViewControllerWithIdentifier:@"PersonalChatViewController"];
    NSXMLElement *msg = [NSXMLElement elementWithName:@"message"];
    [msg addAttributeWithName:@"type" stringValue:@"chat"];
    
    [msg addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@52.74.174.129",[[[userDataArray objectAtIndex:selectedIndex] joinedUserName] lowercaseString]]];
    
    [msg addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@52.74.174.129",[[UserDefaultManager getValue:@"userName"] lowercaseString]]];
    
    [msg addAttributeWithName:@"ToName" stringValue:[[userDataArray objectAtIndex:selectedIndex] joinedUserName]];
    otherUserProfile.userXmlDetail = msg;
    otherUserProfile.friendProfileImageView = userImageView.image;
    otherUserProfile.lastView = @"MeTooUserProfile";
    [self.navigationController pushViewController:otherUserProfile animated:YES];

}
- (IBAction)seeOutbutonAction:(id)sender
{
     [self performSelector:@selector(seeOutUser) withObject:nil afterDelay:0.1];
}
#pragma mark - end
#pragma mark - Tap to see out webservice
-(void)seeOutUser
{
    [[WebService sharedManager] seeOutNotification:[[userDataArray objectAtIndex:selectedIndex] joinedUserId] success:^(id responseObject) {
        
        [myDelegate stopIndicator];
        [self.view makeToast:@"Sent Successfully"];
        
    } failure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end
@end
