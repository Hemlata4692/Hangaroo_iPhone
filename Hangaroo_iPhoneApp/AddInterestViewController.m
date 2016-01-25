//
//  AddInterestViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 21/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "AddInterestViewController.h"
#import "UIPlaceHolderTextView.h"
#import "UIView+Toast.h"
#import "SettingViewController.h"

@interface AddInterestViewController ()

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *interestTextView;
@end

@implementation AddInterestViewController
@synthesize interestTextView;
#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.screenName = @"Add Interest screen";
    
    [interestTextView setPlaceholder:@"  Add your interest"];
    [interestTextView setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title=@"Interest";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - end
#pragma mark - Textfield delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if(textView.text.length>=100 && range.length == 0)
    {
        [self.view makeToast:@"You have reached 100 characters limit."];
        [textView resignFirstResponder];
        return NO;
        
    }
    else if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    else
    {
        return YES;
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length >= 100)
    {
        textView.text = [textView.text substringToIndex:100];
       // sharePostBtn.enabled=YES;
    }
    else if (textView.text.length==1) {
       // sharePostBtn.enabled=YES;
        
    }
    else if (textView.text.length==0) {
        //sharePostBtn.enabled=NO;
        
    }
}
#pragma mark - end
#pragma mark - Webservice
-(void)saveUserInterest
{
    [[WebService sharedManager]addUserInterest:interestTextView.text success: ^(id responseObject) {
        
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
#pragma mark - IBActions
- (IBAction)saveButtonAction:(id)sender
{
    [myDelegate ShowIndicator];
    [self performSelector:@selector(saveUserInterest) withObject:nil afterDelay:.1];
}
#pragma mark - end
@end
