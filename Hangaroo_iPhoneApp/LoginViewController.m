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
     UIImageView *userImageview;
      NSString* userId, *userName, *userImage, *joiningYear;
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
    // Set the screen name for automatic screenview tracking.
    userImage = @"";
    userName = @"";
    userId = @"";
    joiningYear = @"";
    userImageview=[[UIImageView alloc]init];
    self.screenName = @"SignIn screen";
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
        [myDelegate showIndicator];
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
        
        [myDelegate stopIndicator];
         NSDictionary *responseDict = (NSDictionary *)responseObject;
        
       
        userId = [responseDict objectForKey:@"userId"];
        userName = [responseDict objectForKey:@"username"];
        userImage = [responseDict objectForKey:@"userImage"];
        joiningYear = [responseDict objectForKey:@"joining_year"];
        
        [myDelegate showIndicator];
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:userImage]
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:60];
        __weak UIImageView *weakRef = userImageview;
        __weak typeof(self) weakSelf = self;
        [userImageview setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakRef.contentMode = UIViewContentModeScaleAspectFill;
            weakRef.clipsToBounds = YES;
            weakRef.image = image;
            
            [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:weakSelf
                                           selector:@selector(targetMethod)
                                           userInfo:nil
                                            repeats:NO];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];

    } failure:^(NSError *error) {
        
    }] ;
    
   
}
-(void)targetMethod
{
    myDelegate.userProfileImageDataValue = UIImageJPEGRepresentation(userImageview.image, 1.0);
    NSString *username = [NSString stringWithFormat:@"%@@52.74.174.129",userName]; // OR
    NSString *password = passwordField.text;
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    del.xmppStream.myJID = [XMPPJID jidWithString:username];
    
    //    NSLog(@"Does supports registration %ub ", );
    NSLog(@"Attempting registration for username %@",del.xmppStream.myJID.bare);
    
    if (del.xmppStream.supportsInBandRegistration) {
        NSError *error = nil;
        if (![del.xmppStream registerWithPassword:password name:[NSString stringWithFormat:@"%@@52.74.174.129@%@",userName,joiningYear] error:&error])
        {
            NSLog(@"Oops, I forgot something: %@", error);
        }else{
            NSLog(@"No Error");
            if ([UserDefaultManager getValue:@"CountData"] == nil) {
                NSMutableDictionary* countData = [NSMutableDictionary new];
                
                [UserDefaultManager setValue:countData key:@"CountData"];
                
            }
            
            if ([UserDefaultManager getValue:@"BadgeCount"] == nil) {
                [UserDefaultManager setValue:@"0" key:@"BadgeCount"];
            }
            [UserDefaultManager setValue:userId key:@"userId"];
            [UserDefaultManager setValue:userName key:@"userName"];
            [UserDefaultManager setValue:userImage key:@"userImage"];
            [UserDefaultManager setValue:joiningYear key:@"joining_year"];
            [myDelegate registerDeviceForNotification];
            //            AppDelegate *delegate=[self appDelegate];
            [myDelegate disconnect];
            [UserDefaultManager setValue:username key:@"LoginCred"];
            [UserDefaultManager setValue:password key:@"PassCred"];
            [UserDefaultManager setValue:@"1" key:@"CountValue"];
            [myDelegate connect];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HomeViewController * homeView = [storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
            [myDelegate.window setRootViewController:homeView];
            [myDelegate.window makeKeyAndVisible];
            
        }
    }
}

#pragma mark - end
@end
