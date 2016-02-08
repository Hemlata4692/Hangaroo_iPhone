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

@interface DiscoverViewController ()
{
    NSMutableArray *friendRequestArray;
    int totalRequests;
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
     self.navigationItem.title = @"Discover";
    Offset=@"0";
    suggestionBtn.selected=YES;
    [suggestionBtn setTitleColor:[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    friendRequestArray=[[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    if (suggestionBtn.selected==YES)
    {
        return 1;
    }
    else
    {
        return friendRequestArray.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (suggestionBtn.selected==YES)
        
    {
        DiscoverTableCell *suggestionCell ;
        NSString *simpleTableIdentifier = @"suggestionCell";
        suggestionCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (suggestionCell == nil)
        {
            suggestionCell = [[DiscoverTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
//        if (myProfileArray.count!=0) {
//            MyProfileDataModel *data=[myProfileArray objectAtIndex:indexPath.row];
//            [locationCell displayData:data :(int)indexPath.row];
//        }
//        [locationCell.friendListButton addTarget:self action:@selector(showFriendListButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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
            DiscoverDataModel *data=[friendRequestArray objectAtIndex:indexPath.row];
            requestFriendId=data.requestFriendId;
            [requestCell displayData:data :(int)indexPath.row];
        }
        [requestCell.acceptRequestBtn addTarget:self action:@selector(acceptFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
        [requestCell.declineRequestBtn addTarget:self action:@selector(declineFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
        return requestCell;
        
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

#pragma mark - IBActions
- (IBAction)acceptFriendRequest:(UIButton *)sender
{
    isAccept=@"T";
    [myDelegate ShowIndicator];
    [self performSelector:@selector(acceptFriendRequest) withObject:nil afterDelay:.1];
}

- (IBAction)declineFriendRequest:(UIButton *)sender
{
    isAccept=@"F";
    [myDelegate ShowIndicator];
    [self performSelector:@selector(acceptFriendRequest) withObject:nil afterDelay:.1];
    
}
- (IBAction)suggestionBtnAction:(id)sender
{
    Offset=@"0";
    [suggestionBtn setSelected:YES];
    [requestBtn setSelected:NO];
    [suggestionBtn setTitleColor:[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    [requestBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    [discoverTableView reloadData];
//    [myDelegate ShowIndicator];
//    [self performSelector:@selector(suggestedFriendList) withObject:nil afterDelay:.1];
}
- (IBAction)requestBtnAction:(id)sender
{
    Offset=@"0";
    [suggestionBtn setSelected:NO];
    [requestBtn setSelected:YES];
    [requestBtn setTitleColor:[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    [suggestionBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] forState:UIControlStateSelected];
  
    [myDelegate ShowIndicator];
    [self performSelector:@selector(requestFriendList) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Friend request webservice
-(void)requestFriendList
{
   [[WebService sharedManager]friendRequestList:Offset success:^(id friendRequestListDataArray)
    {
        [myDelegate StopIndicator];
        friendRequestArray=[friendRequestListDataArray mutableCopy];
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
-(void)acceptFriendRequest
{
    [[WebService sharedManager]acceptFriendRequest:requestFriendId acceptRequest:isAccept success:^(id friendRequestListDataArray)
     {
         [myDelegate StopIndicator];
        
         
     }
                                         failure:^(NSError *error)
     {
         
     }] ;

}
@end
