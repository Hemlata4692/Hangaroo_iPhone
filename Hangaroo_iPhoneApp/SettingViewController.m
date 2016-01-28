//
//  SettingViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 21/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "SettingViewController.h"
#import "AddInterestViewController.h"
#import "EditProfileViewController.h"
#import "SocialMediaAccountViewController.h"
#import "ShareFeedbackViewController.h"
#import "ChangePasswordViewController.h"
#import "UIView+RoundedCorner.h"
#import "UIView+Toast.h"
#import <MessageUI/MessageUI.h>

@interface SettingViewController ()<MFMailComposeViewControllerDelegate>
{
    NSMutableArray *settingsDataArray;
     NSMutableArray *editUserInfoArray;
}
@property (weak, nonatomic) IBOutlet UIView *findtheRooView;
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation SettingViewController
@synthesize settingTableView,findtheRooView,containerView;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.screenName = @"Settings screen";
    settingsDataArray=[[NSMutableArray alloc]initWithObjects:@"Change Password",@"Share Feedback",@"Find the Roo",@"Log Out", nil];
    editUserInfoArray=[[NSMutableArray alloc]initWithObjects:@"Edit Profile Photo",@"Interest",@"Social Media Accounts", nil];
    findtheRooView.hidden=YES;
    [containerView setCornerRadius:5.0f];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.title=@"Settings";
    self.tabBarController.tabBar.hidden=NO;
    [[self navigationController] setNavigationBarHidden:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return editUserInfoArray.count;
    }
    else
    {
    return settingsDataArray.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 15.0)];
    headerView.backgroundColor=[UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    else
        return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *simpleTableIdentifier = @"settingsCell";
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UILabel *settingsLabel=(UILabel *)[cell viewWithTag:1];
     UILabel *sepratorLabel=(UILabel *)[cell viewWithTag:2];
    UIImageView *arrowImage=(UIImageView *)[cell viewWithTag:3];
    UILabel *logOutLabel=(UILabel *)[cell viewWithTag:4];
    if (indexPath.section==0)
    {
        settingsLabel.text=[editUserInfoArray objectAtIndex:indexPath.row];
        logOutLabel.hidden=YES;
    }
    else
    {
        settingsLabel.text=[settingsDataArray objectAtIndex:indexPath.row];
        logOutLabel.hidden=YES;
    }
    if (indexPath.section==0 && indexPath.row==2) {
        sepratorLabel.hidden=YES;
    }
   else if (indexPath.section==1 && indexPath.row==3) {
       
       settingsLabel.hidden=YES;
       arrowImage.hidden=YES;
       logOutLabel.hidden=NO;
       
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0 && indexPath.row==0) {
                UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                EditProfileViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
                [self.navigationController pushViewController:view animated:YES];
    }
    
    else if (indexPath.section == 0 && indexPath.row==1)
    {
                UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AddInterestViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"AddInterestViewController"];
                [self.navigationController pushViewController:view animated:YES];
    }
    
    else if (indexPath.section == 0 && indexPath.row==2)
    {
                UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SocialMediaAccountViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"SocialMediaAccountViewController"];
                [self.navigationController pushViewController:view animated:YES];
    }
    
    else if (indexPath.section == 1 && indexPath.row==0)
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ChangePasswordViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
        [self.navigationController pushViewController:view animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row==1) {
       
            UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ShareFeedbackViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"ShareFeedbackViewController"];
            [self.navigationController pushViewController:view animated:YES];
      
    }
    else if (indexPath.section == 1 && indexPath.row==2) {
        findtheRooView.hidden=NO;
    }
    
    else if (indexPath.section == 1 && indexPath.row==3)
    {
        [myDelegate unregisterDeviceForNotification];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        myDelegate.window.rootViewController = myDelegate.navigationController;
        [UserDefaultManager removeValue:@"userId"];
        [UserDefaultManager removeValue:@"username"];
        [UserDefaultManager removeValue:@"userImage"];
    }
    
}

#pragma mark - end

#pragma mark - IBActions
- (IBAction)facebookButtonAction:(id)sender
{
}
- (IBAction)twitterButtonAction:(id)sender
{
}
- (IBAction)mailButtonAction:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        // Email Subject
        NSString *emailTitle = @"Hangaroo";
        NSArray *toRecipents = [NSArray arrayWithObject:@""];
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
//        [mc setMessageBody:[NSString stringWithFormat:@"%@ %@ %@ %@ %@%@%@%@\n\n%@\n\n%@",@"Check out",nameLabel.text,@"from",companyLabel.text,@"on Sure",@"(",[NSURL URLWithString: @"http://www.allsurething.com/"],@")",businessDescriptionTextView.text,@"Sure makes your life easier! We believe that booking local services should be easy, fast and definitely reliable! Through our app, you can book a trusted service provider in just a few clicks. With the collections of all the best services in town, we are opening up more possibilities in life for you."] isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        [self presentViewController:mc animated:YES completion:NULL];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Alert"
                                  message:@"Email account is not configured in your device."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    
}


- (IBAction)instagramButtonAction:(id)sender
{
}
- (IBAction)closeFindTheRooViewButtonAction:(id)sender
{
     findtheRooView.hidden=YES;
}
#pragma mark - end

#pragma mark - MFMailComposeViewController delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            [self.view makeToast:@"Your email was not sent."];
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - end

@end
