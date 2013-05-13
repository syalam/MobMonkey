//
//  MMLocationMediaViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/5/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMLocationMediaViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MMSubscriptionViewController.h"
#import "MMClientSDK.h"
#import "Constants.h"
#import "MMAppDelegate.h"
#import "GetRelativeTime.h"
#import "AdWhirlView.h"

@interface MMLocationMediaViewController ()
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayerViewController;

- (void)selectMediaType:(id)sender;

@end

@implementation MMLocationMediaViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    backgroundQueue = dispatch_queue_create("com.MobMonkey.GenerateThumbnailQueue", NULL);
    views = 0;
    //Add custom back button to the nav bar
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self.navigationController action:@selector(dismissModalViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Live Camera", @"Videos", @"Photos"]];
    [self.segmentedControl setTintColor:[UIColor colorWithRed:230.0/255.0 green:113.0/255.0 blue:34.0/255.0 alpha:1.0]];
    [self.segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [self.segmentedControl addTarget:self action:@selector(selectMediaType:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentedControl;
    
    _thumbnailCache = [[NSMutableDictionary alloc]init];
    
    showAd = NO;
    NSString *subscribedUserKey = [NSString stringWithFormat:@"%@ subscribed", [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:subscribedUserKey]) {
        self.myFullscreenAd = [[GSFullscreenAd alloc] initWithDelegate:self];
        [self.myFullscreenAd fetch];
    }
    
    [self.segmentedControl setSelectedSegmentIndex:self.mediaType];
    [self selectMediaType:self.segmentedControl];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.segmentedControl setSelectedSegmentIndex:self.mediaType];
    //[self selectMediaType:self.segmentedControl];
    NSString *subscribedUserKey = [NSString stringWithFormat:@"%@ subscribed", [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:subscribedUserKey]) {
        // Every 5th view will result in a pop-up ad on the client
        // After 5 views always show the subscription modal
        if (views >= 5 && !didShowModal) {
            // After 5 views always show the subscription modal
            didShowModal = YES;
            MMSubscriptionViewController *subscriptionViewController = [[MMSubscriptionViewController alloc] init];
            UINavigationController *subscriptionModal = [[UINavigationController alloc]initWithRootViewController:subscriptionViewController];
            [self.navigationController presentModalViewController:subscriptionModal animated:YES];
        }
        else if (views >= 10 && (views % 5) == 0 && !didShowAd) {
            didShowAd = YES;
            self.myFullscreenAd = [[GSFullscreenAd alloc] initWithDelegate:self];
            [self.myFullscreenAd fetch];
            
        }
        
    }

    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectMediaType:(id)sender
{
    //_mediaArray = nil;
    self.mediaType = [sender selectedSegmentIndex];
    [self.tableView reloadData];
    NSArray *mediaTypes = @[@"livestreaming", @"video", @"image"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type LIKE %@", mediaTypes[[sender selectedSegmentIndex]]];
    self.selectedMedia = [self.allMedia filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectedMedia.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MMLocationMediaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MMLocationMediaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    cell.locationImageView.image = nil;
    
    if (![[[self.selectedMedia objectAtIndex:indexPath.row] valueForKey:@"uploadedDate"] isKindOfClass:[NSNull class]]) {
        double unixTime = [[[self.selectedMedia objectAtIndex:indexPath.row] valueForKey:@"uploadedDate"] floatValue]/1000;
        NSDate *dateAnswered = [NSDate dateWithTimeIntervalSince1970:
                                (NSTimeInterval)unixTime];
        
        cell.timeStampLabel.text = [GetRelativeTime getRelativeTime:dateAnswered];
        [cell.timeStampLabel sizeToFit];
        [cell.timeStampLabel setFrame:CGRectMake(cell.frame.size.width - cell.timeStampLabel.frame.size.width - 20, cell.timeStampLabel.frame.origin.y, cell.timeStampLabel.frame.size.width, cell.timeStampLabel.frame.size.height)];
        [cell.clockImageView setFrame:CGRectMake(cell.timeStampLabel.frame.origin.x - 20, cell.clockImageView.frame.origin.y, cell.clockImageView.frame.size.width, cell.clockImageView.frame.size.height)];
    }
    
    if ([self.segmentedControl selectedSegmentIndex] == MMPhotoMediaType) {
        [cell.locationImageView reloadWithUrl:[[self.selectedMedia objectAtIndex:indexPath.row] valueForKey:@"mediaURL"]];
        [cell.playButtonImageView setHidden:YES];
    }
    else if ([self.segmentedControl selectedSegmentIndex] == MMLiveCameraMediaType) {
        [cell.locationImageView setImage:[UIImage imageNamed:@"liveFeedPlaceholder"]];
        [cell.playButtonImageView setHidden:NO];
    }
    else {
        dispatch_async(backgroundQueue, ^(void) {
            cell.locationImageView.image =  [self generateThumbnailForVideo:indexPath.row cell:cell];
        });
        [cell.playButtonImageView setHidden:NO];
    }
    
    cell.imageButton.tag = indexPath.row;
    cell.moreButton.tag = indexPath.row;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (NSInteger)viewsThisMonth
{
    NSString *userViewsThisMonth = [NSString stringWithFormat:@"%@ viewsThisMonth", [[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    NSMutableArray *viewsArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:userViewsThisMonth]];
    
    NSDate * now = [NSDate date];
    NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:now];
    
    NSEnumerator *dateEnumerator = [viewsArray objectEnumerator];
    NSDate *date;
    NSInteger viewsThisMonth = 0;
    while (date = (NSDate*)[dateEnumerator nextObject]) {
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
        
        if ([dateComponents month] == [nowComponents month] && ([dateComponents year] == [nowComponents year])) {
            viewsThisMonth ++;
        }
        else {
            [viewsArray removeObject:date];
        }
    }
    
    [viewsArray addObject:now];
    
    [[NSUserDefaults standardUserDefaults] setObject:viewsArray forKey:userViewsThisMonth];
    
    return viewsThisMonth;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 317;
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - Helper Methods
- (UIImage*)generateThumbnailForVideo:(int)row cell:(MMLocationMediaCell*)cell {
    UIImage *thumbnailImage;
  
    if ([_thumbnailCache valueForKey:[NSString stringWithFormat:@"%d", row]]) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            cell.locationImageView.image = [_thumbnailCache valueForKey:[NSString stringWithFormat:@"%d", row]];
        });
    }
    else {
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:[[self.selectedMedia objectAtIndex:row] valueForKey:@"mediaURL"]] options:nil];
        AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generate.appliesPreferredTrackTransform = YES;
        NSError *err = NULL;
        CMTime time = CMTimeMake(0, 60);
        CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
        
        thumbnailImage = [UIImage imageWithCGImage:imgRef];
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [_thumbnailCache setValue:thumbnailImage forKey:[NSString stringWithFormat:@"%d", row]];
            cell.locationImageView.image = thumbnailImage;
        });
    }
    
    return thumbnailImage;
}

#pragma mark - Greystripe Protocol methods

- (NSString *)greystripeGUID {
    NSLog(@"Accessing GUID");
    
    // The Greystripe GUID is defined in Constants.h and preloaded in GSSDKDemo-Prefix.pch in this example
    // Alternate example: You can also set the Greystripe GUID in the AppDelegate.m as well
    return GSGUID;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    [textView resignFirstResponder];
}

- (void)greystripeAdFetchSucceeded:(id<GSAd>)a_ad {
    if (a_ad == _myFullscreenAd) {
        if (showAd) {
            NSLog(@"Fullscreen ad successfully fetched.");
            [_myFullscreenAd displayFromViewController:self];

        } else {
            showAd = YES;
        }
    }
}

- (void)greystripeAdFetchFailed:(id<GSAd>)a_ad withError:(GSAdError)a_error {
    NSString *errorString =  @"";
    
    switch(a_error) {
        case kGSNoNetwork:
            errorString = @"Error: No network connection available.";
            break;
        case kGSNoAd:
            errorString = @"Error: No ad available from server.";
            break;
        case kGSTimeout:
            errorString = @"Error: Fetch request timed out.";
            break;
        case kGSServerError:
            errorString = @"Error: Greystripe returned a server error.";
            break;
        case kGSInvalidApplicationIdentifier:
            errorString = @"Error: Invalid or missing application identifier.";
            break;
        case kGSAdExpired:
            errorString = @"Error: Previously fetched ad expired.";
            break;
        case kGSFetchLimitExceeded:
            errorString = @"Error: Too many requests too quickly.";
            break;
        case kGSUnknown:
            errorString = @"Error: An unknown error has occurred.";
            break;
        default:
            errorString = @"An invalid error code was returned. Thats really bad!";
    }
    NSLog(@"Greystripe failed with error: %@",errorString);
    showAd = YES;
    
}

- (void)greystripeAdClickedThrough:(id<GSAd>)a_ad {
    NSLog(@"Greystripe ad was clicked.");
}
- (void)greystripeWillPresentModalViewController {
    MMAppDelegate* appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.adView removeFromSuperview];
    NSLog(@"Greystripe opening fullscreen.");
}
- (void)greystripeDidDismissModalViewController {
    MMAppDelegate* appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window.rootViewController.view addSubview:appDelegate.adView];
    NSLog(@"Greystripe closed fullscreen.");
}

#pragma mark - MMLocationMediaCell delegate
-(void)moreButtonTapped:(id)sender {
    selectedRow = [sender tag];
    
    MMLocationMediaCell *cell = (MMLocationMediaCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:_locationName forKey:@"initialText"];
    if ([self.segmentedControl selectedSegmentIndex] != MMPhotoMediaType) {
        [params setValue:[[self.selectedMedia objectAtIndex:selectedRow] valueForKey:@"mediaURL"] forKey:@"url"];
    }
    else {
        [params setValue:cell.locationImageView.image forKey:@"image"];
    }
    
     [[MMClientSDK sharedSDK]showMoreActionSheet:self showFromTabBar:NO paramsForPublishingToSocialNetwork:params];
    
    /*UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", @"Flag for Review", nil];
    [actionSheet showInView:self.view];*/
}
-(void)imageButtonTapped:(id)sender {
    MMLocationMediaCell *cell = (MMLocationMediaCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    didShowModal = NO;
    didShowAd = NO;
    NSString *urlString = [[self.selectedMedia objectAtIndex:[sender tag]] valueForKey:@"mediaURL"];
    
    NSString *newURL = [urlString stringByReplacingOccurrencesOfString:@"http" withString:@"rtmp"];
    newURL = [newURL stringByReplacingOccurrencesOfString:@".com" withString:@".com:1935"];
    
    NSInteger viewsThisMonth = 0;
    viewsThisMonth = [self viewsThisMonth];
    views = viewsThisMonth;
    NSLog(@"viewsThisMonth: %i", viewsThisMonth);
    
    if ([self.segmentedControl selectedSegmentIndex] != MMPhotoMediaType) {
        
        UIGraphicsBeginImageContext(CGSizeMake(1,1));
        self.moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:newURL]];
        UIGraphicsEndImageContext();
        [self.navigationController presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];
    } else {
        [[MMClientSDK sharedSDK] inboxFullScreenImageScreen:self imageToDisplay:cell.locationImageView.image locationName:nil];
    }
}

#pragma mark - Helper Methods
- (void)publishStoryToFacebook
{
    MMLocationMediaCell *cell = (MMLocationMediaCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    //BOOL isVideo = NO;
    //NSArray *mediaArray  = [[self.mediaArray objectAtIndex:selectedRow]valueForKey:@"media"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:_locationName forKey:@"initialText"];
    if ([self.segmentedControl selectedSegmentIndex] != MMPhotoMediaType) {
        [params setValue:[[self.selectedMedia objectAtIndex:selectedRow] valueForKey:@"mediaURL"] forKey:@"url"];
    }
    else {
        [params setValue:cell.locationImageView.image forKey:@"image"];
    }
    
    [[MMClientSDK sharedSDK]shareViaFacebook:params presentingViewController:self];
}

- (void)publishOnTwitter {
    MMLocationMediaCell *cell = (MMLocationMediaCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    //BOOL isVideo = NO;
    //NSArray *mediaArray  = [[self.mediaArray objectAtIndex:selectedRow]valueForKey:@"media"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:_locationName forKey:@"initialText"];
    if ([self.segmentedControl selectedSegmentIndex] != MMPhotoMediaType) {
        [params setValue:[[self.selectedMedia objectAtIndex:selectedRow] valueForKey:@"mediaURL"] forKey:@"url"];
    }
    else {
        [params setValue:cell.locationImageView.image forKey:@"image"];
    }
    
    [[MMClientSDK sharedSDK]shareViaTwitter:params presentingViewController:self];
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

@end
