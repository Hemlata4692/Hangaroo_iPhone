//
//  FriendListViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 04/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "FriendListViewController.h"
#import "FriendListTableCell.h"
#import "OtherUserProfileViewController.h"
#import "FriendListDataModel.h"
#import "UIView+Toast.h"

@interface FriendListViewController ()
{
   NSMutableArray* friendListArray;
    UIView *footerView;
    int totalFriends;
    
}
@property(nonatomic, strong) NSString *Offset;
@property(nonatomic, strong) NSString *friendUserId;


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *friendListTableView;
@end

@implementation FriendListViewController
@synthesize Offset,friendListTableView,otherUserId;
@synthesize friendUserId;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName=@"Friend list";
    // Do any additional setup after loading the view.
    friendListArray=[[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title=@"Friends";
    [friendListArray removeAllObjects];
    [self initFooterView];
    Offset=@"0";
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getFriendList) withObject:nil afterDelay:0.1];
    
}
#pragma mark - end

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return friendListArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendListTableCell *friendCell ;
    NSString *simpleTableIdentifier = @"friendCell";
    friendCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (friendCell == nil)
    {
        friendCell = [[FriendListTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (friendListArray.count!=0)
    {
        FriendListDataModel *data=[friendListArray objectAtIndex:indexPath.row];
        friendUserId=data.userId;
        [friendCell displayData:data :(int)indexPath.row];
    }
    [friendCell.requestSentButton addTarget:self action:@selector(sendRequest:) forControlEvents:UIControlEventTouchUpInside];
    return friendCell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherUserProfileViewController *otherUserProfile =[storyboard instantiateViewControllerWithIdentifier:@"OtherUserProfileViewController"];
    otherUserProfile.otherUserId=friendUserId;
    [self.navigationController pushViewController:otherUserProfile animated:YES];
}
#pragma mark - end

#pragma mark - pagignation for table view
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (friendListArray.count ==totalFriends)
    {
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] stopAnimating];
        [(UILabel *)[footerView viewWithTag:11] setHidden:true];
    }
    else if(indexPath.row==[friendListArray count]-1) //self.array is the array of items you are displaying
    {
        if(friendListArray.count <= totalFriends)
        {
            tableView.tableFooterView = footerView;
            [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
            [self getFriendList];
        }
        else
        {
            friendListTableView.tableFooterView = nil;
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
- (IBAction)sendRequest:(UIButton *)sender
{
    [myDelegate ShowIndicator];
    [self performSelector:@selector(sendFriendRequest) withObject:nil afterDelay:0.1];

}
#pragma mark - Friend list webservice
-(void)getFriendList
{
    [[WebService sharedManager]getFriendList:Offset otherUserId:otherUserId success:^(id friendListDataArray)
     {
         [myDelegate StopIndicator];
        if (friendListArray.count<=0) {
              friendListArray=[friendListDataArray mutableCopy];
         }
         else
         {
             [friendListArray addObjectsFromArray:friendListArray];
         }
         
         totalFriends= [[friendListArray objectAtIndex:friendListArray.count-1]intValue];
         [friendListArray removeLastObject];
         Offset=[NSString stringWithFormat:@"%lu",(unsigned long)friendListArray.count];
         [friendListTableView reloadData];
         
     }                                     failure:^(NSError *error)
     {
         
     }] ;
}
#pragma mark - end
#pragma mark - Send request webservice
-(void)sendFriendRequest
{
    [[WebService sharedManager]sendFriendRequest:friendUserId success:^(id responseObject)
     {
         [myDelegate StopIndicator];
         //[addFriendBtn setImage:[UIImage imageNamed:@"user_accepted.png"] forState:UIControlStateNormal];
         [self.view makeToast:@"Request Sent"];
        // addFriendBtn.userInteractionEnabled=NO;
     }
                                         failure:^(NSError *error)
     {
         
     }] ;
}
#pragma mark - end

@end
