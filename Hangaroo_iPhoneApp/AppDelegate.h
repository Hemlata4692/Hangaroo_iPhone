//
//  AppDelegate.h
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 29/12/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

//added by rohit
#import "XMPP.h"
#import "XMPPFramework.h"
#import "TURNSocket.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
//end

@interface AppDelegate : UIResponder <UIApplicationDelegate,XMPPRosterDelegate>
{
    //added by rohit
    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    XMPPvCardTempModule *xmppvCardTempModule;
    XMPPvCardAvatarModule *xmppvCardAvatarModule;
    XMPPCapabilities *xmppCapabilities;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    
    NSString *password;
    
    BOOL customCertEvaluation;
    
    BOOL isXmppConnected;
    NSMutableArray *turnSockets;
    //end
    
}
@property(nonatomic,retain) UINavigationController *navigationController;

//added by rohit
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (strong, nonatomic) UIWindow *window;
@property(strong, nonatomic)NSMutableArray *UserListArray;
@property(strong, nonatomic)NSMutableArray *groupListArray;
@property(strong, nonatomic)NSString *chatUser;

- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;


@property(strong, nonatomic)XMPPMessageArchivingCoreDataStorage* xmppMessageArchivingCoreDataStorage;
@property(strong, nonatomic)XMPPMessageArchiving* xmppMessageArchivingModule;


@property(strong, nonatomic)NSMutableArray *userHistoryArr;
@property(strong, nonatomic)NSMutableDictionary *userProfileImage;
- (BOOL)connect;
- (void)disconnect;
//end

//Indicator
- (void)ShowIndicator;
- (void)StopIndicator;
-(void)unregisterDeviceForNotification;
-(void)registerDeviceForNotification;
@property(nonatomic,retain)NSString * deviceToken;
@end

