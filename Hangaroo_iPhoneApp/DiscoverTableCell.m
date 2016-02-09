//
//  DiscoverTableCell.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 08/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "DiscoverTableCell.h"

@implementation DiscoverTableCell
@synthesize userImage,userNameLbl,addFriendBtn,sepratorLbl;
@synthesize userImageView,userNameLabel,acceptRequestBtn,declineRequestBtn,separatorLabel,reuestLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)displayData :(DiscoverDataModel *)requestSentData :(int)indexPath
{
    reuestLabel.hidden=YES;
    userNameLabel.text=requestSentData.requestUsername;
    userImageView.layer.cornerRadius=30.0f;
    userImageView.clipsToBounds=YES;
    __weak UIImageView *weakRef = userImageView;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:requestSentData.requestFriendImage]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [userImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];

    
}

-(void)displaySearchData :(DiscoverDataModel *)searchData :(int)indexPath
{
    
    userNameLbl.text=searchData.requestUsername;
    userImage.layer.cornerRadius=30.0f;
    userImage.clipsToBounds=YES;
    __weak UIImageView *weakRef = userImage;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:searchData.requestFriendImage]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [userImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    

}
@end
