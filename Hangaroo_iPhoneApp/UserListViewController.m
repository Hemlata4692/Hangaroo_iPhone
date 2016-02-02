//
//  UserListViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Ranosys on 02/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "UserListViewController.h"

//#import "FriendListVC.h"
#import "AppDelegate.h"
//#import "ViewController.h"
//#import "ListVCViewController.h"
#import "XMPPvCardTemp.h"
//XMPPMessageArchivingCoreDataStorage
#import "XMPPMessageArchivingCoreDataStorage.h"


@interface UserListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *FTableView;

@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"New Chat";
    
    [myDelegate disconnect];
    if ([myDelegate connect])
    {
        [self fetchedResultsController];
        
        [_FTableView reloadData];
    }
    // Do any additional setup after loading the view.
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
    //NSLog(@"123 %@",[self fetchedResultsController]);
    [self.FTableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5; //[[[self fetchedResultsController] sections] count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView;
    NSArray *sections = [[self fetchedResultsController] sections];
    
//    if (section < [sections count])
//    {
//        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width,0)];
//        headerView.backgroundColor = [UIColor whiteColor];
//        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.frame.size.width, 46)];
//        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
//        
//        int section = [sectionInfo.name intValue];
//        switch (section)
//        {
//            case 0  :
//                label.text = @"Available";
//                label.textColor=[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0];
//                break;
//            case 1  :
//                label.text =  @"Away";
//                label.textColor=[UIColor yellowColor];
//                break;
//            default :
//                label.text =  @"Offline";
//                label.textColor=[UIColor grayColor];
//                break;
//        }
//        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
//        label.backgroundColor=[UIColor clearColor];
//        
//        [headerView addSubview:label];
//    }
//    else{
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0)];
        headerView.backgroundColor = [UIColor clearColor];
        
//    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0;
}

/*- (NSString *)tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)sectionIndex
 {
	NSArray *sections = [[self fetchedResultsController] sections];
 
	if (sectionIndex < [sections count])
	{
 id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
 
 int section = [sectionInfo.name intValue];
 switch (section)
 {
 case 0  : return @"Available";
 case 1  : return @"Away";
 default : return @"Offline";
 }
	}
 
	return @"";
 }*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    NSArray *sections = [[self fetchedResultsController] sections];
    
    if (sectionIndex < [sections count])
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
        return sectionInfo.numberOfObjects;
    }
    
    return 0;
    //return 5;
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
    
    XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    UIImageView *userImage = (UIImageView*)[cell viewWithTag:2];
    userImage.layer.cornerRadius = 20;
    userImage.layer.masksToBounds = YES;
    
    UILabel* nameLabel = (UILabel*)[cell viewWithTag:1];
    nameLabel.text = user.displayName;
    [self configurePhotoForCell:cell user:user];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"vc"];
//    vc.userDetail = [[self fetchedResultsController] objectAtIndexPath:indexPath];
//    [self presentViewController:vc animated:YES completion:nil];
//    //    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"vc"];
//    //    vc.userDetail = [[self fetchedResultsController] objectAtIndexPath:indexPath];
//    //    [self.navigationController pushViewController:vc animated:YES];
    
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
