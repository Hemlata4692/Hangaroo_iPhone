//
//  FriendListTableCell.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 04/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "FriendListTableCell.h"

@implementation FriendListTableCell
@synthesize userImageView,userNameLabel,mutualFriendsLabel,seperatorLabel,requestSentButton;
@synthesize isFriend,isRequestSent;

#pragma mark - Load nib
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - end

#pragma mark - Display friend list data
-(void)displayData :(FriendListDataModel *)friendList :(int)indexPath
{
    userNameLabel.text=friendList.userName;
    if ([friendList.mutualFriends isEqualToString:@"0"]) {
        mutualFriendsLabel.hidden=YES;
    }
    else if ([friendList.mutualFriends isEqualToString:@"1"])
    {
        mutualFriendsLabel.hidden=NO;
        mutualFriendsLabel.text= [NSString stringWithFormat:@"%@ %@",friendList.mutualFriends,@"mutual friend"];
    }
    else
    {
        mutualFriendsLabel.hidden=NO;
        mutualFriendsLabel.text= [NSString stringWithFormat:@"%@ %@",friendList.mutualFriends,@"mutual friends"];
    }
    userImageView.layer.cornerRadius=30.0f;
    userImageView.clipsToBounds=YES;
    userImageView.layer.borderWidth=1.5f;
    userImageView.layer.borderColor=[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0].CGColor;
    __weak UIImageView *weakRef = userImageView;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:friendList.userImageUrl]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [userImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"profileImage.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    isFriend=friendList.isFriend;
    isRequestSent=friendList.isRequestSent;
    if ([isRequestSent isEqualToString:@"True"])
    {
        requestSentButton.hidden=NO;
        [requestSentButton setImage:[UIImage imageNamed:@"user_accepted.png"] forState:UIControlStateNormal];
        requestSentButton.userInteractionEnabled=NO;
    }
    else
    {
        if ([isFriend isEqualToString:@"True"])
        {
            requestSentButton.hidden=YES;
            mutualFriendsLabel.hidden=YES;
        }
        else if ([[UserDefaultManager getValue:@"userId"] isEqualToString:friendList.userId])
        {
            requestSentButton.hidden=YES;
            mutualFriendsLabel.hidden=YES;
        }
        else
        {
            requestSentButton.hidden=NO;
            mutualFriendsLabel.hidden=NO;
            requestSentButton.userInteractionEnabled=YES;
            [requestSentButton setImage:[UIImage imageNamed:@"adduser.png"] forState:UIControlStateNormal];
        }
    }
}
#pragma mark - end
@end
