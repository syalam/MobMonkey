//
//  MMSearchViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/2/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMSearchViewController.h"
#import "MMLocationViewController.h"
#import "MMFullScreenImageViewController.h"
#import "MMResultCell.h"
#import "MMSetTitleImage.h"
#import "MMMapViewController.h"
#import "MMCategoryViewController.h"
#import "MMUtilities.h"
#import "MMClientSDK.h"
#import "SVProgressHUD.h"

@interface MMSearchViewController ()

@end

@implementation MMSearchViewController

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

    //self.navigationItem.titleView = [[MMSetTitleImage alloc]setTitleImageView];
    
    _mapNavBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mapNavBarButton setFrame:CGRectMake(0, 0, 33, 30)];
    [_mapNavBarButton setBackgroundImage:[UIImage imageNamed:@"GlobeBtn~iphone"] forState:UIControlStateNormal];
    [_mapNavBarButton addTarget:self action:@selector(mapButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc]initWithCustomView:_mapNavBarButton];
    self.navigationItem.rightBarButtonItem = mapButton;
    
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setEnabled:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_showSearchResults) {
        //hide search textfield
        [headerView setFrame:CGRectMake(0, 0, 320, 0)];
        [headerView setClipsToBounds:YES];
        self.tableView.tableHeaderView = headerView;
        
        
        //Add custom back button to the nav bar
        UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
        [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
        
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
        self.navigationItem.leftBarButtonItem = backButton;
        
        
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < 20; i++) {
            [resultArray addObject:@""];
        }
        [self setContentList:resultArray];
        [self.tableView reloadData];
    }
    else {
        _showCategories = YES;
        
        _filterNavBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_filterNavBarButton setFrame:CGRectMake(0, 0, 52, 30)];
        [_filterNavBarButton setBackgroundImage:[UIImage imageNamed:@"FilterBtn~iphone"] forState:UIControlStateNormal];
        [_filterNavBarButton addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *filterButton = [[UIBarButtonItem alloc]initWithCustomView:_filterNavBarButton];
        self.navigationItem.leftBarButtonItem = filterButton;
        
        [SVProgressHUD showWithStatus:@"Loading Categories"];
        currentAPICall = kAPICallGetCategoryList;
        [MMAPI sharedAPI].delegate = self;
        [[MMAPI sharedAPI]categories];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (_showCategories) {
        return _contentList.count;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_showCategories) {
        NSArray *sectionArray = [_contentList objectAtIndex:section];
        return sectionArray.count;
    }
    else {
        return _contentList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *SearchCellIdentifier = @"SearchCell";
    if (_showCategories) {
        NSArray *sectionArray = [_contentList objectAtIndex:indexPath.section];
        id contentForThisRow = [sectionArray objectAtIndex:indexPath.row];
        
        MMCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MMCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.mmCategoryCellImageView.image = [UIImage imageNamed:@"monkey.jpg"];
        if (indexPath.section == 0) {
            cell.mmCategoryTitleLabel.text = [contentForThisRow valueForKey:@"name"];
        }
        else {
            cell.mmCategoryTitleLabel.text = contentForThisRow;
        }
        
        return cell;
    }
    else {
        id contentForThisRow = [_contentList objectAtIndex:indexPath.row];
        MMSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchCellIdentifier];
        if (!cell) {
            cell = [[MMSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchCellIdentifier];
            cell.delegate = self;
        }
        
        // Configure the cell...
        //FOR TAP THRU SHOW MM ENABLED FOR EVERY OTHER CELL
        if (indexPath.section % 2 > 0) {
            cell.mmSearchCellMMEnabledIndicator.image = [UIImage imageNamed:@"monkey.jpg"];
        }
        cell.mmSearchCellLocationNameLabel.text = [contentForThisRow valueForKey:@"name"];
        cell.mmSearchCellAddressLabel.text = [NSString stringWithFormat:@"%@, %@, %@ %@", [contentForThisRow valueForKey:@"streetAddress"], [contentForThisRow valueForKey:@"locality"], [contentForThisRow valueForKey:@"region"], [contentForThisRow valueForKey:@"postcode"]];
        float distance = [[MMUtilities sharedUtilities]calculateDistance:[contentForThisRow valueForKey:@"latitude"] longitude:[contentForThisRow valueForKey:@"longitude"]];
        cell.mmSearchCellDistanceLabel.text = [NSString stringWithFormat:@"%.2f miles", distance];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showCategories) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSArray *sectionArray = [_contentList objectAtIndex:indexPath.section];
        id contentForThisRow = [sectionArray objectAtIndex:indexPath.row];
        NSLog(@"%@", contentForThisRow);
        
        
        /*MMSearchViewController *svc = [[MMSearchViewController alloc]initWithNibName:@"MMSearchViewController" bundle:nil];
        svc.showSearchResults = YES;
        svc.title = contentForThisRow;
        [self.navigationController pushViewController:svc animated:YES];*/
    }
    else {
        [[MMClientSDK sharedSDK]locationScreen:self locationDetail:[_contentList objectAtIndex:indexPath.row]];
    }
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_showCategories) {
        return 44;
    }
    else {
        return 140;
    }
}

#pragma mark - search cell delegate methods
-(void)mmSearchCellViewLiveFeedButtonTapped:(id)sender {
    NSLog(@"%@", @"Live Feed Tapped");
}
-(void)mmSearchCellViewUploadedPhotoButtonTapped:(id)sender {
     NSLog(@"%@", @"ViewUploadedPhoto Tapped");
}
-(void)mmSearchCellViewUploadedVideoButtonTapped:(id)sender {
     NSLog(@"%@", @"ViewUploadedVideo Tapped");
}
    
-(void)mmSearchCellUploadPhotoButtonTapped:(id)sender {
     NSLog(@"%@", @"uploadPhoto Tapped");
}
-(void)mmSearchCellUploadVideoButtonTapped:(id)sender {
     NSLog(@"%@", @"uploadVideo Tapped");
}

#pragma mark - NavBar Button Action Methods
- (void)filterButtonClicked:(id)sender {
    MMFilterViewController *fvc = [[MMFilterViewController alloc]initWithNibName:@"MMFilterViewController" bundle:nil];
    fvc.delegate = self;
    fvc.title = @"Filter";
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:fvc];
    [self.navigationController presentViewController:navc animated:YES completion:NULL];
}

- (void)mapButtonClicked:(id)sender {
    MMMapViewController *mvc = [[MMMapViewController alloc]initWithNibName:@"MMMapViewController" bundle:nil];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:mvc];
    [self.navigationController presentViewController:nvc animated:YES completion:NULL];
}


- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Gesture recognizer methods
- (void)screenTapped:(id)sender {
    [_searchTextField resignFirstResponder];
    [tapGesture setEnabled:NO];
}

#pragma mark - UITextField delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [tapGesture setEnabled:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //TAP THROUGH CODE. DELETE WHEN COMMUNICATING WITH SERVER
    /*_contentList = [[NSMutableArray alloc]initWithCapacity:1];
    for (int i = 0; i < 20; i++) {
        [_contentList addObject:@""];
    }*/
    
    double latitude = [[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"]doubleValue];
    double longitude = [[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]doubleValue];
    NSLog(@"%f, %f", latitude, longitude);
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSNumber numberWithDouble:latitude]forKey:@"latitude"];
    [params setObject:[NSNumber numberWithDouble:longitude]forKey:@"longitude"];
    if ([filters valueForKey:@"radius"]) {
        [params setObject:[filters valueForKey:@"radius"] forKey:@"radiusInYards"];
    }
    else {
        [params setObject:[NSNumber numberWithInt:200] forKey:@"radiusInYards"];
    }
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSLog(@"%@", jsonObject);
    
    [SVProgressHUD showWithStatus:@"Searching"];
    currentAPICall = kAPICallLocationSearch;
    [MMAPI sharedAPI].delegate = self;
    [[MMAPI sharedAPI]searchForLocation:params];
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length == 1) {
        [self setCategoriesList];
        _showCategories = YES;
        [self.tableView reloadData];
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self setCategoriesList];
    _showCategories = YES;
    [self.tableView reloadData];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Search Filter Delegate
- (void)selectedFilters:(id)selectedFilters {
    filters = selectedFilters;
}

#pragma mark - Helper Methods
- (void)setCategoriesList {
    NSArray *sectionOneArray = categories;
    NSArray *sectionTwoArray = [[NSMutableArray alloc]initWithObjects:@"History", @"My Locations", @"Events", @"Locations of Interest", nil];
    
    [self setContentList:[NSArray arrayWithObjects:sectionOneArray, sectionTwoArray, nil]];
}

#pragma mark - MMAPI Delegate Methods
- (void)MMAPICallSuccessful:(id)response {
    [SVProgressHUD dismiss];
    switch (currentAPICall) {
        case kAPICallGetCategoryList: {
            categories = response;
            NSLog(@"%@", categories);
            [self setCategoriesList];
            [self.tableView reloadData];
        }
            break;
        case kAPICallLocationSearch:
            NSLog(@"%@", response);
            _showCategories = NO;
            searchResult = response;
            [self setContentList:[searchResult mutableCopy]];
            [self.tableView reloadData];
            [tapGesture setEnabled:NO];
            break;
        default:
            break;
    }
}
- (void)MMAPICallFailed:(AFHTTPRequestOperation*)operation {
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
    if ([response valueForKey:@"description"]) {
        NSString *responseString = [response valueForKey:@"description"];
        
        [SVProgressHUD dismissWithError:responseString];
    }
}

@end
