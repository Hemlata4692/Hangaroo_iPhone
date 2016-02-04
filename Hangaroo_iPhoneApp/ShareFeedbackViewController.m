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
#pragma mark - Webservice
-(void)saveUserFeedback
{
    [[WebService sharedManager]shareFeedback:subjectTextField.text content:contentTextView.text success: ^(id responseObject) {
        
        [myDelegate StopIndicator];
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

#pragma mark - IBActions
- (IBAction)saveFeedbackButtonAction:(id)sender
{
    [self.keyboardControls.activeField resignFirstResponder];
    [myDelegate ShowIndicator];
    [self performSelector:@selector(saveUserFeedback) withObject:nil afterDelay:.1];
}
#pragma mark - end
@end
