//
//  WebService.h
//
//  Created by Hema on 19/08/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//client link
#define BASE_URL                                  @"http://52.74.174.129/admin/api/"

//testing link
//#define BASE_URL                                @"http://52.74.174.129/beta/admin/api"

@interface WebService : NSObject
@property(nonatomic,retain)AFHTTPRequestOperationManager *manager;
+ (id)sharedManager;

//Login screen method
- (void)userLogin:(NSString *)email password:(NSString *)password success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Register screen method
-(void)registerUser:(NSString *)email password:(NSString *)password userName:(NSString*)userName image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Forgot password method
-(void)forgotPassword:(NSString *)email success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Share post method
-(void)sharePost:(NSString *)post success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//Post listing method
-(void)postListing:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

//Hot post listing
-(void)hotPostListing:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

//Join post method
-(void)joinPost:(NSString *)postID success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//Upload photo method
-(void)uploadPhoto:(NSString *)postID image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//Photo listing
-(void)photoListing:(NSString *)postID success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Like dislike
-(void)likDislikePhoto:(NSString *)imageUrl likeDislike:(NSString *)likeDislike success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Edit profile photo
-(void)editProfilePhoto:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Add interest
-(void)addUserInterest:(NSString *)userInterest success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Share feedback
-(void)shareFeedback:(NSString *)subject content:(NSString *)content success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Add social account
-(void)socialAccounts:(NSString *)facebook twitter:(NSString *)twitter instagram:(NSString *)instagram success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Change password
-(void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Tap to see out
-(void)seeOutNotification:(NSString *)joinedUserId success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//My profile
-(void)myProfile:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Notifications
-(void)getUserNotification:(NSString *)offset success:(void (^)(id))success failure:(void (^)(NSError *error))failure;
//end

//Friend List
-(void)getFriendList:(NSString *)offset otherUserId:(NSString *)otherUserId success:(void (^)(id))success failure:(void (^)(NSError *error))failure;
//end

//Other user profile
-(void)otherUserProfile:(NSString *)friendUserId success:(void (^)(id))success failure:(void (^)(NSError *error))failure;
//end

//Send frient request
-(void)sendFriendRequest:(NSString *)friendUserId success:(void (^)(id))success failure:(void (^)(NSError *error))failure;
//end

//Friend request list
-(void)friendRequestList:(NSString *)offset success:(void (^)(id))success failure:(void (^)(NSError *error))failure;
//end

//Suggested friend list
-(void)suggestedFriendList:(NSString *)offset success:(void (^)(id))success failure:(void (^)(NSError *error))failure;
//end

//Search friends
-(void)searchFriends:(NSString *)offset serachKey:(NSString *)serachKey success:(void (^)(id))success failure:(void (^)(NSError *error))failure;
//end

//Accept friend request
-(void)acceptFriendRequest:(NSString *)otherFriendId acceptRequest:(NSString *)acceptRequest success:(void (^)(id))success failure:(void (^)(NSError *error))failure;
//end

//Chat notification
-(void)chatNotification:(NSString *)userNameTo userNameFrom:(NSString *)userNameFrom messageString:(NSString *)messageString success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Register device for push notification
-(void)registerDeviceForPushNotification:(NSString *)deviceId deviceType:(NSString *)deviceType success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end
@end
