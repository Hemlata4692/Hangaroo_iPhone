//
//  DiscoverTableCell.h
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 08/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverDataModel.h"

@interface DiscoverTableCell : UITableViewCell
//Request cell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptRequestBtn;
@property (weak, nonatomic) IBOutlet UIButton *declineRequestBtn;
@property (weak, nonatomic) IBOutlet UILabel *separatorLabel;

//SuggestionCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *addFriendBtn;
@property (weak, nonatomic) IBOutlet UILabel *sepratorLbl;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *mutualFriendLbl;

-(void)displayData :(DiscoverDataModel *)requestSentData :(int)indexPath;
@end
