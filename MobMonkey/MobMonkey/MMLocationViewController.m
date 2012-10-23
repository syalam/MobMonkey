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
    
    //self.navigationItem.titleView = [[MMSetTitleImage alloc]setTitleImageView];
    
    //setup scrollview size
    [_scrollView setContentSize:CGSizeMake(320, 815)];
    
    //set background color
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background~iphone"]]];
    
    
    //set location name label text and font
    _locationNameLabel.textColor = [UIColor colorWithRed:.8941 green:.4509 blue:.1725 alpha:1];
    
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
    [self fetchMediaCounts];
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
                                   [_contentList valueForKey:@"streetAddress"],
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
            MMMapViewController *mmmVc = [[MMMapViewController alloc] initWithNibName:@"MMMapViewController" bundle:nil];
            mmmVc.address = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
            [self.navigationController pushViewController:mmmVc animated:YES];
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
- (IBAction)photoMediaButtonTapped:(id)sender {
    [[MMClientSDK sharedSDK]locationMediaScreen:self locationMediaContent:mediaArray locationName:self.title];
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
    mmmVc.address = [NSString stringWithFormat:@"%@ %@, %@ %@", [_contentList valueForKey:@"streetAddress"], [_contentList valueForKey:@"locality"], [_contentList valueForKey:@"region"], [_contentList valueForKey:@"postcode"]];
    [self.navigationController pushViewController:mmmVc animated:YES];
}

- (IBAction)notificationSettingsButtonTapped:(id)sender {
    MMNotificationSettingsViewController *noticiationSettingsVC = [[MMNotificationSettingsViewController alloc]initWithNibName:@"MMNotificationSettingsViewController" bundle:nil];
    noticiationSettingsVC.delegate = self;
    [self.navigationController pushViewController:noticiationSettingsVC animated:YES];
}

- (IBAction)shareButtonTapped:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", @"Flag for Review", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)enlargeButtonTapped:(id)sender {
    //will only expand image if an image is available
    if (mediaArray.count > 0) {
        [[MMClientSDK sharedSDK]inboxFullScreenImageScreen:self imageToDisplay:_locationLatestImageView.image locationName:self.title];
    }
    else {
        [[MMClientSDK sharedSDK]inboxFullScreenImageScreen:self imageToDisplay:[UIImage imageNamed:@"monkey.jpg"] locationName:self.title];
    }
}

- (IBAction)flagButtonTapped:(id)sender {
        
}

- (IBAction)bookmarkButtonTapped:(id)sender {
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
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            
            break;
        default:
            break;
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
}

- (void)fetchMediaCounts {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[_contentList valueForKey:@"providerId"] forKey:@"providerId"];
    [params setObject:[_contentList valueForKey:@"locationId"] forKey:@"locationId"];
    
    [MMAPI sharedAPI].delegate = self;
    [[MMAPI sharedAPI]fetchMediaCountsForLocation:params];
}

#pragma mark - MMAPI Delegate Methods
- (void)MMAPICallSuccessful:(id)response {
    NSLog(@"%@", response);
    
    mediaArray = response;
    if (mediaArray.count > 0) {
//        [_locationLatestImageView reloadWithUrl:[[mediaArray objectAtIndex:mediaArray.count - 1]valueForKey:@"mediaURL"]];
//        _photoCountLabel.text = [NSString stringWithFormat:@"%d", mediaArray.count];
    }
}

- (void)MMAPICallFailed:(AFHTTPRequestOperation*)operation {
    NSLog(@"%d", operation.response.statusCode);
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
    NSLog(@"%@", response);
}

@end
