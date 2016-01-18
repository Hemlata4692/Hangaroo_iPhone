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

@interface MeTooUserProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *followedUserLabel;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIButton *tapToSeeOutBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property(nonatomic,retain) NSString * postedPostId;
@end

@implementation MeTooUserProfileViewController
@synthesize postLabel,followedUserLabel,userNameLabel,postedPostId;
@synthesize userImageView,mainContainerView,tapToSeeOutBtn;
@synthesize userName,userProfileImageUrl,post,postID,followedUser;

#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [mainContainerView setCornerRadius:3.0f];
    
    [self displayData];
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

#pragma mark - Display data
-(void)displayData
{
    userNameLabel.text=userName;
    postLabel.text=post;
    postedPostId=postID;
    followedUserLabel.text=followedUser;
    __weak UIImageView *weakRef = userImageView;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:userProfileImageUrl]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [userImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];

}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)closeButtonAction:(id)sender
{
     [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)chatButtonAction:(id)sender {
}
- (IBAction)seeOutbutonAction:(id)sender {
}
#pragma mark - end

@end
