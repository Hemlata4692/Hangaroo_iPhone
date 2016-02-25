//
//  EditProfileViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 21/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "EditProfileViewController.h"
#import <UIImageView+AFNetworking.h>
#import "SettingViewController.h"

@interface EditProfileViewController ()<UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;

@end

@implementation EditProfileViewController
@synthesize infoLabel,userProfileImageView;
@synthesize userSettingObj;
#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //have to clear cache
    self.screenName = @"Edit profile photo screen";
    self.title=@"Edit profile photo";
    
   
    __weak UIImageView *weakRef = userProfileImageView;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:userSettingObj.myProfileData.profileImageUrl]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [userProfileImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"placeholder.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];

    
    UITapGestureRecognizer *imageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped)];
    imageViewTap.delegate = self;
    
      [userProfileImageView addGestureRecognizer:imageViewTap];

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
#pragma mark - Change profile image action
- (void) imageViewTapped
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose from Gallery", nil];
    
    [actionSheet showInView:self.view];
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

#pragma mark - Image picker controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info
{
    userProfileImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma mark - end

#pragma mark - Webservice

-(void) editProfilePhoto
{
    [[WebService sharedManager]editProfilePhoto:userProfileImageView.image success: ^(id responseObject) {
        
        [myDelegate stopIndicator];
        userSettingObj.myProfileData.profileImageUrl=[responseObject objectForKey:@"user_image"];
        [UserDefaultManager setValue:[responseObject objectForKey:@"user_image"] key:@"userImage"];
        [myDelegate editProfileImageUploading:userProfileImageView.image];
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
- (IBAction)saveButtonAction:(id)sender
{
    [myDelegate showIndicator];
    [self performSelector:@selector(editProfilePhoto) withObject:nil afterDelay:.1];

}
#pragma mark - end
@end
