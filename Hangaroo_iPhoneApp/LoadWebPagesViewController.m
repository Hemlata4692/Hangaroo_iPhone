//
//  LoadWebPagesViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 28/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "LoadWebPagesViewController.h"

@interface LoadWebPagesViewController ()
{
    NSURL *url;
}
@property (weak, nonatomic) IBOutlet UIWebView *loadWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation LoadWebPagesViewController
@synthesize loadWebView,activityIndicator;
@synthesize facebookString,instagramString,twitterString,navigationTitle;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName=@"Load web view";
    [activityIndicator startAnimating];
    self.navigationItem.title=navigationTitle;
    if ([navigationTitle isEqualToString:@"Facebook"]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.facebook.com/%@",facebookString]];
    }
    else if ([navigationTitle isEqualToString:@"Instagram"])
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.instagram.com/%@",instagramString]];
    }
    else if ([navigationTitle isEqualToString:@"Twitter"])
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.twitter.com/%@",twitterString]];
    }
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [loadWebView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[self navigationController] setNavigationBarHidden:NO];
}
#pragma mark - end

#pragma mark - Webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
    
}
#pragma mark - end
@end
