//
//  ProfileTableViewCell.h
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 01/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProfileDataModel.h"

@interface ProfileTableViewCell : UITableViewCell
//locationCell
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsLabel;

//interestCell
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;

//notificationCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;

-(void)layoutView1 :(CGRect)rect;
-(void)layoutView2 :(CGRect)rect;
//-(void)layoutView3 :(CGRect)rect count:(int)count;
-(void)layoutView4 :(CGRect)rect;
-(void)displayData :(MyProfileDataModel *)profileData :(int)indexPath;
@end
