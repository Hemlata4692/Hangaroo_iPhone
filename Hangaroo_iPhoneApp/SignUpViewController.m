//
//  SignUpViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 30/12/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import "SignUpViewController.h"
#import "UITextField+Validations.h"
#import "LoginViewController.h"
#import "TutorialViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"


@interface SignUpViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *textFieldArray;
}

@property (weak, nonatomic) IBOutlet UIScrollView *signUpScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *profileImageBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *userEmailField;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@end

@implementation SignUpViewController
@synthesize signUpScrollView,profileImageBtn,profileImageView;
@synthesize userNameField,userEmailField,passwordField;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Set the screen name for automatic screenview tracking.
    self.screenName = @"SignUp screen";
    //Adding textfield to array
    textFieldArray = @[userNameField,passwordField,userEmailField];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldArray]];
    [self.keyboardControls setDelegate:self];
    profileImageView.layer.cornerRadius=50.0f;
    profileImageView.clipsToBounds=YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.title=@"Sign up";
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
    [signUpScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark - end

#pragma mark - Textfield delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
    if([[UIScreen mainScreen] bounds].size.height==568)
    {
        if (textField==userEmailField)
        {
            [signUpScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-( textField.frame.size.height+90)) animated:YES];
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    [signUpScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
    
}
#pragma mark - end

#pragma mark - Email validation
- (BOOL)performValidationsForSignUp
{
    UIImage* placeholderImage = [UIImage imageNamed:@"thumb"];
    NSData *placeholderImageData = UIImagePNGRepresentation(placeholderImage);
    NSData *profileImageData = UIImagePNGRepresentation(profileImageView.image);
    
    if ([profileImageData isEqualToData:placeholderImageData])
    {
        [self showAlertMessage:@"Please upload an image."];
        return NO;
    }
    else if ([userNameField isEmpty] || [passwordField isEmpty] || [userEmailField isEmpty])
    {
        [self showAlertMessage:@"All fields are required."];
        return NO;
    }
    else
    {
        if ([userEmailField isValidEmail])
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
        else
        {
            [self showAlertMessage:@"Please enter a valid email address."];
            return NO;
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
#pragma mark - IBActions
- (IBAction)selectImageButtonAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose from Gallery", nil];
    
    [actionSheet showInView:self.view];
}
- (IBAction)doneButtonAction:(id)sender
{
    [self.keyboardControls.activeField resignFirstResponder];
    [signUpScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    if([self performValidationsForSignUp])
    {
        [myDelegate ShowIndicator];
        [self performSelector:@selector(signupUser) withObject:nil afterDelay:.1];
    }
    
}

#pragma mark - end

#pragma mark - Webservice
-(void) signupUser
{
    [[WebService sharedManager]registerUser:userEmailField.text password:passwordField.text userName:userNameField.text image:profileImageView.image success:^(id responseObject) {
        
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
                                      // [alertController dismissViewControllerAnimated:YES completion:nil];
                                       for (UIViewController *controller in self.navigationController.viewControllers)
                                       {
                                           if ([controller isKindOfClass:[TutorialViewController class]])
                                           {
                                               [self.navigationController popToViewController:controller animated:YES];
                                               
                                               break;
                                           }
                                       }

                                       
//                                       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                       LoginViewController * homeView = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//                                       [self.navigationController pushViewController:homeView animated:YES];
                                   }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
      
        
    } failure:^(NSError *error) {
        
    }] ;
    
}
#pragma mark - end

#pragma mark - Action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if (buttonIndex==0)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no camera."
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
            
        }
        else
            
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
        
    }
    if ([buttonTitle isEqualToString:@"Choose from Gallery"])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
}
#pragma mark - end

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info
{
    profileImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma mark - end
@end
