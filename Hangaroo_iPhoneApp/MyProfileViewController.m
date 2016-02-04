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

@interface MyProfileViewController ()
{
    NSMutableArray *notificationsArray;
     NSMutableArray *myProfileArray;
    CoolNavi *headerView;
    UIView * footerView;
    int totalNotifications;
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
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    notificationsArray=[[NSMutableArray alloc]init];
    myProfileArray=[[NSMutableArray alloc]init];

}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[self navigationController] setNavigationBarHidden:NO];
     [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [headerView deallocHeaderView];
    headerView.scrollView=Nil;
    [headerView removeFromSuperview];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[self navigationController] setNavigationBarHidden:YES];
    [notificationsArray removeAllObjects];
      [self initFooterView];
    Offset=@"0";
    [myDelegate ShowIndicator];
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



#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        if (myProfileArray.count==0) {
            return 300;
        }
        else
        {
        return 0;
        }
    }
    else
        return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else if (section == 2)
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
        return 40;
        
    }
    else if (indexPath.section == 1)
    {
        if (myProfileArray.count!=0)
        {
            
            if ([[[myProfileArray objectAtIndex:indexPath.row]userInterest] isEqualToString:@""] )
            {
                return 0;
            }
            else
            {
                MyProfileDataModel *profileData;
                profileData=[myProfileArray objectAtIndex:indexPath.row];
                CGSize size = CGSizeMake(self.view.bounds.size.width-76,999);
                CGRect textRect = [profileData.userInterest
                                   boundingRectWithSize:size
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]}
                                   context:nil];

                return 10+textRect.size.height;
            }
        }
        else
        {
            return 0;
        }
    }
    else if (indexPath.section == 2)
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
        ProfileTableViewCell *locationCell ;
        NSString *simpleTableIdentifier = @"locationCell";
        locationCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (locationCell == nil)
        {
            locationCell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        if (myProfileArray.count!=0) {
            MyProfileDataModel *data=[myProfileArray objectAtIndex:indexPath.row];
            [locationCell displayData:data :(int)indexPath.row];
        }
        
        return locationCell;
    }
    else if (indexPath.section==1)
    {
        
        ProfileTableViewCell *interestCell;
        NSString *simpleTableIdentifier = @"interestCell";
        interestCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (interestCell == nil)
        {
            interestCell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        if (myProfileArray.count!=0)
        {
            MyProfileDataModel *data=[myProfileArray objectAtIndex:indexPath.row];
            interestCell.interestLabel.translatesAutoresizingMaskIntoConstraints=YES;
            interestCell.titleLabel.translatesAutoresizingMaskIntoConstraints=YES;
            interestCell.titleLabel.frame=CGRectMake(20, 10, interestCell.titleLabel.frame.size.width, interestCell.titleLabel.frame.size.height);
            
            CGSize size = CGSizeMake(self.view.bounds.size.width-76,999);
            
            CGRect textRect=[data.userInterest
                                     boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]}
                                     context:nil];
            textRect.origin.x = interestCell.interestLabel.frame.origin.x;
            textRect.origin.y = interestCell.interestLabel.frame.origin.y;
            interestCell.interestLabel.numberOfLines = 0;
            interestCell.interestLabel.text=data.userInterest;
            interestCell.interestLabel.frame=textRect;

        }
        
               return interestCell;
        
    }
    else if (indexPath.section==2)
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
      //  NSMutableDictionary * dataDict = [cartArray objectAtIndex:indexPath.row];
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
            notificationCell.userImage.hidden=YES;
            notificationCell.seperatorLabel.hidden=YES;
        }

            return notificationCell;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    UIViewController *searchView =[storyboard instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
    //    [self.navigationController pushViewController:searchView animated:YES];
    
    //    if (indexPath.section==1 && indexPath.row == 0){
    //        giftMessageBackgroundView.hidden = NO;
    //
    //    }
    
}
#pragma mark - end

#pragma mark - pagignation for table view
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (notificationsArray.count ==totalNotifications)
    {
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] stopAnimating];
        [(UILabel *)[footerView viewWithTag:11] setHidden:true];
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
            //You can add an activity indicator in tableview's footer in viewDidLoad to show a loading status to user.
        }
    }
}

-(void)initFooterView
{
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 40.0)];
    UIActivityIndicatorView * actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actInd.color=[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0];
    UILabel *footerLabel=[[UILabel alloc]init];
    footerLabel.tag=11;
    footerLabel.frame=CGRectMake(self.view.frame.size.width/2, 10.0, 80.0, 20.0);
    footerLabel.text=@"Loading...";
    footerLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:12.0];
    footerLabel.textColor=[UIColor grayColor];
    actInd.tag = 10;
    actInd.frame = CGRectMake(self.view.frame.size.width/2-10, 10.0, 20.0, 20.0);
    actInd.hidesWhenStopped = YES;
    [footerView addSubview:actInd];
  //  [footerView addSubview:footerLabel];
    footerLabel=nil;
    actInd = nil;
}
#pragma mark - end


#pragma mark - My profile webservice
-(void)getMyProfileData
{
    [[WebService sharedManager]myProfile:^(id profileDataArray)
    {
        
        [self getUserNotification];
        
        [myDelegate StopIndicator];
        myProfileArray = [profileDataArray mutableCopy];
       
        headerView = [[CoolNavi alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)backGroudImage:@"" headerImageURL:[[myProfileArray objectAtIndex:0]profileImageUrl] title:[[myProfileArray objectAtIndex:0]userName] facebookBtn:@"facebook_profile.png" instagramBtn:@"insta_profile.png" twitterBtn:@"twit_profile.png" settingsBtn:@"setting_icon.png"];
       
        headerView.scrollView = self.myProfileTableView;
       
        if ([[[myProfileArray objectAtIndex:0]fbUrl] isEqualToString:@""]&&[[[myProfileArray objectAtIndex:0]twitUrl] isEqualToString:@""]&&[[[myProfileArray objectAtIndex:0]instaUrl] isEqualToString:@""])
        {
            headerView.facebookButton.enabled=NO;
            headerView.twitterButton.enabled=NO;
            headerView.instaButton.enabled=NO;
        }
        if(![[[myProfileArray objectAtIndex:0]fbUrl] isEqualToString:@""])
        {
            [headerView.facebookButton setImage:[UIImage imageNamed:@"facebook_org.png"] forState:UIControlStateNormal];
            headerView.facebookButton.enabled=YES;
        }
        else
        {
            headerView.facebookButton.enabled=NO;
        }
        if(![[[myProfileArray objectAtIndex:0]twitUrl] isEqualToString:@""])
        {
            [headerView.twitterButton setImage:[UIImage imageNamed:@"twit_org.png"] forState:UIControlStateNormal];
            headerView.twitterButton.enabled=YES;
        }
        else
        {
            headerView.twitterButton.enabled=NO;
        }
        if(![[[myProfileArray objectAtIndex:0]instaUrl] isEqualToString:@""])
        {
            [headerView.instaButton setImage:[UIImage imageNamed:@"insta_org.png"] forState:UIControlStateNormal];
            headerView.instaButton.enabled=YES;
            
        }
        else
        {
            headerView.instaButton.enabled=NO;
        }

        
        [headerView.settings addTarget:self action:@selector(settingsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
         [headerView.facebookButton addTarget:self action:@selector(facebookBtnAction:) forControlEvents:UIControlEventTouchUpInside];
          [headerView.instaButton addTarget:self action:@selector(instagramBtnAction:) forControlEvents:UIControlEventTouchUpInside];
          [headerView.twitterButton addTarget:self action:@selector(twitterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
        headerView.imgActionBlock = ^(){
            NSLog(@"headerImageAction");
        };
      
        [self.view addSubview:headerView];
        [myProfileTableView reloadData];
        
    }
        failure:^(NSError *error)
     {
         
     }] ;
    

}
#pragma mark - end

#pragma mark - User notification webservice
-(void)getUserNotification
{
   
    [[WebService sharedManager]getUserNotification:[NSString stringWithFormat:@"%@",Offset] success:^(id notificationDataArray)
     {
         [myDelegate StopIndicator];
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
