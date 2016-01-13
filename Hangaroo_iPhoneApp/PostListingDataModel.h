//
//  PostListingDataModel.h
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 07/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostListingDataModel : NSObject
@property(nonatomic,retain)NSString * postContent;
@property(nonatomic,retain)NSString * postID;
@property(nonatomic,retain)NSString * joinedUserCount;
@property(nonatomic,retain)NSString * friendsJoinedCount;
@property(nonatomic,retain)NSString * postedDay;
@property(nonatomic,retain)NSString * isJoined;
@property(nonatomic,retain)NSString * creatorOfPost;
@property(nonatomic,retain)NSString * creatorOfPostName;
@property(nonatomic,retain)NSString * creatorOfPostUserId;
@property(nonatomic,retain)NSString * message;
@property(nonatomic,retain)NSMutableArray * uploadedPhotoArray;
@property(nonatomic,retain)NSMutableArray * joinedUserArray;
@end
