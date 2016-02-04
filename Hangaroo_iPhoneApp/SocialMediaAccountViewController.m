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
{
    NSString *facebookString;
    NSString *twitterString;
    NSString *instaString;
}
@property (weak, nonatomic) IBOutlet UIImageView *facebookImageView;
@property (weak, nonatomic) IBOutlet UITextField *facebookTextField;
@property (weak, nonatomic) IBOutlet UIImageView *instaImageView;
@property (weak, nonatomic) IBOutlet UITextField *instaTextField;
@property (weak, nonatomic) IBOutlet UIImageView *twitterImageView;
@property (weak, nonatomic) IBOutlet UITextField *twitterTextField;

@end

@implementation SocialMediaAccountViewController
@synthesize facebookImageView,facebookTextField,instaImageView,instaTextField,twitterImageView,twitterTextField;
@synthesize userSettingObj;
#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.screenName = @"Social media accounts screen";
    self.title = @"Social media accounts";
    [self loadData];
    
    [facebookTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [twitterTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [instaTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadData
{
    facebookTextField.text=userSettingObj.myProfileData.fbUrl;
    twitterTextField.text=userSettingObj.myProfileData.twitUrl;
    instaTextField.text=userSettingObj.myProfileData.instaUrl;
    
    if (facebookTextField.text.length >= 1)
    {
        facebookImageView.image=[UIImage imageNamed:@"facebook_org.png"];
    }
    else
    {
        facebookImageView.image=[UIImage imageNamed:@"facebook.png"];
    }
    
    
    
    if (twitterTextField.text.length >= 1)
    {
        twitterImageView.image=[UIImage imageNamed:@"twit_org.png"];
    }
    else
    {
        twitterImageView.image=[UIImage imageNamed:@"twit.png"];
    }
    
    
    
    if (instaTextField.text.length >= 1)
    {
        instaImageView.image=[UIImage imageNamed:@"insta_org.png"];
    }
    else
    {
        instaImageView.image=[UIImage imageNamed:@"insta.png"];
    }
    
    
}
#pragma mark - end
#pragma mark - Webservice
-(void)saveSocialAccountsInfo
{
    
    [[WebService sharedManager]socialAccounts:facebookTextField.text twitter:twitterTextField.text instagram:instaTextField.text success: ^(id responseObject) {
        
        [myDelegate StopIndicator];
        userSettingObj.myProfileData.fbUrl=facebookTextField.text;
        userSettingObj.myProfileData.twitUrl=twitterTextField.text;
        userSettingObj.myProfileData.instaUrl=instaTextField.text;
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[SettingViewController class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
                
                break;
            }
        }

//        UIAlertController *alertController = [UIAlertController
//                                              alertControllerWithTitle:@"Alert"
//                                              message:[responseObject objectForKey:@"message"]
//                                              preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *okAction = [UIAlertAction
//                                   actionWithTitle:@"OK"
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction *action)
//                                   {
//                                       
//                                       for (UIViewController *controller in self.navigationController.viewControllers)
//                                       {
//                                           if ([controller isKindOfClass:[SettingViewController class]])
//                                           {
//                                               [self.navigationController popToViewController:controller animated:YES];
//                                               
//                                               break;
//                                           }
//                                       }
//                                       
//                                   }];
//        
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
        
    }
                                      failure:^(NSError *error)
     {
         
     }] ;
    
}
#pragma mark - end
#pragma mark - Textfield delegate methods
-(void)textFieldDidChange :(UITextField *)theTextField{
 
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
    
}
#pragma mark - end
#pragma mark - IBActions
- (IBAction)saveSocialAccountsBtn:(id)sender
{
    [facebookTextField resignFirstResponder];
    [instaTextField resignFirstResponder];
    [twitterTextField resignFirstResponder];
    [myDelegate ShowIndicator];
    [self performSelector:@selector(saveSocialAccountsInfo) withObject:nil afterDelay:.1];
}
#pragma mark - end

@end
