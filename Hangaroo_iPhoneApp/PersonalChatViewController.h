//
//  PersonalChatViewController.h
//  Hangaroo_iPhoneApp
//
//  Created by Monika on 2/3/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XMPPFramework.h"
#import "XMPP.h"
#import "TURNSocket.h"
#import "ChatViewController.h"
#import "UserListViewController.h"

@interface PersonalChatViewController : GlobalBackViewController
{
    NSMutableArray *turnSockets;
    NSMutableArray	*messages;
}
@property (nonatomic,retain) XMPPUserCoreDataStorageObject *userDetail;
@property (nonatomic,retain) NSXMLElement *userXmlDetail;
@property (nonatomic,retain) UIImageView *userProfileImageView;
@property (nonatomic,retain) UIImage *friendProfileImageView;
@property (nonatomic,retain) NSString *lastView;
@property (nonatomic,retain) NSString *meeToProfile;
@property (nonatomic,retain) NSString *userNameProfile;
@property (nonatomic,retain) ChatViewController *chatVC;
@property (nonatomic,retain) UserListViewController *userListVC;

@end
