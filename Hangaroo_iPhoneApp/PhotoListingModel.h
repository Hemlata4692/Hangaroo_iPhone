//
//  PhotoListingModel.h
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 20/01/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoListingModel : NSObject
@property(nonatomic,retain)NSString * likeCountData;
@property(nonatomic,retain)NSString * dislikeCountData;
@property(nonatomic,retain)NSString * postImagesUrl;
@property(nonatomic,retain)NSString * uploadedImageTime;
@property(nonatomic,retain)NSString * userImageUrl;
@property(nonatomic,retain)NSString * isLike;
@end
