//
//  OtherUserProfileViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 04/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "OtherUserProfileViewController.h"

@interface OtherUserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLocationLabel;
@property (weak, nonatomic) IBOutlet UIButton *friendBtn;
@property (weak, nonatomic) IBOutlet UILabel *seperatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestTitle;
@property (weak, nonatomic) IBOutlet UILabel *userInterestLabel;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *tapToSeeOutBtn;
@property (weak, nonatomic) IBOutlet UIButton *instagramBtn;
@property (weak, nonatomic) IBOutlet UIButton *twitterBtn;
@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *addFriendBtn;

@end

@implementation OtherUserProfileViewController
@synthesize scrollView,mainContainerView;
@synthesize profileImage,userNameLabel,userInterestLabel,userLocationLabel,seperatorLabel,interestTitle;
@synthesize facebookBtn,friendBtn,instagramBtn,chatBtn,tapToSeeOutBtn,twitterBtn,addFriendBtn;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setFrames];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setFrames
{
    interestTitle.translatesAutoresizingMaskIntoConstraints=YES;
    userInterestLabel.translatesAutoresizingMaskIntoConstraints=YES;
    chatBtn.translatesAutoresizingMaskIntoConstraints=YES;
    tapToSeeOutBtn.translatesAutoresizingMaskIntoConstraints=YES;
   
    interestTitle.frame=CGRectMake(20, seperatorLabel.frame.origin.y+seperatorLabel.frame.size.height+10, interestTitle.frame.size.width, interestTitle.frame.size.height);
    
    CGSize size = CGSizeMake(self.view.bounds.size.width-76,999);
    
    CGRect textRect=[@"hgfhgfyewufy ffhfgjhffhff fjfhjrhfhrejf hrjghjrhfghrthtyhjy"
                     boundingRectWithSize:size
                     options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]}
                     context:nil];
    textRect.origin.x = userInterestLabel.frame.origin.x;
    textRect.origin.y = seperatorLabel.frame.origin.y+seperatorLabel.frame.size.height+10;
    userInterestLabel.numberOfLines = 0;
    userInterestLabel.text=@"hgfhgfyewufy ffhfgjhffhff fjfhjrhfhrejf hrjghjrhfghrthtyhjy";
    userInterestLabel.frame=textRect;
    
    chatBtn.frame=CGRectMake(0, userInterestLabel.frame.origin.y+userInterestLabel.frame.size.height+10, self.view.frame.size.width/2, chatBtn.frame.size.height);
    tapToSeeOutBtn.frame=CGRectMake(self.view.frame.size.width/2, userInterestLabel.frame.origin.y+userInterestLabel.frame.size.height+10, self.view.frame.size.width/2, tapToSeeOutBtn.frame.size.height);

    
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)instagramBtnAction:(id)sender {
}
- (IBAction)twitterBtnAction:(id)sender {
}
- (IBAction)facebookBtnAction:(id)sender {
}
- (IBAction)friendListBtnAction:(id)sender {
}
- (IBAction)tapToSeeOutBtnAction:(id)sender {
}
- (IBAction)chatBtnAction:(id)sender {
}
- (IBAction)addFriendBtnAction:(id)sender {
}

#pragma mark - end
@end
