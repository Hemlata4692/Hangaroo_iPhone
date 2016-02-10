//
//  DiscoverTableCell.h
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 08/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverDataModel.h"
#import "MyButton.h"

@interface DiscoverTableCell : UITableViewCell
//Request cell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet MyButton *acceptRequestBtn;
@property (weak, nonatomic) IBOutlet MyButton *declineRequestBtn;
@property (weak, nonatomic) IBOutlet UILabel *separatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *reuestLabel;

//SuggestionCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet MyButton *addFriendBtn;
@property (weak, nonatomic) IBOutlet UILabel *sepratorLbl;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *mutualFriendLbl;

-(void)displayData :(DiscoverDataModel *)requestSentData :(int)indexPath;
-(void)displaySuggestedListData :(DiscoverDataModel *)suggestedData :(int)indexPath;
-(void)displaySearchData :(DiscoverDataModel *)searchData :(int)indexPath;
@end
