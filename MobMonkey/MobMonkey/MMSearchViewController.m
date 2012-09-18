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
#import "MMAPI.h"

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

        
        [self setContentList:[[MMAPI sharedAPI]retrieveCategories]];
    }
    
    _mapNavBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mapNavBarButton setFrame:CGRectMake(0, 0, 33, 30)];
    [_mapNavBarButton setBackgroundImage:[UIImage imageNamed:@"GlobeBtn~iphone"] forState:UIControlStateNormal];
    [_mapNavBarButton addTarget:self action:@selector(mapButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc]initWithCustomView:_mapNavBarButton];
    self.navigationItem.rightBarButtonItem = mapButton;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return _contentList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_showCategories) {
        NSArray *sectionArray = [_contentList objectAtIndex:section];
        return sectionArray.count;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if (_showCategories) {
        NSArray *sectionArray = [_contentList objectAtIndex:indexPath.section];
        id contentForThisRow = [sectionArray objectAtIndex:indexPath.row];
        
        MMCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[MMCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.mmCategoryCellImageView.image = [UIImage imageNamed:@"monkey.jpg"];
        cell.mmCategoryTitleLabel.text = contentForThisRow;
        
        return cell;
    }
    else {
        MMSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[MMSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        
        // Configure the cell...
        //FOR TAP THRU SHOW MM ENABLED FOR EVERY OTHER CELL
        if (indexPath.section % 2 > 0) {
            cell.mmSearchCellMMEnabledIndicator.image = [UIImage imageNamed:@"monkey.jpg"];
        }
        cell.mmSearchCellLocationNameLabel.text = @"Nando's";
        cell.mmSearchCellAddressLabel.text = @"750 W. Baseline Rd. Tempe, AZ 85283";
        cell.mmSearchCellDistanceLabel.text = @"15 miles";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
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
    if (_showCategories) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSArray *sectionArray = [_contentList objectAtIndex:indexPath.section];
        id contentForThisRow = [sectionArray objectAtIndex:indexPath.row];
        
        MMSearchViewController *svc = [[MMSearchViewController alloc]initWithNibName:@"MMSearchViewController" bundle:nil];
        svc.showSearchResults = YES;
        svc.title = contentForThisRow;
        [self.navigationController pushViewController:svc animated:YES];
    }
    else {
        MMLocationViewController *locationVC = [[MMLocationViewController alloc]initWithNibName:@"MMLocationViewController" bundle:nil];
        //REPLACE WITH REAL LOCATION NAME
        locationVC.title = @"Nandos";
        [self.navigationController pushViewController:locationVC animated:YES];
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

#pragma mark - UITextField delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //TAP THROUGH CODE. DELETE WHEN COMMUNICATING WITH SERVER
    _contentList = [[NSMutableArray alloc]initWithCapacity:1];
    for (int i = 0; i < 20; i++) {
        [_contentList addObject:@""];
    }
    
    _showCategories = NO;
    
    [self.tableView reloadData];
    
    [textField resignFirstResponder];
    return YES;
}

@end
