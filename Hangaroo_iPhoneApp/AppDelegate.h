//
//  AppDelegate.h
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 29/12/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"
#import "XMPPFramework.h"
#import "TURNSocket.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,XMPPRosterDelegate>
{
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

}
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain) UINavigationController *navigationController;
//Indicator
- (void)ShowIndicator;
- (void)StopIndicator;
-(void)unregisterDeviceForNotification;
-(void)registerDeviceForNotification;
@property(nonatomic,retain)NSString * deviceToken;

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property(strong, nonatomic)NSMutableArray *UserListArray;
@property(strong, nonatomic)NSMutableArray *groupListArray;
@property(strong, nonatomic)NSString *chatUser;
@property(nonatomic,retain) UITabBarController *tabBarView;
- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;


@property(strong, nonatomic)XMPPMessageArchivingCoreDataStorage* xmppMessageArchivingCoreDataStorage;
@property(strong, nonatomic)XMPPMessageArchiving* xmppMessageArchivingModule;


@property(strong, nonatomic)NSMutableArray *userHistoryArr;
@property(strong, nonatomic)NSMutableDictionary *userProfileImage;
@property(strong, nonatomic)UIImageView *userProfileImageData;

@property(strong, nonatomic)NSData *userProfileImageDataValue;
@property(strong, nonatomic)NSString *myView;
- (BOOL)connect;
- (void)disconnect;
-(void)addBadgeIcon:(NSString*)badgeValue;
-(void)editProfileImageUploading:(UIImage*)editProfileImge;
-(void)addBadgeIconLastTab;
-(void)removeBadgeIconLastTab;
@end

