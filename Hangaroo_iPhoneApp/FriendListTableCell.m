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


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
