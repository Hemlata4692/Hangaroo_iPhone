//
//  ForgotPasswordViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 30/12/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "UITextField+Validations.h"
#import "LoginViewController.h"

@interface ForgotPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userEmailField;

@end

@implementation ForgotPasswordViewController
@synthesize userEmailField;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the screen name for automatic screenview tracking.
    self.screenName = @"Forgot password screen";
    
    self.title=@"Forgot password";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
}
#pragma mark - end

#pragma mark - Textfield delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
    
}
#pragma mark - end

#pragma mark - Validation

- (BOOL)performValidationsForForgorPassword
{
       if ([userEmailField isEmpty])
    {
        [self showAlertMessage:@"Please enter your email address."];
        return NO;
    }
    else if (![userEmailField isValidEmail])
    {
         [self showAlertMessage:@"Please enter a valid email address."];
        return NO;
    }
    else
    {
        return YES;
    }
    
}

#pragma mark - end
#pragma mark - Alert message
-(void)showAlertMessage:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Alert"
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [alertController dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)submitButtonAction:(id)sender
{
    [userEmailField resignFirstResponder];
    if([self performValidationsForForgorPassword])
  {
        [myDelegate ShowIndicator];
        [self performSelector:@selector(forgotPassword) withObject:nil afterDelay:.1];
    }

}
#pragma mark - end

#pragma mark - Webservice
-(void)forgotPassword
{
    
    [[WebService sharedManager] forgotPassword:userEmailField.text success:^(id responseObject) {
        
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
                                       // [alertController dismissViewControllerAnimated:YES completion:nil];
                        
                                       for (UIViewController *controller in self.navigationController.viewControllers)
                                       {
                                           if ([controller isKindOfClass:[LoginViewController class]])
                                           {
                                               [self.navigationController popToViewController:controller animated:YES];
                                               
                                               break;
                                           }
                                       }

                                   }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    } failure:^(NSError *error) {
        
    }] ;

}
#pragma mark - end
@end
