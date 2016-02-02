//
//  ChatViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 04/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ChatViewController.h"
#import "UserListViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"New Chat";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)userListingView:(UIButton *)sender {
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserListViewController *loginView =[storyboard instantiateViewControllerWithIdentifier:@"UserListViewController"];
    [self.navigationController pushViewController:loginView animated:YES];
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
