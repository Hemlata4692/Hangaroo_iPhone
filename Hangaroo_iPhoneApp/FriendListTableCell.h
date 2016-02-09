//
//  FriendListTableCell.h
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 04/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendListDataModel.h"
#import "MyButton.h"

@interface FriendListTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mutualFriendsLabel;
@property (weak, nonatomic) IBOutlet MyButton *requestSentButton;
@property (weak, nonatomic) IBOutlet UILabel *seperatorLabel;

@property(nonatomic, strong) NSString *isFriend;
@property(nonatomic, strong) NSString *isRequestSent;
-(void)displayData :(FriendListDataModel *)friendList :(int)indexPath;
@end
