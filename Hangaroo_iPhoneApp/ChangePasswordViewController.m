//
//  ChangePasswordViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 21/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UITextField+Validations.h"
#import "SettingViewController.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate>
{
    NSArray *textFieldArray;
}
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *changePasswordField;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation ChangePasswordViewController
@synthesize confirmPasswordField,oldPasswordField,changePasswordField;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
     self.screenName = @"Change password screen";
    //Adding textfield to array
    textFieldArray = @[oldPasswordField,changePasswordField,confirmPasswordField];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldArray]];
    [self.keyboardControls setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.title=@"Change password";
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[self navigationController] setNavigationBarHidden:NO];
    
}
#pragma mark - end
#pragma mark - Keyboard controls delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Textfield delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
 }

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Password validation
- (BOOL)performValidationsForConfirmPassword
{
    if ([oldPasswordField isEmpty] || [changePasswordField isEmpty] || [confirmPasswordField isEmpty])
    {
        [self showAlertMessage:@"All fields are required."];
        return NO;
    }
    else  if (changePasswordField.text.length < 6)
    {
        [self showAlertMessage:@"Your password must be atleast 6 characters long."];
        return NO;
    }
    else if (![changePasswordField.text isEqualToString:confirmPasswordField.text])
    {
        [self showAlertMessage:@"Passwords do not match."];
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

#pragma mark - Webservice
-(void)changePassword
{
    [[WebService sharedManager]changePassword:oldPasswordField.text newPassword:changePasswordField.text success: ^(id responseObject) {
        [myDelegate stopIndicator];
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

#pragma mark - IBActions
- (IBAction)changePasswordButtonAction:(id)sender
{
    [self.keyboardControls.activeField resignFirstResponder];
    if([self performValidationsForConfirmPassword])
    {
        [myDelegate showIndicator];
        [self performSelector:@selector(changePassword) withObject:nil afterDelay:.1];
    }    
}
#pragma mark - end
@end
