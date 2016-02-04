//
//  ProfileTableViewCell.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 01/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ProfileTableViewCell.h"

@implementation ProfileTableViewCell
@synthesize interestLabel,notificationLabel,locationLabel,friendsLabel,userImage,titleLabel,seperatorLabel;

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
    __weak UIImageView *weakRef = userImage;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:notificationData.userImageUrl]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [userImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];

    notificationLabel.text=notificationData.notificationString;
 
}

- (IBAction)showFriendListButtonAction:(id)sender
{
}
@end
