//
//  HomeViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 30/12/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//



#import "HomeViewController.h"
#import "PostListingDataModel.h"
#import "JoinedUserDataModel.h"
#import "PostImageDataModel.h"
#import <UIImageView+AFNetworking.h>
#import "MyCollectionView.h"
#import "PhotoPreviewViewController.h"
#import "MyButton.h"
#import "MeTooUserProfileViewController.h"
#import "ViewPostImagesViewController.h"

#define kCellsPerRow 3

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *postListingArray;
    NSString *posted;
    bool flag;
    UIRefreshControl *refreshControl;
    bool pickerSelection;
    NSString *postId;
    int btnTag;
    int tableSection;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *hotNewPostSegment;

@property (weak, nonatomic) IBOutlet UITableView *postListingTableView;

@property (strong, nonatomic) UITabBarController *tabbarcontroller;
@property(nonatomic,retain) NSMutableArray * todayPostData;
@property(nonatomic,retain) NSMutableArray * yesterdayPostData;
@property(nonatomic,retain) NSMutableArray * joinedUserInfoArray;
@property(nonatomic,retain) NSMutableArray * postPhotoArray;
@property(nonatomic,retain) NSMutableArray * joinedUserInfoTodayArray;
@property (weak, nonatomic) IBOutlet UILabel *noResultFound;
@property(nonatomic,retain) NSMutableArray * postPhotoTodayArray;
@property(nonatomic,retain) NSMutableArray * postImagesArray;
@end

@implementation HomeViewController
@synthesize postListingTableView,todayPostData,yesterdayPostData,joinedUserInfoArray,postPhotoArray,postPhotoTodayArray,joinedUserInfoTodayArray,noResultFound,postImagesArray;

#pragma mark - View life cycle
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Set the screen name for automatic screenview tracking.
    self.screenName = @"Home screen";
    
    [self setTabBarImages];
    myDelegate.tabBarView = (UITabBarController *)self.tabBarController;
    postListingArray=[[NSMutableArray alloc]init];
    todayPostData = [[NSMutableArray alloc]init];
    yesterdayPostData = [[NSMutableArray alloc]init];
    joinedUserInfoArray=[[NSMutableArray alloc]init];
    postPhotoArray=[[NSMutableArray alloc]init];
    joinedUserInfoTodayArray=[[NSMutableArray alloc]init];
    postPhotoTodayArray=[[NSMutableArray alloc]init];
    postImagesArray=[[NSMutableArray alloc]init];
    flag=true;
    noResultFound.hidden=YES;
    posted=@"Today";
    pickerSelection=false;
    // Pull To Refresh
    refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, 10, 10)];
    [self.postListingTableView addSubview:refreshControl];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@""];
    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
    refreshControl.attributedTitle = refreshString;
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    self.postListingTableView.alwaysBounceVertical = YES;
    
//    [myDelegate ShowIndicator];
// [self performSelector:@selector(getPostListing) withObject:nil afterDelay:0.1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.tabBarController.tabBar.hidden=NO;
    [[self navigationController] setNavigationBarHidden:NO];
    posted=@"Today";
    if (!pickerSelection) {
        [myDelegate ShowIndicator];
        [self performSelector:@selector(getPostListing) withObject:nil afterDelay:.1];

    }
   }

#pragma mark - end

#pragma mark - Set tabbar images
-(void)setTabBarImages
{
    UITabBarController * myTab = (UITabBarController *)self.tabBarController;
    UITabBar *tabBar = myTab.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5 = [tabBar.items objectAtIndex:4];
    tabBar.clipsToBounds=YES;
    [tabBarItem1 setImage:[[UIImage imageNamed:@"Home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"Home_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    tabBarItem1.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    [tabBarItem2 setImage:[[UIImage imageNamed:@"Chat.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"Chat_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem2.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    [tabBarItem3 setImage:[[UIImage imageNamed:@"SharePost.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"SharePost.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem3.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    [tabBarItem4 setImage:[[UIImage imageNamed:@"Discover.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem4 setSelectedImage:[[UIImage imageNamed:@"Discover_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem4.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    [tabBarItem5 setImage:[[UIImage imageNamed:@"Profile.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem5 setSelectedImage:[[UIImage imageNamed:@"Profile_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem5.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
}
#pragma mark - end
#pragma mark - Refresh Table
//Pull to refresh implementation on my submission data
- (void)refreshTable
{
    
    [self performSelector:@selector(getPostListing) withObject:nil afterDelay:0.1];
    [refreshControl endRefreshing];
    [self.postListingTableView reloadData];
    
}
#pragma mark - end

#pragma mark - Webservice - Post listing
-(void)getPostListing
{
     flag=true;
    
    [postListingArray removeAllObjects];
    [[WebService sharedManager]postListing:^(id dataArray) {
        
        [myDelegate StopIndicator];
        if ([dataArray isKindOfClass:[NSArray class]])
        {
            if ([dataArray count]==0) {
                noResultFound.hidden=NO;
                postListingTableView.hidden=YES;
            }
            else
            {
                postListingArray = [dataArray mutableCopy];
                
                [self filterData];
            }
            
        }
    }
                                   failure:^(NSError *error)
     {
         [postListingArray removeAllObjects];
         [postListingTableView reloadData];
//         noResultFound.hidden=NO;
//         postListingTableView.hidden=YES;
     }] ;
    
}
-(void)filterData
{
    [todayPostData removeAllObjects];
    [yesterdayPostData removeAllObjects];
    
    for (int i =0; i<postListingArray.count; i++)
    {
        
        PostListingDataModel *posListData = [postListingArray objectAtIndex:i];
        
        if ([posListData.postedDay isEqualToString:@"today"] )
        {
            [todayPostData addObject:posListData];
            
            
        }
        else if ([posListData.postedDay isEqualToString:@"yesterday"] )
        {
            [yesterdayPostData addObject:posListData];
            
        }
        
    }
    if (todayPostData.count==0) {
        flag=false;
        todayPostData=[yesterdayPostData mutableCopy];
        posted=@"Yesterday";
        [yesterdayPostData removeAllObjects];
    }
    else if (yesterdayPostData.count==0)
    {
        flag=false;
    }
    [postListingTableView reloadData];
    
    
}

#pragma mark - end

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (postListingArray.count>0) {
        
            if (flag)
            {
                return 2;
            }
            else
            {
                return 1;
            }

    }
    else
    {
        return 0;
    }
     
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section==0)
    {
        return todayPostData.count;
    }
    else{
        return yesterdayPostData.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40.0)];
    headerView.backgroundColor=[UIColor whiteColor];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, tableView.frame.size.width, 30)];
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.font=[UIFont fontWithName:@"Roboto-Light" size:16.0];
    headerLabel.textColor=[UIColor colorWithRed:126.0/255.0 green:126.0/255.0 blue:126.0/255.0 alpha:1.0];
    [headerView addSubview:headerLabel];
    
    UILabel *seperatorLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, headerLabel.frame.origin.y+headerLabel.frame.size.height+5, tableView.frame.size.width-40, 1)];
    seperatorLabel.backgroundColor=[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0];
    [headerView addSubview:seperatorLabel];
    if (flag) {
        if (section==0)
        {
            
            headerLabel.text=@"Today";
            
        }
        else
        {
            
            headerLabel.text=@"Yesterday";
            
        }
        
    }
    else
    {
        headerLabel.text=posted;
    }
    
    
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostListingDataModel *postListData;
    
    if (indexPath.section==0) {
        postListData=[todayPostData objectAtIndex:indexPath.row];
        CGSize size = CGSizeMake(postListingTableView.frame.size.width-70,999);
        CGRect textRect = [postListData.postContent
                           boundingRectWithSize:size
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:15.0]}
                           context:nil];
        textRect.origin.x = 8;
        textRect.origin.y = 19;
        if ([[todayPostData objectAtIndex:indexPath.row]uploadedPhotoArray].count==0 )
        {
            return 180+textRect.size.height;
        }
        else
        {
            return 286+textRect.size.height;
        }
        
    }
    else
    {
        postListData=[yesterdayPostData objectAtIndex:indexPath.row];
        CGSize size = CGSizeMake(postListingTableView.frame.size.width-70,999);
        CGRect textRect = [postListData.postContent
                           boundingRectWithSize:size
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:15.0]}
                           context:nil];
        textRect.origin.x = 8;
        textRect.origin.y = 19;
        if ([[yesterdayPostData objectAtIndex:indexPath.row]uploadedPhotoArray].count==0 )
        {
            return 180+textRect.size.height;
        }
        else
        {
            return 286+textRect.size.height;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *simpleTableIdentifier = @"homeCell";
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    UILabel *postLabel=(UILabel *)[cell viewWithTag:1];
    UILabel *followedUserLabel=(UILabel *)[cell viewWithTag:2];
    UILabel *seperatorLabel=(UILabel *)[cell viewWithTag:7];
    MyButton *cameraButton=(MyButton *)[cell viewWithTag:10];
    UIImageView *tickIcon=(UIImageView *)[cell viewWithTag:3];
    UIImageView *cameraIcon=(UIImageView *)[cell viewWithTag:4];
    MyCollectionView*  meTooCollectionView=(MyCollectionView *)[cell viewWithTag:50];
    MyCollectionView*  photoCollectionView=(MyCollectionView *)[cell viewWithTag:60];
    postLabel.translatesAutoresizingMaskIntoConstraints=YES;
    followedUserLabel.translatesAutoresizingMaskIntoConstraints=YES;
    seperatorLabel.translatesAutoresizingMaskIntoConstraints=YES;
    tickIcon.translatesAutoresizingMaskIntoConstraints=YES;
    cameraIcon.translatesAutoresizingMaskIntoConstraints=YES;
    cameraButton.translatesAutoresizingMaskIntoConstraints=YES;
    meTooCollectionView.translatesAutoresizingMaskIntoConstraints=YES;
    photoCollectionView.translatesAutoresizingMaskIntoConstraints=YES;
    
    if (indexPath.section==0) {
        postLabel.text=[[todayPostData objectAtIndex:indexPath.row] postContent];
    }
    else
    {
        postLabel.text=[[yesterdayPostData objectAtIndex:indexPath.row] postContent];
        
    }
    // setting collection view cell size according to iPhone screens
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)photoCollectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.view.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow-1)-10;
    CGFloat cellWidth = (availableWidthForCells / kCellsPerRow)-10;
    flowLayout.itemSize = CGSizeMake(cellWidth, flowLayout.itemSize.height);
    
    CGSize size = CGSizeMake(postListingTableView.frame.size.width-70,999);
    CGRect textRect = [postLabel.text
                       boundingRectWithSize:size
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:15.0]}
                       context:nil];
    postLabel.numberOfLines = 0;
    textRect.origin.x = postLabel.frame.origin.x;
    textRect.origin.y = 19;
    postLabel.frame = textRect;
    
    postLabel.frame =CGRectMake(8, postLabel.frame.origin.y, postListingTableView.frame.size.width-70, postLabel.frame.size.height);

    followedUserLabel.frame =CGRectMake(8, postLabel.frame.origin.y+postLabel.frame.size.height+7, postListingTableView.frame.size.width-70, followedUserLabel.frame.size.height);
    tickIcon.frame =CGRectMake(postListingTableView.frame.size.width-18, -1, tickIcon.frame.size.width, tickIcon.frame.size.height);
    cameraIcon.frame =CGRectMake(postListingTableView.frame.size.width-(cameraIcon.frame.size.width+5), cameraIcon.frame.origin.y, cameraIcon.frame.size.width, cameraIcon.frame.size.height);
    cameraButton.frame =CGRectMake(postListingTableView.frame.size.width-(cameraButton.frame.size.width+5), cameraButton.frame.origin.y, cameraButton.frame.size.width, cameraButton.frame.size.height);
    cameraButton.Tag=(int)indexPath.row;
    cameraButton.sectionTag=(int)indexPath.section;
    
    meTooCollectionView.frame =CGRectMake(8, followedUserLabel.frame.origin.y+followedUserLabel.frame.size.height+12, postListingTableView.frame.size.width-16, meTooCollectionView.frame.size.height);
    
    photoCollectionView.frame =CGRectMake(8, meTooCollectionView.frame.origin.y+meTooCollectionView.frame.size.height, postListingTableView.frame.size.width-16, photoCollectionView.frame.size.height);
    
    [cameraButton addTarget:self action:@selector(openCameraAction:) forControlEvents:UIControlEventTouchUpInside];
    meTooCollectionView.collectionTag = (int)indexPath.row;
    photoCollectionView.collectionTag = (int)indexPath.row;
  
    meTooCollectionView.sectionTag = (int)indexPath.section;
    photoCollectionView.sectionTag = (int)indexPath.section;
    if (indexPath.section==0)
    {
        if ([[todayPostData objectAtIndex:indexPath.row]uploadedPhotoArray].count==0)
        {
            photoCollectionView.hidden=YES;
            seperatorLabel.frame =CGRectMake(0, meTooCollectionView.frame.origin.y+meTooCollectionView.frame.size.height+15, postListingTableView.frame.size.width, 2);
        }
        else
        {
            photoCollectionView.hidden=NO;
            seperatorLabel.frame =CGRectMake(0, photoCollectionView.frame.origin.y+photoCollectionView.frame.size.height+15, postListingTableView.frame.size.width, 2);
        }
        
        if ([[[todayPostData objectAtIndex:indexPath.row] friendsJoinedCount]intValue] ==0)
        {
            followedUserLabel.text=[NSString stringWithFormat:@"%@ felt the same way",[[todayPostData objectAtIndex:indexPath.row] joinedUserCount]];
        }
        else
        {
            followedUserLabel.text=[NSString stringWithFormat:@"%@+%@ felt the same way",[[todayPostData objectAtIndex:indexPath.row] joinedUserCount],[[todayPostData objectAtIndex:indexPath.row] friendsJoinedCount]];
        }
        
        if ([[(PostListingDataModel*)[todayPostData objectAtIndex:indexPath.row] isJoined] isEqualToString:@"No"]) {
            cameraButton.hidden=YES;
            cameraIcon.hidden=YES;
            tickIcon.hidden=YES;
        }
        else
        {
            cameraButton.hidden=NO;
            cameraIcon.hidden=NO;
            tickIcon.hidden=NO;
        }
        
    }
    else
    {
        if ([[yesterdayPostData objectAtIndex:indexPath.row]uploadedPhotoArray].count==0)
        {
            photoCollectionView.hidden=YES;
            seperatorLabel.frame =CGRectMake(0, meTooCollectionView.frame.origin.y+meTooCollectionView.frame.size.height+15, postListingTableView.frame.size.width, 2);
        }
        else
        {
            photoCollectionView.hidden=NO;
            seperatorLabel.frame =CGRectMake(0, photoCollectionView.frame.origin.y+photoCollectionView.frame.size.height+15, postListingTableView.frame.size.width, 2);
        }
        
        if ([[[yesterdayPostData objectAtIndex:indexPath.row] friendsJoinedCount]intValue] ==0)
        {
            followedUserLabel.text=[NSString stringWithFormat:@"%@ felt the same way",[[yesterdayPostData objectAtIndex:indexPath.row] joinedUserCount]];
        }
        else
        {
            followedUserLabel.text=[NSString stringWithFormat:@"%@+%@ felt the same way",[[yesterdayPostData objectAtIndex:indexPath.row] joinedUserCount],[[yesterdayPostData objectAtIndex:indexPath.row] friendsJoinedCount]];
        }
        
        
        if ([[(PostListingDataModel*)[yesterdayPostData objectAtIndex:indexPath.row] isJoined] isEqualToString:@"No"]) {
            cameraButton.hidden=YES;
            cameraIcon.hidden=YES;
            tickIcon.hidden=YES;
        }
        else
        {
            cameraButton.hidden=NO;
            cameraIcon.hidden=NO;
            tickIcon.hidden=NO;
        }
    }
    

    [meTooCollectionView reloadData];
    [photoCollectionView reloadData];
    
    
    
    return cell;
    
}

#pragma mark - end

#pragma mark- Cell collection view delegate


- (NSInteger)collectionView:(MyCollectionView *)view numberOfItemsInSection:(NSInteger)section {

    NSLog(@"cell tag %d %d",view.collectionTag, view.sectionTag);
    
    if (view.sectionTag==0)
    {
        if (view.tag==50)
        {
           
            return [[todayPostData objectAtIndex:view.collectionTag]joinedUserArray].count;
            
        }
        else
        {
          
            return [[todayPostData objectAtIndex:view.collectionTag]uploadedPhotoArray].count;
        }
        
    }
    else
    {
        if (view.tag==50)
        {
         
            return [[yesterdayPostData objectAtIndex:view.collectionTag]joinedUserArray].count;
        }
        else
        {
           
            return [[yesterdayPostData objectAtIndex:view.collectionTag]uploadedPhotoArray].count;
        }
        
    }
    
}

- (UICollectionViewCell *)collectionView:(MyCollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (cv.tag==50) {
        
        UICollectionViewCell *meTooCell = [cv dequeueReusableCellWithReuseIdentifier:@"meTooCell" forIndexPath:indexPath];
        meTooCell.translatesAutoresizingMaskIntoConstraints=YES;
        
        UIImageView *userImage=(UIImageView *)[meTooCell viewWithTag:20];
        
        userImage.translatesAutoresizingMaskIntoConstraints=YES;
        userImage.frame=CGRectMake(5, 1, userImage.frame.size.width,  userImage.frame.size.height);
        userImage.layer.cornerRadius=userImage.frame.size.height/2;
        userImage.clipsToBounds=YES;
        //[userImage clearImageCacheForURL:[NSURL URLWithString:[UserDefaultManager getValue:@"userImage"]]];
        UIImageView *meeToo=(UIImageView *)[meTooCell viewWithTag:90];
        
        meeToo.translatesAutoresizingMaskIntoConstraints=YES;
        meeToo.frame=CGRectMake(5, 1, meeToo.frame.size.width,  meeToo.frame.size.height);
        meeToo.layer.cornerRadius=meeToo.frame.size.height/2;
        meeToo.clipsToBounds=YES;
        meeToo.image=[UIImage imageNamed:@"me_too.png"];
        
        UILabel *nameLabel=(UILabel *)[meTooCell viewWithTag:21];
        nameLabel.translatesAutoresizingMaskIntoConstraints=YES;
        nameLabel.frame=CGRectMake(3, userImage.frame.origin.y+userImage.frame.size.height, nameLabel.frame.size.width,  nameLabel.frame.size.height);
        nameLabel.textAlignment=NSTextAlignmentCenter;
        
        if (cv.sectionTag==0)
        {
            if ([[(PostListingDataModel*)[todayPostData objectAtIndex:cv.collectionTag] isJoined] isEqualToString:@"No"])
            {
                if (indexPath.item==0)
                {
                     meeToo.hidden=NO;
                    nameLabel.text=@"";
                    __weak UIImageView *weakRef = userImage;
                    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[[todayPostData objectAtIndex:cv.collectionTag]joinedUserArray] objectAtIndex:0] joinedUserImage]]
                                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                              timeoutInterval:60];
                    
                    [userImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                        weakRef.contentMode = UIViewContentModeScaleAspectFill;
                        weakRef.clipsToBounds = YES;
                        weakRef.image = image;
                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                        
                    }];
                    
                    
                }
                else
                {
                    meeToo.hidden=YES;
                    nameLabel.text=[[[[todayPostData objectAtIndex:cv.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserName];
                    nameLabel.textColor=[UIColor colorWithRed:126.0/255.0 green:126.0/255.0 blue:126.0/255.0 alpha:1.0];
                    __weak UIImageView *weakRef = userImage;
                    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[[todayPostData objectAtIndex:cv.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserImage]]
                                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                              timeoutInterval:60];
                    
                    [userImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                        weakRef.contentMode = UIViewContentModeScaleAspectFill;
                        weakRef.clipsToBounds = YES;
                        weakRef.image = image;
                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                        
                    }];
                }
            }
            else
            {
                meeToo.hidden=YES;
                if ([[[todayPostData objectAtIndex:cv.collectionTag] creatorOfPostUserId]intValue]==[[UserDefaultManager getValue:@"userId"]intValue])
                {
                    if (indexPath.item==0)
                    {
                        nameLabel.text=@"Me";
                        nameLabel.textColor=[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0];
                        __weak UIImageView *weakRef = userImage;
                        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[[todayPostData objectAtIndex:cv.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserImage]]
                                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                                  timeoutInterval:60];
                        
                        [userImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                            weakRef.contentMode = UIViewContentModeScaleAspectFill;
                            weakRef.clipsToBounds = YES;
                            weakRef.image = image;
                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                            
                        }];
                        
                    }
                    else
                    {
                        nameLabel.textColor=[UIColor colorWithRed:126.0/255.0 green:126.0/255.0 blue:126.0/255.0 alpha:1.0];
                        nameLabel.text=[[[[todayPostData objectAtIndex:cv.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserName];
                        
                        __weak UIImageView *weakRef = userImage;
                        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[[todayPostData objectAtIndex:cv.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserImage]]
                                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                                  timeoutInterval:60];
                        
                        [userImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                            weakRef.contentMode = UIViewContentModeScaleAspectFill;
                            weakRef.clipsToBounds = YES;
                            weakRef.image = image;
                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                            
                        }];
                        
                    }
                }
                else
                {
                    if (indexPath.item==0)
                    {
                        
                        nameLabel.textColor=[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0];
                    }
                    else
                    {
                        nameLabel.textColor=[UIColor colorWithRed:126.0/255.0 green:126.0/255.0 blue:126.0/255.0 alpha:1.0];
                    }
                    
                    nameLabel.text=[[[[todayPostData objectAtIndex:cv.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserName];
                    
                    __weak UIImageView *weakRef = userImage;
                    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[[todayPostData objectAtIndex:cv.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserImage]]
                                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                              timeoutInterval:60];
                    
                    [userImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                        weakRef.contentMode = UIViewContentModeScaleAspectFill;
                        weakRef.clipsToBounds = YES;
                        weakRef.image = image;
                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                        
                    }];
                    
                }
            }
        }
        
        
        else if (cv.sectionTag==1)
        {
            if ([[(PostListingDataModel*)[yesterdayPostData objectAtIndex:cv.collectionTag] isJoined] isEqualToString:@"No"])
            {
                if (indexPath.item==0)
                {
                    
                    meeToo.hidden=NO;
                    nameLabel.text=@"";
                    __weak UIImageView *weakRef = userImage;
                    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[[yesterdayPostData objectAtIndex:cv.collectionTag]joinedUserArray] objectAtIndex:0] joinedUserImage]]
                                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                              timeoutInterval:60];
                    
                    [userImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                        weakRef.contentMode = UIViewContentModeScaleAspectFill;
                        weakRef.clipsToBounds = YES;
                        weakRef.image = image;
                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                        
                    }];
                    
                    
                }
                else
                {
                    meeToo.hidden=YES;
                    nameLabel.text=[[[[yesterdayPostData objectAtIndex:cv.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserName];
                    nameLabel.textColor=[UIColor colorWithRed:126.0/255.0 green:126.0/255.0 blue:126.0/255.0 alpha:1.0];
                    __weak UIImageView *weakRef = userImage;
                    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[[yesterdayPostData objectAtIndex:cv.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserImage]]
                                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                              timeoutInterval:60];
                    
                    [userImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                        weakRef.contentMode = UIViewContentModeScaleAspectFill;
                        weakRef.clipsToBounds = YES;
                        weakRef.image = image;
                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                        
                    }];
                    
                }
            }
            else
            {
                meeToo.hidden=YES;
                if ([[[yesterdayPostData objectAtIndex:cv.collectionTag] creatorOfPostUserId]intValue]==[[UserDefaultManager getValue:@"userId"]intValue])
                {
                    if (indexPath.item==0)
                    {
                        nameLabel.text=@"Me";
                        nameLabel.textColor=[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0];
                        __weak UIImageView *weakRef = userImage;
                        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[[yesterdayPostData objectAtIndex:cv.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserImage]]
                                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                                  timeoutInterval:60];
                        
                        [userImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                            weakRef.contentMode = UIViewContentModeScaleAspectFill;
                            weakRef.clipsToBounds = YES;
                            weakRef.image = image;
                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                            
                        }];
                        
                    }
                    else
                    {
                        nameLabel.textColor=[UIColor colorWithRed:126.0/255.0 green:126.0/255.0 blue:126.0/255.0 alpha:1.0];
                        nameLabel.text=[[[[yesterdayPostData objectAtIndex:cv.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserName];
                        
                        __weak UIImageView *weakRef = userImage;
                        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[[yesterdayPostData objectAtIndex:cv.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserImage]]
                                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                                  timeoutInterval:60];
                        
                        [userImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                            weakRef.contentMode = UIViewContentModeScaleAspectFill;
                            weakRef.clipsToBounds = YES;
                            weakRef.image = image;
                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                            
                        }];
                        
                    }
                }
                else
                {
                    if (indexPath.item==0)
                    {
                        
                        nameLabel.textColor=[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0];
                    }
                    else
                    {
                        nameLabel.textColor=[UIColor colorWithRed:126.0/255.0 green:126.0/255.0 blue:126.0/255.0 alpha:1.0];
                    }
                    
                    nameLabel.text=[[[[yesterdayPostData objectAtIndex:cv.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserName];
                    
                    __weak UIImageView *weakRef = userImage;
                    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[[yesterdayPostData objectAtIndex:cv.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserImage]]
                                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                              timeoutInterval:60];
                    
                    [userImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                        weakRef.contentMode = UIViewContentModeScaleAspectFill;
                        weakRef.clipsToBounds = YES;
                        weakRef.image = image;
                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                        
                    }];
                    
                }
                
            }
            
        }
        return meTooCell;
        
    }
    else
    {
        
        UICollectionViewCell *photoCell = [cv dequeueReusableCellWithReuseIdentifier:@"uploadPhoto" forIndexPath:indexPath];
        photoCell.translatesAutoresizingMaskIntoConstraints=YES;
        photoCell.layer.cornerRadius=7.0f;
        photoCell.clipsToBounds=YES;
        photoCell.layer.borderWidth=1.0f;
        photoCell.layer.borderColor=[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0].CGColor;
        UIImageView *postPhoto=(UIImageView *)[photoCell viewWithTag:30];
        
        postPhoto.translatesAutoresizingMaskIntoConstraints=YES;
        postPhoto.frame=CGRectMake(0, 0, photoCell.frame.size.width,  postPhoto.frame.size.height);
        
        if ( cv.sectionTag==0)
        {
            __weak UIImageView *weakRef = postPhoto;
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[[todayPostData objectAtIndex:cv.collectionTag]uploadedPhotoArray] objectAtIndex:indexPath.item] postImageUrl]]
                                                          cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                      timeoutInterval:60];
            
            [postPhoto setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"picture.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                weakRef.contentMode = UIViewContentModeScaleAspectFill;
                weakRef.clipsToBounds = YES;
                weakRef.image = image;
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
            }];
            
        }
        else if (cv.sectionTag==1)
        {
            __weak UIImageView *weakRef = postPhoto;
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[[yesterdayPostData objectAtIndex:cv.collectionTag]uploadedPhotoArray] objectAtIndex:indexPath.item] postImageUrl]]
                                                          cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                      timeoutInterval:60];
            
            [postPhoto setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"picture.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                weakRef.contentMode = UIViewContentModeScaleAspectFill;
                weakRef.clipsToBounds = YES;
                weakRef.image = image;
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
            }];
            
        }
        return photoCell;
    }
}

- (void)collectionView:(MyCollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag==50)
    {
        
        if (collectionView.sectionTag==0)
        {
            if (indexPath.item==0 && [[(PostListingDataModel*)[todayPostData objectAtIndex:collectionView.collectionTag]isJoined]isEqualToString:@"No"]) {
                postId=[[todayPostData objectAtIndex:collectionView.collectionTag]postID];
                [myDelegate ShowIndicator];
                [self performSelector:@selector(joinPost) withObject:nil afterDelay:0.1];
            }
            else
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MeTooUserProfileViewController * viewPost = [storyboard instantiateViewControllerWithIdentifier:@"MeTooUserProfileViewController"];
                viewPost.postID=[[todayPostData objectAtIndex:collectionView.collectionTag]postID];
                viewPost.post=[[todayPostData objectAtIndex:collectionView.collectionTag]postContent];
               viewPost.joineUserId=[[[[todayPostData objectAtIndex:collectionView.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserId];
                 viewPost.userName=[[[[todayPostData objectAtIndex:collectionView.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserName];
                viewPost.userProfileImageUrl=[[[[todayPostData objectAtIndex:collectionView.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserImage];
                if ([[[todayPostData objectAtIndex:collectionView.collectionTag] friendsJoinedCount]intValue] ==0)
                {
                    viewPost.followedUser=[NSString stringWithFormat:@"%@ felt the same way",[[todayPostData objectAtIndex:collectionView.collectionTag] joinedUserCount]];
                }
                else
                {
                    viewPost.followedUser=[NSString stringWithFormat:@"%@+%@ felt the same way",[[todayPostData objectAtIndex:collectionView.collectionTag] joinedUserCount],[[todayPostData objectAtIndex:indexPath.row] friendsJoinedCount]];
                }
                UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:viewPost];
                [self.navigationController presentViewController:navBar animated: YES completion: ^ {
                    
                }];
               // [self.navigationController pushViewController:viewPost animated:YES];
            }
            
        }
        else
        {
            if (indexPath.item==0 && [[(PostListingDataModel*)[yesterdayPostData objectAtIndex:collectionView.collectionTag]isJoined]isEqualToString:@"No"]) {
                postId=[[yesterdayPostData objectAtIndex:collectionView.collectionTag]postID];
                [myDelegate ShowIndicator];
                [self performSelector:@selector(joinPost) withObject:nil afterDelay:0.1];
            }
            else
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MeTooUserProfileViewController * viewPost = [storyboard instantiateViewControllerWithIdentifier:@"MeTooUserProfileViewController"];
                viewPost.postID=[[yesterdayPostData objectAtIndex:collectionView.collectionTag]postID];
                viewPost.post=[[yesterdayPostData objectAtIndex:collectionView.collectionTag]postContent];
                viewPost.joineUserId=[[[[yesterdayPostData objectAtIndex:collectionView.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserId];
                viewPost.userName=[[[[yesterdayPostData objectAtIndex:collectionView.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserName];
                viewPost.userProfileImageUrl=[[[[yesterdayPostData objectAtIndex:collectionView.collectionTag]joinedUserArray] objectAtIndex:indexPath.item] joinedUserImage];
                if ([[[yesterdayPostData objectAtIndex:collectionView.collectionTag] friendsJoinedCount]intValue] ==0)
                {
                    viewPost.followedUser=[NSString stringWithFormat:@"%@ felt the same way",[[yesterdayPostData objectAtIndex:collectionView.collectionTag] joinedUserCount]];
                }
                else
                {
                    viewPost.followedUser=[NSString stringWithFormat:@"%@+%@ felt the same way",[[yesterdayPostData objectAtIndex:collectionView.collectionTag] joinedUserCount],[[yesterdayPostData objectAtIndex:collectionView.collectionTag] friendsJoinedCount]];
                }
                UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:viewPost];
                [self.navigationController presentViewController:navBar animated: YES completion: ^ {
                    
                }];
                // [self.navigationController pushViewController:viewPost animated:YES];
            }

            
            
        }
    }
    else
    {
        if (collectionView.sectionTag==0)
        {
           
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ViewPostImagesViewController * viewPost = [storyboard instantiateViewControllerWithIdentifier:@"ViewPostImagesViewController"];
              viewPost.postID=[[todayPostData objectAtIndex:collectionView.collectionTag]postID];
            viewPost.selectedIndex=(int)indexPath.row;
                UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:viewPost];
                [self.navigationController presentViewController:navBar animated: YES completion: ^ {
                    
                }];
                // [self.navigationController pushViewController:viewPost animated:YES];
          
            
        }
        else
        {
           
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewPostImagesViewController * viewPost = [storyboard instantiateViewControllerWithIdentifier:@"ViewPostImagesViewController"];
              viewPost.postID=[[yesterdayPostData objectAtIndex:collectionView.collectionTag]postID];
            viewPost.selectedIndex=(int)indexPath.row;
            UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:viewPost];
            [self.navigationController presentViewController:navBar animated: YES completion: ^ {
                
            }];
                // [self.navigationController pushViewController:viewPost animated:YES];
            
        }

        NSLog(@"selected index %ld",(long)indexPath.item);
    }
}
#pragma mark - end
#pragma mark - Webservice - JoinPost
-(void)joinPost
{
    [[WebService sharedManager]joinPost:postId success: ^(id responseObject) {
        
        [myDelegate ShowIndicator];
        [self performSelector:@selector(getPostListing) withObject:nil afterDelay:0.1];
        
    }
                                failure:^(NSError *error)
     {
         
     }] ;
    
}
#pragma mark - end
#pragma mark - IBActions
- (IBAction)hotNewPostSegmentAction:(id)sender
{
    NSLog(@"segment button clicked.");
    [postListingTableView reloadData];
}

-(void)openCameraAction:(MyButton *)sender
{
       
    if (sender.sectionTag==0) {
        
        postId=[[todayPostData objectAtIndex:sender.Tag]postID];
    }
    else
    {
        postId=[[yesterdayPostData objectAtIndex:sender.Tag]postID];
    }
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take Photo", @"Choose from Gallery", nil];
    
        [actionSheet showInView:self.view];
    
    
}
#pragma mark - end

#pragma mark - Action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if (buttonIndex==0)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no camera."
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
            
        }
        else
            
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
        
    }
    if ([buttonTitle isEqualToString:@"Choose from Gallery"])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [self presentViewController:picker animated:YES completion:NULL];
       // [self presentViewController:imagePickerController animated:YES completion:NULL];
    }
}
#pragma mark - end

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info valueForKey:UIImagePickerControllerOriginalImage];
    pickerSelection=true;
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PhotoPreviewViewController * photoView = [storyboard instantiateViewControllerWithIdentifier:@"PhotoPreviewViewController"];
        photoView.postImage=image;
    photoView.postID=postId;
 
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:photoView];
    [self.navigationController presentViewController:navBar animated: YES completion: ^ {
         pickerSelection=false;
    }];

    
}
- (void)dismissImagePickerController
{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popToViewController:self animated:YES];
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
   // [myDelegate StopIndicator];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
