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
    
    [interestTextView setPlaceholder:@" Add your interest"];
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
@end
