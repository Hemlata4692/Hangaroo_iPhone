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
#import <UIImageView+AFNetworking.h>
#import "PersonalChatViewController.h"

@interface UserListViewController (){
//    NSURLRequest *imageRequest;
//    UIImageView* profileImage;
    NSMutableSet* sortArrSet;
    NSMutableArray* userListArr;
}
@property (strong, nonatomic) IBOutlet UITableView *userListTableView;

@end

@implementation UserListViewController
@synthesize isChange, chatVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sortArrSet = [NSMutableSet new];
    userListArr = [NSMutableArray new];
//    isChange = 1;
    myDelegate.myView = @"UserListView";
  
    [myDelegate ShowIndicator];
  
    self.title = @"New Chat";
  
    [myDelegate disconnect];
    
    if ([myDelegate connect])
    {
        [self fetchedResultsController];
        
        [_userListTableView reloadData];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView) name:@"UserProfile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterInBackGround) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterInForeGround) name:UIApplicationWillEnterForegroundNotification object:nil];
    // Do any additional setup after loading the view.
}

-(void)enterInBackGround{
    if (userListArr.count == 0) {
        [myDelegate StopIndicator];
    }
    
}

-(void)enterInForeGround{
    if (userListArr.count == 0) {
        [myDelegate disconnect];
        
        if ([myDelegate connect])
        {
            [self fetchedResultsController];
            
            [_userListTableView reloadData];
        }
        
    }
    else{
        [_userListTableView reloadData];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    myDelegate.myView = @"Other";


}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    
    myDelegate.chatUser = @"";
//    chatVC.isChange = isChange;
}

-(void)updateTableView{
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [_userListTableView reloadData];
                   });
}

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
            NSLog(@"Error performing fetch: %@", error);
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
                [sortArrSet addObject:[[self fetchedResultsController] objectAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]]];
            }
            
        }
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    userListArr = [[sortArrSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] mutableCopy];
       NSLog(@"check");
    
    [self.userListTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return userListArr.count;
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
    
    XMPPUserCoreDataStorageObject *user = [userListArr objectAtIndex:indexPath.row];
    
    UIImageView *userImage = (UIImageView*)[cell viewWithTag:2];
    userImage.layer.cornerRadius = 20;
    userImage.layer.masksToBounds = YES;
    
    UILabel* nameLabel = (UILabel*)[cell viewWithTag:1];
    nameLabel.text = user.displayName;
    [self configurePhotoForCell:cell user:user];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    isChange = 1;
    PersonalChatViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonalChatViewController"];
    vc.userDetail = [userListArr objectAtIndex:indexPath.row];
    vc.lastView = @"UserListViewController";
    NSLog(@"%@",[[userListArr objectAtIndex:indexPath.row] jidStr]);
    
    if ([myDelegate.userProfileImage objectForKey:[[userListArr objectAtIndex:indexPath.row] jidStr]] == nil) {
        vc.friendProfileImageView = [UIImage imageNamed:@"user_thumbnail.png"];
    }
    else{
        vc.friendProfileImageView = [myDelegate.userProfileImage objectForKey:[[userListArr objectAtIndex:indexPath.row] jidStr]];
    }
    
    //    vc.userProfileImageView = profileImage.image;
    vc.userListVC = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)configurePhotoForCell:(UITableViewCell *)cell user:(XMPPUserCoreDataStorageObject *)user
{
    // Our xmppRosterStorage will cache photos as they arrive from the xmppvCardAvatarModule.
    // We only need to ask the avatar module for a photo, if the roster doesn't have it.
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
