//
//  AppDelegate.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 29/12/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import "AppDelegate.h"
#import "MMMaterialDesignSpinner.h"
#import "HomeViewController.h"
#import "TutorialViewController.h"
#import "GAI.h"

@interface AppDelegate ()
{
    UIImageView *logoImage;
    UIView *loaderView;
}
@property (nonatomic, strong) MMMaterialDesignSpinner *spinnerView;
@end

@implementation AppDelegate
@synthesize deviceToken;
id<GAITracker> tracker;
#pragma mark - Global indicator view
- (void)ShowIndicator
{
    logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 50, 50)];
    logoImage.backgroundColor=[UIColor whiteColor];
    logoImage.layer.cornerRadius=25.0f;
    logoImage.clipsToBounds=YES;
    logoImage.center = CGPointMake(CGRectGetMidX(self.window.bounds), CGRectGetMidY(self.window.bounds));
    
    loaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
    loaderView.backgroundColor=[UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:0.3];
    [loaderView addSubview:logoImage];
  
    MMMaterialDesignSpinner *spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.spinnerView = spinnerView;
    self.spinnerView.bounds = CGRectMake(0, 0, 40, 40);
    self.spinnerView.tintColor = [UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0];
    self.spinnerView.center = CGPointMake(CGRectGetMidX(self.window.bounds), CGRectGetMidY(self.window.bounds));
    self.spinnerView.lineWidth=3.0f;
    [self.window addSubview:loaderView];
    [self.window addSubview:self.spinnerView];
    [self.spinnerView startAnimating];
    
    
}
- (void)StopIndicator
{
    [loaderView removeFromSuperview];
    [self.spinnerView removeFromSuperview];
    [self.spinnerView stopAnimating];
}
#pragma mark - end

#pragma mark - Application life cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 5;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-72052944-1"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    // [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Roboto-Light" size:18.0], NSFontAttributeName, nil]];
    
    NSLog(@"customerId %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
   
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]!=nil)
    {
        HomeViewController * objView=[storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.window setRootViewController:objView];
        [self.window makeKeyAndVisible];
    }
    else
    {
     
        TutorialViewController * infoView = [storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
        [self.navigationController setViewControllers: [NSArray arrayWithObject: infoView]
                                             animated: YES];
    }
    application.applicationIconBadgeNumber = 0;
    NSDictionary *remoteNotifiInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    //Accept push notification when app is not open
    if (remoteNotifiInfo)
    {
        [self application:application didReceiveRemoteNotification:remoteNotifiInfo];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - end
#pragma mark - Push notification methods

-(void)registerDeviceForNotification
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}


//-(NSString *)getNotificationMessage : (NSDictionary *)userInfo
//{
//    NSLog(@"Notification info %@",userInfo);
////    [[NSUserDefaults standardUserDefaults]setInteger:[[userInfo objectForKey:@"PendingConfirmation"]intValue] forKey:@"PendingConfirmation"];
////    [[NSUserDefaults standardUserDefaults]synchronize];
////    bookingId =[userInfo objectForKey:@"BookingId"];
////    NSDictionary *tempDict=[userInfo objectForKey:@"aps"];
////    return [tempDict objectForKey:@"alert"];
//}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken1
{
    NSString *token = [[deviceToken1 description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
     NSLog(@"Notification token device ...............................////// info %@",token);
    self.deviceToken = token;
    
    [[WebService sharedManager] registerDeviceForPushNotification:token deviceType:@"ios"  success:^(id responseObject) {
        
        //[myDelegate StopIndicator];
        
    } failure:^(NSError *error) {
        
    }] ;
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"]!=nil)
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber=0;
      //  [self getNotificationMessage:userInfo];
        NSLog(@"Notification info %@",userInfo);
    }
    else
    {
        return;
    }
}


- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"did failtoRegister and testing : %@",str);
    
}
-(void)unregisterDeviceForNotification
{
    [[UIApplication sharedApplication]  unregisterForRemoteNotifications];
}

#pragma mark - end
@end
