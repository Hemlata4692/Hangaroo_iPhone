//
//  AddInterestViewController.h
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 21/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProfileDataModel.h"
#import "SettingViewController.h"

@interface AddInterestViewController : GlobalBackViewController
@property(strong, nonatomic) MyProfileDataModel *userProfileData;
@property(strong, nonatomic) SettingViewController *userSettingObj;
@end
