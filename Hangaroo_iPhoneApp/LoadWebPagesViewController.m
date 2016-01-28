//
//  LoadWebPagesViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 28/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "LoadWebPagesViewController.h"

@interface LoadWebPagesViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *loadWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LoadWebPagesViewController
@synthesize loadWebView,activityIndicator;

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - end
@end
