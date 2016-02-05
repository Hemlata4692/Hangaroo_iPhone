//
//  FriendListDataModel.h
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 04/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendListDataModel : NSObject
@property(nonatomic,retain)NSString * userImageUrl;
@property(nonatomic,retain)NSString * userName;
@property(nonatomic,retain)NSString * mutualFriends;
@property(nonatomic,retain)NSString * isFriend;
@property(nonatomic,retain)NSString * isRequestSent;
@property(nonatomic,retain)NSString * totalRecords;
@end
