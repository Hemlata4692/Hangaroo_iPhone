//
//  DiscoverViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 04/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableCell.h"
#import "DiscoverDataModel.h"
#import "SearchViewController.h"
#import "MyButton.h"
#import "UIView+Toast.h"
#import "OtherUserProfileViewController.h"
#import "MyProfileViewController.h"

@interface DiscoverViewController ()
{
    NSMutableArray *friendRequestArray;
    NSMutableArray *friendSuggestionArray;
    int totalRequests;
    int btnTag;
    UIView *footerView;
}
@property (weak, nonatomic) IBOutlet UISearchBar *serachBar;
@property (weak, nonatomic) IBOutlet UIButton *suggestionBtn;
@property (weak, nonatomic) IBOutlet UIButton *requestBtn;
@property (weak, nonatomic) IBOutlet UITableView *discoverTableView;
@property(nonatomic, strong) NSString *Offset;
@property(nonatomic, strong) NSString *requestFriendId;
@property(nonatomic, strong) NSString *isAccept;
@end

@implementation DiscoverViewController
@synthesize serachBar,suggestionBtn,requestBtn,discoverTableView,Offset,requestFriendId,isAccept;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.screenName = @"Discover screen";
    Offset=@"0";
    requestBtn.selected=YES;
    [requestBtn setTitleColor:[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    friendRequestArray=[[NSMutableArray alloc]init];
    friendSuggestionArray=[[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"Discover";
    [serachBar resignFirstResponder];
    [friendRequestArray removeAllObjects];
    [friendSuggestionArray removeAllObjects];
    [discoverTableView setContentOffset:CGPointZero animated:YES];
    [[self navigationController] setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self initFooterView];
    Offset=@"0";
    //    if (suggestionBtn.selected==YES) {
    [myDelegate showIndicator];
    [self performSelector:@selector(suggestedFriendList) withObject:nil afterDelay:.1];
    //    }
    //    else
    //    {
    //    [myDelegate showIndicator];
    //    [self performSelector:@selector(requestFriendList) withObject:nil afterDelay:0.1];
    //    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 5;
    }
    else{
        return 0;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView;
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30.0)];
    
    headerView.backgroundColor = [UIColor colorWithRed:(228.0/255.0) green:(228.0/255.0) blue:(228.0/255.0) alpha:1];
    
    UILabel * categoryLabel = [[UILabel alloc] init];
    categoryLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0];
    if (section==0) {
        categoryLabel.text=@"Friend Requests";
    }
    else
    {
        categoryLabel.text=@"Suggested Friends";
    }
    float width =  [categoryLabel.text boundingRectWithSize:categoryLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:categoryLabel.font } context:nil]
    .size.width;
    
    categoryLabel.frame = CGRectMake(15, 0, width,30.0);
    categoryLabel.textColor=[UIColor colorWithRed:(113.0/255.0) green:(113.0/255.0) blue:(113.0/255.0) alpha:1];
    [headerView addSubview:categoryLabel];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==0)
    {
        if (friendRequestArray.count==0) {
            return 1;
        }
        else
        {
            if(totalRequests>=3)
            {
            return [friendRequestArray count]+1;
            }
            else
            {
                return friendRequestArray.count;
            }
            
        }
    }
    else
    {
        if (friendSuggestionArray.count==0) {
            return 1;
        }
        else
        {
            return friendSuggestionArray.count;
        }
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row ==([friendRequestArray count]))
        {
            if (indexPath.row==totalRequests) {
                return 0;
            }
            else
            {
            return 35;
            }
        }
        else
        {
            return 80;
        }
    }
    else
    {
        return 80;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // if (suggestionBtn.selected==YES)
    if (indexPath.section==1)
        
    {
        DiscoverTableCell *suggestionCell ;
        NSString *simpleTableIdentifier = @"suggestionCell";
        suggestionCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (suggestionCell == nil)
        {
            suggestionCell = [[DiscoverTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        if (friendSuggestionArray.count!=0)
        {
            suggestionCell.noRecordLabel.hidden=YES;
            suggestionCell.userImage.hidden=NO;
            suggestionCell.userNameLbl.hidden=NO;
            suggestionCell.mutualFriendLbl.hidden=NO;
            suggestionCell.addFriendBtn.hidden=NO;
            DiscoverDataModel *data=[friendSuggestionArray objectAtIndex:indexPath.row];
            [suggestionCell displaySuggestedListData:data :(int)indexPath.row];
        }
        else
        {
            suggestionCell.noRecordLabel.hidden=NO;
            suggestionCell.noRecordLabel.text=@"No new suggestions.";
            suggestionCell.userImage.hidden=YES;
            suggestionCell.userNameLbl.hidden=YES;
            suggestionCell.mutualFriendLbl.hidden=YES;
            suggestionCell.addFriendBtn.hidden=YES;
            
        }
        suggestionCell.addFriendBtn.Tag=(int)indexPath.row;
        [suggestionCell.addFriendBtn addTarget:self action:@selector(sendRequest:) forControlEvents:UIControlEventTouchUpInside];
        return suggestionCell;
    }
    else
    {
        
        DiscoverTableCell *requestCell;
        NSString *simpleTableIdentifier = @"requestCell";
        requestCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (requestCell == nil)
        {
            requestCell = [[DiscoverTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
    
        if (friendRequestArray.count!=0)
        {
             DiscoverTableCell *loadMore;
            if(indexPath.row ==([friendRequestArray count]))
            {
                if (indexPath.row==totalRequests) {
                    loadMore.hidden=YES;
                }
                else
                {
                NSLog(@"true");
                NSString *simpleTableIdentifier = @"loadMore";
                loadMore = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                if (loadMore == nil)
                {
                    loadMore = [[DiscoverTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
                }
                    loadMore.loadIndicator.hidden=YES;
                [loadMore.loadMoreData addTarget:self action:@selector(loadMore:) forControlEvents:
                 UIControlEventTouchUpInside];
                    loadMore.loadMoreData.tag=indexPath.row;
                return loadMore;
                }
            }
           
            else{
                requestCell.noNewRequest.hidden=YES;
                requestCell.userImageView.hidden=NO;
                requestCell.userNameLabel.hidden=NO;
                requestCell.acceptRequestBtn.hidden=NO;
                requestCell.declineRequestBtn.hidden=NO;
                requestCell.reuestLabel.hidden=NO;
                
                DiscoverDataModel *data=[friendRequestArray objectAtIndex:indexPath.row];
                [requestCell displayData:data :(int)indexPath.row];
            }
        }
        else
        {
            requestCell.noNewRequest.hidden=NO;
            requestCell.noNewRequest.text=@"No new requests.";
            requestCell.userImageView.hidden=YES;
            requestCell.userNameLabel.hidden=YES;
            requestCell.acceptRequestBtn.hidden=YES;
            requestCell.declineRequestBtn.hidden=YES;
            requestCell.reuestLabel.hidden=YES;
            
        }

        requestCell.acceptRequestBtn.Tag=(int)indexPath.row;
        requestCell.declineRequestBtn.Tag=(int)indexPath.row;
        [requestCell.acceptRequestBtn addTarget:self action:@selector(acceptFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
        [requestCell.declineRequestBtn addTarget:self action:@selector(declineFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
        return requestCell;
        
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==1) {
        
        
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OtherUserProfileViewController *otherUserProfile =[storyboard instantiateViewControllerWithIdentifier:@"OtherUserProfileViewController"];
        otherUserProfile.otherUserId=[[friendSuggestionArray objectAtIndex:indexPath.row]requestFriendId];
        [self.navigationController pushViewController:otherUserProfile animated:YES];
    }
    else
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OtherUserProfileViewController *otherUserProfile =[storyboard instantiateViewControllerWithIdentifier:@"OtherUserProfileViewController"];
        otherUserProfile.otherUserId=[[friendRequestArray objectAtIndex:indexPath.row]requestFriendId];
        [self.navigationController pushViewController:otherUserProfile animated:YES];
    }
    
    
}


#pragma mark - end

#pragma mark - IBActions
- (IBAction)loadMore:(UIButton *)sender
{
     btnTag=[sender tag];
    NSIndexPath *myIP = [NSIndexPath indexPathForRow:btnTag inSection:0];
    //Type cast it to CustomCell
   
    DiscoverTableCell *loadMore = (DiscoverTableCell*)[discoverTableView cellForRowAtIndexPath:myIP];
   // DiscoverTableCell *loadMore = [discoverTableView dequeueReusableCellWithIdentifier:@"loadMore"];
    loadMore.loadIndicator.hidden=NO;
    loadMore.loadMoreData.hidden=YES;
    [loadMore.loadIndicator startAnimating];
     [self performSelector:@selector(requestFriendList) withObject:nil afterDelay:.1];
}
- (IBAction)sendRequest:(MyButton *)sender
{
    btnTag=[sender Tag];
    requestFriendId=[[friendSuggestionArray objectAtIndex:btnTag]requestFriendId];
    [myDelegate showIndicator];
    [self performSelector:@selector(sendRequestWebservice) withObject:nil afterDelay:0.1];
    
}

- (IBAction)acceptFriendRequest:(MyButton *)sender
{
    btnTag=[sender Tag];
    isAccept=@"T";
    requestFriendId=[[friendRequestArray objectAtIndex:btnTag]requestFriendId];
    [myDelegate showIndicator];
    [self performSelector:@selector(acceptFriendRequest) withObject:nil afterDelay:.1];
}

- (IBAction)declineFriendRequest:(MyButton *)sender
{
    btnTag=[sender Tag];
    isAccept=@"F";
    requestFriendId=[[friendRequestArray objectAtIndex:btnTag]requestFriendId];
    [myDelegate showIndicator];
    [self performSelector:@selector(acceptFriendRequest) withObject:nil afterDelay:.1];
    
}
- (IBAction)suggestionBtnAction:(id)sender
{
    discoverTableView.hidden=NO;
    [friendRequestArray removeAllObjects];
    [friendSuggestionArray removeAllObjects];
    [discoverTableView reloadData];
    Offset=@"0";
    [discoverTableView setContentOffset:CGPointZero animated:YES];
    [suggestionBtn setSelected:YES];
    [requestBtn setSelected:NO];
    [suggestionBtn setTitleColor:[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    [requestBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    [myDelegate showIndicator];
    [self performSelector:@selector(suggestedFriendList) withObject:nil afterDelay:.1];
}
- (IBAction)requestBtnAction:(id)sender
{
    Offset=@"0";
    discoverTableView.hidden=NO;
    [friendRequestArray removeAllObjects];
    [friendSuggestionArray removeAllObjects];
    [discoverTableView reloadData];
    [discoverTableView setContentOffset:CGPointZero animated:YES];
    [suggestionBtn setSelected:NO];
    [requestBtn setSelected:YES];
    [requestBtn setTitleColor:[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    [suggestionBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    [myDelegate showIndicator];
    [self performSelector:@selector(requestFriendList) withObject:nil afterDelay:.1];
}
#pragma mark - end
#pragma mark - Send request webservice
-(void)sendRequestWebservice
{
    NSIndexPath *index=[NSIndexPath indexPathForRow:btnTag inSection:0];
    DiscoverTableCell * cell = (DiscoverTableCell *)[discoverTableView cellForRowAtIndexPath:index];
    [[WebService sharedManager]sendFriendRequest:requestFriendId success:^(id responseObject)
     {
        // [myDelegate stopIndicator];
         
         DiscoverDataModel *tempModel = [friendSuggestionArray objectAtIndex:btnTag];
         tempModel.addFriend=2;
         [friendSuggestionArray replaceObjectAtIndex:btnTag withObject:tempModel];
         [discoverTableView reloadData];
         
         [self.view makeToast:@"Request Sent"];
     }
                                         failure:^(NSError *error)
     {
         [cell.addFriendBtn setImage:[UIImage imageNamed:@"adduser.png"] forState:UIControlStateNormal];
         cell.addFriendBtn.userInteractionEnabled=YES;
     }] ;
}
#pragma mark - end

#pragma mark - Friend request webservice
-(void)requestFriendList
{
    [[WebService sharedManager]friendRequestList:Offset success:^(id friendRequestListDataArray)
     {
         [myDelegate stopIndicator];
         NSIndexPath *myIP = [NSIndexPath indexPathForRow:btnTag inSection:0];
         //Type cast it to CustomCell
         
         DiscoverTableCell *loadMore = (DiscoverTableCell*)[discoverTableView cellForRowAtIndexPath:myIP];
         // DiscoverTableCell *loadMore = [discoverTableView dequeueReusableCellWithIdentifier:@"loadMore"];
         loadMore.loadIndicator.hidden=YES;
         loadMore.loadMoreData.hidden=NO;
         [loadMore.loadIndicator stopAnimating];
         if (friendRequestArray.count<=0) {
             friendRequestArray=[friendRequestListDataArray mutableCopy];
         }
         else
         {
             [friendRequestArray addObjectsFromArray:friendRequestListDataArray];
         }
         
         totalRequests= [[friendRequestArray objectAtIndex:friendRequestArray.count-1]intValue];
         [friendRequestArray removeLastObject];
         Offset=[NSString stringWithFormat:@"%lu",(unsigned long)friendRequestArray.count];
      
         [discoverTableView reloadData];
         
     }
                                         failure:^(NSError *error)
     {
     }] ;
    
}
#pragma mark - end
#pragma mark - Suggested friend webservice
-(void)suggestedFriendList
{
    [[WebService sharedManager]suggestedFriendList:Offset success:^(id suggestionListDataArray)
     {
         [self requestFriendList];
         [myDelegate stopIndicator];
         if (friendSuggestionArray.count<=0) {
             friendSuggestionArray=[suggestionListDataArray mutableCopy];
         }
         else
         {
             [friendSuggestionArray addObjectsFromArray:suggestionListDataArray];
         }
         
         totalRequests= [[friendSuggestionArray objectAtIndex:friendSuggestionArray.count-1]intValue];
         [friendSuggestionArray removeLastObject];
         Offset=[NSString stringWithFormat:@"%lu",(unsigned long)friendSuggestionArray.count];
         [discoverTableView reloadData];
     }
                                           failure:^(NSError *error)
     {

     }] ;
    
}
#pragma mark - end
#pragma mark - Accept friend request webservice
-(void)acceptFriendRequest
{
    NSIndexPath *index=[NSIndexPath indexPathForRow:btnTag inSection:0];
    DiscoverTableCell * cell = (DiscoverTableCell *)[discoverTableView cellForRowAtIndexPath:index];
    [[WebService sharedManager]acceptFriendRequest:requestFriendId acceptRequest:isAccept success:^(id responseObject)
     {
         [myDelegate stopIndicator];
         DiscoverDataModel *tempModel = [friendRequestArray objectAtIndex:btnTag];
         tempModel.acceptRequestCheck=2;
         [friendRequestArray replaceObjectAtIndex:btnTag withObject:tempModel];
         
         if ([isAccept isEqualToString:@"T"]) {
             cell.reuestLabel.text=@"You are now friends.";
             // [self.view makeToast:@"You are now friends."];
         }
         else
         {
             cell.reuestLabel.text=@"Request declined.";
             //[self.view makeToast:@"Request declined."];
         }
         [discoverTableView reloadData];
     }
                                           failure:^(NSError *error)
     {
         cell.acceptRequestBtn.hidden=NO;
         cell.declineRequestBtn.hidden=NO;
         cell.reuestLabel.hidden=YES;
     }] ;
    
}
#pragma mark - end
#pragma mark - Search bar delegates
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    // called only once
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *searchView =[storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:searchView animated:NO];
    [searchBar resignFirstResponder];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
#pragma mark - end
#pragma mark - Pagignation for table view
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//        if (suggestionBtn.selected==YES)
//        {
        if (friendSuggestionArray.count ==totalRequests)
        {
            [(UIActivityIndicatorView *)[footerView viewWithTag:10] stopAnimating];
            [(UILabel *)[footerView viewWithTag:11] setHidden:true];
        }
        else if(indexPath.row==[friendSuggestionArray count]-1) //self.array is the array of items you are displaying
        {
            if(friendSuggestionArray.count <= totalRequests)
            {
                tableView.tableFooterView = footerView;
                [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
                [self suggestedFriendList];
            }
            else
            {
                discoverTableView.tableFooterView = nil;
                //You can add an activity indicator in tableview's footer in viewDidLoad to show a loading status to user.
            }
        }
      //  }
//        else
//        {
//            if (friendRequestArray.count ==totalRequests)
//            {
//                [(UIActivityIndicatorView *)[footerView viewWithTag:10] stopAnimating];
//                [(UILabel *)[footerView viewWithTag:11] setHidden:true];
//            }
//            else if(indexPath.row==[friendRequestArray count]-1) //self.array is the array of items you are displaying
//            {
//                if(friendRequestArray.count <= totalRequests)
//                {
//                    tableView.tableFooterView = footerView;
//                    [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
//                    [self requestFriendList];
//                }
//                else
//                {
//                    discoverTableView.tableFooterView = nil;
//                    //You can add an activity indicator in tableview's footer in viewDidLoad to show a loading status to user.
//                }
//            }
//    
//        }
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
