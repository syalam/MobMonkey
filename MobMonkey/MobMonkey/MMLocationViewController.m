//
//  MMLocationViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/2/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMLocationViewController.h"
#import "MMNotificationSettingsViewController.h"
#import "MMFullScreenImageViewController.h"
#import "MMSetTitleImage.h"
#import "MMLoginViewController.h"
#import "MMMapViewController.h"
#import "MMClientSDK.h"
#import "PhoneNumberFormatter.h"
#import "MMRequestViewController.h"
#import "MMLocationMediaViewController.h"
#import <MapKit/MapKit.h>
#import "MMLocationAnnotation.h"
#import "GetRelativeTime.h"
#import "UIActionSheet+Blocks.h"
#import "BrowserViewController.h"

@implementation MMlocationDetailCellData


@end


@interface MMLocationViewController ()

@property (nonatomic, strong) NSArray *locationCellData;

@end

@implementation MMLocationViewController
@synthesize locationInformation = _locationInformation;
@synthesize locationCellData = _locationCellData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    /*NSString *locationId = @"5d44fab0-6f4f-4fe7-8351-aa4fb695d764";
    NSString *providerId = @"e048acf0-9e61-4794-b901-6a4bb49c3181";
    self.locationInformation.locationID = locationId;
    self.locationInformation.providerID = providerId;*/
    
    // Do any additional setup after loading the view from its nib.
    
    backgroundQueue = dispatch_queue_create("com.MobMonkey.GenerateThumbnail", NULL);
    
    //setup scrollview size
    [_scrollView setContentSize:CGSizeMake(320, 815)];
    
    //set background color
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background~iphone"]]];
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    //set location name label text and font
  _locationNameLabel.textColor = [UIColor blackColor];
    
    //Add custom back button to the nav bar    
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"row%dFlagged", self.rowIndex]]) {
        [self.flagButton setBackgroundColor:[UIColor blueColor]];
    }
    else {
        [self.flagButton setBackgroundColor:[UIColor clearColor]];
    }

    [_notificationSettingView setHidden:YES];
    [_notificationSettingLabel setHidden:YES];
    
    //Get Counts of photos and videos for this location
    [_locationLatestImageView setCaching:YES];
    
    //Set location detail items to display
    [self setLocationDetailItems];
    
    //initialize variables
    uiAdjustedForNotificationSetting = NO;
    
    //initialize gesture recognizer
    expandImageGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enlargeButtonTapped:)];
    expandImageGesture.numberOfTapsRequired = 1;
    
    [_locationLatestImageView addGestureRecognizer:expandImageGesture];
    
    
    UITapGestureRecognizer *tapRegister = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedMessageLink:)];
    [self.messageLabel addGestureRecognizer:tapRegister];
    self.messageLabel.userInteractionEnabled = YES;
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.locationID && self.providerID){
        /*self.locationID = self.locationInformation.locationID;
        self.providerID = self.locationInformation.providerID;*/
        [self loadLocationDataWithLocationId:self.locationID providerId:self.providerID];
    }
}
- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setStreamingCountLabel:nil];
    [self setMonkeyCountLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UINavBar Button Tap method
- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //No Rows if there is no location information
    if(!self.locationInformation && section == 0){
        return 1;
    }
    
    NSUInteger rowCount = 0;
    if(section == 0){
        rowCount = self.locationCellData.count;
    }else if(section == 1){
        
        // Row for "Add to Favorites
        rowCount  = 1; 
    }
    
    return rowCount;
    
}
-(void)loadCellData{
    NSMutableArray *cellData = [NSMutableArray array];
    
    if(_locationInformation.phoneNumber && _locationInformation.phoneNumber !=(id)[NSNull null]){
        MMlocationDetailCellData *phoneData = [[MMlocationDetailCellData alloc] init];
        phoneData.text = _locationInformation.phoneNumber;
        phoneData.cellType = LocationCellTypePhoneNumber;
        phoneData.image = [UIImage imageNamed:@"telephone"];
        [cellData addObject:phoneData];
    }
    
    NSString *addressString = [_locationInformation formattedAddressString];
    if(addressString){
        MMlocationDetailCellData *addressData = [[MMlocationDetailCellData alloc] init];
        addressData.text = addressString;
        addressData.cellType = LocationCellTypeAddressBOOL;
        addressData.image = [UIImage imageNamed:@"mapPin"];
        [cellData addObject:addressData];
        
    }
    
    MMlocationDetailCellData *notifcationsData = [[MMlocationDetailCellData alloc] init];
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
        
        MMlocationDetailCellData *cellData = [self.locationCellData objectAtIndex:indexPath.row];
        cell.imageView.image = cellData.image;
        cell.textLabel.text = cellData.text;
        
        if(cellData.cellType == LocationCellTypeAddressBOOL){
            cell.textLabel.numberOfLines = 2;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if(cellData.cellType == LocationCellTypeNotification){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else if (indexPath.section == 1) {
        cell.textLabel.text = @"Add to Favorites";
        if (_locationInformation.isBookmark) {
            cell.textLabel.text = @"Remove from Favorites";
        }
        cell.imageView.image = [UIImage imageNamed:@"favorite"];
        return cell;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self bookmarkButtonTapped:nil];
        return;
    }
    if(indexPath.section == 0){
        
        MMlocationDetailCellData *cellData = [self.locationCellData objectAtIndex:indexPath.row];
        
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
    }
    
}
- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        MMlocationDetailCellData *cellData = [self.locationCellData objectAtIndex:indexPath.row];

        if(cellData.cellType == LocationCellTypeAddressBOOL){
            return 65;
        }
        
    }
        
    return 44;
}

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
- (IBAction)videoMediaButtonTapped:(id)sender {
    
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

- (IBAction)phoneNumberButtonTapped:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"tel:%@", _phoneNumberLabel.text];
    NSString *escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", escaped);
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:escaped]];
}
- (IBAction)addressButtonTapped:(id)sender {
    MMMapViewController *mmmVc = [[MMMapViewController alloc]initWithNibName:@"MMMapViewController" bundle:nil];
    mmmVc.address = [self.locationInformation formattedAddressString];
    mmmVc.contentList = @[mmmVc.address];
    [self.navigationController pushViewController:mmmVc animated:YES];
    UIViewController *mapViewController = [[UIViewController alloc] init];
    UIView *view = mapViewController.view;
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:view.frame];
    [mapView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [view addSubview:mapView];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.locationInformation.latitude.floatValue;
    coordinate.longitude = self.locationInformation.longitude.floatValue;
    id annotation = [[MMLocationAnnotation alloc] initWithName:self.locationInformation.name address:[self.locationInformation formattedAddressString] coordinate:coordinate arrayIndex:0];
    [mapView addAnnotation:annotation];
}

- (IBAction)notificationSettingsButtonTapped:(id)sender {
    MMNotificationSettingsViewController *noticiationSettingsVC = [[MMNotificationSettingsViewController alloc]initWithNibName:@"MMNotificationSettingsViewController" bundle:nil];
    noticiationSettingsVC.delegate = self;
    [self.navigationController pushViewController:noticiationSettingsVC animated:YES];
}

- (IBAction)shareButtonTapped:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    BOOL isVideo = NO;
    [params setValue:_locationNameLabel.text forKey:@"initialText"];
    if (mediaArray.count > 0) {
        if ([[[mediaArray objectAtIndex:0]valueForKey:@"type"]isEqualToString:@"video"]) {
            [params setValue:[[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"] forKey:@"url"];
            isVideo = YES;
        }
        else {
            [params setValue:_locationLatestImageView.image forKey:@"image"];
        }
    }
    if (![self.locationInformation.website isKindOfClass:[NSNull class]] && ![self.locationInformation.website isEqualToString:@""] && !isVideo) {
        [params setValue:self.locationInformation.website forKey:@"url"];
    }
    
    [[MMClientSDK sharedSDK]showMoreActionSheet:self showFromTabBar:YES paramsForPublishingToSocialNetwork:params];
    /*UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs boolForKey:@"facebookEnabled"]) {
        [actionSheet addButtonWithTitle:@"Share on Facebook"];
    }
    if ([prefs boolForKey:@"twitterEnabled"]) {
        [actionSheet addButtonWithTitle:@"Share on Twitter"];
    }
    [actionSheet addButtonWithTitle:@"Flag for Review"];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];*/
}

- (void)enlargeButtonTapped:(id)sender {
    if (mediaArray.count > 0) {
        if ([[[mediaArray objectAtIndex:0]valueForKey:@"type"]isEqualToString:@"video"] || [[[mediaArray objectAtIndex:0]valueForKey:@"type"]isEqualToString:@"livestreaming"]) {
            NSURL *url = [NSURL URLWithString:[[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"]];
            _player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
            [self.navigationController presentMoviePlayerViewControllerAnimated:_player];
        }
        else {
            [[MMClientSDK sharedSDK] inboxFullScreenImageScreen:self imageToDisplay:_locationLatestImageView.image locationName:self.title];
        }
    }
}

- (IBAction)flagButtonTapped:(id)sender {
        
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
- (IBAction)clearNotificationSettingButtonTapped:(id)sender {
    uiAdjustedForNotificationSetting = NO;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationDelegate: self];
    [_notificationSettingView setHidden:YES];
    [_bookmarkView setFrame:CGRectMake(_bookmarkView.frame.origin.x, _bookmarkView.frame.origin.y - 46, _bookmarkView.frame.size.width, _bookmarkView.frame.size.height)];
    [UIView commitAnimations];
}
-(void)pressedMessageLink:(id)sender{
    if(self.locationInformation.messageURL && ![self.locationInformation.messageURL isKindOfClass:[NSNull class]]){
        [self openURL: self.locationInformation.messageURL];
    }
}

#pragma mark - Action Sheet Delegate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Share on Facebook"]) {
            [self publishStoryToFacebook];
    }
    else if ([buttonTitle isEqualToString:@"Share on Twitter"]) {
        [self publishOnTwitter];
    }
    else if ([buttonTitle isEqualToString:@"Flag for Review"]) {
        
    }

}

#pragma mark - MMNotificationSettings delegate methods
- (void)selectedSetting:(id)selectedNotificationSetting {
    [_notificationSettingLabel setHidden:NO];
    [_notificationSettingView setHidden:NO];
    
    if (!uiAdjustedForNotificationSetting) {
        uiAdjustedForNotificationSetting = YES;
        [_bookmarkView setFrame:CGRectMake(_bookmarkView.frame.origin.x, _bookmarkView.frame.origin.y + 46, _bookmarkView.frame.size.width, _bookmarkView.frame.size.height)];
    }
}

#pragma mark - Helper Methods
- (void)setLocationDetailItems {
    
    if(self.locationInformation.name && [self.locationInformation.name length] > 0){
        self.title = self.locationInformation.name;
    }
    
    _locationNameLabel.text = self.title;
    _phoneNumberLabel.text = self.locationInformation.phoneNumber;
    _addressLabel.text = [self.locationInformation formattedAddressString];
    //NSLog(@"%@", _contentList);
    NSString *message = self.locationInformation.message;
    if (!message || [message isKindOfClass:[NSNull class]]) {
        message = @"Check out MobMonkey!";
    }
   
    _messageLabel.adjustsFontSizeToFitWidth = YES;
    _messageLabel.text = message;
    _mediaToolbarView.backgroundColor = [UIColor clearColor];
  
    
    [_liveStreamButton setEnabled:YES];
    [liveStreamImage setImage:[UIImage imageNamed:@"location-liveVideoIcn"]];
    [_videosButton setEnabled:YES];
    [_photosButton setEnabled:YES];
  
    int streamingCount = [self.locationInformation.livestreaming intValue];
    if (streamingCount == 0) {
        self.streamingCountLabel.hidden = YES;
        [_liveStreamButton setEnabled:NO];
        [liveStreamImage setImage:[UIImage imageNamed:@"location-liveVideoIcnOff"]];
    }
    else {
        self.streamingCountLabel.hidden = NO;
        self.streamingCountLabel.text = [NSString stringWithFormat:@"%d", streamingCount];
    }
    
    int videoCount = [self.locationInformation.videos intValue];
    if (videoCount == 0) {
        self.videoCountLabel.hidden = YES;
        [self.videosButton setEnabled:NO];
        
    } else {
        self.videoCountLabel.hidden = NO;
        self.videoCountLabel.text = [NSString stringWithFormat:@"%d", videoCount];
    }
  
    int photoCount = [self.locationInformation.images intValue];
    if (photoCount == 0) {
        self.photoCountLabel.hidden = YES;
        [self.photosButton setEnabled:NO];
        
    }
    else {
        self.photoCountLabel.hidden = NO;
        self.photoCountLabel.text = [NSString stringWithFormat:@"%d", photoCount];
    }
  
  int monkeyCount = [self.locationInformation.monkeys intValue];
    if (monkeyCount == 0) {
        _monkeyCountLabel.text = @"No members found";
        
    }
    else if (monkeyCount == 1) {
        _monkeyCountLabel.text = @"1 member found";
    }
    else {
        self.monkeyCountLabel.text = [NSString stringWithFormat:@"%d members found", monkeyCount];
    }
}

- (void)loadLocationDataWithLocationId:(NSString*)locationId providerId:(NSString*)providerId {
    
#warning THIS IS HARD CODED, NEEDS TO BE REMOVED
   /* locationId = @"5d44fab0-6f4f-4fe7-8351-aa4fb695d764";
    providerId = @"e048acf0-9e61-4794-b901-6a4bb49c3181";
    self.locationInformation.locationID = locationId;
    self.locationInformation.providerID = providerId;*/
    
    
    [SVProgressHUD showWithStatus:@"Loading"];
    
   
    [MMAPI getLocationWithID:locationId providerID:providerId success:^(AFHTTPRequestOperation *operation, MMLocationInformation *locationInformation) {
        
        [SVProgressHUD dismiss];
        self.locationInformation = locationInformation;
        [self setLocationDetailItems];
        [self fetchLatestMediaForLocation];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(operation.response.statusCode == 401){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm Email Address" message:@"Please check your email and confirm the registration." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
        
        NSLog(@"Failed: %@", error);
    }];
    
}

- (void)fetchLatestMediaForLocation {
    [MMAPI getMediaForLocationID:self.locationInformation.locationID providerID:self.locationInformation.providerID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        mediaArray = [responseObject valueForKey:@"media"];
        if (mediaArray.count > 0) {
            [_uploadDateLabel setHidden:NO];
            [_clockImageView setHidden:NO];
            double unixTime = [[[mediaArray objectAtIndex:0]valueForKey:@"uploadedDate"] floatValue]/1000;
            NSDate *dateAnswered = [NSDate dateWithTimeIntervalSince1970:
                                    (NSTimeInterval)unixTime];
            
            _uploadDateLabel.text = [GetRelativeTime getRelativeTime:dateAnswered];
            
            NSString *mediaUrl = [[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"];
            if ([[[mediaArray objectAtIndex:0]valueForKey:@"type"]isEqualToString:@"image"]) {
                [_locationLatestImageView reloadWithUrl:mediaUrl];
            }
            else if ([[[mediaArray objectAtIndex:0]valueForKey:@"type"]isEqualToString:@"livestreaming"]) {
                _locationLatestImageView.image = [UIImage imageNamed:@"liveFeedPlaceholder"];
                [playButtonImageView setHidden:NO];
            }
            else {
                [playButtonImageView setHidden:NO];
                dispatch_async(backgroundQueue, ^(void) {
                    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:[[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"]] options:nil];
                    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                    generate.appliesPreferredTrackTransform = YES;
                    NSError *err = NULL;
                    CMTime time = CMTimeMake(0, 60);
                    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        _locationLatestImageView.image =  [UIImage imageWithCGImage:imgRef];
                    });
                });
                
            }
            
            [self resizeTableView];
            [_mediaView setHidden:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", operation.responseString);
    }];

}

-(void)resizeTableView {
    [_makeRequestButton setFrame:CGRectMake(9, 349, 302, 66)];
    [_makeRequestLabel setFrame:CGRectMake(10, 361, 300, 21)];
    [_numberOfPeopleLabel setFrame:CGRectMake(10, 380, 300, 22)];
    [_tableView setFrame:CGRectMake(0, 427,320, 440)];
}
- (void)publishStoryToFacebook
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    BOOL isVideo = NO;
    [params setValue:_locationNameLabel.text forKey:@"initialText"];
    if (mediaArray.count > 0) {
        if ([[[mediaArray objectAtIndex:0]valueForKey:@"type"]isEqualToString:@"video"]) {
            [params setValue:[[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"] forKey:@"url"];
            isVideo = YES;
        }
        else {
            [params setValue:_locationLatestImageView.image forKey:@"image"];
        }
    }
    if (![self.locationInformation.website isKindOfClass:[NSNull class]] && ![self.locationInformation.website isEqualToString:@""] && !isVideo) {
        [params setValue:self.locationInformation.website forKey:@"url"];
    }
    
    [[MMClientSDK sharedSDK]shareViaFacebook:params presentingViewController:self];
}

- (void)publishOnTwitter {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    BOOL isVideo = NO;
    [params setValue:_locationNameLabel.text forKey:@"initialText"];
    if (mediaArray.count > 0) {
        if ([[[mediaArray objectAtIndex:0]valueForKey:@"type"]isEqualToString:@"video"]) {
            [params setValue:[[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"] forKey:@"url"];
            isVideo = YES;
        }
        else {
            [params setValue:_locationLatestImageView.image forKey:@"image"];
        }
    }
    if (![self.locationInformation.website isKindOfClass:[NSNull class]] && ![self.locationInformation.website isEqualToString:@""] && !isVideo) {
        [params setValue:self.locationInformation.website forKey:@"url"];
    }
    
    [[MMClientSDK sharedSDK]shareViaTwitter:params presentingViewController:self];
}

-(void)openURL:(NSURL*)url{
    BrowserViewController *bvc = [[BrowserViewController alloc] initWithUrls:url];
    [self.navigationController pushViewController:bvc animated:YES];
    
}

@end
