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
{
    int Count;
    int checker;
}

@property (weak, nonatomic) IBOutlet UILabel *seperator;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *postTextView;
@property (weak, nonatomic) IBOutlet UIButton *sharePostBtn;
@property (weak, nonatomic) IBOutlet UILabel *textCount;

@end

@implementation SharePostViewController
@synthesize postTextView,seperator,sharePostBtn,textCount;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the screen name for automatic screenview tracking.
    self.screenName = @"Sharepost screen";
    [postTextView setPlaceholder:@" Do it for the hangaroo!"];
    [postTextView setFont:[UIFont fontWithName:@"Roboto-Regular" size:20.0]];
    
    postTextView.translatesAutoresizingMaskIntoConstraints = YES;
    seperator.translatesAutoresizingMaskIntoConstraints = YES;
    postTextView.frame=CGRectMake(0, 0, self.view.frame.size.width, postTextView.frame.size.height);
     seperator.frame=CGRectMake(0, seperator.frame.origin.y , self.view.frame.size.width, 1);
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title=@"Share post";
    [[self navigationController] setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if ([postTextView.text isEqualToString:@""]) {
        sharePostBtn.enabled=NO;
        checker=1;
        Count=140;
        textCount.text=[NSString stringWithFormat:@"%lu",Count - postTextView.text.length];
    }
    else
    {
        sharePostBtn.enabled=YES;
        textCount.text=[NSString stringWithFormat:@"%lu", Count - postTextView.text.length];
    }
}
#pragma mark - end

#pragma mark - Textfield delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (([postTextView sizeThatFits:postTextView.frame.size].height < 250) && ([postTextView sizeThatFits:postTextView.frame.size].height > 50)) {
        
        postTextView.frame = CGRectMake(postTextView.frame.origin.x, postTextView.frame.origin.y, postTextView.frame.size.width, [postTextView sizeThatFits:postTextView.frame.size].height);
        seperator.frame=CGRectMake(self.view.frame.origin.x, self.postTextView.frame.size.height+1, self.view.frame.size.width, 1);
    }

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
        if (![text isEqualToString:@" "] && ![text isEqualToString:@""])
        {
            checker=2;
        }
        if (checker==1)
        {
            sharePostBtn.enabled=NO;
        }
        else
        {
            sharePostBtn.enabled=YES;
        }
       
        return YES;
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (([postTextView sizeThatFits:postTextView.frame.size].height < 250) && ([postTextView sizeThatFits:postTextView.frame.size].height > 50)) {
        
        postTextView.frame = CGRectMake(postTextView.frame.origin.x, postTextView.frame.origin.y, postTextView.frame.size.width, [postTextView sizeThatFits:postTextView.frame.size].height);
        seperator.frame=CGRectMake(self.view.frame.origin.x, self.postTextView.frame.size.height+1, self.view.frame.size.width, 1);
    }
    else if([postTextView sizeThatFits:postTextView.frame.size].height <= 50){
       
        postTextView.frame = CGRectMake(postTextView.frame.origin.x, postTextView.frame.origin.y, postTextView.frame.size.width, 50);
        seperator.frame=CGRectMake(self.view.frame.origin.x, self.postTextView.frame.size.height+1, self.view.frame.size.width, 1);
    }

    if (textView.text.length >= 140)
    {
        textView.text = [textView.text substringToIndex:140];
        sharePostBtn.enabled=YES;
      
    }
    else if (textView.text.length==0) {
        sharePostBtn.enabled=NO;
        checker=1;
    }
    
    textCount.text = [NSString stringWithFormat:@"%lu", Count - textView.text.length];
}

#pragma mark - end

#pragma mark - IBActions
- (IBAction)sharePostButtonAction:(id)sender
{
    [postTextView resignFirstResponder];
    NSString *trimmedString = [postTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    postTextView.text=trimmedString;
    [myDelegate showIndicator];
    [self performSelector:@selector(sharePost) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Webservice
-(void)sharePost
{
    [[WebService sharedManager] sharePost:postTextView.text success:^(id responseObject) {
        
        [myDelegate stopIndicator];
        postTextView.text=@"";
        [self.tabBarController setSelectedIndex:0];
        
    } failure:^(NSError *error) {
        
    }] ;
    
    
}
#pragma mark - end
@end
