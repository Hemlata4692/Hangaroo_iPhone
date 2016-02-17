//
//  ChatViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 04/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ChatViewController.h"
#import "UserListViewController.h"
#import "PersonalChatViewController.h"

@interface ChatViewController (){
    NSMutableArray *historyArray;
}
@property (strong, nonatomic) IBOutlet UITableView *historyTableView;

@end

@implementation ChatViewController
@synthesize historyTableView, isChange;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Chats";
    historyArray = [NSMutableArray new];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChatScreenHistory) name:@"ChatScreenHistory" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterInBackGround) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChatScreenHistory) name:UIApplicationWillEnterForegroundNotification object:nil];

    // Do any additional setup after loading the view.
}

-(void)enterInBackGround{
    [myDelegate stopIndicator];
}

-(void)ChatScreenHistory{
    [historyArray removeAllObjects];
    [myDelegate showIndicator];
    [self performSelector:@selector(getHistoryData) withObject:nil afterDelay:.1];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    myDelegate.chatUser = @"";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[self navigationController] setNavigationBarHidden:NO];
    myDelegate.chatUser = @"ChatScreen";
//    if (isChange == 2 ) {
        [historyArray removeAllObjects];
        [myDelegate showIndicator];
        [self performSelector:@selector(getHistoryData) withObject:nil afterDelay:.1];
//    }
//    else{
//        [historyTableView reloadData];
//    }
}



-(void)getHistoryData{
    NSManagedObjectContext *moc = [myDelegate.xmppMessageArchivingCoreDataStorage mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //    NSString *predicateFrmt = @"bareJidStr like %@ ";
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt, @"hema@52.74.174.129"];
    //    request.predicate = predicate;
    NSLog(@"%@",[UserDefaultManager getValue:@"LoginCred"]);
    [request setEntity:entityDescription];
    NSError *error;
    NSArray *messages_arc = [moc executeFetchRequest:request error:&error];
    //
    [self print:[[NSMutableArray alloc]initWithArray:messages_arc]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)userListingView:(UIButton *)sender {
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserListViewController *userListView =[storyboard instantiateViewControllerWithIdentifier:@"UserListViewController"];
    userListView.chatVC = self;
    [self.navigationController pushViewController:userListView animated:YES];
}

- (IBAction)historyMethod:(UIButton *)sender {
    [self performSelector:@selector(methodCallingSecond) withObject:nil afterDelay:0.1];
    
}
-(void)methodCallingSecond{
    //    ---------------DELETE HISTORY---------
    //    NSString *userJid = [NSString stringWithFormat:@"rohit321@52.74.174.129"];
    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *context = [storage mainThreadManagedObjectContext];
    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    //    NSString *predicateFrmt = @"bareJidStr == %@";
    NSError *error;
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt, userJid];
    //    request.predicate = predicate;
    NSArray *messages_new = [moc executeFetchRequest:request error:&error];
    
    for (NSManagedObject * message in messages_new)
    {
        [context deleteObject:message];
        //        [tableView reloadData];
    }
    
    error = nil;
    if (![moc save:&error])
    {
        NSLog(@"Error deleting movie, %@", [error userInfo]);
    }
}

-(void)print:(NSMutableArray*)messages_arc{
    NSMutableArray *tempArray = [NSMutableArray new];
    int i = 0;
    @autoreleasepool {
        for (XMPPMessageArchiving_Message_CoreDataObject *message in messages_arc) {
            
            NSXMLElement *element = [[NSXMLElement alloc] initWithXMLString:message.messageStr error:nil];
            if ( [[element attributeStringValueForName:@"ToName"] caseInsensitiveCompare:[UserDefaultManager getValue:@"userName"]] == NSOrderedSame) {
                if ([tempArray containsObject:[[element attributeStringValueForName:@"Name"] lowercaseString]]) {
                    i = (int)[tempArray indexOfObject:[[element attributeStringValueForName:@"Name"] lowercaseString]];
                    [tempArray removeObjectAtIndex:i];
                    [historyArray removeObjectAtIndex:i];
                    [tempArray addObject:[[element attributeStringValueForName:@"Name"] lowercaseString]];
                    [historyArray addObject:element];
                }
                else{
                    [tempArray addObject:[[element attributeStringValueForName:@"Name"] lowercaseString]];
                    [historyArray addObject:element];
                    
                }
            }
            else{
                if ([tempArray containsObject:[[element attributeStringValueForName:@"ToName"] lowercaseString]]) {
                    i = (int)[tempArray indexOfObject:[[element attributeStringValueForName:@"ToName"] lowercaseString]];
                    [tempArray removeObjectAtIndex:i];
                    [historyArray removeObjectAtIndex:i];
                    [tempArray addObject:[[element attributeStringValueForName:@"ToName"] lowercaseString]];
                    [historyArray addObject:element];
                }
                else{
                    [tempArray addObject:[[element attributeStringValueForName:@"ToName"] lowercaseString]];
                    [historyArray addObject:element];
                }
            }
        }
        historyArray=[[[historyArray reverseObjectEnumerator] allObjects] mutableCopy];
        [myDelegate stopIndicator];
//        isChange = 1;
        [historyTableView reloadData];
        //        -----reload table-------
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
//    if (isChange == 2 ) {
//        return 0;
//    }
//    else{
        return historyArray.count;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    if (historyArray.count > 0) {
        NSXMLElement *msg = [historyArray objectAtIndex:indexPath.row];
        
        //
        UIImageView *userImage = (UIImageView*)[cell viewWithTag:1];
        UILabel* nameLabel = (UILabel*)[cell viewWithTag:2];
        UILabel* chatHistory = (UILabel*)[cell viewWithTag:3];
        UILabel* dateLabel = (UILabel*)[cell viewWithTag:4];
        UILabel* countLabel = (UILabel*)[cell viewWithTag:5];
        countLabel.layer.cornerRadius = 10;
        countLabel.layer.masksToBounds = YES;
        
        userImage.layer.cornerRadius = 30;
        userImage.layer.masksToBounds = YES;
        
        if ( [[msg attributeStringValueForName:@"ToName"] caseInsensitiveCompare:[UserDefaultManager getValue:@"userName"]] == NSOrderedSame) {
            nameLabel.text = [msg attributeStringValueForName:@"Name"];
        }
        else{
            nameLabel.text = [msg attributeStringValueForName:@"ToName"];
            
        }
        
        if ( [[UserDefaultManager getValue:@"LoginCred"] caseInsensitiveCompare:[[[msg attributeStringValueForName:@"to"] componentsSeparatedByString:@"/"] objectAtIndex:0]] == NSOrderedSame) {
            [self configurePhotoForCell:cell user:[XMPPJID jidWithString:[[[msg attributeStringValueForName:@"from"] componentsSeparatedByString:@"/"] objectAtIndex:0]]];
            
        }
        else{
            [self configurePhotoForCell:cell user:[XMPPJID jidWithString:[[[msg attributeStringValueForName:@"to"] componentsSeparatedByString:@"/"] objectAtIndex:0]]];
        }
        
        NSString *keyName = [[[msg attributeStringValueForName:@"from"] componentsSeparatedByString:@"/"] objectAtIndex:0];
        if ([[UserDefaultManager getValue:@"CountData"] objectForKey:keyName] == nil) {
            countLabel.hidden = YES;
        }
        else{
            if ([[[UserDefaultManager getValue:@"CountData"] objectForKey:keyName] intValue] == 0) {
                countLabel.hidden = YES;
            }
            else{
                countLabel.hidden = NO;
                countLabel.text = [[UserDefaultManager getValue:@"CountData"] objectForKey:keyName];
            }
        }
        
        dateLabel.text = [msg attributeStringValueForName:@"Date"];
        chatHistory.text = [[msg elementForName:@"body"]stringValue];
    }
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    isChange = 1;
    PersonalChatViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonalChatViewController"];
    NSXMLElement *msg = [historyArray objectAtIndex:indexPath.row];
    NSString* fromString = [[[msg attributeStringValueForName:@"to"] componentsSeparatedByString:@"/"] objectAtIndex:0];
    NSString* toString = [[[msg attributeStringValueForName:@"from"] componentsSeparatedByString:@"/"] objectAtIndex:0];
    
    vc.lastView = @"ChatViewController";
    //    NSLog(@"%@",[NSString stringWithFormat:@"%@",[[[msg attributeStringValueForName:@"from"] componentsSeparatedByString:@"/"] objectAtIndex:0]]);
    
    if ( [[UserDefaultManager getValue:@"LoginCred"] caseInsensitiveCompare:[[[msg attributeStringValueForName:@"to"] componentsSeparatedByString:@"/"] objectAtIndex:0]] == NSOrderedSame) {
        if ([myDelegate.userProfileImage objectForKey:toString] == nil) {
            vc.friendProfileImageView = [UIImage imageNamed:@"user_thumbnail.png"];
        }
        else{
            vc.friendProfileImageView = [myDelegate.userProfileImage objectForKey:toString];
        }
        
        [msg addAttributeWithName:@"to" stringValue:toString];
        [msg addAttributeWithName:@"from" stringValue:fromString];
        [msg addAttributeWithName:@"ToName" stringValue:[msg attributeStringValueForName:@"Name"]];
        [msg addAttributeWithName:@"Name" stringValue:[UserDefaultManager getValue:@"userName"]];
    }
    else{
        
        if ([myDelegate.userProfileImage objectForKey:[[[msg attributeStringValueForName:@"to"] componentsSeparatedByString:@"/"] objectAtIndex:0]] == nil) {
            vc.friendProfileImageView = [UIImage imageNamed:@"user_thumbnail.png"];
        }
        else{
            vc.friendProfileImageView = [myDelegate.userProfileImage objectForKey:[[[msg attributeStringValueForName:@"to"] componentsSeparatedByString:@"/"] objectAtIndex:0]];
        }
    }
    //    NSLog(@"%@",[NSString stringWithFormat:@"%@",[[[msg attributeStringValueForName:@"from"] componentsSeparatedByString:@"/"] objectAtIndex:0]]);
    vc.userXmlDetail = msg;
    vc.chatVC = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)configurePhotoForCell:(UITableViewCell *)cell user:(XMPPJID *)user
{
    // Our xmppRosterStorage will cache photos as they arrive from the xmppvCardAvatarModule.
    // We only need to ask the avatar module for a photo, if the roster doesn't have it.
    UIImageView *userImage = (UIImageView*)[cell viewWithTag:1];
    
    if ([myDelegate.userProfileImage objectForKey:[NSString stringWithFormat:@"%@",user]] == nil) {
        NSData *photoData = [myDelegate.xmppvCardAvatarModule photoDataForJID:user];
        
        if (photoData != nil)
            userImage.image = [UIImage imageWithData:photoData];
        else
            userImage.image = [UIImage imageNamed:@"user_thumbnail.png"];
        [myDelegate.userProfileImage setObject:userImage.image forKey:[NSString stringWithFormat:@"%@",user]];
        NSLog(@"%@",[NSString stringWithFormat:@"%@",user]);
    }
    else{
        userImage.image = [myDelegate.userProfileImage objectForKey:[NSString stringWithFormat:@"%@",user]];
    }
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
