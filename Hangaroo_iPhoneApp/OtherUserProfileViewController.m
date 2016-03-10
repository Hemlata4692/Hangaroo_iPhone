//
//  OtherUserProfileViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 04/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "OtherUserProfileViewController.h"
#import "OtherUserProfileDataModel.h"
#import "UIView+Toast.h"
#import "LoadWebPagesViewController.h"
#import "FriendListViewController.h"
#import "PersonalChatViewController.h"

@interface OtherUserProfileViewController ()
{
    NSMutableArray *otherUserProfileArray;
}
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
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property(nonatomic,retain)NSString * isFriend;
@property(nonatomic,retain)NSString * isRequestSent;
@end

@implementation OtherUserProfileViewController
@synthesize scrollView,mainContainerView;
@synthesize profileImage,userNameLabel,userInterestLabel,userLocationLabel,seperatorLabel,interestTitle;
@synthesize facebookBtn,friendBtn,instagramBtn,chatBtn,tapToSeeOutBtn,twitterBtn,addFriendBtn,backBtn;
@synthesize otherUserId,isFriend,isRequestSent;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([[UIScreen mainScreen] bounds].size.height>568)
    {
        scrollView.scrollEnabled=NO;
    }
    otherUserProfileArray=[[NSMutableArray alloc]init];
    backBtn.layer.shadowRadius = 5.0f;
    backBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    backBtn.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    backBtn.layer.shadowOpacity = 0.5f;
    backBtn.layer.masksToBounds = NO;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
//    [[chatBtn layer] setBorderWidth:1.0f];
//    [[chatBtn layer] setBorderColor:[UIColor lightGrayColor].CGColor];
//    
//    [[tapToSeeOutBtn layer] setBorderWidth:1.0f];
//    [[tapToSeeOutBtn layer] setBorderColor:[UIColor lightGrayColor].CGColor];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title=@"Profile";
    [[self navigationController] setNavigationBarHidden:YES];
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [myDelegate showIndicator];
    [self performSelector:@selector(getOtherUserProfileData) withObject:nil afterDelay:0.1];
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
//    [[self navigationController] setNavigationBarHidden:NO];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
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

-(void)setFrames
{
    interestTitle.translatesAutoresizingMaskIntoConstraints=YES;
    userInterestLabel.translatesAutoresizingMaskIntoConstraints=YES;
    chatBtn.translatesAutoresizingMaskIntoConstraints=YES;
    tapToSeeOutBtn.translatesAutoresizingMaskIntoConstraints=YES;
   
    if ([[[otherUserProfileArray objectAtIndex:0]userInterest] isEqualToString:@""]) {
        userInterestLabel.hidden=YES;
        interestTitle.hidden=YES;
        chatBtn.frame=CGRectMake(0, seperatorLabel.frame.origin.y+seperatorLabel.frame.size.height+30, self.view.frame.size.width/2, chatBtn.frame.size.height);
        tapToSeeOutBtn.frame=CGRectMake(self.view.frame.size.width/2, seperatorLabel.frame.origin.y+seperatorLabel.frame.size.height+30, self.view.frame.size.width/2, tapToSeeOutBtn.frame.size.height);
//        if([[UIScreen mainScreen] bounds].size.height==568)
//        {
//            chatBtn.frame=CGRectMake(0, seperatorLabel.frame.origin.y+seperatorLabel.frame.size.height+30, self.view.frame.size.width/2, chatBtn.frame.size.height);
//            tapToSeeOutBtn.frame=CGRectMake(self.view.frame.size.width/2, seperatorLabel.frame.origin.y+seperatorLabel.frame.size.height+30, self.view.frame.size.width/2, tapToSeeOutBtn.frame.size.height);
//        }
//        else if([[UIScreen mainScreen] bounds].size.height==667)
//        {
//            chatBtn.frame=CGRectMake(0, seperatorLabel.frame.origin.y+seperatorLabel.frame.size.height+80, self.view.frame.size.width/2, chatBtn.frame.size.height);
//            tapToSeeOutBtn.frame=CGRectMake(self.view.frame.size.width/2, seperatorLabel.frame.origin.y+seperatorLabel.frame.size.height+80, self.view.frame.size.width/2, tapToSeeOutBtn.frame.size.height);
//        }
//        else if([[UIScreen mainScreen] bounds].size.height==736)
//        {
//            chatBtn.frame=CGRectMake(0, seperatorLabel.frame.origin.y+seperatorLabel.frame.size.height+120, self.view.frame.size.width/2, chatBtn.frame.size.height);
//            tapToSeeOutBtn.frame=CGRectMake(self.view.frame.size.width/2, seperatorLabel.frame.origin.y+seperatorLabel.frame.size.height+120, self.view.frame.size.width/2, tapToSeeOutBtn.frame.size.height);
//        }
    }

    else
    {
        userInterestLabel.hidden=NO;
        interestTitle.hidden=NO;
    interestTitle.frame=CGRectMake(20, seperatorLabel.frame.origin.y+seperatorLabel.frame.size.height+10, interestTitle.frame.size.width, interestTitle.frame.size.height);
    
    CGSize size = CGSizeMake(self.view.frame.size.width-78,999);
    
    CGRect textRect=[[[otherUserProfileArray objectAtIndex:0]userInterest]
                     boundingRectWithSize:size
                     options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]}
                     context:nil];
    textRect.origin.x = userInterestLabel.frame.origin.x;
    textRect.origin.y = seperatorLabel.frame.origin.y+seperatorLabel.frame.size.height+11;
    userInterestLabel.numberOfLines = 0;
    userInterestLabel.text=[[otherUserProfileArray objectAtIndex:0]userInterest];
    userInterestLabel.frame=textRect;
    
    chatBtn.frame=CGRectMake(0, userInterestLabel.frame.origin.y+userInterestLabel.frame.size.height+10, self.view.frame.size.width/2, chatBtn.frame.size.height);
    tapToSeeOutBtn.frame=CGRectMake(self.view.frame.size.width/2, userInterestLabel.frame.origin.y+userInterestLabel.frame.size.height+10, self.view.frame.size.width/2, tapToSeeOutBtn.frame.size.height);
    }
    
}
#pragma mark - end

#pragma mark - Other user profile webservice
-(void)getOtherUserProfileData
{
    [[WebService sharedManager]otherUserProfile:otherUserId success:^(id otherUserDataArray)
     {
         [myDelegate stopIndicator];
         otherUserProfileArray=[otherUserDataArray mutableCopy];
         [self displayData];
         [self setFrames];
         
     }                                     failure:^(NSError *error)
     {
         
     }] ;
}
#pragma mark - end
#pragma mark - Send request webservice
-(void)sendFriendRequest
{
    [[WebService sharedManager]sendFriendRequest:otherUserId success:^(id responseObject)
     {
         [myDelegate stopIndicator];
        [addFriendBtn setImage:[UIImage imageNamed:@"user_accepted.png"] forState:UIControlStateNormal];
         [self.view makeToast:@"Request Sent"];
         addFriendBtn.userInteractionEnabled=NO;
     }
      failure:^(NSError *error)
     {
         
     }] ;
}
#pragma mark - end

#pragma mark - Tap to see out webservice
-(void)seeOutUser
{
    NSLog(@"user id %@",otherUserId);
    [[WebService sharedManager] seeOutNotification:otherUserId success:^(id responseObject) {
        
        [myDelegate stopIndicator];
        [self.view makeToast:@"Sent Successfully"];
        
    } failure:^(NSError *error) {
        
    }] ;
    
}
#pragma mark - end

#pragma mark - Display data for user profile
-(void)displayData
{
    __weak UIImageView *weakRef = profileImage;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[otherUserProfileArray objectAtIndex:0]userImageUrl]]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [profileImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"placeholder.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];

    userNameLabel.text=[[otherUserProfileArray objectAtIndex:0]userName];
    otherUserId=[[otherUserProfileArray objectAtIndex:0]otherUserId];
    isFriend=[[otherUserProfileArray objectAtIndex:0]isFriend];
    isRequestSent=[[otherUserProfileArray objectAtIndex:0]isRequestSent];
    userLocationLabel.text=[[[otherUserProfileArray objectAtIndex:0]userLocation] uppercaseString];
   
    if ([[[otherUserProfileArray objectAtIndex:0]userFbUrl] isEqualToString:@""]&&[[[otherUserProfileArray objectAtIndex:0]usertwitUrl] isEqualToString:@""]&&[[[otherUserProfileArray objectAtIndex:0]userInstaUrl] isEqualToString:@""])
    {
        facebookBtn.enabled=NO;
        twitterBtn.enabled=NO;
        instagramBtn.enabled=NO;
        facebookBtn.adjustsImageWhenDisabled=NO;
        twitterBtn.adjustsImageWhenDisabled=NO;
        instagramBtn.adjustsImageWhenDisabled=NO;
    }
    if(![[[otherUserProfileArray objectAtIndex:0]userFbUrl] isEqualToString:@""])
    {
        [facebookBtn setImage:[UIImage imageNamed:@"facebook_org.png"] forState:UIControlStateNormal];
        facebookBtn.enabled=YES;
    }
    else
    {
       facebookBtn.enabled=NO;
        facebookBtn.adjustsImageWhenDisabled=NO;
    }
    if(![[[otherUserProfileArray objectAtIndex:0]usertwitUrl] isEqualToString:@""])
    {
        [twitterBtn setImage:[UIImage imageNamed:@"twit_org.png"] forState:UIControlStateNormal];
        twitterBtn.enabled=YES;
    }
    else
    {
        twitterBtn.enabled=NO;
        twitterBtn.adjustsImageWhenDisabled=NO;
    }
    if(![[[otherUserProfileArray objectAtIndex:0]userInstaUrl] isEqualToString:@""])
    {
        [instagramBtn setImage:[UIImage imageNamed:@"insta_org.png"] forState:UIControlStateNormal];
        instagramBtn.enabled=YES;
    }
    else
    {
        instagramBtn.enabled=NO;
        instagramBtn.adjustsImageWhenDisabled=NO;
    }
    if ([isRequestSent isEqualToString:@"True"])
    {
        friendBtn.hidden=YES;
        addFriendBtn.hidden=NO;
        [addFriendBtn setImage:[UIImage imageNamed:@"user_accepted.png"] forState:UIControlStateNormal];
        addFriendBtn.userInteractionEnabled=NO;
    }
    else
    {
        if ([isFriend isEqualToString:@"True"]) {
            friendBtn.hidden=NO;
            addFriendBtn.hidden=YES;
        }
        else if ([[UserDefaultManager getValue:@"userId"] isEqualToString:[[otherUserProfileArray objectAtIndex:0]otherUserId]])
        {
            friendBtn.hidden=NO;
            addFriendBtn.hidden=YES;
        }
        else
        {
            friendBtn.hidden=YES;
            addFriendBtn.hidden=NO;
            addFriendBtn.userInteractionEnabled=YES;
            [addFriendBtn setImage:[UIImage imageNamed:@"adduser.png"] forState:UIControlStateNormal];
        }
    }
    NSString *friendString;
    if ([[[otherUserProfileArray objectAtIndex:0]totalFriends] isEqualToString:@"1"] || [[[otherUserProfileArray objectAtIndex:0]totalFriends] isEqualToString:@"0"]) {
        friendString = [NSString stringWithFormat:@"%@ %@",[[otherUserProfileArray objectAtIndex:0]totalFriends],@"FRIEND"];
    }
    else
    {
        friendString = [NSString stringWithFormat:@"%@ %@",[[otherUserProfileArray objectAtIndex:0]totalFriends],@"FRIENDS"];
    }
    NSRange boldedRange = NSMakeRange([[otherUserProfileArray objectAtIndex:0]totalFriends].length, (friendString.length-[[otherUserProfileArray objectAtIndex:0]totalFriends].length));
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:friendString];
    
    [attrString beginEditing];
    [attrString addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"Roboto-Regular" size:14.0]
                       range:boldedRange];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor blackColor]
                       range:NSMakeRange([[otherUserProfileArray objectAtIndex:0]totalFriends].length, (friendString.length-[[otherUserProfileArray objectAtIndex:0]totalFriends].length))];
    
    [attrString endEditing];
  //  friendBtn.titleLabel.attributedText=attrString;
    [friendBtn setAttributedTitle:attrString forState:UIControlStateNormal];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)instagramBtnAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoadWebPagesViewController *loadWebPage =[storyboard instantiateViewControllerWithIdentifier:@"LoadWebPagesViewController"];
    loadWebPage.instagramString=[[otherUserProfileArray objectAtIndex:0]userInstaUrl];
    loadWebPage.navigationTitle=@"Instagram";
    [self.navigationController pushViewController:loadWebPage animated:YES];
}
- (IBAction)twitterBtnAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoadWebPagesViewController *loadWebPage =[storyboard instantiateViewControllerWithIdentifier:@"LoadWebPagesViewController"];
    loadWebPage.twitterString=[[otherUserProfileArray objectAtIndex:0]usertwitUrl];
    loadWebPage.navigationTitle=@"Twitter";
    [self.navigationController pushViewController:loadWebPage animated:YES];
}
- (IBAction)facebookBtnAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoadWebPagesViewController *loadWebPage =[storyboard instantiateViewControllerWithIdentifier:@"LoadWebPagesViewController"];
    loadWebPage.facebookString=[[otherUserProfileArray objectAtIndex:0]userFbUrl];
    loadWebPage.navigationTitle=@"Facebook";
    [self.navigationController pushViewController:loadWebPage animated:YES];
}
- (IBAction)friendListBtnAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FriendListViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"FriendListViewController"];
    view.otherUserId=otherUserId;
    [self.navigationController pushViewController:view animated:YES];
}
- (IBAction)tapToSeeOutBtnAction:(id)sender
{
    [self performSelector:@selector(seeOutUser) withObject:nil afterDelay:0.1];
}
- (IBAction)chatBtnAction:(id)sender
{
    
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalChatViewController *otherUserProfile =[storyboard instantiateViewControllerWithIdentifier:@"PersonalChatViewController"];
    NSXMLElement *msg = [NSXMLElement elementWithName:@"message"];
    [msg addAttributeWithName:@"type" stringValue:@"chat"];
    
    [msg addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@52.74.174.129",[userNameLabel.text lowercaseString]]];
    
    [msg addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@52.74.174.129",[[UserDefaultManager getValue:@"userName"] lowercaseString]]];
    
    [msg addAttributeWithName:@"ToName" stringValue:userNameLabel.text];
    otherUserProfile.userXmlDetail = msg;
    otherUserProfile.friendProfileImageView = profileImage.image;
    otherUserProfile.lastView = @"MeTooUserProfile";
   //same functionality as me too 
    [self.navigationController pushViewController:otherUserProfile animated:YES];
}

- (IBAction)addFriendBtnAction:(id)sender
{
    //[myDelegate showIndicator];
    [self performSelector:@selector(sendFriendRequest) withObject:nil afterDelay:0.1];
}

#pragma mark - end
@end
