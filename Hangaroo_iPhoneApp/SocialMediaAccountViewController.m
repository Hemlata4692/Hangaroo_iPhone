//
//  SocialMediaAccountViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 21/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "SocialMediaAccountViewController.h"
#import "SettingViewController.h"

@interface SocialMediaAccountViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *facebookImageView;
@property (weak, nonatomic) IBOutlet UITextField *facebookTextField;
@property (weak, nonatomic) IBOutlet UIImageView *instaImageView;
@property (weak, nonatomic) IBOutlet UITextField *instaTextField;
@property (weak, nonatomic) IBOutlet UIImageView *twitterImageView;
@property (weak, nonatomic) IBOutlet UITextField *twitterTextField;

@end

@implementation SocialMediaAccountViewController
@synthesize facebookImageView,facebookTextField,instaImageView,instaTextField,twitterImageView,twitterTextField;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.screenName = @"Social media accounts screen";
    self.title = @"Social accounts";
    
    [facebookTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [twitterTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [instaTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end
#pragma mark - Webservice
-(void)saveSocialAccountsInfo
{
  // NSLog(@"%@",[NSString stringWithFormat:@"www.facebook.com/%@",facebookTextField.text]);
    [[WebService sharedManager]socialAccounts:[NSString stringWithFormat:@"www.facebook.com/%@",facebookTextField.text] twitter:[NSString stringWithFormat:@"www.twitter.com/%@",twitterTextField.text] instagram:[NSString stringWithFormat:@"www.instagram.com/%@",instaTextField.text] success: ^(id responseObject) {
        
        [myDelegate StopIndicator];
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Alert"
                                              message:[responseObject objectForKey:@"message"]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                       for (UIViewController *controller in self.navigationController.viewControllers)
                                       {
                                           if ([controller isKindOfClass:[SettingViewController class]])
                                           {
                                               [self.navigationController popToViewController:controller animated:YES];
                                               
                                               break;
                                           }
                                       }
                                       
                                   }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
                                       failure:^(NSError *error)
     {
         
     }] ;
    
}
#pragma mark - end
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    if (theTextField==facebookTextField) {
        if (facebookTextField.text.length >= 1)
        {
            facebookImageView.image=[UIImage imageNamed:@"facebook_org.png"];
        }
        else
        {
            facebookImageView.image=[UIImage imageNamed:@"facebook.png"];
        }

    }
   else if (theTextField==twitterTextField) {
        if (twitterTextField.text.length >= 1)
        {
            twitterImageView.image=[UIImage imageNamed:@"twit_org.png"];
        }
        else
        {
            twitterImageView.image=[UIImage imageNamed:@"twit.png"];
        }
        
    }
   else if (theTextField==instaTextField) {
       if (instaTextField.text.length >= 1)
       {
           instaImageView.image=[UIImage imageNamed:@"insta_org.png"];
       }
       else
       {
            instaImageView.image=[UIImage imageNamed:@"insta.png"];
       }
   }

}
#pragma mark - IBActions
- (IBAction)saveSocialAccountsBtn:(id)sender
{
    [myDelegate ShowIndicator];
    [self performSelector:@selector(saveSocialAccountsInfo) withObject:nil afterDelay:.1];
}
#pragma mark - end

@end
