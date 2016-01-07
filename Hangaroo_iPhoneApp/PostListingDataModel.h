//
//  PostListingDataModel.h
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 07/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostListingDataModel : NSObject
@property(nonatomic,retain)NSString * postStatus;
@property(nonatomic,retain)NSString * postID;
@property(nonatomic,retain)NSString * joinedUser;
@property(nonatomic,retain)NSString * friendsJoined;
@property(nonatomic,retain)NSString * postedDay;
@property(nonatomic,retain)NSMutableArray * uploadedPhotoArray;
@property(nonatomic,retain)NSMutableArray * joinedUserArray;
@end
