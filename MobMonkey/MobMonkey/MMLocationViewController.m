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

@interface MMLocationViewController ()


@end

@implementation MMLocationViewController

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
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor clearColor];
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 3 : 1;
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
    
    if (indexPath.section == 1) {
        cell.textLabel.text = @"Bookmark";
        if ([[_contentList valueForKey:@"bookmark"] boolValue]) {
            cell.textLabel.text = @"Remove Bookmark";
        }
        cell.imageView.image = [UIImage imageNamed:@"bookmark"];
        return cell;
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = [[PhoneNumberFormatter alloc] stringForObjectValue:[_contentList valueForKey:@"phoneNumber"]];
            cell.imageView.image = [UIImage imageNamed:@"telephone"];
            break;
        case 1:
            cell.textLabel.numberOfLines = 2;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@, %@ %@",
                                   [_contentList valueForKey:@"address"],
                                   [_contentList valueForKey:@"locality"],
                                   [_contentList valueForKey:@"region"],
                                   [_contentList valueForKey:@"postcode"]];
            cell.imageView.image = [UIImage imageNamed:@"mapPin"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case 2:
            cell.textLabel.text = @"Add Notifications";
            cell.imageView.image = [UIImage imageNamed:@"alarmClock"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableView Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self bookmarkButtonTapped:nil];
        return;
    }
    switch (indexPath.row) {
        case 0: {
            NSString *telNumber = [@"tel:" stringByAppendingString:[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]];
            telNumber = [telNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@", telNumber);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
        }
            break;
        case 1: {
            MMMapViewController *mapViewController = [[MMMapViewController alloc]initWithNibName:@"MMMapViewController" bundle:nil];
            mapViewController.title = [_contentList valueForKey:@"name"];
            mapViewController.contentList = [NSArray arrayWithObject:_contentList];
            [self.navigationController pushViewController:mapViewController animated:YES];
            break;
        }
        case 2: {
            [self notificationSettingsButtonTapped:nil];
            break;
        }
        default:
            break;
    }
   
}
- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:
            return 88;
            break;
        default:
            return 44;
            break;
    }
}

#pragma mark - IBAction Methods
- (IBAction)mediaButtonTapped:(id)sender
{
  switch ([sender tag]) {
    case MMLiveCameraMediaType:
      if ([[[self.contentList valueForKey:@"livestreaming"] description] intValue] == 0)
        return;
      
      break;
      
    case MMVideoMediaType:
      if ([[[self.contentList valueForKey:@"videos"] description] intValue] == 0)
        return;
      
      break;
      
    case MMPhotoMediaType:
      if ([[[self.contentList valueForKey:@"images"] description] intValue] == 0)
        return;

      break;
      
    default:
      break;
  }

    MMLocationMediaViewController *lmvc = [[MMLocationMediaViewController alloc] initWithNibName:@"MMLocationMediaViewController" bundle:nil];
    lmvc.location = self.contentList;
    lmvc.title = self.title;
    lmvc.providerId = [_contentList valueForKey:@"providerId"];
    lmvc.locationId = [_contentList valueForKey:@"locationId"];
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
        [requestVC setContentList:self.contentList];
        [self.navigationController presentViewController:navVC animated:YES completion:nil];
        /*if ([[NSUserDefaults standardUserDefaults]boolForKey:@"subscribedUser"]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Request" bundle:nil];
            UINavigationController *navVC = [storyboard instantiateInitialViewController];
            MMRequestViewController *requestVC = (MMRequestViewController *)navVC.viewControllers[0];
            [requestVC setContentList:self.contentList];
            [self.navigationController presentViewController:navVC animated:YES completion:nil];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Sign up for MobMonkey to see whats happening now!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Subscribe", nil];
            [alert show];
        }*/
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
    mmmVc.address = [NSString stringWithFormat:@"%@ %@, %@ %@", [_contentList valueForKey:@"address"], [_contentList valueForKey:@"locality"], [_contentList valueForKey:@"region"], [_contentList valueForKey:@"postcode"]];
    mmmVc.contentList = @[mmmVc.address];
    [self.navigationController pushViewController:mmmVc animated:YES];
    UIViewController *mapViewController = [[UIViewController alloc] init];
    UIView *view = mapViewController.view;
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:view.frame];
    [mapView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [view addSubview:mapView];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[_contentList valueForKey:@"latitude"] floatValue];
    coordinate.longitude = [[_contentList valueForKey:@"longitude"] floatValue];
    id annotation = [[MMLocationAnnotation alloc] initWithName:[_contentList valueForKey:@"name"] address:[_contentList valueForKey:@"address"] coordinate:coordinate arrayIndex:0];
    [mapView addAnnotation:annotation];
}

- (IBAction)notificationSettingsButtonTapped:(id)sender {
    MMNotificationSettingsViewController *noticiationSettingsVC = [[MMNotificationSettingsViewController alloc]initWithNibName:@"MMNotificationSettingsViewController" bundle:nil];
    noticiationSettingsVC.delegate = self;
    [self.navigationController pushViewController:noticiationSettingsVC animated:YES];
}

- (IBAction)shareButtonTapped:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs boolForKey:@"facebookEnabled"]) {
        [actionSheet addButtonWithTitle:@"Share on Facebook"];
    }
    if ([prefs boolForKey:@"twitterEnabled"]) {
        [actionSheet addButtonWithTitle:@"Share on Twitter"];
    }
    [actionSheet addButtonWithTitle:@"Flag for Review"];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
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
    _contentList = [_contentList mutableCopy];
    if ([[_contentList valueForKey:@"bookmark"] boolValue]) {
        [_contentList setValue:[NSNumber numberWithBool:NO] forKey:@"bookmark"];
        [self.tableView reloadData];
        [MMAPI deleteBookmarkWithLocationID:[_contentList valueForKey:@"locationId"] providerID:[_contentList valueForKey:@"providerId"] success:^(id responseObject) {
            NSLog(@"Removed bookmark");
        } failure:^(NSError *error) {
            NSLog(@"Could not remove! %@", [error description]);
        }];
        return;
    }
    [_contentList setValue:[NSNumber numberWithBool:YES] forKey:@"bookmark"];
    [self.tableView reloadData];
    [MMAPI createBookmarkWithLocationID:[_contentList valueForKey:@"locationId"] providerID:[_contentList valueForKey:@"providerId"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    self.title = [_contentList valueForKey:@"name"];
    _locationNameLabel.text = self.title;
    _phoneNumberLabel.text = [_contentList valueForKey:@"phoneNumber"];
    _addressLabel.text = [NSString stringWithFormat:@"%@\n%@, %@ %@", [_contentList valueForKey:@"streetAddress"], [_contentList valueForKey:@"locality"], [_contentList valueForKey:@"region"], [_contentList valueForKey:@"postcode"]];
    NSLog(@"%@", _contentList);
    NSString *message = [_contentList valueForKey:@"message"];
    if (![message isKindOfClass:[NSNull class]]) {
        _messageLabel.adjustsFontSizeToFitWidth = YES;
        _messageLabel.text = [_contentList valueForKey:@"message"];
        _mediaToolbarView.backgroundColor = [UIColor clearColor];
    }
   
  
    
    [_liveStreamButton setEnabled:YES];
    [liveStreamImage setImage:[UIImage imageNamed:@"location-liveVideoIcn"]];
    [_videosButton setEnabled:YES];
    [_photosButton setEnabled:YES];
  
    int streamingCount = [[self.contentList valueForKey:@"livestreaming"] intValue];
    if (streamingCount == 0) {
        self.streamingCountLabel.hidden = YES;
        [_liveStreamButton setEnabled:NO];
        [liveStreamImage setImage:[UIImage imageNamed:@"location-liveVideoIcnOff"]];
    }
    else {
        self.streamingCountLabel.hidden = NO;
        self.streamingCountLabel.text = [NSString stringWithFormat:@"%d", streamingCount];
    }
    
    int videoCount = [[self.contentList valueForKey:@"videos"] intValue];
    if (videoCount == 0) {
        self.videoCountLabel.hidden = YES;
        [self.videosButton setEnabled:NO];
        
    } else {
        self.videoCountLabel.hidden = NO;
        self.videoCountLabel.text = [NSString stringWithFormat:@"%d", videoCount];
    }
  
    int photoCount = [[self.contentList valueForKey:@"images"] intValue];
    if (photoCount == 0) {
        self.photoCountLabel.hidden = YES;
        [self.photosButton setEnabled:NO];
        
    }
    else {
        self.photoCountLabel.hidden = NO;
        self.photoCountLabel.text = [NSString stringWithFormat:@"%d", photoCount];
    }
  
  int monkeyCount = [[self.contentList valueForKey:@"monkeys"] intValue];
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
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            locationId, @"locationId",
                            providerId, @"providerId", nil];
    [SVProgressHUD showWithStatus:@"Loading location information"];
    [MMAPI getLocationInfo:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [self setContentList:responseObject];
        [self setLocationDetailItems];
        [self fetchLatestMediaForLocation];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
        [SVProgressHUD showErrorWithStatus:@"Unable to load location data"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)fetchLatestMediaForLocation {
    [MMAPI getMediaForLocationID:[_contentList valueForKey:@"locationId"] providerID:[_contentList valueForKey:@"providerId"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            else {
                /*dispatch_async(backgroundQueue, ^(void) {
                    
                });*/
                AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:[[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"]] options:nil];
                AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                generate.appliesPreferredTrackTransform = YES;
                NSError *err = NULL;
                CMTime time = CMTimeMake(0, 60);
                CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
                _locationLatestImageView.image =  [UIImage imageWithCGImage:imgRef];
            }
            [_makeRequestButton setFrame:CGRectMake(9, 349, 302, 66)];
            [_makeRequestLabel setFrame:CGRectMake(10, 361, 300, 21)];
            [_numberOfPeopleLabel setFrame:CGRectMake(10, 380, 300, 22)];
            [_tableView setFrame:CGRectMake(0, 427,320, 440)];
            [_mediaView setHidden:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
    }];

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
    if (![[_contentList valueForKey:@"webSite"] isKindOfClass:[NSNull class]] && ![[_contentList valueForKey:@"webSite"]isEqualToString:@""] && !isVideo) {
        [params setValue:[_contentList valueForKey:@"webSite"] forKey:@"url"];
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
    if (![[_contentList valueForKey:@"webSite"] isKindOfClass:[NSNull class]] && ![[_contentList valueForKey:@"webSite"]isEqualToString:@""] && !isVideo) {
        [params setValue:[_contentList valueForKey:@"webSite"] forKey:@"url"];
    }
    
    [[MMClientSDK sharedSDK]shareViaTwitter:params presentingViewController:self];
}



@end
