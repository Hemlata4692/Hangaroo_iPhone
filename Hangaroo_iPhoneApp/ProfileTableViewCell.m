//
//  ProfileTableViewCell.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 01/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ProfileTableViewCell.h"


@implementation ProfileTableViewCell
@synthesize interestLabel,notificationLabel,locationLabel,friendsLabel,userImage,titleLabel,seperatorLabel,friendListButton,notificationPhoto,notificationPictureLabel,userProfileBtn;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)displayData :(MyProfileDataModel *)profileData :(int)indexPath
{
    
    locationLabel.text=[profileData.university uppercaseString];
    NSString *yourString;
    if ([profileData.totalFriends isEqualToString:@"1"] || [profileData.totalFriends isEqualToString:@"0"]) {
        yourString = [NSString stringWithFormat:@"%@ %@",profileData.totalFriends,@"FRIEND"];
    }
    else
    {
        yourString = [NSString stringWithFormat:@"%@ %@",profileData.totalFriends,@"FRIENDS"];
    }
    NSRange boldedRange = NSMakeRange(profileData.totalFriends.length, (yourString.length-profileData.totalFriends.length));
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:yourString];
    
    [attrString beginEditing];
    [attrString addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"Roboto-Regular" size:14.0]
                       range:boldedRange];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor blackColor]
                       range:NSMakeRange(profileData.totalFriends.length, (yourString.length-profileData.totalFriends.length))];
    
    [attrString endEditing];
    friendsLabel.attributedText=attrString;
    
    
}
-(void)displayNotificationData :(NotificationDataModel *)notificationData :(int)indexPath
{
    self.userImage.layer.cornerRadius=30.0f;
    self.userImage.clipsToBounds=YES;
    userImage.layer.borderWidth=1.5f;
    userImage.layer.borderColor=[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0].CGColor;
    __weak UIImageView *weakRef = userImage;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:notificationData.userImageUrl]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [userImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"profileImage.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];

    if ([notificationData.photoLiked isEqualToString:@""]) {
              NSString *yourString;
        
        yourString = [NSString stringWithFormat:@"%@%@",notificationData.username,notificationData.notificationString];
        
        NSRange boldedRange = NSMakeRange(notificationData.username.length, (yourString.length-notificationData.username.length));
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:yourString];
        
        [attrString beginEditing];
        [attrString addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"Roboto-Regular" size:14.0]
                           range:boldedRange];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0]
                           range:NSMakeRange(notificationData.username.length, (yourString.length-notificationData.username.length))];
        
        [attrString endEditing];
        notificationLabel.attributedText=attrString;
        notificationPhoto.hidden=YES;
        notificationPictureLabel.hidden=YES;
    }
    
    else
    {
         notificationPictureLabel.hidden=NO;
         notificationPhoto.hidden=NO;
        notificationLabel.hidden=YES;
        NSString *yourString;
        
        yourString = [NSString stringWithFormat:@"%@%@",notificationData.username,notificationData.notificationString];
        
        NSRange boldedRange = NSMakeRange(notificationData.username.length, (yourString.length-notificationData.username.length));
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:yourString];
        
        [attrString beginEditing];
        [attrString addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"Roboto-Regular" size:14.0]
                           range:boldedRange];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0]
                           range:NSMakeRange(notificationData.username.length, (yourString.length-notificationData.username.length))];
        
        [attrString endEditing];
        notificationPictureLabel.attributedText=attrString;
      __weak UIImageView *weakRef1 = notificationPhoto;
    NSURLRequest *imageRequest1 = [NSURLRequest requestWithURL:[NSURL URLWithString:notificationData.photoLiked]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [notificationPhoto setImageWithURLRequest:imageRequest1 placeholderImage:[UIImage imageNamed:@"picture.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef1.contentMode = UIViewContentModeScaleAspectFill;
        weakRef1.clipsToBounds = YES;
        weakRef1.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];

    }
}

@end
