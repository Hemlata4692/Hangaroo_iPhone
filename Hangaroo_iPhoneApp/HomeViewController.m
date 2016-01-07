//
//  HomeViewController.m
//  Hangaroo_iPhoneApp
//
//  Created by Hema on 30/12/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//



#import "HomeViewController.h"

#define kCellsPerRow 3

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
    NSMutableArray *uploadedPhotoArray;
    
    
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *hotNewPostSegment;

@property (weak, nonatomic) IBOutlet UITableView *postListingTableView;
@property (strong, nonatomic) UITabBarController *tabbarcontroller;

@end

@implementation HomeViewController
@synthesize postListingTableView;

#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTabBarImages];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
  //  [myDelegate ShowIndicator];
    [self performSelector:@selector(getPostListing) withObject:nil afterDelay:.1];
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
    
    [tabBarItem1 setImage:[[UIImage imageNamed:@"Home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"Home_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    tabBarItem1.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    [tabBarItem2 setImage:[[UIImage imageNamed:@"Chat.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"Chat_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem2.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    [tabBarItem3 setImage:[[UIImage imageNamed:@"SharePost.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"SharePost_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem3.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    [tabBarItem4 setImage:[[UIImage imageNamed:@"Discover.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem4 setSelectedImage:[[UIImage imageNamed:@"Discover_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem4.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    [tabBarItem5 setImage:[[UIImage imageNamed:@"Profile.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem5 setSelectedImage:[[UIImage imageNamed:@"Profile_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem5.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
}
#pragma mark - end

#pragma mark - Webservice
-(void)getPostListing
{
//    [[WebService sharedManager]postListing:^(id responseObject) {
//        
//        [myDelegate StopIndicator];
//              
//    } failure:^(NSError *error) {
//        
//    }] ;

}
#pragma mark - end

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else
    return 2;
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
   
    if (section==0) {
         headerLabel.text=@"Today";
    }
    else
    {
         headerLabel.text=@"Yesterday";
    }
    [headerView addSubview:headerLabel];
    
    UILabel *seperatorLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, headerLabel.frame.origin.y+headerLabel.frame.size.height+5, tableView.frame.size.width-40, 1)];
    seperatorLabel.backgroundColor=[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0];
    [headerView addSubview:seperatorLabel];
    
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(235,999);
    CGRect textRect = [@"fjfenffkmfdfdnfmndfjlfefnbfkjdlfdbfmfjfenffkmfdfdnfmndfjlfe"
                       boundingRectWithSize:size
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:15.0]}
                       context:nil];
    textRect.origin.x = 8;
    textRect.origin.y = 19;
    if (uploadedPhotoArray.count==0) {
        return 180+textRect.size.height;
    }
    else
        return 286+textRect.size.height;
    
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
    UIButton *cameraButton=(UIButton *)[cell viewWithTag:10];
    UIImageView *tickIcon=(UIImageView *)[cell viewWithTag:3];
    UIImageView *cameraIcon=(UIImageView *)[cell viewWithTag:4];
    UICollectionView*  meTooCollectionView=(UICollectionView *)[cell viewWithTag:50];
    UICollectionView*  photoCollectionView=(UICollectionView *)[cell viewWithTag:60];
    postLabel.translatesAutoresizingMaskIntoConstraints=YES;
    followedUserLabel.translatesAutoresizingMaskIntoConstraints=YES;
    seperatorLabel.translatesAutoresizingMaskIntoConstraints=YES;
    tickIcon.translatesAutoresizingMaskIntoConstraints=YES;
    cameraIcon.translatesAutoresizingMaskIntoConstraints=YES;
    cameraButton.translatesAutoresizingMaskIntoConstraints=YES;
    meTooCollectionView.translatesAutoresizingMaskIntoConstraints=YES;
    photoCollectionView.translatesAutoresizingMaskIntoConstraints=YES;
   
    postLabel.text=@"fjfenffkmfdfdnfmndfjlfefnbfkjdlfdbfmfjfenffkmfdfdnfmndfjlfe";
    CGSize size = CGSizeMake(235,999);
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
    
    meTooCollectionView.frame =CGRectMake(8, followedUserLabel.frame.origin.y+followedUserLabel.frame.size.height+12, postListingTableView.frame.size.width-16, meTooCollectionView.frame.size.height);
    
    photoCollectionView.frame =CGRectMake(8, meTooCollectionView.frame.origin.y+meTooCollectionView.frame.size.height, postListingTableView.frame.size.width-16, photoCollectionView.frame.size.height);
    
    if (uploadedPhotoArray.count==0)
    {
        photoCollectionView.hidden=YES;
        seperatorLabel.frame =CGRectMake(0, meTooCollectionView.frame.origin.y+meTooCollectionView.frame.size.height+15, postListingTableView.frame.size.width, 2);
    }
    else
    {
        photoCollectionView.hidden=NO;
        seperatorLabel.frame =CGRectMake(0, photoCollectionView.frame.origin.y+photoCollectionView.frame.size.height+15, postListingTableView.frame.size.width, 2);
    }
    [cameraButton addTarget:self action:@selector(openCameraAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // setting collection view cell size according to iPhone screens
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)photoCollectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.view.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow-1)-10;
    CGFloat cellWidth = (availableWidthForCells / kCellsPerRow)-10;
    flowLayout.itemSize = CGSizeMake(cellWidth, flowLayout.itemSize.height);
    
    [photoCollectionView reloadData];
    [meTooCollectionView reloadData];
    return cell;
    
}

#pragma mark - end

#pragma mark- Cell collection view delegate

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    if (view.tag==50)
    {
        return 6;
    }
    else
    {
        return 6;
    }
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (cv.tag==50) {
        
        UICollectionViewCell *meTooCell = [cv dequeueReusableCellWithReuseIdentifier:@"meTooCell" forIndexPath:indexPath];
        meTooCell.translatesAutoresizingMaskIntoConstraints=YES;
        
        UIImageView *userImage=(UIImageView *)[meTooCell viewWithTag:20];
        
        userImage.translatesAutoresizingMaskIntoConstraints=YES;
        userImage.frame=CGRectMake(15, 8, meTooCell.frame.size.width-30,  userImage.frame.size.height);
        userImage.layer.cornerRadius=userImage.frame.size.height/2;
        userImage.clipsToBounds=YES;
        
        UILabel *nameLabel=(UILabel *)[meTooCell viewWithTag:21];
        nameLabel.translatesAutoresizingMaskIntoConstraints=YES;
        nameLabel.frame=CGRectMake(4, userImage.frame.origin.y+userImage.frame.size.height, nameLabel.frame.size.width,  nameLabel.frame.size.height);
        nameLabel.textAlignment=NSTextAlignmentCenter;
        
        // serviceImage.image=[UIImage imageNamed:[imageList objectAtIndex:indexPath.row]];
        //    __weak UIImageView *weakRef = userImage;
        //    NSDictionary *tempDict=[imageList objectAtIndex:indexPath.row];
        //
        //    NSString *tempUrl=[tempDict objectForKey:@"Image"];
        //
        //
        //    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:tempUrl]
        //                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
        //                                              timeoutInterval:60];
        //
        //    [serviceImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"picture"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        //        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        //        //  weakRef.clipsToBounds = YES;
        //        weakRef.image = image;
        //    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //
        //    }];
        
        return meTooCell;
        
    }
    else
    {
        
        UICollectionViewCell *photoCell = [cv dequeueReusableCellWithReuseIdentifier:@"uploadPhoto" forIndexPath:indexPath];
        photoCell.translatesAutoresizingMaskIntoConstraints=YES;
        photoCell.layer.cornerRadius=3.0f;
        photoCell.clipsToBounds=YES;
        photoCell.layer.borderWidth=1.0f;
        photoCell.layer.borderColor=[UIColor colorWithRed:13.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0].CGColor;
        UIImageView *photo=(UIImageView *)[photoCell viewWithTag:30];
        
        photo.translatesAutoresizingMaskIntoConstraints=YES;
        photo.frame=CGRectMake(0, 0, photoCell.frame.size.width,  photo.frame.size.height);
        
        
        return photoCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag==50) {
        NSLog(@"selected index %ld",(long)indexPath.row);
    }
    else
    {
        NSLog(@"selected index %ld",(long)indexPath.row);
    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)hotNewPostSegmentAction:(id)sender
{
    NSLog(@"segment button clicked.");
    [postListingTableView reloadData];
}

-(void)openCameraAction:(UIButton *)sender
{
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
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
}
#pragma mark - end

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info
{


    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma mark - end

@end
