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

#define kUrlLogin                       @"login"
#define kUrlRegister                    @"register"
#define kUrlForgotPassword              @"forgotpassword"
#define kUrlSharePost                   @"sharepost"
#define kUrlPostListing                 @"postlisting"
#define kUrlJoinPost                    @"joinpost"
#define kUrlUploadPhoto                 @"uploadphoto"

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
        //[myDelegate StopIndicator];
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[myDelegate StopIndicator];
        failure(error);
        
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
        TutorialViewController * objReveal = [storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
        myDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [myDelegate.window setRootViewController:objReveal];
        [myDelegate.window setBackgroundColor:[UIColor whiteColor]];
        [myDelegate.window makeKeyAndVisible];
        [UserDefaultManager removeValue:@"userId"];
        [UserDefaultManager removeValue:@"userName"];
    }
}

#pragma mark - end

#pragma mark- Login
//Login
- (void)userLogin:(NSString *)email password:(NSString *)password success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSDictionary *requestDict = @{@"username":email,@"password":password};
    
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
    
    [self post:kUrlForgotPassword parameters:requestDict success:^(id responseObject)
     {
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

#pragma mark- Share post
//Share Post
-(void)sharePost:(NSString *)post success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
 //{user_id:"20" post_content:"i had a bad day"}
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"post_content":post};
    
    [self post:kUrlSharePost parameters:requestDict success:^(id responseObject)
     {
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

#pragma mark- Post listing
//Post Listing
-(void)postListing:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"]};
    
    [self post:kUrlPostListing parameters:requestDict success:^(id responseObject)
     {
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

#pragma mark- Join post
-(void)joinPost:(NSString *)postID success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"postId":postID};
    
    [self post:kUrlJoinPost parameters:requestDict success:^(id responseObject)
     {
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
-(void)uploadPhoto:(NSString *)postID success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"postId":postID};
    
   
}
#pragma mark- end
@end
