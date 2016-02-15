//
//  SharePostViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 04/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "SharePostViewController.h"
#import "UIPlaceHolderTextView.h"

@interface SharePostViewController ()


@property (weak, nonatomic) IBOutlet UILabel *seperator;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *postTextView;

@end

@implementation SharePostViewController
@synthesize postTextView,seperator;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
     
   // [postTextView setReturnKeyType: UIReturnKeyDone];
    [postTextView setPlaceholder:@" Do it for the hangaroo!"];
    [postTextView setFont:[UIFont fontWithName:@"Roboto-Regular" size:18.0]];
   // [postTextView setTextContainerInset:UIEdgeInsetsMake(5, 3, 0,0)];
    //[postTextView setTextAlignment:NSTextAlignmentLeft];
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
    self.navigationItem.title=@"Share Post";
    
}

#pragma mark - end

#pragma mark - Textfield delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   
    if(textView.text.length>=140 && range.length == 0)
    {
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

#pragma mark - end

#pragma mark - IBActions
- (IBAction)sharePostButtonAction:(id)sender
{
    [myDelegate ShowIndicator];
    [self performSelector:@selector(sharePost) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Webservice
-(void)sharePost
{
    [[WebService sharedManager] sharePost:postTextView.text success:^(id responseObject) {
        
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
                                    [alertController dismissViewControllerAnimated:YES completion:nil];
                                       postTextView.text=@"";
                                   }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    } failure:^(NSError *error) {
        
    }] ;
    

}
#pragma mark - end
@end