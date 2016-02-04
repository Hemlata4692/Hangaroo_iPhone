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

@interface PersonalChatViewController : UIViewController
{
    NSMutableArray *turnSockets;
    NSMutableArray	*messages;
}
@property (nonatomic,retain) XMPPUserCoreDataStorageObject *userDetail;
@property (nonatomic,retain) UIImageView *userProfileImageView;
@property (nonatomic,retain) UIImage *friendProfileImageView;
@end
