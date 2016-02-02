//
//  ProfileTableViewCell.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 01/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ProfileTableViewCell.h"

@implementation ProfileTableViewCell
@synthesize interestLabel,notificationLabel,locationLabel,friendsLabel,userImage;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)displayData :(MyProfileDataModel *)profileData :(int)indexPath
{
 
    locationLabel.text=profileData.university;
    
    NSString *yourString = [NSString stringWithFormat:@"%@ %@",profileData.totalFriends,@"FRIENDS"];
    NSRange boldedRange = NSMakeRange(profileData.totalFriends.length, (yourString.length-profileData.totalFriends.length));
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:yourString];
    
    [attrString beginEditing];
    [attrString addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"Roboto-Regular" size:14.0]
                       range:boldedRange];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0]
                       range:NSMakeRange(profileData.totalFriends.length, (yourString.length-profileData.totalFriends.length))];
    
    [attrString endEditing];
    friendsLabel.attributedText=attrString;
}
-(void)layoutView1 :(CGRect)rect
{
    self.interestLabel.translatesAutoresizingMaskIntoConstraints=YES;
    
    CGSize size = CGSizeMake(rect.size.width-40,240);
    
//    CGRect textRect=[giftMessage
//                     boundingRectWithSize:size
//                     options:NSStringDrawingUsesLineFragmentOrigin
//                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]}
//                     context:nil];
//    interestLabel.numberOfLines = 0;
//    notificationLabel.text=giftMessage;
//    
//    interestLabel.frame=CGRectMake(rect.origin.x ,interestLabel.frame.origin.y, rect.size.width-40,textRect.size.height+5);
}
-(void)layoutView4 :(CGRect)rect
{

    self.notificationLabel.translatesAutoresizingMaskIntoConstraints=YES;
    
    self.userImage.layer.cornerRadius=30.0f;
    self.userImage.clipsToBounds=YES;
    self.userImage.backgroundColor=[UIColor redColor];
    
    CGSize size = CGSizeMake(rect.size.width-90,240);
    
//    CGRect textRect=[giftMessage
//                     boundingRectWithSize:size
//                     options:NSStringDrawingUsesLineFragmentOrigin
//                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]}
//                     context:nil];
//    notificationLabel.numberOfLines = 0;
//    notificationLabel.text=giftMessage;
//    
//    notificationLabel.frame=CGRectMake(rect.origin.x+self.userImage.frame.size.width+10 ,notificationLabel.frame.origin.y, rect.size.width-(rect.origin.x+self.userImage.frame.size.width+15),textRect.size.height+5);
}
@end
