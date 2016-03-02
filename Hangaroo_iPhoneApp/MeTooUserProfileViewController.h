//
//  MeTooUserProfileViewController.h
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 07/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeTooUserProfileViewController : GAITrackedViewController
@property(nonatomic,retain) NSString * userProfileImageUrl;
@property(nonatomic,retain) NSString * postID;
@property(nonatomic,retain) NSString * post;
@property(nonatomic,retain) NSString * userName;
@property(nonatomic,retain) NSString * joineUserId;
@property(nonatomic,retain) NSString * followedUser;
@property(nonatomic,retain) NSArray * userDataArray;
@property(nonatomic,assign)int selectedIndex;


@end
