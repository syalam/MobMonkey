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
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *cellBGImageView = [[UIImageView alloc]init];
    
    switch (indexPath.row) {
        case 0:
            [cell setFrame:CGRectMake(0, 0, 303, 44)];
            cellBGImageView.image = [UIImage imageNamed:@"roundedRectSmall"];
            [cell.contentView addSubview:cellBGImageView];
            cell.textLabel.text = [[PhoneNumberFormatter alloc]stringForObjectValue:@"4808675309"];
            break;
        case 1:
            cell.textLabel.numberOfLines = 2;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.text = @"750 W. Baseline Rd.\nTempe, AZ 85283";
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            NSString *urlString = @"tel:4808675309";
            NSString *escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@", escaped);
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:escaped]];
        }
            break;
        case 1: {
            MMMapViewController *mmmVc = [[MMMapViewController alloc]initWithNibName:@"MMMapViewController" bundle:nil];
            mmmVc.address = @"750 W. Baseline Rd. Tempe, AZ 85283";
            [self.navigationController pushViewController:mmmVc animated:YES];
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
        [[MMClientSDK sharedSDK]makeARequestScreen:self locationDetail:_contentList];
    }
    else {
        [[MMClientSDK sharedSDK]signInScreen:self];
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
        [_locationLatestImageView reloadWithUrl:[[mediaArray objectAtIndex:mediaArray.count - 1]valueForKey:@"mediaURL"]];
        _photoCountLabel.text = [NSString stringWithFormat:@"%d", mediaArray.count];
    }
}

- (void)MMAPICallFailed:(AFHTTPRequestOperation*)operation {
    NSLog(@"%d", operation.response.statusCode);
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
    NSLog(@"%@", response);
}

@end
