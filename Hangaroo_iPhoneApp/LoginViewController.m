//
//  LoginViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 30/12/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import "LoginViewController.h"
#import "UITextField+Validations.h"
#import "HomeViewController.h"

@interface LoginViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate>
{
    NSArray *textFieldArray;
}

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@end

@implementation LoginViewController
@synthesize userNameField,passwordField;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    //Adding textfield to array
    textFieldArray = @[userNameField,passwordField];
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
     self.title=@"Sign in";
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

#pragma mark - Email validation
- (BOOL)performValidationsForLogin
{
    if ([userNameField isEmpty] || [passwordField isEmpty])
    {
        [self showAlertMessage:@"All fields are required"];
        return NO;
    }
    else
    {
        if (passwordField.text.length < 6)
        {
            [self showAlertMessage:@"Your password must be atleast 6 characters long."];
            return NO;
            
        }
        else
        {
            return YES;
        }
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

#pragma mark - IBAction
- (IBAction)loginButtonAction:(id)sender
{
    [self.keyboardControls.activeField resignFirstResponder];
    if([self performValidationsForLogin])
    {
        [myDelegate ShowIndicator];
        [self performSelector:@selector(loginUser) withObject:nil afterDelay:.1];
    }

}
- (IBAction)forgotPasswordButtonAction:(id)sender {
}
#pragma mark - end

#pragma mark - Webservice
-(void)loginUser
{
    [[WebService sharedManager] userLogin:userNameField.text password:passwordField.text success:^(id responseObject) {
        
        [myDelegate StopIndicator];
         NSDictionary *responseDict = (NSDictionary *)responseObject;
        [UserDefaultManager setValue:[responseDict objectForKey:@"userId"] key:@"userId"];
        [UserDefaultManager setValue:[responseDict objectForKey:@"username"] key:@"userName"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeViewController * homeView = [storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
        [myDelegate.window setRootViewController:homeView];
        [myDelegate.window makeKeyAndVisible];
        
    } failure:^(NSError *error) {
        
    }] ;
    
   
}
#pragma mark - end
@end
