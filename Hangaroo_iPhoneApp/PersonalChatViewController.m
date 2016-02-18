//
//  PersonalChatViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Monika on 2/3/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "PersonalChatViewController.h"
#import "AppDelegate.h"
#import "XMPP.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "UIPlaceHolderTextView.h"


@interface PersonalChatViewController (){
    CGFloat messageHeight, messageYValue;
    NSMutableArray *userData;
}

@property (strong, nonatomic) IBOutlet UIPlaceHolderTextView *sendMessage;
@property (strong, nonatomic) IBOutlet UIButton *sendOutlet;
@property (strong, nonatomic) IBOutlet UIView *messageView;

@property (strong, nonatomic) IBOutlet UITableView *userTableView;
@end

@implementation PersonalChatViewController
@synthesize userDetail, userXmlDetail;
@synthesize sendMessage, sendOutlet;
@synthesize messageView;
@synthesize userTableView;
@synthesize lastView,meeToProfile,userNameProfile;
@synthesize chatVC,userListVC;
@synthesize userProfileImageView, friendProfileImageView;

#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName=@"Personal Chat";
    userProfileImageView = [[UIImageView alloc] init];
    [self setUserData];
}
-(void)setUserData
{
    __weak UIImageView *weakRef = userProfileImageView;
    
    __weak UITableView *weaktable = userTableView;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[UserDefaultManager getValue:@"userImage"]]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [userProfileImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
        [weaktable reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    sendMessage.text = @"";
    [sendMessage setPlaceholder:@"Type a message here..."];
    [sendMessage setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    sendMessage.backgroundColor = [UIColor whiteColor];
    sendMessage.contentInset = UIEdgeInsetsMake(-5, 5, 0, 0);
    sendMessage.alwaysBounceHorizontal = NO;
    sendMessage.bounces = NO;
    userData = [NSMutableArray new];
    [self registerForKeyboardNotifications];
    messageView.translatesAutoresizingMaskIntoConstraints = YES;
    sendMessage.translatesAutoresizingMaskIntoConstraints = YES;
    messageView.backgroundColor = [UIColor whiteColor];
    messageHeight = 40;
    messageView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height- messageHeight -64 -49 - 10, self.view.bounds.size.width, messageHeight + 10);
    sendMessage.frame = CGRectMake(15, 4, messageView.frame.size.width - 8 - 15 - 52, messageHeight - 8);
    
    messageYValue = messageView.frame.origin.y;
    if ([sendMessage.text isEqualToString:@""] || sendMessage.text.length == 0) {
        sendOutlet.enabled = NO;
    }
    else{
        sendOutlet.enabled = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(historUpdated:) name:@"UserHistory" object:nil];
    userTableView.translatesAutoresizingMaskIntoConstraints = YES;
    userTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - (messageHeight +64 +49 + 14));
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden=NO;
    [[self navigationController] setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [myDelegate showIndicator];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSLog(@"%@",userXmlDetail);
    if ([lastView isEqualToString:@"ChatViewController"] || [lastView isEqualToString:@"MeTooUserProfile"]) {
        
        self.title = [userXmlDetail attributeStringValueForName:@"ToName"];
        
        myDelegate.chatUser = [userXmlDetail attributeStringValueForName:@"to"];
        NSLog(@"%@",myDelegate.chatUser);
    }
    else{
        NSArray* fromUser = [userDetail.jidStr componentsSeparatedByString:@"@52.74.174.129"];
        self.title = [fromUser objectAtIndex:0];
        
        myDelegate.chatUser = [[userDetail.jidStr componentsSeparatedByString:@"/"] objectAtIndex:0];
    }
    [userData removeAllObjects];
    NSString *keyName = myDelegate.chatUser;
    if ([[UserDefaultManager getValue:@"CountData"] objectForKey:keyName] != nil) {
        int tempCount = 0;
        int badgeCount = [[[UserDefaultManager getValue:@"CountData"] objectForKey:keyName] intValue];
        if (badgeCount > 0) {
            [myDelegate addBadgeIcon:[NSString stringWithFormat:@"%d",[[UserDefaultManager getValue:@"BadgeCount"] intValue] - badgeCount ]];
            [UserDefaultManager setValue:[NSString stringWithFormat:@"%d",[[UserDefaultManager getValue:@"BadgeCount"] intValue] - badgeCount ] key:@"BadgeCount"];
        }
        NSMutableDictionary *tempDict = [[UserDefaultManager getValue:@"CountData"] mutableCopy];
        [tempDict setObject:[NSString stringWithFormat:@"%d",tempCount] forKey:keyName];
        [UserDefaultManager setValue:tempDict key:@"CountData"];
    }
    [self performSelector:@selector(getHistoryData) withObject:nil afterDelay:.1];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    myDelegate.myView = @"Other";
    myDelegate.chatUser = @"";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Fetch chat history
-(void)getHistoryData{
    NSManagedObjectContext *moc = [myDelegate.xmppMessageArchivingCoreDataStorage mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSString *predicateFrmt = @"bareJidStr == %@ ";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt, myDelegate.chatUser];
    request.predicate = predicate;
    NSLog(@"%@",[UserDefaultManager getValue:@"LoginCred"]);
    [request setEntity:entityDescription];
    NSError *error;
    NSArray *messages_arc = [moc executeFetchRequest:request error:&error];
    [self print:[[NSMutableArray alloc]initWithArray:messages_arc]];
}

-(void)print:(NSMutableArray*)messages_arc{
    
    @autoreleasepool {
        for (XMPPMessageArchiving_Message_CoreDataObject *message in messages_arc) {
            
            NSXMLElement *element = [[NSXMLElement alloc] initWithXMLString:message.messageStr error:nil];
            [userData addObject:element];
        }
        [myDelegate stopIndicator];
        [userTableView reloadData];
        if (userData.count > 0) {
            NSIndexPath* ip = [NSIndexPath indexPathForRow:userData.count-1 inSection:0];
            [userTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

- (void)historUpdated:(NSNotification *)notification {
    NSString *keyName = myDelegate.chatUser;
    if ([[UserDefaultManager getValue:@"CountData"] objectForKey:keyName] != nil) {
        int tempCount = 0;
        NSMutableDictionary *tempDict = [[UserDefaultManager getValue:@"CountData"] mutableCopy];
        [tempDict setObject:[NSString stringWithFormat:@"%d",tempCount] forKey:keyName];
        [UserDefaultManager setValue:tempDict key:@"CountData"];
    }
    NSLog(@"%@",[notification object]);
    NSXMLElement* message = [notification object];
    [self messagesData:message];
}
#pragma mark - end

#pragma mark - Keyboard delegates
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSLog(@"%f,%f",[UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.height-[aValue CGRectValue].size.height - messageHeight + 50);
    
    messageView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height- [aValue CGRectValue].size.height -messageHeight -64 -10 , [aValue CGRectValue].size.width, messageHeight+ 10);
    messageYValue = [UIScreen mainScreen].bounds.size.height- [aValue CGRectValue].size.height  -50 -10;
    
    NSLog(@"%f,%f",userTableView.frame.size.height,[UIScreen mainScreen].bounds.size.height - [aValue CGRectValue].size.height  -50 -10);
    userTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height- [aValue CGRectValue].size.height -messageHeight -64 -14);
    
    if (userData.count > 0) {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:userData.count-1 inSection:0];
        [userTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}
- (void)keyboardWillHide:(NSNotification *)notification {
    NSLog(@"%f,%f",[UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.height - messageHeight);
    messageView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height- messageHeight -64 -49 -10, self.view.bounds.size.width, messageHeight+ 10);
    messageYValue = [UIScreen mainScreen].bounds.size.height -64 -49 -10;
    
    userTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height- messageHeight -64 -49 -14);
    if (userData.count > 0) {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:userData.count-1 inSection:0];
        [userTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}
#pragma mark - end

#pragma mark - Textfield delegates
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:[UIPasteboard generalPasteboard].string]) {
        
        CGSize size = CGSizeMake(sendMessage.frame.size.height,126);
        NSString *string = textView.text;
        NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        text = [NSString stringWithFormat:@"%@%@",sendMessage.text,text];
        CGRect textRect=[text
                         boundingRectWithSize:size
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:15]}
                         context:nil];
        
        if ((textRect.size.height < 126) && (textRect.size.height > 50)) {
            
            sendMessage.frame = CGRectMake(sendMessage.frame.origin.x, sendMessage.frame.origin.y, sendMessage.frame.size.width, textRect.size.height);
            
            messageHeight = textRect.size.height + 8;
            messageView.frame = CGRectMake(0, messageYValue-messageHeight - 14 , self.view.bounds.size.width, messageHeight +10 );
            userTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  messageYValue-messageHeight - 18);
            if (userData.count > 0) {
                NSIndexPath* ip = [NSIndexPath indexPathForRow:userData.count-1 inSection:0];
                [userTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
        else if(textRect.size.height <= 50){
            messageHeight = 40;
            
            sendMessage.frame = CGRectMake(sendMessage.frame.origin.x, sendMessage.frame.origin.y, sendMessage.frame.size.width, messageHeight-8);
            messageView.frame = CGRectMake(0, messageYValue-messageHeight - 14  , self.view.bounds.size.width, messageHeight + 10);
            userTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  messageYValue-messageHeight - 18);
            if (userData.count > 0) {
                NSIndexPath* ip = [NSIndexPath indexPathForRow:userData.count-1 inSection:0];
                [userTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
        if (textView.text.length>=1) {
            
            if (trimmedString.length>=1) {
                sendOutlet.enabled=YES;
            }
            else{
                sendOutlet.enabled=NO;
            }
        }
        else if (textView.text.length==0) {
            sendOutlet.enabled=NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (([sendMessage sizeThatFits:sendMessage.frame.size].height < 126) && ([sendMessage sizeThatFits:sendMessage.frame.size].height > 50)) {
        
        sendMessage.frame = CGRectMake(sendMessage.frame.origin.x, sendMessage.frame.origin.y, sendMessage.frame.size.width, [sendMessage sizeThatFits:sendMessage.frame.size].height);
        
        messageHeight = [sendMessage sizeThatFits:sendMessage.frame.size].height + 8;
        messageView.frame = CGRectMake(0, messageYValue-messageHeight - 14 , self.view.bounds.size.width, messageHeight +10 );
        userTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  messageYValue-messageHeight - 18);
        if (userData.count > 0) {
            NSIndexPath* ip = [NSIndexPath indexPathForRow:userData.count-1 inSection:0];
            [userTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    else if([sendMessage sizeThatFits:sendMessage.frame.size].height <= 50){
        messageHeight = 40;
        
        sendMessage.frame = CGRectMake(sendMessage.frame.origin.x, sendMessage.frame.origin.y, sendMessage.frame.size.width, messageHeight-8);
        messageView.frame = CGRectMake(0, messageYValue-messageHeight - 14  , self.view.bounds.size.width, messageHeight + 10);
        userTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  messageYValue-messageHeight - 18 );
        if (userData.count > 0) {
            NSIndexPath* ip = [NSIndexPath indexPathForRow:userData.count-1 inSection:0];
            [userTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    
    NSString *string = textView.text;
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (textView.text.length>=1) {
        if (trimmedString.length>=1) {
            sendOutlet.enabled=YES;
        }
        else if (trimmedString.length==0) {
            sendOutlet.enabled=NO;
        }
    }
    else if (textView.text.length==0) {
        sendOutlet.enabled=NO;
    }
    
}
- (IBAction)tapGestureOnView:(UITapGestureRecognizer *)sender {
    [sendMessage resignFirstResponder];
}

#pragma mark - end

#pragma mark - XMPP delegates
- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket {
    
    NSLog(@"TURN Connection succeeded!");
    NSLog(@"You now have a socket that you can use to send/receive data to/from the other person.");
    
    [turnSockets removeObject:sender];
}

- (void)turnSocketDidFail:(TURNSocket *)sender {
    
    NSLog(@"TURN Connection failed!");
    [turnSockets removeObject:sender];
    
}

- (XMPPStream *)xmppStream
{
    return [myDelegate xmppStream];
}

-(IBAction)sendMessage:(id)sender
{
    [sendMessage resignFirstResponder];
    
    
    
    [myDelegate.xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    [myDelegate.xmppMessageArchivingModule activate:[self xmppStream]];    //By this line all your messages are stored in CoreData
    [myDelegate.xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSString *messageStr = [sendMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [NSDate date];
    [dateFormatter setDateFormat:@"hh:mm a"];
    [dateFormatter setAMSymbol:@"am"];
    [dateFormatter setPMSymbol:@"pm"];
    
    NSString *formattedTime = [dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"dd/MM/yy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    NSLog(@"%@",formattedTime);
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:messageStr];
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    
    if ([lastView isEqualToString:@"ChatViewController"] || [lastView isEqualToString:@"MeTooUserProfile"]) {
        
        [message addAttributeWithName:@"to" stringValue:[userXmlDetail attributeStringValueForName:@"to"]];
        [message addAttributeWithName:@"from" stringValue:[userXmlDetail attributeStringValueForName:@"from"]];
        
        [message addAttributeWithName:@"time" stringValue:formattedTime];
        [message addAttributeWithName:@"Name" stringValue:[UserDefaultManager getValue:@"userName"]];
        [message addAttributeWithName:@"Date" stringValue:formattedDate];
        [message addAttributeWithName:@"fromTo" stringValue:[NSString stringWithFormat:@"%@-%@",[userXmlDetail attributeStringValueForName:@"to"],[userXmlDetail attributeStringValueForName:@"from"]]];
        [message addAttributeWithName:@"ToName" stringValue:[userXmlDetail attributeStringValueForName:@"ToName"]];
    }
    else{
        [message addAttributeWithName:@"to" stringValue:userDetail.jidStr];
        [message addAttributeWithName:@"from" stringValue:userDetail.streamBareJidStr];
        
        [message addAttributeWithName:@"time" stringValue:formattedTime];
        [message addAttributeWithName:@"Name" stringValue:[UserDefaultManager getValue:@"userName"]];
        [message addAttributeWithName:@"Date" stringValue:formattedDate];
        [message addAttributeWithName:@"fromTo" stringValue:[NSString stringWithFormat:@"%@-%@",userDetail.streamBareJidStr,userDetail.jidStr]];
        [message addAttributeWithName:@"ToName" stringValue:[[[userDetail displayName] componentsSeparatedByString:@"@52.74.174.129@"] objectAtIndex:0]];
    }
    [message addChild:body];
    
    [[WebService sharedManager] chatNotification:[message attributeStringValueForName:@"to"] userNameFrom:[message attributeStringValueForName:@"from"] messageString:[[message elementForName:@"body"] stringValue] success:^(id responseObject) {
        
        [myDelegate stopIndicator];
        
    } failure:^(NSError *error) {
        
    }] ;
    
    [[self xmppStream] sendElement:message];
    
    [self messagesData:message];
    
    sendMessage.text=@"";
    
    NSLog(@"%f,%f",[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.height - messageHeight - 2);
    
    sendMessage.frame = CGRectMake(sendMessage.frame.origin.x, sendMessage.frame.origin.y, sendMessage.frame.size.width, 32);
    
    messageHeight = 40;
    messageView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height- messageHeight -64 -49 -10, self.view.bounds.size.width, messageHeight+ 10);
    messageYValue = [UIScreen mainScreen].bounds.size.height -64 -49;
    userTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height- messageHeight -64 -49 -14);
    if (userData.count > 0) {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:userData.count-1 inSection:0];
        [userTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    if (sendMessage.text.length>=1) {
        sendOutlet.enabled=YES;
    }
    else if (sendMessage.text.length==0) {
        sendOutlet.enabled=NO;
        
    }
}

-(void)messagesData:(NSXMLElement*)myMessage{
    
    [userData addObject:myMessage];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:userData.count-1 inSection:0];
    [userTableView beginUpdates];
    [userTableView insertRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationBottom];
    [userTableView endUpdates];
    
    [userTableView scrollToRowAtIndexPath:[self indexPathForLastMessage]
                         atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}
#pragma mark - end

#pragma mark - Table view delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return userData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[userTableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    UIImageView *userImage = (UIImageView*)[cell viewWithTag:1];
    UILabel *userName = (UILabel*)[cell viewWithTag:2];
    UILabel *userChat = (UILabel*)[cell viewWithTag:3];
    UILabel *chatTime = (UILabel*)[cell viewWithTag:4];
    
    userName.translatesAutoresizingMaskIntoConstraints = YES;
    userChat.translatesAutoresizingMaskIntoConstraints = YES;
    
    userImage.layer.cornerRadius = 30;
    userImage.layer.masksToBounds = YES;
    
    NSXMLElement* message = [userData objectAtIndex:indexPath.row];
    
    if ( [[UserDefaultManager getValue:@"userName"] caseInsensitiveCompare:[message attributeStringValueForName:@"Name"]] == NSOrderedSame) {
        userName.text = [UserDefaultManager getValue:@"userName"];
    }
    else{
        userName.text = [message attributeStringValueForName:@"Name"];
    }
    
    userChat.text = [[message elementForName:@"body"] stringValue];
    
    NSArray* fromUser = [[message attributeStringValueForName:@"from"] componentsSeparatedByString:@"/"];
    
    NSLog(@"%@,%@",[UserDefaultManager getValue:@"LoginCred"],[fromUser objectAtIndex:0]);
    
    if ( [[UserDefaultManager getValue:@"LoginCred"] caseInsensitiveCompare:[fromUser objectAtIndex:0]] == NSOrderedSame) {
        
        userImage.image = userProfileImageView.image;
        userName.textColor = [UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0];
        
    }
    else{
        userName.textColor = [UIColor blackColor];
        userImage.image = friendProfileImageView;
    }
    
    NSString *userNameValue = [message attributeStringValueForName:@"Name"];
    float userNameHeight;
    CGSize size = CGSizeMake(userTableView.frame.size.width - (10+50+20+10),50);
    CGRect textRect=[userNameValue
                     boundingRectWithSize:size
                     options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:14]}
                     context:nil];
    userName.numberOfLines = 0;
    userNameHeight = textRect.size.height;
    
    userName.frame = CGRectMake(82, 25, userTableView.frame.size.width - (10+50+20+10), userNameHeight);
    
    NSString *body = [[message elementForName:@"body"] stringValue];
    
    size = CGSizeMake(userTableView.frame.size.width - (10+50+20+10),2000);
    textRect=[body
              boundingRectWithSize:size
              options:NSStringDrawingUsesLineFragmentOrigin
              attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14]}
              context:nil];
    userChat.numberOfLines = 0;
    
    if (userData.count == 1 || indexPath.row == 0) {
        userChat.frame = CGRectMake(82,  userName.frame.origin.y + userNameHeight + 15, userTableView.frame.size.width - (10+50+20+10), textRect.size.height);
        userImage.hidden = NO;
        userName.hidden = NO;
        
    }
    else{
        NSXMLElement* message1;
        
        message1 = [userData objectAtIndex:(int)indexPath.row - 1];
        
        if ([[message attributeStringValueForName:@"Name"] isEqualToString:[message1 attributeStringValueForName:@"Name"]]) {
            userChat.frame = CGRectMake(82, 10, userTableView.frame.size.width - (10+50+20+10), textRect.size.height);
            
            userImage.hidden = YES;
            userName.hidden = YES;
            
        }
        else{
            userChat.frame = CGRectMake(82,  userName.frame.origin.y + userNameHeight + 15, userTableView.frame.size.width - (10+50+20+10), textRect.size.height);
            userImage.hidden = NO;
            userName.hidden = NO;
            
        }
    }
    chatTime.hidden = NO;
    chatTime.text = [message attributeStringValueForName:@"time"];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSXMLElement* message = [userData objectAtIndex:indexPath.row];
    NSString *userName = [message attributeStringValueForName:@"Name"];
    float userNameHeight;
    CGSize size = CGSizeMake(userTableView.frame.size.width - (10+50+20+10),50);//here (10+50+20+15) = (imageView.x + imageView.width + space b/w imageView and label + label trailing)
    
    CGRect textRect=[userName
                     boundingRectWithSize:size
                     options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:14]}
                     context:nil];
    userNameHeight = textRect.size.height;
    
    NSString *body = [[message elementForName:@"body"] stringValue];
    
    size = CGSizeMake(userTableView.frame.size.width - (10+50+20+10),2000);//here (10+50+20+15) = (imageView.x + imageView.width + space b/w imageView and label + label trailing)
    
    textRect=[body
              boundingRectWithSize:size
              options:NSStringDrawingUsesLineFragmentOrigin
              attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14]}
              context:nil];\
    if (userData.count==1 || indexPath.row == 0) {
        if (textRect.size.height > 20) {
            //            return textRect.size.height + 25 + userNameHeight + 5 + 25;
            return textRect.size.height + 25 + userNameHeight + 10 + 16 + 20;
        }
        else{
            return 106;
        }
    }
    else{
        NSXMLElement* message1 = [userData objectAtIndex:(int)indexPath.row - 1];
        if ([[message attributeStringValueForName:@"Name"] isEqualToString:[message1 attributeStringValueForName:@"Name"]]) {
            return textRect.size.height + 20 + 16 + 5;
        }
        else{
            if (textRect.size.height > 20) {
                //                return textRect.size.height + 25 + userNameHeight + 5 + 25;
                return textRect.size.height + 25 + userNameHeight + 10 + 16 + 20;
            }
            else{
                return 106;
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return (action == @selector(copy:));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        UILabel *userChat = (UILabel*)[cell viewWithTag:3];
        [[UIPasteboard generalPasteboard] setString:userChat.text];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1;
}

- (void)tableViewScrollToBottomAnimated:(BOOL)animated
{
    NSInteger numberOfRows = userData.count;
    if (numberOfRows)
    {
        [userTableView scrollToRowAtIndexPath:[self indexPathForLastMessage]
                             atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

-(NSIndexPath *)indexPathForLastMessage
{
    NSInteger lastSection = 0;
    NSInteger numberOfMessages = userData.count;
    return [NSIndexPath indexPathForRow:numberOfMessages-1 inSection:lastSection];
}
#pragma mark - end

@end
