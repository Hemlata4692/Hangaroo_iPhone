//
//  DiscoverTableCell.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 08/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "DiscoverTableCell.h"

@implementation DiscoverTableCell
//SuggestionCell
@synthesize userImage,userNameLbl,addFriendBtn,sepratorLbl,mutualFriendLbl;
//RequestCell
@synthesize userImageView,userNameLabel,acceptRequestBtn,declineRequestBtn,separatorLabel,reuestLabel;
//search
@synthesize isRequestSent,isFriend;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//RequestCell
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
    
    [userImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"profileImage.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    if (requestSentData.acceptRequestCheck==1) {
        acceptRequestBtn.hidden=NO;
        declineRequestBtn.hidden=NO;
         reuestLabel.hidden=YES;
    }
    else
    {
        acceptRequestBtn.hidden=YES;
        declineRequestBtn.hidden=YES;
         reuestLabel.hidden=NO;
    }
    
}
//SuggestionCell
-(void)displaySuggestedListData :(DiscoverDataModel *)suggestedData :(int)indexPath
{
    userNameLbl.text=suggestedData.requestUsername;
    if ([suggestedData.mutualFriends isEqualToString:@"0"]) {
        mutualFriendLbl.hidden=YES;
    }
    else if ([suggestedData.mutualFriends isEqualToString:@"1"])
    {
         mutualFriendLbl.hidden=NO;
        mutualFriendLbl.text= [NSString stringWithFormat:@"%@ %@",suggestedData.mutualFriends,@"mutual friend"];
    }
    else
    {
         mutualFriendLbl.hidden=NO;
        mutualFriendLbl.text= [NSString stringWithFormat:@"%@ %@",suggestedData.mutualFriends,@"mutual friends"];
    }
    userImage.layer.cornerRadius=30.0f;
    userImage.clipsToBounds=YES;
    __weak UIImageView *weakRef = userImage;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:suggestedData.requestFriendImage]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [userImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"profileImage.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    if (suggestedData.addFriend==1) {
        [addFriendBtn setImage:[UIImage imageNamed:@"adduser.png"] forState:UIControlStateNormal];
       addFriendBtn.userInteractionEnabled=YES;
    }
    else
    {
        [addFriendBtn setImage:[UIImage imageNamed:@"user_accepted.png"] forState:UIControlStateNormal];
         addFriendBtn.userInteractionEnabled=NO;
    }
    
    
}
//Search
-(void)displaySearchData :(FriendListDataModel *)searchData :(int)indexPath
{
    
    userNameLbl.text=searchData.userName;
    userImage.layer.cornerRadius=30.0f;
    userImage.clipsToBounds=YES;
    __weak UIImageView *weakRef = userImage;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:searchData.userImageUrl]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [userImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"profileImage.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    
    isFriend=searchData.isFriend;
    isRequestSent=searchData.isRequestSent;
    
    if ([isRequestSent isEqualToString:@"True"])
    {
        addFriendBtn.hidden=NO;
        [addFriendBtn setImage:[UIImage imageNamed:@"user_accepted.png"] forState:UIControlStateNormal];
        addFriendBtn.userInteractionEnabled=NO;
        if ([searchData.mutualFriends isEqualToString:@"0"]) {
            mutualFriendLbl.hidden=YES;
        }
        else if ([searchData.mutualFriends isEqualToString:@"1"])
        {
            mutualFriendLbl.hidden=NO;
            mutualFriendLbl.text= [NSString stringWithFormat:@"%@ %@",searchData.mutualFriends,@"mutual friend"];
        }
        else
        {
            mutualFriendLbl.hidden=NO;
            mutualFriendLbl.text= [NSString stringWithFormat:@"%@ %@",searchData.mutualFriends,@"mutual friends"];
        }

    }
    else
    {
        if ([isFriend isEqualToString:@"True"])
        {
            addFriendBtn.hidden=YES;
            if ([searchData.mutualFriends isEqualToString:@"0"]) {
                mutualFriendLbl.hidden=YES;
            }
            else if ([searchData.mutualFriends isEqualToString:@"1"])
            {
                mutualFriendLbl.hidden=NO;
                mutualFriendLbl.text= [NSString stringWithFormat:@"%@ %@",searchData.mutualFriends,@"mutual friend"];
            }
            else
            {
                mutualFriendLbl.hidden=NO;
                mutualFriendLbl.text= [NSString stringWithFormat:@"%@ %@",searchData.mutualFriends,@"mutual friends"];
            }

            
        }
        else if ([[UserDefaultManager getValue:@"userId"] isEqualToString:searchData.userId])
        {
            addFriendBtn.hidden=YES;
            mutualFriendLbl.hidden=YES;
        }
        else
        {
            if ([searchData.mutualFriends isEqualToString:@"0"]) {
                mutualFriendLbl.hidden=YES;
            }
            else if ([searchData.mutualFriends isEqualToString:@"1"])
            {
                mutualFriendLbl.hidden=NO;
                mutualFriendLbl.text= [NSString stringWithFormat:@"%@ %@",searchData.mutualFriends,@"mutual friend"];
            }
            else
            {
                mutualFriendLbl.hidden=NO;
                mutualFriendLbl.text= [NSString stringWithFormat:@"%@ %@",searchData.mutualFriends,@"mutual friends"];
            }

            addFriendBtn.hidden=NO;
            addFriendBtn.userInteractionEnabled=YES;
            [addFriendBtn setImage:[UIImage imageNamed:@"adduser.png"] forState:UIControlStateNormal];
        }
        
    }


}
@end
