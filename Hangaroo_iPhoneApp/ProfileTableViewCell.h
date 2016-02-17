//
//  ProfileTableViewCell.h
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 01/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProfileDataModel.h"
#import "NotificationDataModel.h"

@interface ProfileTableViewCell : UITableViewCell
//locationCell
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsLabel;
@property (weak, nonatomic) IBOutlet UIButton *friendListButton;

//interestCell
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//notificationCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *noNotificationFound;
@property (weak, nonatomic) IBOutlet UILabel *seperatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationPictureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *notificationPhoto;

-(void)displayData :(MyProfileDataModel *)profileData :(int)indexPath;
-(void)displayNotificationData :(NotificationDataModel *)profileData :(int)indexPath;
@end
