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

@interface MeTooUserProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *followedUserLabel;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIButton *tapToSeeOutBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property(nonatomic,retain) NSString * postedPostId;
@end

@implementation MeTooUserProfileViewController
@synthesize postLabel,followedUserLabel,userNameLabel,postedPostId;
@synthesize userImageView,mainContainerView,tapToSeeOutBtn,joineUserId;
@synthesize userName,userProfileImageUrl,post,postID,followedUser,chatBtn;

#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.screenName = @"Me too user profile screen";
    [mainContainerView setCornerRadius:3.0f];
    [self displayData];
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
//-(BOOL)hidesBottomBarWhenPushed
//{
//    return NO;
//}
#pragma mark - end

#pragma mark - Display data
-(void)displayData
{
    if ([joineUserId isEqualToString:[UserDefaultManager getValue:@"userId"]]) {
        tapToSeeOutBtn.enabled=NO;
        chatBtn.enabled=NO;
    }
    else
    {
        tapToSeeOutBtn.enabled=YES;
        chatBtn.enabled=YES;

    }
    userNameLabel.text=userName;
    postLabel.text=post;
    postedPostId=postID;
    followedUserLabel.text=followedUser;
    __weak UIImageView *weakRef = userImageView;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:userProfileImageUrl]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [userImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"placeholder.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];

}
- (BOOL) hidesBottomBarWhenPushed
{
    return (self.navigationController.topViewController == self);
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
    //[self.navigationController popViewControllerAnimated:NO];
    // [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)chatButtonAction:(id)sender
{

    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalChatViewController *otherUserProfile =[storyboard instantiateViewControllerWithIdentifier:@"PersonalChatViewController"];
    NSXMLElement *msg = [NSXMLElement elementWithName:@"message"];
    [msg addAttributeWithName:@"type" stringValue:@"chat"];
    
    [msg addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@52.74.174.129",[userName lowercaseString]]];
    
    [msg addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@52.74.174.129",[[UserDefaultManager getValue:@"userName"] lowercaseString]]];
    
    [msg addAttributeWithName:@"ToName" stringValue:userName];
    
    //    otherUserProfile.meeToProfile=@"1";
    //    otherUserProfile.userNameProfile=userName;
    otherUserProfile.userXmlDetail = msg;
    otherUserProfile.friendProfileImageView = userImageView.image;
    otherUserProfile.lastView = @"MeTooUserProfile";
    //     self.hidesBottomBarWhenPushed = NO;
    //    otherUserProfile.hidesBottomBarWhenPushed=NO;
    [self.navigationController pushViewController:otherUserProfile animated:YES];

}
- (IBAction)seeOutbutonAction:(id)sender
{
    //    [myDelegate showIndicator];
     [self performSelector:@selector(seeOutUser) withObject:nil afterDelay:0.1];
}
#pragma mark - end
#pragma mark - Tap to see out webservice
-(void)seeOutUser
{
    NSLog(@"user id %@",joineUserId);
    [[WebService sharedManager] seeOutNotification:joineUserId success:^(id responseObject) {
        
        [myDelegate stopIndicator];
        [self.view makeToast:@"Sent Successfully"];
        
    } failure:^(NSError *error) {
        
    }] ;

}
#pragma mark - end
@end
