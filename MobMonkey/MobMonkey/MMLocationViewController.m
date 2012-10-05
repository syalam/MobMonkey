//
//  MMLocationViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/2/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMLocationViewController.h"
#import "MMRequestViewController.h"
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
    [_scrollView setContentSize:CGSizeMake(320, 740)];
    
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
    
    
    //Add custom bookmark button to the nav bar
    UIButton *bookmarkNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [bookmarkNavbutton addTarget:self action:@selector(bookmarkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [bookmarkNavbutton setBackgroundImage:[UIImage imageNamed:@"bookmarkBtn"] forState:UIControlStateNormal];
    
    UIBarButtonItem* bookmarkButton = [[UIBarButtonItem alloc]initWithCustomView:bookmarkNavbutton];
    self.navigationItem.rightBarButtonItem = bookmarkButton;
    
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
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)enlargeButtonTapped:(id)sender {
   /* MMFullScreenImageViewController *fullScreenVC = [[MMFullScreenImageViewController alloc]initWithNibName:@"MMFullScreenImageViewController" bundle:nil];
    fullScreenVC.imageToDisplay = _locationLatestImageView.image;
    fullScreenVC.rowIndex = self.rowIndex;
    UINavigationController *fullScreenNavC = [[UINavigationController alloc]initWithRootViewController:fullScreenVC];
    fullScreenNavC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:fullScreenNavC animated:YES completion:NULL];*/
}

- (IBAction)flagButtonTapped:(id)sender {
    /*if (![[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"row%dFlagged", self.rowIndex]]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:[NSString stringWithFormat:@"row%dFlagged", self.rowIndex]];
        [self.flagButton setBackgroundColor:[UIColor blueColor]];
    }
    else {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:[NSString stringWithFormat:@"row%dFlagged", self.rowIndex]];
        [self.flagButton setBackgroundColor:[UIColor clearColor]];
    }*/
    
}

- (IBAction)bookmarkButtonTapped:(id)sender {
    /*if (![[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"row%dBookmarked", self.rowIndex]]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:[NSString stringWithFormat:@"row%dBookmarked", self.rowIndex]];
        [self.bookmarkButton setTitle:@"Bookmark" forState:UIControlStateNormal];
    }
    else {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:[NSString stringWithFormat:@"row%dBookmarked", self.rowIndex]];
        [self.bookmarkButton setTitle:@"Unbookmark" forState:UIControlStateNormal];
    }*/
}

- (IBAction)clearNotificationSettingButtonTapped:(id)sender {
    [_notificationSettingView setHidden:YES];
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
