//
//  MyProfileViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 04/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MyProfileViewController.h"
#import "SettingViewController.h"
#import "ProfileTableViewCell.h"
#import "CoolNavi.h"

@interface MyProfileViewController ()
{
    NSMutableArray *notificationsArray;
}
@property (weak, nonatomic) IBOutlet UITableView *myProfileTableView;
@end

@implementation MyProfileViewController
@synthesize myProfileTableView;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.screenName = @"Profile screen";
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
    notificationsArray=[[NSMutableArray alloc]init];
    CoolNavi *headerView = [[CoolNavi alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)backGroudImage:@"picture.png" headerImageURL:@"user.png" title:@"Hello" subTitle:@"This is a test!" buttonTitle:@"settings"];
    headerView.scrollView = self.myProfileTableView;
    headerView.imgActionBlock = ^(){
        NSLog(@"headerImageAction");
    };
    [self.view addSubview:headerView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[self navigationController] setNavigationBarHidden:NO];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title=@"My profile";
    [[self navigationController] setNavigationBarHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)statusHide
{
    [UIView animateWithDuration:0.1 animations:^() {
        [self setNeedsStatusBarAppearanceUpdate];
    }completion:^(BOOL finished){}];
}

#pragma mark - end

- (IBAction)settingsBtnAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *loginView =[storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:loginView animated:YES];
}

#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    else
        return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else if (section == 2)
    {
        return 1;
    }
    else
    {
        return 10;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 70;
        
    }
    else if (indexPath.section == 1)
    {
        return 64;
        
    }
    else if (indexPath.section == 2)
    {
        return 30;
    }
    else{
        return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
        
    {
        ProfileTableViewCell *locationCell ;
        NSString *simpleTableIdentifier = @"locationCell";
        locationCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (locationCell == nil)
        {
            locationCell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
      //  [locationCell layoutView4:self.view.frame];
        
             return locationCell;
    }
    else if (indexPath.section==1)
    {
        
        ProfileTableViewCell *interestCell;
        NSString *simpleTableIdentifier = @"interestCell";
        interestCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (interestCell == nil)
        {
            interestCell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        //[interestCell layoutView3:self.view.frame count:(int)cartArray.count];
               return interestCell;
        
    }
    else if (indexPath.section==2)
    {
        
        ProfileTableViewCell *titleCell ;
        NSString *simpleTableIdentifier = @"titleCell";
        titleCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (titleCell == nil)
        {
            titleCell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
       // [titleCell layoutView2:self.view.frame];
       
        return titleCell;
        
    }
    
    else
    {
        ProfileTableViewCell *notificationCell ;
        NSString *simpleTableIdentifier = @"notificationCell";
        notificationCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
      //  NSMutableDictionary * dataDict = [cartArray objectAtIndex:indexPath.row];
        if (notificationCell == nil)
        {
            notificationCell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        //[notificationCell layoutView1:self.view.frame];

            return notificationCell;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    UIViewController *searchView =[storyboard instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
    //    [self.navigationController pushViewController:searchView animated:YES];
    
    //    if (indexPath.section==1 && indexPath.row == 0){
    //        giftMessageBackgroundView.hidden = NO;
    //
    //    }
    
}


@end
