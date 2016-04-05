//
//  ShareFeedbackViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 21/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ShareFeedbackViewController.h"
#import "UIPlaceHolderTextView.h"
#import "SettingViewController.h"
#import "UITextField+Validations.h"

@interface ShareFeedbackViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate,UITextViewDelegate>
{
    NSArray *textFieldArray;
}

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@end

@implementation ShareFeedbackViewController
@synthesize contentTextView,subjectTextField;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.screenName = @"Share feedback screen";
    self.title = @"Share feedback";
    //Adding textfield to array
    textFieldArray = @[subjectTextField,contentTextView];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldArray]];
    [self.keyboardControls setDelegate:self];
    [contentTextView setPlaceholder:@" Content:"];
    [contentTextView setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
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
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.keyboardControls setActiveField:textView];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end
#pragma mark - Email validation
- (BOOL)performValidationsForFeedback
{
    if ([subjectTextField isEmpty] && contentTextView.text.length<=0)
    {
        [self showAlertMessage:@"Please enter a subject and content in the body."];
        return NO;
    }
    else
    {
        if ([subjectTextField isEmpty])
        {
            [self showAlertMessage:@"Please enter a subject."];
            return NO;
        }
        else if (contentTextView.text.length<=0)
        {
            [self showAlertMessage:@"Please enter content in the body."];
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

#pragma mark - Webservice
-(void)saveUserFeedback
{
    [[WebService sharedManager]shareFeedback:subjectTextField.text content:contentTextView.text success: ^(id responseObject) {
        [myDelegate stopIndicator];
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[SettingViewController class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
                
                break;
            }
        }
    }
                                     failure:^(NSError *error)
     {
         
     }] ;
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)saveFeedbackButtonAction:(id)sender
{
    [self.keyboardControls.activeField resignFirstResponder];
    if ([self performValidationsForFeedback]) {
        [myDelegate showIndicator];
        [self performSelector:@selector(saveUserFeedback) withObject:nil afterDelay:.1];
    }
    
}
#pragma mark - end
@end
