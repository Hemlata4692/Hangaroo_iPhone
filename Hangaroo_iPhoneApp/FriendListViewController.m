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
#import "MyProfileViewController.h"
#import "MyButton.h"

@interface FriendListViewController ()
{
   NSMutableArray* friendListArray;
    UIRefreshControl *refreshControl;
    NSArray* searchArray;
    UIView *footerView;
    int totalFriends;
    int btnTag;
    BOOL isSearch;
}
@property(nonatomic, strong) NSString *Offset;
@property(nonatomic, strong) NSString *friendUserId;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLbl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *friendListTableView;
@end

@implementation FriendListViewController
@synthesize Offset,friendListTableView,otherUserId;
@synthesize friendUserId,searchBar,noRecordLbl;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName=@"Friend list";
    // Do any additional setup after loading the view.
    friendListArray=[[NSMutableArray alloc]init];
    searchArray=[[NSArray alloc]init];
    noRecordLbl.hidden=YES;
     searchBar.enablesReturnKeyAutomatically = NO;
    searchBar.returnKeyType=UIReturnKeyDone;
    
    // Pull To Refresh
    refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, 10, 10)];
    [self.friendListTableView addSubview:refreshControl];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@""];
    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
    refreshControl.attributedTitle = refreshString;
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    self.friendListTableView.alwaysBounceVertical = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[self navigationController] setNavigationBarHidden:NO];
    self.navigationItem.title=@"Friends";
    [friendListArray removeAllObjects];
    [friendListTableView setContentOffset:CGPointZero animated:YES];
    [self initFooterView];
    Offset=@"0";
    [myDelegate showIndicator];
    [self performSelector:@selector(getFriendList) withObject:nil afterDelay:0.1];
    
}
#pragma mark - end
#pragma mark - Refresh Table
//Pull to refresh implementation on my submission data
- (void)refreshTable
{
    [friendListArray removeAllObjects];
    Offset=@"0";
    [self performSelector:@selector(getFriendList) withObject:nil afterDelay:0.1];
    [refreshControl endRefreshing];
    [self.friendListTableView reloadData];
}
#pragma mark - end

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (isSearch)
    {
        if (searchArray.count<1) {
            noRecordLbl.hidden=NO;
            return searchArray.count;
        }
        else
        {
            noRecordLbl.hidden=YES;
            return searchArray.count;
        }
    }
    else
    {
    return friendListArray.count;
    }
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
     if (isSearch)
     {
         if (searchArray.count!=0)
         {
         FriendListDataModel *data=[searchArray objectAtIndex:indexPath.row];
         [friendCell displayData:data :(int)indexPath.row];
         }
         else
         {
            noRecordLbl.hidden=NO;
             friendListTableView.hidden=YES;
         }
     }
    else
    {
    if (friendListArray.count!=0)
    {
        FriendListDataModel *data=[friendListArray objectAtIndex:indexPath.row];
        [friendCell displayData:data :(int)indexPath.row];
    }
    }
    friendCell.requestSentButton.Tag=(int)indexPath.row;
    [friendCell.requestSentButton addTarget:self action:@selector(sendRequest:) forControlEvents:UIControlEventTouchUpInside];
    return friendCell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearch) {
        if ([[UserDefaultManager getValue:@"userId"] isEqualToString:[[searchArray objectAtIndex:indexPath.row]userId]])
        {
            UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyProfileViewController *otherUserProfile =[storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
            // otherUserProfile.otherUserId=[[friendListArray objectAtIndex:indexPath.row]userId];
            [self.navigationController pushViewController:otherUserProfile animated:YES];
        }
        else
        {
            UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            OtherUserProfileViewController *otherUserProfile =[storyboard instantiateViewControllerWithIdentifier:@"OtherUserProfileViewController"];
            otherUserProfile.otherUserId=[[searchArray objectAtIndex:indexPath.row]userId];
            [self.navigationController pushViewController:otherUserProfile animated:YES];
        }

    }
    else
    {
    if ([[UserDefaultManager getValue:@"userId"] isEqualToString:[[friendListArray objectAtIndex:indexPath.row]userId]])
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MyProfileViewController *otherUserProfile =[storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
       // otherUserProfile.otherUserId=[[friendListArray objectAtIndex:indexPath.row]userId];
        [self.navigationController pushViewController:otherUserProfile animated:YES];
    }
    else
    {
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherUserProfileViewController *otherUserProfile =[storyboard instantiateViewControllerWithIdentifier:@"OtherUserProfileViewController"];
    otherUserProfile.otherUserId=[[friendListArray objectAtIndex:indexPath.row]userId];
    [self.navigationController pushViewController:otherUserProfile animated:YES];
    }
    }
}
#pragma mark - end

#pragma mark - Pagignation for table view
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
#pragma mark - IBActions
- (IBAction)sendRequest:(MyButton *)sender
{
    btnTag=[sender Tag];
    friendUserId=[[friendListArray objectAtIndex:btnTag]userId];
    [myDelegate showIndicator];
    [self performSelector:@selector(sendFriendRequestWebservice) withObject:nil afterDelay:0.1];

}
#pragma mark - end
#pragma mark - Friend list webservice
-(void)getFriendList
{
    [[WebService sharedManager]getFriendList:Offset otherUserId:otherUserId success:^(id friendListDataArray)
     {
         [myDelegate stopIndicator];
        if (friendListArray.count<=0) {
              friendListArray=[friendListDataArray mutableCopy];
         }
         else
         {
             [friendListArray addObjectsFromArray:friendListDataArray];
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
-(void)sendFriendRequestWebservice
{
    NSIndexPath *index=[NSIndexPath indexPathForRow:btnTag inSection:0];
    FriendListTableCell * cell = (FriendListTableCell *)[friendListTableView cellForRowAtIndexPath:index];
    [[WebService sharedManager]sendFriendRequest:friendUserId success:^(id responseObject)
     {
         [myDelegate stopIndicator];
         FriendListDataModel *tempModel = [friendListArray objectAtIndex:btnTag];
         tempModel.isRequestSent=@"True";
         [friendListArray replaceObjectAtIndex:btnTag withObject:tempModel];
         [friendListTableView reloadData];

         [self.view makeToast:@"Request Sent"];
     }
        failure:^(NSError *error)
     {
         [cell.requestSentButton setImage:[UIImage imageNamed:@"adduser.png"] forState:UIControlStateNormal];
         cell.requestSentButton.userInteractionEnabled=YES;
     }] ;
}
#pragma mark - end

#pragma mark - Search bar delegates
-(BOOL)searchBar:(UISearchBar *)srchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if (text.length<1) {
        noRecordLbl.hidden=YES;
        searchArray = [NSArray arrayWithArray:friendListArray];
        isSearch = NO;
    }
    
    NSLog(@"%@",searchBar.text);
  //  NSLog(@"check3");
    NSString *searchKey;
    if([text isEqualToString:@"\n"]){
        searchKey = searchBar.text;
        
    }
    else if(text.length){
        searchKey = [searchBar.text stringByAppendingString:text];
    }
    
    else if((searchBar.text.length-1)!=0){
        searchKey = [searchBar.text substringWithRange:NSMakeRange(0, searchBar.text.length-1)];
    }
    
    else{
        searchKey = @"";
    }
    
    searchArray = nil;
    
    if (searchKey.length)
    {
        noRecordLbl.hidden=YES;
        isSearch = YES;
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"userName contains[cd] %@",searchKey];
        NSArray *subPredicates = [NSArray arrayWithObjects:pred1, nil];
        NSPredicate * orPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:subPredicates];
        searchArray=[friendListArray filteredArrayUsingPredicate:orPredicate];
       // NSLog(@"arrFilterSearch count is %lu",(unsigned long)searchArray.count);
    }
    
    
    else
    {
        searchArray = [NSArray arrayWithArray:friendListArray];
        searchBar.text=@"";
         [searchBar resignFirstResponder];
        isSearch = NO;
        
    }
    [friendListTableView reloadData];
   
    return YES;
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
   // NSLog(@"check2");
    return YES;
}


-(BOOL)searchBarShouldEndEditing:(UISearchBar *)srchBar
{
    if ([srchBar.text isEqualToString:@""]) {
        searchArray = [friendListArray mutableCopy];
        isSearch = NO;
        [friendListTableView reloadData];

    }
    
    return  YES;
}

-(void)searchBar:(UISearchBar *)srchBar textDidChange:(NSString *)searchText
{
    if (searchText.length<1)
    {
        noRecordLbl.hidden=YES;
        searchArray = [friendListArray mutableCopy];
        isSearch = NO;
        [friendListTableView reloadData];
    
    }
   
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)srchBar
{
    [searchBar resignFirstResponder];
}
#pragma mark - end
@end
