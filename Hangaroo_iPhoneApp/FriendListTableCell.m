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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)displayData :(FriendListDataModel *)friendList :(int)indexPath
{
    userNameLabel.text=friendList.userName;
    mutualFriendsLabel.text=friendList.mutualFriends;
    userImageView.layer.cornerRadius=30.0f;
    userImageView.clipsToBounds=YES;
    __weak UIImageView *weakRef = userImageView;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:friendList.userImageUrl]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [userImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
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
        if ([isFriend isEqualToString:@"True"]) {
           
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
@end
