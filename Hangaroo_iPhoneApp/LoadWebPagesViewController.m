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
        NSArray* words = [facebookString componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* fbString = [words componentsJoinedByString:@""];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.facebook.com/%@",fbString]];
    }
    else if ([navigationTitle isEqualToString:@"Instagram"])
    {
        NSArray* words = [instagramString componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* instaString = [words componentsJoinedByString:@""];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.instagram.com/%@",instaString]];
    }
    else if ([navigationTitle isEqualToString:@"Twitter"])
    {
        NSArray* words = [twitterString componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* twitString = [words componentsJoinedByString:@""];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.twitter.com/%@",twitString]];
    }
    if (url==nil)
    {
        [activityIndicator stopAnimating];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Invalid username." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        });
    }
    else
    {
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [loadWebView loadRequest:requestObj];
    }
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
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    NSString *errorMsg;
    if (error==nil) {
        errorMsg=@"Request time out.";
    }
    else
    {
        errorMsg=error.localizedDescription;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:errorMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    });
}
#pragma mark - end
@end
