//
//  WebService.m
//  ActorsCam
//
//  Created by Hema on 19/08/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import "WebService.h"
#import "NullValueChecker.h"
#import "TutorialViewController.h"
#import "PostImageDataModel.h"
#import "PostListingDataModel.h"
#import "JoinedUserDataModel.h"
#import "PhotoListingModel.h"
#import "MyProfileDataModel.h"
#import "NotificationDataModel.h"
#import "FriendListDataModel.h"
#import "OtherUserProfileDataModel.h"
#import "DiscoverDataModel.h"

#define kUrlLogin                       @"login"
#define kUrlRegister                    @"register"
#define kUrlForgotPassword              @"forgotpassword"
#define kUrlSharePost                   @"sharepost"
#define kUrlPostListing                 @"postlisting"
#define kUrlJoinPost                    @"joinpost"
#define kUrlUploadPhoto                 @"uploadphoto"
#define kUrlPhotoListing                @"photolisting"
#define kUrlLikeDislike                 @"likedislike"
#define kUrlEditProfilePhoto            @"edituserimage"
#define kUrlAddInterest                 @"userinterest"
#define kUrlShareFeedback               @"sharefeedback"
#define kUrlChangePassword              @"changepass"
#define kUrlRegisterDevice              @"registerdevice"
#define kUrlTapToSeeOut                 @"seeout"
#define kUrlSocialAccounts              @"socialaccounts"
#define kUrlMyProfile                   @"userprofile"
#define kUrlUserNotification            @"getnotifications"
#define kUrlFriendList                  @"userfriendlist"
#define kUrlOtherUserProfile            @"otheruserprofile"
#define kUrlSentRequest                 @"sentrequest"
#define kUrlFriendRequestList           @"requestlist"
#define kUrlSuggestedFriendList         @"suggestedfrnds"
#define kUrlAcceptRequest               @"acceptdecline"
#define kUrlSearch                      @"search"
@implementation WebService
@synthesize manager;


+ (id)sharedManager
{
    static WebService *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
- (id)init
{
    if (self = [super init])
    {
        manager = [[AFHTTPRequestOperationManager manager] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    }
    return self;
}

#pragma mark - AFNetworking method
- (void)post:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [myDelegate StopIndicator];
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [myDelegate StopIndicator];
        failure(error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        });
        
    }];
}


- (void)postImage:(NSString *)path parameters:(NSDictionary *)parameters image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //  NSLog(@"path: %@, %@", path, parameters);
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
    [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //[formData appendPartWithFormData:imageData name:@"image.png"];
        [formData appendPartWithFileData:imageData name:@"files" fileName:@"files.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [myDelegate StopIndicator];
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [myDelegate StopIndicator];
        failure(error);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        });
    }];
}

- (void)postImageArray:(NSString *)path parameters:(NSDictionary *)parameters image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //  NSLog(@"path: %@, %@", path, parameters);
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
    [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //[formData appendPartWithFormData:imageData name:@"image.png"];
        [formData appendPartWithFileData:imageData name:@"files[]" fileName:@"files.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [myDelegate StopIndicator];
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [myDelegate StopIndicator];
        failure(error);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        });
    }];
}


- (BOOL)isStatusOK:(id)responseObject {
    NSNumber *number = responseObject[@"isSuccess"];
    NSString *msg;
    switch (number.integerValue)
    {
        case 0:
        {
            msg = responseObject[@"message"];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            });
            return NO;
        }
            
        case 1:
            return YES;
            break;
            
        case 2:
        {
            msg = responseObject[@"message"];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.tag=1;
                [alert show];
            });
            
        }
            return NO;
            break;
        default: {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:responseObject[@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            });
            
        }
            return NO;
            break;
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag==1 && buttonIndex==0)
    {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        
        myDelegate.window.rootViewController = myDelegate.navigationController;
        [UserDefaultManager removeValue:@"userId"];
        [UserDefaultManager removeValue:@"username"];
    }
}

#pragma mark - end

#pragma mark- Login
//Login
- (void)userLogin:(NSString *)email password:(NSString *)password success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSDictionary *requestDict = @{@"username":email,@"password":password};
    NSLog(@"login request%@", requestDict);
    [self post:kUrlLogin parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"Login User Response%@", responseObject);
         if([self isStatusOK:responseObject])
         {
             success(responseObject);
         } else
         {
             [myDelegate StopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Register
//Register
-(void)registerUser:(NSString *)email password:(NSString *)password userName:(NSString*)userName image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"email_id":email,@"password":password,@"username":userName};
    NSLog(@"register user request%@", requestDict);
    [self postImage:kUrlRegister parameters:requestDict image:image success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"Register User Response%@", responseObject);
         if([self isStatusOK:responseObject])
         {
             success(responseObject);
         }
         else
         {
             [myDelegate StopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Forgot password
//Forgot Password
-(void)forgotPassword:(NSString *)email success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"email_id":email};
    NSLog(@"forgot password request%@", requestDict);
    [self post:kUrlForgotPassword parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"forgot User Response%@", responseObject);
         if([self isStatusOK:responseObject])
         {
             success(responseObject);
         } else
         {
             [myDelegate StopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Share post
//Share Post
-(void)sharePost:(NSString *)post success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //{user_id:"20" post_content:"i had a bad day"}
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"post_content":post};
    NSLog(@"share post request%@", requestDict);
    [self post:kUrlSharePost parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"share User Response%@", responseObject);
         if([self isStatusOK:responseObject])
         {
             success(responseObject);
         } else
         {
             [myDelegate StopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Post listing
//Post Listing
-(void)postListing:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"]};
    NSLog(@"post listing request%@", requestDict);
    [self post:kUrlPostListing parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"postlisting User Response%@", responseObject);
         if([self isStatusOK:responseObject])
         {
             id array =[responseObject objectForKey:@"post_listing"];
             if (([array isKindOfClass:[NSArray class]]))
             {
                 NSArray * postListingArray = [responseObject objectForKey:@"post_listing"];
                 NSMutableArray *dataArray = [NSMutableArray new];
                 
                 
                 for (int i =0; i<postListingArray.count; i++)
                 {
                     PostListingDataModel *postListData = [[PostListingDataModel alloc]init];
                     NSDictionary * postListDict =[postListingArray objectAtIndex:i];
                     postListData.joinedUserArray = [[NSMutableArray alloc]init];
                     postListData.uploadedPhotoArray = [[NSMutableArray alloc]init];
                     postListData.postContent =[postListDict objectForKey:@"post_content"];
                     postListData.postedDay =[postListDict objectForKey:@"posted"];
                     postListData.postID =[postListDict objectForKey:@"post_id"];
                     postListData.creatorOfPost=[postListDict objectForKey:@"createOfPost"];
                     postListData.friendsJoinedCount =[postListDict objectForKey:@"friends_joined"];
                     postListData.joinedUserCount=[postListDict objectForKey:@"joined_users_count"];
                     postListData.isJoined = [postListDict objectForKey:@"is_joined"];
                     postListData.creatorOfPostName = [postListDict objectForKey:@"PostCreatorName"];
                     postListData.creatorOfPostUserId=[postListDict objectForKey:@"user_id"];
                     NSArray *joinedArray=[postListDict objectForKey:@"joined_users"];
                     
                     for (int j =0; j<joinedArray.count; j++)
                     {
                         JoinedUserDataModel * joinedUserList = [[JoinedUserDataModel alloc]init];
                         NSDictionary * joinedUserDict =[joinedArray objectAtIndex:j];
                         
                         joinedUserList.joinedUserName = [joinedUserDict objectForKey:@"username"];
                         joinedUserList.joinedUserImage =[joinedUserDict objectForKey:@"image_url"];
                         joinedUserList.joinedUserId=[joinedUserDict objectForKey:@"id"];
                         
                         [postListData.joinedUserArray addObject:joinedUserList];
                         
                     }
                     
                     NSArray *postImagesArray=[postListDict objectForKey:@"post_images"];
                     for (int k =0; k<postImagesArray.count; k++)
                     {
                         NSDictionary * postImagesDict =[postImagesArray objectAtIndex:k];
                         PostImageDataModel * postImagesList = [[PostImageDataModel alloc]init];
                         postImagesList.postImageUrl = [postImagesDict objectForKey:@"image"];
                         
                         [postListData.uploadedPhotoArray addObject:postImagesList];
                         
                     }
                     
                     [dataArray addObject:postListData];
                 }
                 success(dataArray);
             }
             else
             {
                 PostListingDataModel *postListData = [[PostListingDataModel alloc]init];
                 postListData.message =[responseObject objectForKey:@"message"];
                 success(postListData);
             }
         } else
         {
             [myDelegate StopIndicator];
             failure(responseObject);
         }
     }
       failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Join post
-(void)joinPost:(NSString *)postID success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"post_id":postID};
    NSLog(@"join post  request%@", requestDict);
    [self post:kUrlJoinPost parameters:requestDict success:^(id responseObject)
     {
         NSLog(@"join post Response%@", responseObject);
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         if([self isStatusOK:responseObject])
         {
             success(responseObject);
         } else
         {
             [myDelegate StopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Upload photo
-(void)uploadPhoto:(NSString *)postID image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"post_id":postID};
    NSLog(@"me too User request%@", requestDict);
    [self postImageArray:kUrlUploadPhoto parameters:requestDict image:image success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"Register User Response%@", responseObject);
         if([self isStatusOK:responseObject])
         {
             success(responseObject);
         }
         else
         {
             [myDelegate StopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Photo Listing
-(void)photoListing:(NSString *)postID success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"post_id":postID};
    NSLog(@"photo listing User request%@", requestDict);
    [self post:kUrlPhotoListing parameters:requestDict success:^(id responseObject)
     {
         NSLog(@"photo listing User Response%@", responseObject);
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         if([self isStatusOK:responseObject])
         {
             id array =[responseObject objectForKey:@"photoListing"];
             if (([array isKindOfClass:[NSArray class]]))
             {
                 NSArray * photoListingArray = [responseObject objectForKey:@"photoListing"];
                 NSMutableArray *dataArray = [NSMutableArray new];
                 
                 
                 for (int i =0; i<photoListingArray.count; i++)
                 {
                     PhotoListingModel *photoListData = [[PhotoListingModel alloc]init];
                     NSDictionary * photoListDict =[photoListingArray objectAtIndex:i];
                     photoListData.likeCountData =[photoListDict objectForKey:@"like_count"];
                     photoListData.dislikeCountData =[photoListDict objectForKey:@"dislike_count"];
                     photoListData.postImagesUrl =[photoListDict objectForKey:@"post_image"];
                     photoListData.uploadedImageTime =[photoListDict objectForKey:@"uploaded_time"];
                     photoListData.userImageUrl=[photoListDict objectForKey:@"user_image_url"];
                     photoListData.isLike=[photoListDict objectForKey:@"is_like"];
                     
                     [dataArray addObject:photoListData];
                 }
                 success(dataArray);
             }
         }
         else
         {
             [myDelegate StopIndicator];
             failure(responseObject);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Like Dislike

-(void)likDislikePhoto:(NSString *)imageUrl likeDislike:(NSString *)likeDislike success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"imageName":imageUrl,@"isLike":likeDislike};
    NSLog(@"like dislike  request%@", requestDict);
    [self post:kUrlLikeDislike parameters:requestDict success:^(id responseObject)
     {
         NSLog(@"like dislike Response%@", responseObject);
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         if([self isStatusOK:responseObject])
         {
             success(responseObject);
         } else
         {
             [myDelegate StopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Edit Profile Photo
-(void)editProfilePhoto:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"]};
    NSLog(@"edit profile photo request%@", requestDict);
    [self postImage:kUrlEditProfilePhoto parameters:requestDict image:image success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"Edit profile photo Response%@", responseObject);
         if([self isStatusOK:responseObject])
         {
             success(responseObject);
         }
         else
         {
             [myDelegate StopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Add User Interest
-(void)addUserInterest:(NSString *)userInterest success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"interest":userInterest};
    NSLog(@"Add user interst request%@", requestDict);
    [self post:kUrlAddInterest parameters:requestDict success:^(id responseObject)
     {
         NSLog(@"Add user interst Response%@", responseObject);
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         if([self isStatusOK:responseObject])
         {
             success(responseObject);
         } else
         {
             [myDelegate StopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
    
}
#pragma mark- end

#pragma mark- Share Feedback
-(void)shareFeedback:(NSString *)subject content:(NSString *)content success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"subject":subject,@"content":content};
    NSLog(@"share feedback request%@", requestDict);
    [self post:kUrlShareFeedback parameters:requestDict success:^(id responseObject)
     {
         NSLog(@"share feedback Response%@", responseObject);
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         if([self isStatusOK:responseObject])
         {
             success(responseObject);
         } else
         {
             [myDelegate StopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
    
}
#pragma mark- end

#pragma mark- Change Password
-(void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"oldPassword":oldPassword,@"newPassword":newPassword};
    NSLog(@"change password request%@", requestDict);
    [self post:kUrlChangePassword parameters:requestDict success:^(id responseObject)
     {
         NSLog(@"change password Response%@", responseObject);
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         if([self isStatusOK:responseObject])
         {
             success(responseObject);
         } else
         {
             [myDelegate StopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
    
}
#pragma mark- end

#pragma mark- Register Device
-(void)registerDeviceForPushNotification:(NSString *)deviceId deviceType:(NSString *)deviceType success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"deviceId":deviceId,@"deviceType":deviceType};
    NSLog(@"Register device  request%@", requestDict);
    [self post:kUrlRegisterDevice parameters:requestDict success:^(id responseObject)
     {
         NSLog(@"Register device Response%@", responseObject);
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         if([self isStatusOK:responseObject])
         {
             NSLog(@"Notification info  --------------------->>>%@",responseObject);
             success(responseObject);
         }
         else
         {
             [myDelegate StopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- See Out Notification
-(void)seeOutNotification:(NSString *)joinedUserId success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"joined_userid":joinedUserId};
    NSLog(@"Tap to see out request%@", requestDict);
    [self post:kUrlTapToSeeOut parameters:requestDict success:^(id responseObject)
     {
         NSLog(@"Tap to see out Response%@", responseObject);
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         if([self isStatusOK:responseObject])
         {
             success(responseObject);
         } else
         {
             [myDelegate StopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Social Accounts
//Add social account
-(void)socialAccounts:(NSString *)facebook twitter:(NSString *)twitter instagram:(NSString *)instagram success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"fb_username":facebook,@"twitter_username":twitter,@"insta_username":instagram};
    NSLog(@"socialAccounts request%@", requestDict);
    [self post:kUrlSocialAccounts parameters:requestDict success:^(id responseObject)
     {
         NSLog(@"socialAccounts Response%@", responseObject);
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         if([self isStatusOK:responseObject])
         {
             success(responseObject);
         } else
         {
             [myDelegate StopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- My Profile
-(void)myProfile:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"]};
    NSLog(@"my Profile User request%@", requestDict);
    [self post:kUrlMyProfile parameters:requestDict success:^(id responseObject)
     {
         NSLog(@"my Profile User Response%@", responseObject);
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         if([self isStatusOK:responseObject])
         {
             NSMutableArray *profileDataArray = [NSMutableArray new];
             
             MyProfileDataModel *profileData = [[MyProfileDataModel alloc]init];
             NSDictionary * profileDict =[responseObject objectForKey:@"userprofile"];
             profileData.fbUrl =[profileDict objectForKey:@"fb_url"];
             profileData.twitUrl =[profileDict objectForKey:@"twitter_url"];
             profileData.instaUrl =[profileDict objectForKey:@"insta_url"];
             profileData.userInterest =[profileDict objectForKey:@"interest"];
             profileData.userName=[profileDict objectForKey:@"username"];
             profileData.profileImageUrl=[profileDict objectForKey:@"user_image"];
             profileData.totalFriends=[NSString stringWithFormat:@"%d",[[profileDict objectForKey:@"totalFriends"] intValue]];
             profileData.university=[profileDict objectForKey:@"university"];
             
             [profileDataArray addObject:profileData];
             
             success(profileDataArray);
             
         }
         else
         {
             [myDelegate StopIndicator];
             failure(responseObject);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end
#pragma mark- User Notification
-(void)getUserNotification:(NSString *)offset success:(void (^)(id))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"offset":offset};
    NSLog(@"my Profile User request%@", requestDict);
    [self post:kUrlUserNotification parameters:requestDict success:^(id responseObject)
     {
         NSLog(@"my Profile User Response%@", responseObject);
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         NSNumber *number = responseObject[@"isSuccess"];
         if (number.integerValue!=0)
         {
             id array =[responseObject objectForKey:@"notificationMessage"];
             if (([array isKindOfClass:[NSArray class]]))
             {
                 NSArray * notificationDataArray = [responseObject objectForKey:@"notificationMessage"];
                 NSMutableArray *dataArray = [NSMutableArray new];
                 
                 
                 for (int i =0; i<notificationDataArray.count; i++)
                 {
                     NotificationDataModel *notificationData = [[NotificationDataModel alloc]init];
                     NSDictionary * notificationDict =[notificationDataArray objectAtIndex:i];
                     notificationData.notificationString =[notificationDict objectForKey:@"notification_text"];
                     notificationData.userImageUrl =[notificationDict objectForKey:@"user_image"];
                     [dataArray addObject:notificationData];
                 }
                 [dataArray addObject:[responseObject objectForKey:@"totalRecords"]];
                 success(dataArray);
             }
             
         }
         
         
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Friend List
-(void)getFriendList:(NSString *)offset otherUserId:(NSString *)otherUserId success:(void (^)(id))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"friend_id":otherUserId ,@"offset":offset};
    NSLog(@"friend list request%@", requestDict);
    [self post:kUrlFriendList parameters:requestDict success:^(id responseObject)
     {
         NSLog(@"friend list Response%@", responseObject);
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         if([self isStatusOK:responseObject])
         {
             id array =[responseObject objectForKey:@"friendList"];
             if (([array isKindOfClass:[NSArray class]]))
             {
                 NSArray * friendListArray = [responseObject objectForKey:@"friendList"];
                 NSMutableArray *friendListDataArray = [NSMutableArray new];
                 
                 for (int i =0; i<friendListArray.count; i++)
                 {
                     FriendListDataModel *friendList = [[FriendListDataModel alloc]init];
                     NSDictionary * friendListDict =[friendListArray objectAtIndex:i];
                     friendList.isFriend =[friendListDict objectForKey:@"isFriend"];
                     friendList.isRequestSent =[friendListDict objectForKey:@"isRequestSent"];
                     friendList.userImageUrl =[friendListDict objectForKey:@"user_image"];
                     friendList.userName=[friendListDict objectForKey:@"username"];
                     friendList.mutualFriends=[NSString stringWithFormat:@"%d",[[friendListDict objectForKey:@"mutualFriends"] intValue]];
                     friendList.userId=[friendListDict objectForKey:@"user_id"];
                     
                     
                     [friendListDataArray addObject:friendList];
                 }
                 [friendListDataArray addObject:[responseObject objectForKey:@"totalRecord"]];
                 
                 success(friendListDataArray);
             }

             
        }
         else
         {
             [myDelegate StopIndicator];
             failure(responseObject);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end
#pragma mark- Other user profile
-(void)otherUserProfile:(NSString *)friendUserId success:(void (^)(id))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"friendUser_id":friendUserId};
    NSLog(@"other user profile%@", requestDict);
    [self post:kUrlOtherUserProfile parameters:requestDict success:^(id responseObject)
     {
         NSLog(@"other user profile Response%@", responseObject);
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         if([self isStatusOK:responseObject])
         {
             
             NSMutableArray *otherUserDataArray = [NSMutableArray new];
             
             OtherUserProfileDataModel *otherUserProfile = [[OtherUserProfileDataModel alloc]init];
             NSDictionary * profileDict =[responseObject objectForKey:@"userprofile"];
             otherUserProfile.isFriend =[profileDict objectForKey:@"isFriend"];
             otherUserProfile.isRequestSent =[profileDict objectForKey:@"isRequestSent"];
             otherUserProfile.userImageUrl =[profileDict objectForKey:@"userProfilePic"];
             otherUserProfile.userName=[profileDict objectForKey:@"username"];
             otherUserProfile.userInterest=[profileDict objectForKey:@"interest"];
             otherUserProfile.totalFriends=[NSString stringWithFormat:@"%d",[[profileDict objectForKey:@"totalFriends"] intValue]];
             otherUserProfile.userFbUrl=[profileDict objectForKey:@"fb_url"];
             otherUserProfile.userInstaUrl=[profileDict objectForKey:@"insta_url"];
             otherUserProfile.usertwitUrl=[profileDict objectForKey:@"twitter_url"];
             otherUserProfile.userLocation=[profileDict objectForKey:@"university"];
             otherUserProfile.otherUserId=[profileDict objectForKey:@"user_id"];
             [otherUserDataArray addObject:otherUserProfile];
             
             success(otherUserDataArray);
             
         }
         else
         {
             [myDelegate StopIndicator];
             failure(responseObject);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Send request
-(void)sendFriendRequest:(NSString *)friendUserId success:(void (^)(id))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"friend_id":friendUserId};
    NSLog(@"sent request%@", requestDict);
    [self post:kUrlSentRequest parameters:requestDict success:^(id responseObject)
     {
         NSLog(@"sent request Response%@", responseObject);
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         if([self isStatusOK:responseObject])
         {
             success(responseObject);
             
         }
         else
         {
             [myDelegate StopIndicator];
             failure(responseObject);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Friend request list
-(void)friendRequestList:(NSString *)offset success:(void (^)(id))success failure:(void (^)(NSError *error))failure{
    
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"offset":offset};
    NSLog(@"friend request%@", requestDict);
    [self post:kUrlFriendRequestList parameters:requestDict success:^(id responseObject)
     {
         NSLog(@"friend request Response%@", responseObject);
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         if([self isStatusOK:responseObject])
         {
            id array =[responseObject objectForKey:@"friendRequestList"];
             if (([array isKindOfClass:[NSArray class]]))
             {
                 NSArray * requestArray = [responseObject objectForKey:@"friendRequestList"];
                 NSMutableArray *friendRequestListDataArray = [NSMutableArray new];
                 
                 
                 for (int i =0; i<requestArray.count; i++)
                 {
                     DiscoverDataModel *friendRequestList = [[DiscoverDataModel alloc]init];
                     NSDictionary * friendRequestListDict =[requestArray objectAtIndex:i];
                     friendRequestList.requestUsername =[friendRequestListDict objectForKey:@"f_username"];
                     friendRequestList.requestFriendId =[friendRequestListDict objectForKey:@"f_id"];
                     friendRequestList.requestFriendImage =[friendRequestListDict objectForKey:@"f_userimg"];
                     friendRequestList.acceptRequestCheck =1;
                     [friendRequestListDataArray addObject:friendRequestList];
                 }
                 [friendRequestListDataArray addObject:[responseObject objectForKey:@"totalRecord"]];
                
                 success(friendRequestListDataArray);
             }

         }
         else
         {
             [myDelegate StopIndicator];
             failure(responseObject);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Suggested friend list
-(void)suggestedFriendList:(NSString *)offset success:(void (^)(id))success failure:(void (^)(NSError *error))failure{
    
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"offset":offset};
    NSLog(@"suggested friend request%@", requestDict);
    [self post:kUrlSuggestedFriendList parameters:requestDict success:^(id responseObject)
     {
         NSLog(@"suggested friend request Response%@", responseObject);
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         if([self isStatusOK:responseObject])
         {
             id array =[responseObject objectForKey:@"suggestedFriendList"];
             if (([array isKindOfClass:[NSArray class]]))
             {
                 NSArray * suggestionArray = [responseObject objectForKey:@"suggestedFriendList"];
                 NSMutableArray *suggestionListDataArray = [NSMutableArray new];
                 
                 
                 for (int i =0; i<suggestionArray.count; i++)
                 {
                     DiscoverDataModel *suggestionList = [[DiscoverDataModel alloc]init];
                     NSDictionary * suggestionDict =[suggestionArray objectAtIndex:i];
                     suggestionList.requestUsername =[suggestionDict objectForKey:@"username"];
                     suggestionList.requestFriendId =[suggestionDict objectForKey:@"user_id"];
                     suggestionList.requestFriendImage =[suggestionDict objectForKey:@"user_image"];
                     suggestionList.mutualFriends =[NSString stringWithFormat:@"%d",[[suggestionDict objectForKey:@"mutual_friends"] intValue]];
                     suggestionList.addFriend =1;
                     [suggestionListDataArray addObject:suggestionList];
                 }
               //  [suggestionListDataArray addObject:[responseObject objectForKey:@"totalRecord"]];
                 
                 success(suggestionListDataArray);
             }

             
         }
         else
         {
             [myDelegate StopIndicator];
             failure(responseObject);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Accept decline friend request
-(void)acceptFriendRequest:(NSString *)otherFriendId acceptRequest:(NSString *)acceptRequest success:(void (^)(id))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"friend_id":otherFriendId,@"accept":acceptRequest};
    NSLog(@"accept friend request%@", requestDict);
    [self post:kUrlAcceptRequest parameters:requestDict success:^(id responseObject)
     {
         NSLog(@"accept friend request Response%@", responseObject);
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         if([self isStatusOK:responseObject])
         {
             success(responseObject);
             
         }
         else
         {
             [myDelegate StopIndicator];
             failure(responseObject);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];
    

}
#pragma mark- end

#pragma mark- Search
-(void)searchFriends:(NSString *)offset serachKey:(NSString *)serachKey success:(void (^)(id))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"offset":offset,@"text":serachKey};
    NSLog(@"search friend request%@", requestDict);
    [self post:kUrlSearch parameters:requestDict success:^(id responseObject)
     {
         NSLog(@"search friend request Response%@", responseObject);
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         if([self isStatusOK:responseObject])
         {
             id array =[responseObject objectForKey:@"searchResult"];
             if (([array isKindOfClass:[NSArray class]]))
             {
                 NSArray * searchArray = [responseObject objectForKey:@"searchResult"];
                 NSMutableArray *searchListDataArray = [NSMutableArray new];
                 
                 
                 for (int i =0; i<searchArray.count; i++)
                 {
                     DiscoverDataModel *searchList = [[DiscoverDataModel alloc]init];
                     NSDictionary * friendRequestListDict =[searchArray objectAtIndex:i];
                     searchList.requestFriendId =[friendRequestListDict objectForKey:@"user_id"];
                     searchList.requestFriendImage =[friendRequestListDict objectForKey:@"user_image"];
                     searchList.requestUsername =[friendRequestListDict objectForKey:@"username"];
                     [searchListDataArray addObject:searchList];
                 }
                [searchListDataArray addObject:[responseObject objectForKey:@"count"]];
                 
                 success(searchListDataArray);
             }
             
         }

         else
         {
             [myDelegate StopIndicator];
             failure(responseObject);
         }
     } failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         failure(error);
     }];

}
#pragma mark- end
@end
