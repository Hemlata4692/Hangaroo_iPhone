//
//  SearchViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 09/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "SearchViewController.h"
#import "FriendListDataModel.h"
#import "DiscoverTableCell.h"
#import "OtherUserProfileViewController.h"
#import "MyButton.h"
#import "UIView+Toast.h"
#import "MyProfileViewController.h"

@interface SearchViewController ()
{
    NSMutableArray *searchResultArray;
    int totalResults;
    int btnTag;
    UIView *footerView;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property(nonatomic, strong) NSString *Offset;
@property(nonatomic, strong) NSString *friendId;
@property(nonatomic, strong) NSString *searchTextKey;
@end

@implementation SearchViewController
@synthesize searchBar,searchTableView,Offset,searchTextKey,friendId;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.screenName = @"Search screen";
    Offset=@"0";
    self.navigationItem.title = @"Search";
    searchResultArray=[[NSMutableArray alloc]init];
    searchBar.enablesReturnKeyAutomatically = NO;
    [searchBar becomeFirstResponder];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [searchTableView setContentOffset:CGPointZero animated:YES];
    [[self navigationController] setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    [self initFooterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end
#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return searchResultArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        DiscoverTableCell *suggestionCell ;
        NSString *simpleTableIdentifier = @"suggestionCell";
        suggestionCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (suggestionCell == nil)
        {
            suggestionCell = [[DiscoverTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
                if (searchResultArray.count!=0) {
                    FriendListDataModel *data=[searchResultArray objectAtIndex:indexPath.row];
                    [suggestionCell displaySearchData:data :(int)indexPath.row];
                }
    suggestionCell.addFriendBtn.Tag=(int)indexPath.row;
    [suggestionCell.addFriendBtn addTarget:self action:@selector(sendFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
        return suggestionCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UserDefaultManager getValue:@"userId"] isEqualToString:[[searchResultArray objectAtIndex:indexPath.row]userId]])
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MyProfileViewController *otherUserProfile =[storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
        // otherUserProfile.otherUserId=[[searchResultArray objectAtIndex:indexPath.row]userId];
        [self.navigationController pushViewController:otherUserProfile animated:YES];
    }
    else
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OtherUserProfileViewController *otherUserProfile =[storyboard instantiateViewControllerWithIdentifier:@"OtherUserProfileViewController"];
        otherUserProfile.otherUserId=[[searchResultArray objectAtIndex:indexPath.row]userId];
        [self.navigationController pushViewController:otherUserProfile animated:YES];
    }
   
}


#pragma mark - end
- (IBAction)sendFriendRequest:(MyButton *)sender
{
    btnTag=[sender Tag];
    friendId=[[searchResultArray objectAtIndex:btnTag]userId];
    [myDelegate showIndicator];
    [self performSelector:@selector(sendRequestWebservice) withObject:nil afterDelay:0.1];
}

#pragma mark - Search webservice
-(void)searchFriend
{
    [[WebService sharedManager]searchFriends:Offset serachKey:searchTextKey success:^(id searchListDataArray)
     {
         [myDelegate stopIndicator];
         if (searchResultArray.count<=0) {
             searchResultArray=[searchListDataArray mutableCopy];
         }
         else
         {
             [searchResultArray addObjectsFromArray:searchListDataArray];
         }
         
         totalResults= [[searchResultArray objectAtIndex:searchResultArray.count-1]intValue];
         [searchResultArray removeLastObject];
         Offset=[NSString stringWithFormat:@"%lu",(unsigned long)searchResultArray.count];
         [searchTableView reloadData];

         
     }
                                     failure:^(NSError *error)
     {
         
     }] ;
}
#pragma mark - end
#pragma mark - Send request webservice
-(void)sendRequestWebservice
{
    NSIndexPath *index=[NSIndexPath indexPathForRow:btnTag inSection:0];
    DiscoverTableCell * cell = (DiscoverTableCell *)[searchTableView cellForRowAtIndexPath:index];
    [[WebService sharedManager]sendFriendRequest:friendId success:^(id responseObject)
     {
         [myDelegate stopIndicator];
         
         FriendListDataModel *tempModel = [searchResultArray objectAtIndex:btnTag];
         tempModel.isRequestSent=@"True";
         [searchResultArray replaceObjectAtIndex:btnTag withObject:tempModel];
         [searchTableView reloadData];
         [self.view makeToast:@"Request Sent"];
     }
                                         failure:^(NSError *error)
     {
         [cell.addFriendBtn setImage:[UIImage imageNamed:@"adduser.png"] forState:UIControlStateNormal];
         cell.addFriendBtn.userInteractionEnabled=YES;
     }] ;
}
#pragma mark - end
#pragma mark - Search bar delegates
- (void)searchBar:(UISearchBar *)srchBar textDidChange:(NSString *)searchText
{
    if ([searchText length]==0)
    {
        Offset=@"0";
        [searchResultArray removeAllObjects];
        [searchTableView reloadData];
    }
   
    NSLog(@"%@",searchText);
    searchTextKey=searchText;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)srchBar
{
    if ([searchTextKey length]==0)
    {
        [searchBar resignFirstResponder];
    }
    else
    {
    [myDelegate showIndicator];
    [self performSelector:@selector(searchFriend) withObject:nil afterDelay:.1];
    [searchBar resignFirstResponder];
    }
}
#pragma mark - end
#pragma mark - Pagignation for table view
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (searchResultArray.count ==totalResults)
    {
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] stopAnimating];
        [(UILabel *)[footerView viewWithTag:11] setHidden:true];
    }
    else if(indexPath.row==[searchResultArray count]-1) //self.array is the array of items you are displaying
    {
        if(searchResultArray.count <= totalResults)
        {
            tableView.tableFooterView = footerView;
            [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
            [self searchFriend];
        }
        else
        {
            searchTableView.tableFooterView = nil;
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

@end
