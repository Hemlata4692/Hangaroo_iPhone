//
//  UserListViewController.h
//  Hangaroo_iPhoneApp
//
//  Created by Ranosys on 02/02/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ChatViewController.h"
@interface UserListViewController : GlobalBackViewController<NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
    
}
@property (nonatomic,assign) int isChange;
@property (nonatomic,retain) ChatViewController *chatVC;
@end