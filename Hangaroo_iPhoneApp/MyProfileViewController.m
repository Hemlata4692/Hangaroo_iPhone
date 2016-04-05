//
//  MyProfileViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 04/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MyProfileViewController.h"
#import "SettingViewController.h"
#import "ProfileTableViewCell.h"
#import "CoolNavi.h"
#import "MyProfileDataModel.h"
#import "LoadWebPagesViewController.h"
#import "NotificationDataModel.h"
#import "FriendListViewController.h"
#import "OtherUserProfileViewController.h"
#import "MyButton.h"

@interface MyProfileViewController ()
{
    NSMutableArray *notificationsArray;
    NSMutableArray *myProfileArray;
    CoolNavi *headerView;
    UIView * footerView;
    int totalNotifications;
    int btnTag;
}
@property (weak, nonatomic) IBOutlet UITableView *myProfileTableView;
@property(nonatomic, strong) NSString *Offset;
@end

@implementation MyProfileViewController
@synthesize myProfileTableView,Offset;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.screenName = @"Profile screen";
    Offset=@"0";
    notificationsArray=[[NSMutableArray alloc]init];
    myProfileArray=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myProfileData) name:@"MyProfileData" object:nil];
    
}

-(void)myProfileData{
    [myDelegate removeBadgeIconLastTab];
    [self performSelector:@selector(getMyProfileData) withObject:nil afterDelay:0.1];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    myDelegate.myView=@"other";
    [headerView deallocHeaderView];
    headerView.scrollView=Nil;
    [headerView removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[self navigationController] setNavigationBarHidden:YES];
    myDelegate.myView=@"MyProfileViewController";
    [notificationsArray removeAllObjects];
    [myProfileTableView reloadData];
    [myProfileArray removeAllObjects];
    [(UIActivityIndicatorView *)[footerView viewWithTag:10] setHidden:true];
    myProfileTableView.tableFooterView = nil;
    [myDelegate removeBadgeIconLastTab];
    [self initFooterView];
    Offset=@"0";
    [myDelegate showIndicator];
    myProfileTableView.hidden=YES;
    [self performSelector:@selector(getMyProfileData) withObject:nil afterDelay:0.1];
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

#pragma mark - Table view delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        if (notificationsArray.count==0) {
            return 1;
        }
        else
        {
            return notificationsArray.count;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 35;
    }
    else{
        return 70;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        ProfileTableViewCell *titleCell ;
        NSString *simpleTableIdentifier = @"titleCell";
        titleCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (titleCell == nil)
        {
            titleCell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        return titleCell;
    }
    else
    {
        ProfileTableViewCell *notificationCell ;
        NSString *simpleTableIdentifier = @"notificationCell";
        notificationCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (notificationCell == nil)
        {
            notificationCell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        if (notificationsArray.count!=0)
        {
            notificationCell.noNotificationFound.hidden=YES;
            notificationCell.notificationLabel.hidden=NO;
            notificationCell.userImage.hidden=NO;
            notificationCell.seperatorLabel.hidden=NO;
            NotificationDataModel *data=[notificationsArray objectAtIndex:indexPath.row];
            [notificationCell displayNotificationData:data :(int)indexPath.row];
        }
        else
        {
            notificationCell.noNotificationFound.hidden=NO;
            notificationCell.notificationLabel.hidden=YES;
            notificationCell.notificationLabel.text=@"";
            notificationCell.noNotificationFound.text=@"No notifications found.";
            notificationCell.userImage.hidden=YES;
            notificationCell.seperatorLabel.hidden=YES;
            notificationCell.notificationPhoto.hidden=YES;
        }
        [notificationCell.userProfileBtn addTarget:self action:@selector(openUserProfileButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        notificationCell.userProfileBtn.Tag=(int)indexPath.row;
        return notificationCell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        ProfileTableViewCell *notificationCell ;
        NSString *simpleTableIdentifier = @"notificationCell";
        notificationCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        NotificationDataModel *data=[notificationsArray objectAtIndex:indexPath.row];
        if ([data.notificationString rangeOfString:@"wants to see you out"].location == NSNotFound && [data.notificationString rangeOfString:@"shares your sentiments"].location==NSNotFound && [data.notificationString rangeOfString:@"liked your photo"].location == NSNotFound)
        {
            //string not match
        }
        else
        {
            UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            OtherUserProfileViewController *otherUserProfile =[storyboard instantiateViewControllerWithIdentifier:@"OtherUserProfileViewController"];
            otherUserProfile.otherUserId=[[notificationsArray objectAtIndex:indexPath.row]senderId];
            [self.navigationController pushViewController:otherUserProfile animated:YES];
        }
    }
}
#pragma mark - end

#pragma mark - Pagignation for table view
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (notificationsArray.count ==totalNotifications)
    {
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] stopAnimating];
        [(UILabel *)[footerView viewWithTag:11] setHidden:true];
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] setHidden:true];
    }
    else if(indexPath.row==[notificationsArray count]-1) //self.array is the array of items you are displaying
    {
        if(notificationsArray.count <= totalNotifications)
        {
            tableView.tableFooterView = footerView;
            [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
            [self getUserNotification];
        }
        else
        {
            myProfileTableView.tableFooterView = nil;
        }
    }
}
//Load footer view in table
-(void)initFooterView
{
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 40.0)];
    UIActivityIndicatorView * actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actInd.color=[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0];
    actInd.tag = 10;
    actInd.frame = CGRectMake(self.view.frame.size.width/2-10, 10.0, 20.0, 20.0);
    actInd.hidesWhenStopped = YES;
    [footerView addSubview:actInd];
    actInd = nil;
}
#pragma mark - end

#pragma mark - My profile webservice
-(void)getMyProfileData
{
    [[WebService sharedManager]myProfile:^(id profileDataArray)
     {
         [self getUserNotification];
         myProfileArray = [profileDataArray mutableCopy];
         [self addHeaderView];
         
     }
                                 failure:^(NSError *error)
     {
     }] ;
}
#pragma mark - end

#pragma mark - Add header view
-(void)addHeaderView
{
    MyProfileDataModel *profileData;
    profileData=[myProfileArray objectAtIndex:0];
    CGSize size = CGSizeMake(self.view.bounds.size.width-76,999);
    CGRect textRect = [profileData.userInterest
                       boundingRectWithSize:size
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]}
                       context:nil];
    if ([profileData.userInterest isEqualToString:@""]) {
        textRect.size.height=0.0;
    }
    else
    {
        textRect.size.height=10+textRect.size.height;
    }
    headerView = [[CoolNavi alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300 + textRect.size.height + 45)backGroudImage:[[myProfileArray objectAtIndex:0]profileImageUrl] headerImageURL:[[myProfileArray objectAtIndex:0]profileImageUrl] title:[[myProfileArray objectAtIndex:0]userName] facebookBtn:@"facebook_profile.png" instagramBtn:@"insta_profile.png" twitterBtn:@"twit_profile.png" settingsBtn:@"setting_icon.png" interestLabelFrame:textRect interestText:profileData.userInterest];
    headerView.scrollView = self.myProfileTableView;
    headerView.locationLabel.text=[profileData.university uppercaseString];
    NSString *attributedString;
    if ([profileData.totalFriends isEqualToString:@"1"] || [profileData.totalFriends isEqualToString:@"0"]) {
        attributedString = [NSString stringWithFormat:@"%@ %@",profileData.totalFriends,@"FRIEND"];
    }
    else
    {
        attributedString = [NSString stringWithFormat:@"%@ %@",profileData.totalFriends,@"FRIENDS"];
    }
    NSRange boldedRange = NSMakeRange(profileData.totalFriends.length, (attributedString.length-profileData.totalFriends.length));
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:attributedString];
    [attrString beginEditing];
    [attrString addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"Roboto-Regular" size:14.0]
                       range:boldedRange];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor blackColor]
                       range:NSMakeRange(profileData.totalFriends.length, (attributedString.length-profileData.totalFriends.length))];
    [attrString endEditing];
    [headerView.friendsListButton setAttributedTitle:attrString forState:UIControlStateNormal];
    textRect.origin.x = headerView.interestLabel.frame.origin.x;
    textRect.origin.y = headerView.interestLabel.frame.origin.y;
    headerView.interestLabel.numberOfLines = 0;
    headerView.interestLabel.text=profileData.userInterest;
    headerView.interestLabel.frame=textRect;
    if ([[[myProfileArray objectAtIndex:0]fbUrl] isEqualToString:@""]&&[[[myProfileArray objectAtIndex:0]twitUrl] isEqualToString:@""]&&[[[myProfileArray objectAtIndex:0]instaUrl] isEqualToString:@""])
    {
        headerView.facebookButton.enabled=NO;
        headerView.twitterButton.enabled=NO;
        headerView.instaButton.enabled=NO;
        headerView.facebookButton.adjustsImageWhenDisabled=NO;
        headerView.twitterButton.adjustsImageWhenDisabled=NO;
        headerView.instaButton.adjustsImageWhenDisabled=NO;
    }
    if(![[[myProfileArray objectAtIndex:0]fbUrl] isEqualToString:@""])
    {
        [headerView.facebookButton setImage:[UIImage imageNamed:@"facebook_org.png"] forState:UIControlStateNormal];
        headerView.facebookButton.enabled=YES;
    }
    else
    {
        headerView.facebookButton.enabled=NO;
        headerView.facebookButton.adjustsImageWhenDisabled=NO;
    }
    if(![[[myProfileArray objectAtIndex:0]twitUrl] isEqualToString:@""])
    {
        [headerView.twitterButton setImage:[UIImage imageNamed:@"twit_org.png"] forState:UIControlStateNormal];
        headerView.twitterButton.enabled=YES;
    }
    else
    {
        headerView.twitterButton.enabled=NO;
        headerView.twitterButton.adjustsImageWhenDisabled=NO;
    }
    if(![[[myProfileArray objectAtIndex:0]instaUrl] isEqualToString:@""])
    {
        [headerView.instaButton setImage:[UIImage imageNamed:@"insta_org.png"] forState:UIControlStateNormal];
        headerView.instaButton.enabled=YES;
    }
    else
    {
        headerView.instaButton.enabled=NO;
        headerView.instaButton.adjustsImageWhenDisabled=NO;
    }
    [headerView.settings addTarget:self action:@selector(settingsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.facebookButton addTarget:self action:@selector(facebookBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.instaButton addTarget:self action:@selector(instagramBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.twitterButton addTarget:self action:@selector(twitterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.friendsListButton addTarget:self action:@selector(showFriendListButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    headerView.imgActionBlock = ^(){
        //image action
    };
    
    [self.view addSubview:headerView];
    [myProfileTableView reloadData];
}
#pragma mark - end

#pragma mark - User notification webservice
-(void)getUserNotification
{
    [[WebService sharedManager]getUserNotification:[NSString stringWithFormat:@"%@",Offset] success:^(id notificationDataArray)
     {
         [myDelegate stopIndicator];
         myProfileTableView.hidden=NO;
         if (notificationsArray.count<=0) {
             notificationsArray =[notificationDataArray mutableCopy];
         }
         else
         {
             [notificationsArray addObjectsFromArray:notificationDataArray];
         }
         totalNotifications= [[notificationsArray objectAtIndex:notificationsArray.count-1]intValue];
         [notificationsArray removeLastObject];
         Offset=[NSString stringWithFormat:@"%lu",(unsigned long)notificationsArray.count];
         [myProfileTableView reloadData];
     }
                                           failure:^(NSError *error)
     {
         
     }] ;
}
#pragma mark - end
#pragma mark - IBActions
- (IBAction)openUserProfileButtonAction:(id)sender
{
    btnTag=[sender Tag];
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherUserProfileViewController *otherUserProfile =[storyboard instantiateViewControllerWithIdentifier:@"OtherUserProfileViewController"];
    otherUserProfile.otherUserId=[[notificationsArray objectAtIndex:btnTag]senderId];
    [self.navigationController pushViewController:otherUserProfile animated:YES];
    
}
- (IBAction)showFriendListButtonAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FriendListViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"FriendListViewController"];
    view.otherUserId=@"0";
    [self.navigationController pushViewController:view animated:YES];
}
- (IBAction)settingsBtnAction:(UIButton *)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *settingsView =[storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    settingsView.myProfileData=[myProfileArray objectAtIndex:0];
    [self.navigationController pushViewController:settingsView animated:YES];
}
- (IBAction)instagramBtnAction:(UIButton *)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoadWebPagesViewController *loadWebPage =[storyboard instantiateViewControllerWithIdentifier:@"LoadWebPagesViewController"];
    loadWebPage.instagramString=[[myProfileArray objectAtIndex:0]instaUrl];
    loadWebPage.navigationTitle=@"Instagram";
    [self.navigationController pushViewController:loadWebPage animated:YES];
}

- (IBAction)twitterBtnAction:(UIButton *)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoadWebPagesViewController *loadWebPage =[storyboard instantiateViewControllerWithIdentifier:@"LoadWebPagesViewController"];
    loadWebPage.twitterString=[[myProfileArray objectAtIndex:0]twitUrl];
    loadWebPage.navigationTitle=@"Twitter";
    [self.navigationController pushViewController:loadWebPage animated:YES];
}

- (IBAction)facebookBtnAction:(UIButton *)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoadWebPagesViewController *loadWebPage =[storyboard instantiateViewControllerWithIdentifier:@"LoadWebPagesViewController"];
    loadWebPage.facebookString=[[myProfileArray objectAtIndex:0]fbUrl];
    loadWebPage.navigationTitle=@"Facebook";
    [self.navigationController pushViewController:loadWebPage animated:YES];
}
#pragma mark - end
@end
