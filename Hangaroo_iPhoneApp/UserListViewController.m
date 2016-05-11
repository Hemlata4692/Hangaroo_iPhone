//
//  UserListViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Ranosys on 02/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "UserListViewController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "PersonalChatViewController.h"

@interface UserListViewController (){
    NSMutableSet* sortArrSet;
    NSMutableArray* userListArr;
    NSString *yearValue, *checkCompare;
    NSArray *searchResultArray;
    BOOL isSearch;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *userListTableView;
@property (weak, nonatomic) IBOutlet UILabel *noRecordsLabel;

@end

@implementation UserListViewController
@synthesize isChange, chatVC,searchBar,userListTableView,noRecordsLabel;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName=@"User list Chat";
    self.title = @"New Chat";
    noRecordsLabel.hidden=YES;
    sortArrSet = [NSMutableSet new];
    userListArr = [NSMutableArray new];
    searchResultArray=[[NSArray alloc]init];
    searchBar.enablesReturnKeyAutomatically = NO;
    searchBar.returnKeyType=UIReturnKeyDone;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *dateString = [NSString stringWithFormat:@"01-05-%@",[dateFormatter stringFromDate:[NSDate date]]];
    yearValue = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    NSDate *dateFromString1 = [NSDate date];
    dateFromString1 = [dateFormatter dateFromString:[dateFormatter stringFromDate:dateFromString1]];
    if ([dateFromString compare:dateFromString1] == NSOrderedDescending) {
        checkCompare = @"L";
    }
    else if ([dateFromString compare:dateFromString1] == NSOrderedAscending) {
        checkCompare = @"G";
    }
    else {
        checkCompare = @"E";
    }
    myDelegate.myView = @"UserListView";
    [myDelegate showIndicator];
    [myDelegate disconnect];
    if ([myDelegate connect])
    {
        [self fetchedResultsController];
        [userListTableView reloadData];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView) name:@"UserProfile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterInBackGround) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterInForeGround) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)enterInBackGround{
    if (userListArr.count == 0) {
        [myDelegate stopIndicator];
    }
}
-(void)enterInForeGround{
    if (userListArr.count == 0) {
        [myDelegate disconnect];
        
        if ([myDelegate connect])
        {
            [self fetchedResultsController];
            
            [userListTableView reloadData];
        }
    }
    else{
        [userListTableView reloadData];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    myDelegate.myView = @"Other";
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    noRecordsLabel.hidden=YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[self navigationController] setNavigationBarHidden:NO];
    myDelegate.chatUser = @"";
}

-(void)updateTableView{
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [userListTableView reloadData];
                   });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - XMPP delegates
- (XMPPStream *)xmppStream
{
    return [myDelegate xmppStream];
}
- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController == nil)
    {
        NSManagedObjectContext *moc = [myDelegate managedObjectContext_roster];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
                                                  inManagedObjectContext:moc];
        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
        NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setFetchBatchSize:10];
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:moc
                                                                         sectionNameKeyPath:@"sectionNum"
                                                                                  cacheName:nil];
        [fetchedResultsController setDelegate:self];
        NSError *error = nil;
        if (![fetchedResultsController performFetch:&error])
        {
            //error
        }
    }
    return fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSArray *sections = [[self fetchedResultsController] sections];
    [sortArrSet removeAllObjects];
    for (int i = 0 ; i< [[[self fetchedResultsController] sections] count];i++) {
        for (int j = 0; j<[[sections objectAtIndex:i] numberOfObjects]; j++) {
            if (([[[self fetchedResultsController] objectAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]] displayName] != nil) && ![[[[self fetchedResultsController] objectAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]] displayName] isEqualToString:@""] && ([[[self fetchedResultsController] objectAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]] displayName] != NULL)) {
                
                NSString *myName = [[[[[self fetchedResultsController] objectAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]] displayName] componentsSeparatedByString:@"@52.74.174.129@"] objectAtIndex:1];

                if (!([myName intValue] <= [yearValue intValue] - 3) || ((([yearValue intValue] - 3) == [myName intValue]) && [checkCompare isEqualToString:@"L"])) {
                    [sortArrSet addObject:[[self fetchedResultsController] objectAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]]];
                }
            }
        }
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    userListArr = [[sortArrSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] mutableCopy];
    [self.userListTableView reloadData];
}
#pragma mark - end

#pragma mark - Table view delegates
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (isSearch)
    {
        if (searchResultArray.count<1) {
            noRecordsLabel.hidden=NO;
            noRecordsLabel.text=@"No records found.";
            return searchResultArray.count;
        }
        else
        {
            noRecordsLabel.hidden=YES;
            return searchResultArray.count;
        }
    }
    else
    {
        if (userListArr.count<1)
        {
            noRecordsLabel.hidden=NO;
            noRecordsLabel.text=@"No friends added.";
            return userListArr.count;
        }
        else
        {
            noRecordsLabel.hidden=YES;
            return userListArr.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    UIImageView *userImage = (UIImageView*)[cell viewWithTag:2];
    userImage.layer.cornerRadius = 20;
    userImage.layer.masksToBounds = YES;
    userImage.layer.borderWidth=1.5f;
    userImage.layer.borderColor=[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0].CGColor;
    UILabel* nameLabel = (UILabel*)[cell viewWithTag:1];
    XMPPUserCoreDataStorageObject *user;
    if (isSearch)
    {
        if (searchResultArray.count!=0)
        {
            user = [searchResultArray objectAtIndex:indexPath.row];
        }
        else
        {
            noRecordsLabel.hidden=NO;
            noRecordsLabel.text=@"No records found.";
            userListTableView.hidden=YES;
        }
    }
    else
    {
        if (userListArr.count!=0)
        {
            user = [userListArr objectAtIndex:indexPath.row];
        }
    }
    
    nameLabel.text = [[[user displayName] componentsSeparatedByString:@"@52.74.174.129@"] objectAtIndex:0];
    [self configurePhotoForCell:cell user:user];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalChatViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonalChatViewController"];
    if (isSearch)
    {
        vc.userDetail = [searchResultArray objectAtIndex:indexPath.row];
        vc.lastView = @"UserListViewController";
        if ([myDelegate.userProfileImage objectForKey:[[searchResultArray objectAtIndex:indexPath.row] jidStr]] == nil) {
            vc.friendProfileImageView = [UIImage imageNamed:@"user_thumbnail.png"];
        }
        else{
            vc.friendProfileImageView = [myDelegate.userProfileImage objectForKey:[[searchResultArray objectAtIndex:indexPath.row] jidStr]];
        }
        vc.userListVC = self;
    }
    else
    {
        vc.userDetail = [userListArr objectAtIndex:indexPath.row];
        vc.lastView = @"UserListViewController";
        if ([myDelegate.userProfileImage objectForKey:[[userListArr objectAtIndex:indexPath.row] jidStr]] == nil) {
            vc.friendProfileImageView = [UIImage imageNamed:@"user_thumbnail.png"];
        }
        else{
            vc.friendProfileImageView = [myDelegate.userProfileImage objectForKey:[[userListArr objectAtIndex:indexPath.row] jidStr]];
        }
        vc.userListVC = self;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configurePhotoForCell:(UITableViewCell *)cell user:(XMPPUserCoreDataStorageObject *)user
{
    UIImageView *userImage = (UIImageView*)[cell viewWithTag:2];
    
    if (user.photo != nil)
    {
        userImage.image = user.photo;
    }
    else
    {
        NSData *photoData = [myDelegate.xmppvCardAvatarModule photoDataForJID:user.jid];
        
        if (photoData != nil)
            userImage.image = [UIImage imageWithData:photoData];
        else
            userImage.image = [UIImage imageNamed:@"user_thumbnail.png"];
        
        [myDelegate.userProfileImage setObject:userImage.image forKey:[NSString stringWithFormat:@"%@",user.jidStr]];
    }
}
#pragma mark - end

#pragma mark - Search bar delegates
-(BOOL)searchBar:(UISearchBar *)srchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length<1) {
        noRecordsLabel.hidden=YES;
        searchResultArray = [NSArray arrayWithArray:userListArr];
        isSearch = NO;
    }
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
    searchResultArray = nil;
    if (searchKey.length)
    {
        noRecordsLabel.hidden=YES;
        isSearch = YES;
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"displayName contains[cd] %@",searchKey];
        NSArray *subPredicates = [NSArray arrayWithObjects:pred1, nil];
        NSPredicate * orPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:subPredicates];
        searchResultArray=[userListArr filteredArrayUsingPredicate:orPredicate];
    }
    else
    {
        searchResultArray = [NSArray arrayWithArray:userListArr];
        searchBar.text=@"";
        [searchBar resignFirstResponder];
        isSearch = NO;
    }
    [userListTableView reloadData];
    return YES;
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)srchBar
{
    if ([srchBar.text isEqualToString:@""]) {
        searchResultArray = [userListArr mutableCopy];
        isSearch = NO;
        [userListTableView reloadData];
    }
    return  YES;
}

-(void)searchBar:(UISearchBar *)srchBar textDidChange:(NSString *)searchText
{
    if (searchText.length<1)
    {
        noRecordsLabel.hidden=YES;
        searchResultArray = [userListArr mutableCopy];
        isSearch = NO;
        [userListTableView reloadData];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)srchBar
{
    [searchBar resignFirstResponder];
}
#pragma mark - end

@end
