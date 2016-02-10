//
//  SharePostViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 04/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "SharePostViewController.h"
#import "UIPlaceHolderTextView.h"
#import "HomeViewController.h"
#import "UIView+Toast.h"

@interface SharePostViewController ()


@property (weak, nonatomic) IBOutlet UILabel *seperator;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *postTextView;
@property (weak, nonatomic) IBOutlet UIButton *sharePostBtn;

@end

@implementation SharePostViewController
@synthesize postTextView,seperator,sharePostBtn;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the screen name for automatic screenview tracking.
    self.screenName = @"Sharepost screen";
   
    [postTextView setPlaceholder:@" Do it for the hangaroo!"];
    [postTextView setFont:[UIFont fontWithName:@"Roboto-Regular" size:18.0]];
 
    seperator.frame=CGRectMake(self.view.frame.origin.x, self.postTextView.frame.size.height+1, self.view.frame.size.width, 1);
    postTextView.layer.borderWidth=1.0f;
    postTextView.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor grayColor]);
    
    
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title=@"Share post";
    if ([postTextView.text isEqualToString:@""]) {
        sharePostBtn.enabled=NO;
    }
    else
    {
        sharePostBtn.enabled=YES;
    }
    
}

#pragma mark - end

#pragma mark - Textfield delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   
    if(textView.text.length>=140 && range.length == 0)
    {
        [self.view makeToast:@"You have reached 140 characters limit."];
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
    if (textView.text.length >= 140)
    {
        textView.text = [textView.text substringToIndex:140];
         sharePostBtn.enabled=YES;
    }
    else if (textView.text.length==1) {
        sharePostBtn.enabled=YES;
       
    }
    else if (textView.text.length==0) {
        sharePostBtn.enabled=NO;
        
    }
}

#pragma mark - end

#pragma mark - IBActions
- (IBAction)sharePostButtonAction:(id)sender
{
    [postTextView resignFirstResponder];
   
    [myDelegate ShowIndicator];
    [self performSelector:@selector(sharePost) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Share post webservice
-(void)sharePost
{
    [[WebService sharedManager] sharePost:postTextView.text success:^(id responseObject) {
        
        [myDelegate StopIndicator];
        postTextView.text=@"";
         [self.tabBarController setSelectedIndex:0];
        
    } failure:^(NSError *error) {
        
    }] ;
    

}
#pragma mark - end
@end
