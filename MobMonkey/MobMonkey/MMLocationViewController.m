//
//  MMLocationViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 5/6/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMLocationViewController.h"
#import "MMLocationHeaderView.h"
#import "MMLocationMediaView.h"
#import <QuartzCore/QuartzCore.h>
#import "MMRequestViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIActionSheet+Blocks.h"
#import "MMMapViewController.h"
#import "MMNotificationSettingsViewController.h"

@implementation MMLocationDetailCellData


@end



@interface MMLocationViewController ()

@property (nonatomic, strong) NSArray *locationCellData;

@end

@implementation MMLocationViewController

@synthesize mediaArray;
@synthesize headerView = _headerView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    self.tableView.backgroundView = nil;
    
    self.headerView = [[MMLocationHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
    self.headerView.layer.zPosition = 100;
    self.headerView.backgroundColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    
    UIView *headerViewSpacer = [[UIView alloc] initWithFrame:self.headerView.frame];
    [self.tableView addSubview:self.headerView];
    [self.tableView setTableHeaderView:headerViewSpacer];
    
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    [self.tableView setTableFooterView:footerView];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   // [self.tableView reloadData];
    
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    self.headerView.mediaView.liveStreamButton.tag = MMLiveCameraMediaType;
    self.headerView.mediaView.videosButton.tag = MMVideoMediaType;
    self.headerView.mediaView.photosButton.tag = MMPhotoMediaType;
    
    [self.headerView.mediaView.videosButton addTarget:self action:@selector(mediaButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.mediaView.liveStreamButton addTarget:self action:@selector(mediaButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.mediaView.photosButton addTarget:self action:@selector(mediaButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView.mediaView.shareButton addTarget:self action:@selector(shareButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapMediaGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enlargeButtonTapped:)];
    tapMediaGesture.numberOfTapsRequired = 1;
    [self.headerView.mediaView.mediaImageView addGestureRecognizer:tapMediaGesture];
    
    [self.headerView.makeARequestButton addTarget:self action:@selector(makeRequestButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self loadLocationDataWithLocationId:self.locationInformation.locationID providerId:self.locationInformation.providerID];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadCellData{
    NSMutableArray *cellData = [NSMutableArray array];
    
    if(_locationInformation.phoneNumber && _locationInformation.phoneNumber !=(id)[NSNull null]){
        MMLocationDetailCellData *phoneData = [[MMLocationDetailCellData alloc] init];
        phoneData.text = _locationInformation.phoneNumber;
        phoneData.cellType = LocationCellTypePhoneNumber;
        phoneData.image = [UIImage imageNamed:@"telephone"];
        [cellData addObject:phoneData];
    }
    
    NSString *addressString = [_locationInformation formattedAddressString];
    if(addressString){
        MMLocationDetailCellData *addressData = [[MMLocationDetailCellData alloc] init];
        addressData.text = addressString;
        addressData.cellType = LocationCellTypeAddressBOOL;
        addressData.image = [UIImage imageNamed:@"mapPin"];
        [cellData addObject:addressData];
        
    }
    
    MMLocationDetailCellData *notifcationsData = [[MMLocationDetailCellData alloc] init];
    notifcationsData.text = @"Add Notifications";
    notifcationsData.image = [UIImage imageNamed:@"alarmClock"];
    notifcationsData.cellType = LocationCellTypeNotification;
    [cellData addObject:notifcationsData];
    
    self.locationCellData = cellData;
}
-(void)setLocationInformation:(MMLocationInformation *)locationInformation{
    
    _locationInformation = locationInformation;
    
    [self loadCellData];
    
    
    [self.tableView reloadData];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //No Rows if there is no location information
    if(!self.locationInformation && section == 0){
        return 1;
    }
    
    NSUInteger rowCount = 0;
    if(section == 0){
        rowCount = self.locationCellData.count;
    }else if(section == 2){
        
        // Row for "Add to Favorites
        rowCount  = 1;
    }else if(section == 1){
        return self.locationInformation.sublocations.count ;
    }
    
    return rowCount;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    }
    if(indexPath.section == 0){
        
        MMLocationDetailCellData *cellData = [self.locationCellData objectAtIndex:indexPath.row];
        cell.imageView.image = cellData.image;
        cell.textLabel.text = cellData.text;
        
        if(cellData.cellType == LocationCellTypeAddressBOOL){
            cell.textLabel.numberOfLines = 2;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if(cellData.cellType == LocationCellTypeNotification){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else if (indexPath.section == 2) {
        cell.textLabel.text = @"Add to Favorites";
        if (_locationInformation.isBookmark) {
            cell.textLabel.text = @"Remove from Favorites";
        }
        cell.imageView.image = [UIImage imageNamed:@"favorite"];
        return cell;
    } else if (indexPath.section == 1){
        MMLocationInformation *subLocation = [self.locationInformation.sublocations.allObjects objectAtIndex:indexPath.row];
        cell.textLabel.text = subLocation.name;
        cell.imageView.image = nil;
    }
    
    return cell;

}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 1 && self.locationInformation.sublocations.count > 0) return @"Hot Spots";
    if(section == 0) return @"Location Information";
    return nil;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        MMLocationDetailCellData *cellData = [self.locationCellData objectAtIndex:indexPath.row];
        
        if(cellData.cellType == LocationCellTypeAddressBOOL){
            return 65;
        }
        
    }
    
    return 44;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        [self bookmarkButtonTapped:nil];
        return;
    }
    if(indexPath.section == 0){
        
        MMLocationDetailCellData *cellData = [self.locationCellData objectAtIndex:indexPath.row];
        
        switch (cellData.cellType) {
            case LocationCellTypePhoneNumber: {
                
                NSString *telNumber = cellData.text;
                NSString *telURI;
                if(telNumber.length > 0){
                    telURI = [@"tel:" stringByAppendingString:telNumber];
                    telURI = [telURI stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }else{
                    //Break switch, if there is no number.
                    break;
                }
                
                //Create the ActionView Buttons (using +Blocks category)
                RIButtonItem *copyButton = [RIButtonItem itemWithLabel:@"Copy"];
                RIButtonItem *callButton = [RIButtonItem itemWithLabel:[NSString stringWithFormat:@"Call: %@", telNumber]];
                RIButtonItem *cancelButton = [RIButtonItem itemWithLabel:@"Cancel"];
                
                /*****
                 Set Action blocks for buttons
                 *****/
                //Copy text to pasteboard
                [copyButton setAction:^{
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = telNumber;
                }];
                
                //Call number
                [callButton setAction:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telURI]];
                }];
                
                
                UIActionSheet *copyCallActionsheet;
                
                //Only show call if phone has the capability
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:telURI]]){
                    copyCallActionsheet = [[UIActionSheet alloc] initWithTitle:@"Options" cancelButtonItem:cancelButton destructiveButtonItem:nil otherButtonItems:callButton, copyButton, nil];
                }else{
                    copyCallActionsheet = [[UIActionSheet alloc] initWithTitle:@"Options" cancelButtonItem:cancelButton destructiveButtonItem:nil otherButtonItems:copyButton, nil];
                }
                
                //Show the action sheet
                [copyCallActionsheet showFromTabBar:self.tabBarController.tabBar];
                break;
            }
            case LocationCellTypeAddressBOOL: {
                MMMapViewController *mapViewController = [[MMMapViewController alloc]initWithNibName:@"MMMapViewController" bundle:nil];
                mapViewController.title = self.locationInformation.name;
                mapViewController.locationInformationCollection = @[self.locationInformation];
                [self.navigationController pushViewController:mapViewController animated:YES];
                break;
            }
            case LocationCellTypeNotification: {
                [self notificationSettingsButtonTapped:nil];
                break;
            }
                
            default:
                break;
        }
    }else if(indexPath.section == 1){
        MMLocationInformation *subLocation = [self.locationInformation.sublocations.allObjects objectAtIndex:indexPath.row];
        MMLocationViewController *subLocationViewController = [[MMLocationViewController alloc] initWithNibName:@"MMLocationViewController" bundle:nil];
        subLocationViewController.locationInformation = subLocation;
        [self.navigationController pushViewController:subLocationViewController animated:YES];
    }
}

#pragma mark - ScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGRect newFrame = self.headerView.frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.tableView.contentOffset.y;
    self.headerView.frame = newFrame;
    
}

#pragma mark Button methods
#pragma mark - IBAction Methods
- (IBAction)mediaButtonTapped:(id)sender
{
    switch ([sender tag]) {
        case MMLiveCameraMediaType:
            if ([[self.locationInformation.livestreaming description] intValue] == 0)
                return;
            
            break;
            
        case MMVideoMediaType:
            if ([[self.locationInformation.videos description] intValue] == 0)
                return;
            
            break;
            
        case MMPhotoMediaType:
            if ([[self.locationInformation.images description] intValue] == 0)
                return;
            
            break;
            
        default:
            break;
    }
    
    MMLocationMediaViewController *lmvc = [[MMLocationMediaViewController alloc] initWithNibName:@"MMLocationMediaViewController" bundle:nil];
    //lmvc.location = self.contentList;
    lmvc.locationInformation = self.locationInformation;
    lmvc.title = self.title;
    lmvc.providerId = self.locationInformation.locationID;
    lmvc.locationId = self.locationInformation.providerID;
    lmvc.mediaType = [sender tag];
    
    UINavigationController *locationMediaNavC = [[UINavigationController alloc] initWithRootViewController:lmvc];
    [self presentViewController:locationMediaNavC animated:YES completion:NULL];
}
- (IBAction)makeRequestButtonTapped:(id)sender {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Request" bundle:nil];
        UINavigationController *navVC = [storyboard instantiateInitialViewController];
        MMRequestViewController *requestVC = (MMRequestViewController *)navVC.viewControllers[0];
        requestVC.locationInformation = self.locationInformation;
        //[requestVC setContentList:self.contentList];
        [self.navigationController presentViewController:navVC animated:YES completion:nil];
    }
    else {
        [[MMClientSDK sharedSDK] signInScreen:self];
    }
}
- (IBAction)shareButtonTapped:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    BOOL isVideo = NO;
    [params setValue:self.headerView.locationTitleLabel.text forKey:@"initialText"];
    if (mediaArray.count > 0) {
        if ([[[mediaArray objectAtIndex:0]valueForKey:@"type"]isEqualToString:@"video"]) {
            [params setValue:[[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"] forKey:@"url"];
            isVideo = YES;
        }
        else {
            [params setValue:self.headerView.mediaView.mediaImageView.image forKey:@"image"];
        }
    }
    if (![self.locationInformation.website isKindOfClass:[NSNull class]] && ![self.locationInformation.website isEqualToString:@""] && !isVideo) {
        [params setValue:self.locationInformation.website forKey:@"url"];
    }
    
    [[MMClientSDK sharedSDK]showMoreActionSheet:self showFromTabBar:YES paramsForPublishingToSocialNetwork:params];
}
- (void)enlargeButtonTapped:(id)sender {
    if (mediaArray.count > 0) {
        if ([[[mediaArray objectAtIndex:0]valueForKey:@"type"]isEqualToString:@"video"] || [[[mediaArray objectAtIndex:0]valueForKey:@"type"]isEqualToString:@"livestreaming"]) {
            NSURL *url = [NSURL URLWithString:[[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"]];
            _player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
            [self.navigationController presentMoviePlayerViewControllerAnimated:_player];
        }
        else {
            [[MMClientSDK sharedSDK] inboxFullScreenImageScreen:self imageToDisplay:self.headerView.mediaView.mediaImageView.image locationName:self.title];
        }
    }
}
- (IBAction)bookmarkButtonTapped:(id)sender {
    if (self.locationInformation.isBookmark) {
        self.locationInformation.isBookmark = NO;
        [self.tableView reloadData];
        [MMAPI deleteBookmarkWithLocationID:self.locationInformation.locationID providerID:self.locationInformation.providerID  success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Removed bookmark");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", operation.responseString);
        }];
        
        return;
    }
    self.locationInformation.isBookmark = YES;
    [self.tableView reloadData];
    [MMAPI createBookmarkWithLocationID:self.locationInformation.locationID providerID:self.locationInformation.providerID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Added Bookmark!");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Could not add Bookmark!");
    }];
}


- (IBAction)notificationSettingsButtonTapped:(id)sender {
    MMNotificationSettingsViewController *noticiationSettingsVC = [[MMNotificationSettingsViewController alloc]initWithNibName:@"MMNotificationSettingsViewController" bundle:nil];
    noticiationSettingsVC.delegate = self;
    [self.navigationController pushViewController:noticiationSettingsVC animated:YES];
}

#pragma  mark Load Location Data
- (void)loadLocationDataWithLocationId:(NSString*)locationId providerId:(NSString*)providerId {
    
    //locationId = self.locationInformation.locationID;
    //providerId = self.locationInformation.providerID;
    
    if(!locationId && !providerId) {
        
        if(!self.locationInformation)return;
        
        locationId = self.locationInformation.locationID;
        providerId = self.locationInformation.providerID;
    }
    
    if(!self.locationInformation){
        [SVProgressHUD showWithStatus:@"Loading"];
    }else{
        self.headerView.makeARequestSubLabel.text = @"Finding Members...";
        /*[self resizeTableViewForMediaLoadingView];
        self.mediaLoadingView.hidden = NO;
        [self.mediaIndicatorView startAnimating];*/
    }
    [self.headerView showLoadingView];
    
    [MMAPI getLocationWithID:locationId providerID:providerId success:^(AFHTTPRequestOperation *operation, MMLocationInformation *locationInformation) {
        
        [SVProgressHUD dismiss];
        
        if(!self.locationInformation){
            self.locationInformation = locationInformation;
        }else{
            self.locationInformation.monkeys = locationInformation.monkeys;
            self.locationInformation.videos = locationInformation.videos;
            self.locationInformation.images = locationInformation.images;
            self.locationInformation.livestreaming = locationInformation.livestreaming;
        }
        
        
        [self setLocationDetailItems];
        [self fetchLatestMediaForLocation];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(operation.response.statusCode == 401){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm Email Address" message:@"Please check your email and confirm the registration." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
        [self.headerView hideLoadingViewShowMedia:NO];
        NSLog(@"Failed: %@", error);
    }];
    
}

- (void)setLocationDetailItems {
    
    if(self.locationInformation.name && [self.locationInformation.name length] > 0){
        
        if(self.locationInformation.parentLocation){
            self.title = [NSString stringWithFormat:@"HOT SPOT: %@", self.locationInformation.name];
        }else{
            self.title = self.locationInformation.name;
        }
        
    }
    
    self.headerView.locationTitleLabel.text = self.title;
    /*_phoneNumberLabel.text = self.locationInformation.phoneNumber;
    _addressLabel.text = [self.locationInformation formattedAddressString];
    //NSLog(@"%@", _contentList);*/
    NSString *message = self.locationInformation.message;
    
    if(message && ![message isEqual:[NSNull null]]){
        self.headerView.mediaView.messageLabel.adjustsFontSizeToFitWidth = YES;
        self.headerView.mediaView.messageLabel.text = message;
        self.headerView.mediaView.messageLabel.backgroundColor = [UIColor clearColor];
    }
    
    
    
    [self.headerView.mediaView.liveStreamButton setEnabled:YES];
    [self.headerView.mediaView.liveVideoButtonImageView setImage:[UIImage imageNamed:@"location-liveVideoIcn"]];
    [self.headerView.mediaView.videosButton setEnabled:YES];
    [self.headerView.mediaView.photosButton setEnabled:YES];
    
    int streamingCount = [self.locationInformation.livestreaming intValue];
    if (streamingCount == 0) {
        self.headerView.mediaView.liveStreamCountLabel.hidden = YES;
        [self.headerView.mediaView.liveStreamButton setEnabled:NO];
        [self.headerView.mediaView.liveVideoButtonImageView setImage:[UIImage imageNamed:@"location-liveVideoIcnOff"]];
    }
    else {
        self.headerView.mediaView.liveStreamCountLabel.hidden = NO;
        self.headerView.mediaView.liveStreamCountLabel.text = [NSString stringWithFormat:@"%d", streamingCount];
    }
    
    int videoCount = [self.locationInformation.videos intValue];
    if (videoCount == 0) {
        self.headerView.mediaView.videoCountLabel.hidden = YES;
        [self.headerView.mediaView.videosButton setEnabled:NO];
        
    } else {
        self.headerView.mediaView.videoCountLabel.hidden = NO;
        self.headerView.mediaView.videoCountLabel.text = [NSString stringWithFormat:@"%d", videoCount];
    }
    
    int photoCount = [self.locationInformation.images intValue];
    if (photoCount == 0) {
        self.headerView.mediaView.photoCountLabel.hidden = YES;
        [self.headerView.mediaView.photosButton setEnabled:NO];
        
    }
    else {
        self.headerView.mediaView.photoCountLabel.hidden = NO;
        self.headerView.mediaView.photoCountLabel.text = [NSString stringWithFormat:@"%d", photoCount];
    }
    
    int monkeyCount = [self.locationInformation.monkeys intValue];
    if (monkeyCount == 0) {
        self.headerView.makeARequestSubLabel.text = @"No members found";
        
    }
    else if (monkeyCount == 1) {
        self.headerView.makeARequestSubLabel.text = @"1 member found";
    }
    else {
        self.headerView.makeARequestSubLabel.text = [NSString stringWithFormat:@"%d members found", monkeyCount];
    }
}
- (void)fetchLatestMediaForLocation {
    
    //self.mediaLoadingView.hidden = NO;
    //[self.mediaIndicatorView startAnimating];
    
        
    [MMAPI getMediaForLocationID:self.locationInformation.locationID providerID:self.locationInformation.providerID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"DATA: %@", responseObject);
        mediaArray = [responseObject valueForKey:@"media"];
        if (mediaArray.count > 0) {
            //self.headerView.mediaView = [[MMLocationMediaView alloc] init];
            [self.headerView.mediaView.clockLabel setHidden:NO];
            double unixTime = [[[mediaArray objectAtIndex:0]valueForKey:@"uploadedDate"] floatValue]/1000;
            NSDate *dateAnswered = [NSDate dateWithTimeIntervalSince1970:
                                    (NSTimeInterval)unixTime];
            
            //TODO: _uploadDateLabel.text = [GetRelativeTime getRelativeTime:dateAnswered];
            
            NSString *mediaUrl = [[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"];
            __weak typeof(self) weakSelf = self;
            if ([[[mediaArray objectAtIndex:0]valueForKey:@"type"]isEqualToString:@"image"]) {
                NSURLRequest *imageRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:mediaUrl]];
                [self.headerView.mediaView.mediaImageView setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    
                    NSLog(@"Starting");
                    weakSelf.headerView.mediaView.mediaImageView.image = image;
                    weakSelf.headerView.mediaView.topGradientView.hidden = NO;
                    weakSelf.headerView.mediaView.bottomGradientView.hidden = NO;
                    
                    
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    NSLog(@"Failed Loading Image");
                }];
                //self.bottonBlackGradient.hid
            }
            else if ([[[mediaArray objectAtIndex:0]valueForKey:@"type"]isEqualToString:@"livestreaming"]) {
                self.headerView.mediaView.mediaImageView.image = [UIImage imageNamed:@"liveFeedPlaceholder"];
                self.headerView.mediaView.bottomGradientView.hidden = NO;
                [self.headerView.mediaView.playButtonOverlay setHidden:NO];
            }
            else {
                [self.headerView.mediaView.playButtonOverlay setHidden:NO];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:[[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"]] options:nil];
                    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                    generate.appliesPreferredTrackTransform = YES;
                    NSError *err = NULL;
                    CMTime time = CMTimeMake(0, 60);
                    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        self.headerView.mediaView.mediaImageView.image =  [UIImage imageWithCGImage:imgRef];
                        self.headerView.mediaView.bottomGradientView.hidden = NO;
                    });
                });
                
            }
            [self.headerView hideLoadingViewShowMedia:YES];
        }else{
            [self.headerView hideLoadingViewShowMedia:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", operation.responseString);
        [self.headerView hideLoadingViewShowMedia:NO];
    }];
    
}

#pragma mark - header view delegate
-(void)headerViewNeedsToBeSetOnSuperView:(MMLocationHeaderView *)headerView{
    self.headerView = headerView;
    self.tableView.tableHeaderView = self.headerView;
}
@end
