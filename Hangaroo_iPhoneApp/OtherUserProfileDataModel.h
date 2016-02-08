//
//  OtherUserProfileDataModel.h
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 08/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OtherUserProfileDataModel : NSObject
@property(nonatomic,retain)NSString * userImageUrl;
@property(nonatomic,retain)NSString * userName;
@property(nonatomic,retain)NSString * otherUserId;
@property(nonatomic,retain)NSString * userFbUrl;
@property(nonatomic,retain)NSString * usertwitUrl;
@property(nonatomic,retain)NSString * userInstaUrl;
@property(nonatomic,retain)NSString * userLocation;
@property(nonatomic,retain)NSString * userInterest;
@property(nonatomic,retain)NSString * isFriend;
@property(nonatomic,retain)NSString * isRequestSent;
@property(nonatomic,retain)NSString * totalFriends;
@end
