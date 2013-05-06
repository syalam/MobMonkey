//
//  MMHotSpotViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 4/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMHotSpotViewController.h"

#import "MMHotSpotHeaderView.h"
#import "MMLocationSearch.h"
#import "MMLocationInformation.h"
#import <QuartzCore/QuartzCore.h>
#import "MMCreateHotSpotViewController.h"
#import "MMLocationAnnotation.h"
#import "MMLocationsViewController.h"
#import "MMSearchViewController.h"
#import "MMLocationViewController.h"
#import "MMLocationSearch.h"
#import "MMLocationListCell.h"

@interface MMHotSpotViewController ()

@end

@implementation MMHotSpotViewController

@synthesize nearbyLocations;

//s@synthesize mapView = _mapView;

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
    loadFromServer = NO;
    

    
    
    headerView = [[MMHotSpotHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 137)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    headerView.layer.zPosition = 100;
    headerView.searchBar.delegate = self;
   
    [self.tableView addSubview:headerView];
    
    UIView *headerSpace = [[UIView alloc] initWithFrame:headerView.frame];
    [self.tableView setTableHeaderView:headerSpace];
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:headerView.searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    //[searchDisplayController setActive:YES];
    //self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:headerView.searchBar contentsController:self];
    
    
    [headerView.createHotSpotButton addTarget:self action:@selector(createHotSpotButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    self.tableView.backgroundView = nil;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //Create MapView
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(10, 20 , 300, 220)];
    [mapView setScrollEnabled:NO];
    [mapView setZoomEnabled:NO];
    mapView.layer.cornerRadius = 8.0f;
    mapView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    mapView.layer.borderWidth = 1.0f;
    [mapView setShowsUserLocation:YES];
    mapView.delegate = self;
    
    //Create Pan Label
    mapPanLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 20)];
    mapPanLabel.text = @"Hold to Enable Pan and Zoom";
    mapPanLabel.backgroundColor = [UIColor clearColor];
    mapPanLabel.textColor = [UIColor grayColor];
    mapPanLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:14.0f];
    
    
    //Search bar controller

    
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingIndicator.hidden = YES;

    
    UILongPressGestureRecognizer *longPressToPanMap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressOnMap:)];
    
   
    
    
    [mapView addGestureRecognizer:longPressToPanMap];
    
    
    
    
    [SVProgressHUD showWithStatus:@"Searching for Locations"];
    
    
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)createHotSpotButtonPressed:(id)sender{
    MMCreateHotSpotViewController *createHotSpotVC = [[MMCreateHotSpotViewController alloc] initWithStyle:UITableViewStyleGrouped];
    createHotSpotVC.nearbyLocations = self.nearbyLocations;
    [self.navigationController pushViewController:createHotSpotVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    numberOfLocations = 5;
    [self loadNearbyLocations];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    
}
-(void)showCategorySearch{
    MMSearchViewController *categorySearchViewController = [[MMSearchViewController alloc] initWithNibName:@"MMSearchViewController" bundle:nil];
    categorySearchViewController.title = @"Categories";
    [self.navigationController pushViewController:categorySearchViewController animated:YES];
}

- (void)showSearchHistory {
    
    MMLocationsViewController *searchHistoryViewController = [[MMLocationsViewController alloc] initWithNibName:@"MMLocationsViewController" bundle:nil];
    
    NSMutableArray *searchHistory;
    NSString *historyKey = [NSString stringWithFormat:@"%@ history", [[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:historyKey]) {
        searchHistory = [[NSUserDefaults standardUserDefaults]  mutableArrayValueForKey:historyKey];
        //reverse order of items in array so that its displayed as latest viewed to oldest
        NSArray *reverse = [[searchHistory reverseObjectEnumerator]allObjects];
        searchHistory = [reverse mutableCopy];
    }
    else {
        searchHistory = [[NSMutableArray alloc]init];
    }
    
    NSMutableArray *locationInformations = [NSMutableArray array];
    
    for(NSDictionary *locationDictionary in searchHistory){
        MMLocationInformation *locationInformation = [MMAPI locationInformationForLocationDictionary:locationDictionary];
        [locationInformations addObject:locationInformation];
    }
    
    searchHistoryViewController.locationsInformationCollection = locationInformations;
    [searchHistoryViewController.tableView reloadData];
    searchHistoryViewController.isHistory = YES;
    searchHistoryViewController.title = @"History";
    
    [self.navigationController pushViewController:searchHistoryViewController animated:YES];
    
}

-(MKCoordinateRegion)zoomRegionFromLocations:(NSArray *)locations{
    
    CLLocationCoordinate2D currentLocation = mapView.userLocation.coordinate;
    double minLat = 0;
    double maxLat = 0;
    double minLong = 0;
    double maxLong= 0;
    
    for(int i=0; i< numberOfLocations; i++){
        MMLocationInformation *locationInfo = [nearbyLocations objectAtIndex:i];
        if(minLat == 0 || minLat > locationInfo.latitude.doubleValue) {
            minLat = locationInfo.latitude.doubleValue;
        }
        if(minLong == 0 || minLong > locationInfo.longitude.doubleValue) {
            minLong = locationInfo.longitude.doubleValue;
        }
        if(maxLat == 0 || maxLat < locationInfo.latitude.doubleValue) {
            maxLat = locationInfo.latitude.doubleValue;
        }
        if(maxLong == 0 || maxLong < locationInfo.longitude.doubleValue) {
            maxLong = locationInfo.longitude.doubleValue;
        }
    }
    
    double latDiff = maxLat-minLat;
    double longDiff = maxLong-minLong;
    double delta = latDiff>longDiff ? latDiff : longDiff;
    

    MKCoordinateRegion region;
    MKCoordinateSpan span;
    delta += 0.015; // Add extra to show pins
    
    span.latitudeDelta = delta;
    span.longitudeDelta= delta;
    
    
    region.span=span;
    
    region.center = CLLocationCoordinate2DMake((maxLat + minLat)/2, ((maxLong + minLong)/2));
    return region;
    
    
}

-(void)addAnotationsToMap:(NSArray *)locations{
    for(int i = 0; i < numberOfLocations; i++){
        MMLocationInformation *location = [nearbyLocations objectAtIndex:i];
        MMLocationAnnotation    *pin = [[MMLocationAnnotation alloc] initWithName:location.name address:location.formattedAddressString coordinate:CLLocationCoordinate2DMake(location.latitude.doubleValue, location.longitude.doubleValue) arrayIndex:i];               
        [mapView addAnnotation:(MKPointAnnotation*)pin];
    }
}
-(void)loadNearbyLocations {
    MMLocationSearch *locationSearchModel = [[MMLocationSearch alloc] init];
    [locationSearchModel locationsInfoForCategory:nil searchString:nil success:^(NSArray *locationInformations) {
        nearbyLocations = locationInformations;
        [self.tableView reloadData];
        // [mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES];
        
        [mapView setRegion:[self zoomRegionFromLocations:locationInformations] animated:YES];
        [self addAnotationsToMap:locationInformations];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        NSLog(@"Failed");
        [SVProgressHUD showErrorWithStatus:@"Failed to retreive locations"];
    }];
}

-(void)showMoreLocations {
    
    int numberOfCellsToAdd;
    
    
    
    if (numberOfLocations + 5 < nearbyLocations.count) {
        numberOfCellsToAdd = 5;
    }else{
        numberOfCellsToAdd =  nearbyLocations.count - numberOfLocations;
    }
    
    NSMutableArray *cellIndexPaths = [NSMutableArray array];
    NSIndexPath *lastCellIndex = nil;
    
    for(int i=0; i < numberOfCellsToAdd; i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:numberOfLocations + i inSection:0];
        
        if(numberOfLocations + i == nearbyLocations.count - 1){
            lastCellIndex = indexPath;
        }else{
            [cellIndexPaths addObject:indexPath];
        }
       
    }
    
    numberOfLocations += numberOfCellsToAdd ;
    
    if(numberOfCellsToAdd > 0){
        
        [self.tableView beginUpdates];
        
        if(cellIndexPaths.count > 0){
            [self.tableView insertRowsAtIndexPaths:cellIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
        }
        
        
        if(lastCellIndex){
            NSIndexPath *lastIndex = [NSIndexPath indexPathForItem:[self.tableView numberOfRowsInSection:0]-1 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[lastIndex] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        [self.tableView endUpdates];
        
    }
   
    
}

-(void)handleLongPressOnMap:(UILongPressGestureRecognizer *)sender{
    
    if(sender.state == UIGestureRecognizerStateBegan){
        [self togglePanAndZoom];
    }
    
}
-(void)togglePanAndZoom{
    if(mapView.isScrollEnabled){
        mapView.scrollEnabled = NO;
        mapView.zoomEnabled = NO;
        mapPanLabel.text = @"Hold to Enable Pan and Zoom";
    }else{
        mapView.scrollEnabled = YES;
        mapView.zoomEnabled = YES;
        mapPanLabel.text = @"Hold to Disable Pan and Zoom";
    }
    [self animatePanLabel];
}
-(void)animatePanLabel {
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
        mapPanLabel.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            mapPanLabel.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF.name contains[cd] %@",
                                    searchText];
    
    searchResults = [self.nearbyLocations filteredArrayUsingPredicate:resultPredicate];
    NSLog(@"STOP");
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return 1;
    }
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return loadFromServer ? searchResults.count : searchResults.count + 1;
        
    } else {
        if(nearbyLocations.count <= 0){
            return numberOfLocations;
        }
        if(section == 0){
            return nearbyLocations.count > numberOfLocations ? numberOfLocations + 1 : nearbyLocations.count
            ;
        }else if (section == 1){
            return 2;
        }
        return 0;
        
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *LocationCellIdentifier = @"LocationCell";
    static NSString *NormalCellIdentifier = @"NormalCell";
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        if(indexPath.row == searchResults.count && !loadFromServer){
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalCellIdentifier];
            
            if(!cell){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalCellIdentifier];
            }
            
            cell.textLabel.text = @"Load More From Server";
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Oblique" size:20];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
            
        }else{
            
            MMLocationListCell *cell = [tableView dequeueReusableCellWithIdentifier:LocationCellIdentifier];
            
            if(!cell){
                cell = [[MMLocationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LocationCellIdentifier];
            }
        
            MMLocationInformation *locationInfoSearch = [searchResults objectAtIndex:indexPath.row];
            [cell setLocationInformation:locationInfoSearch];
            
             return cell;
        }
        
        
       
    }
    
    
    if(indexPath.section == 0) {
        
        
        if(nearbyLocations.count > numberOfLocations && indexPath.row == numberOfLocations){
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalCellIdentifier];
            
            if(!cell){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalCellIdentifier];
            }
            
            cell.textLabel.text = @"Load More";
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.accessoryView = loadingIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }else{
            MMLocationListCell *cell = [tableView dequeueReusableCellWithIdentifier:LocationCellIdentifier];
            
            if(!cell){
                cell = [[MMLocationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LocationCellIdentifier];
            }
            
            MMLocationInformation *locationInformation = [nearbyLocations objectAtIndex:indexPath.row];
            [cell setLocationInformation:locationInformation];
            return cell;
        }
        
        
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalCellIdentifier];
        
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalCellIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"My History";
                
                break;
            case 1:
                cell.textLabel.text = @"Search by Category";
                break;
                
            default:
                break;
        }
        return cell;
    }
    
    // Configure the ce
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 1){
        return 60;
    }
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 1){
        return 257;
    }
    return UITableViewAutomaticDimension ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row != numberOfLocations){
        return 80;
    }
    return UITableViewAutomaticDimension;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 1 && tableView != self.searchDisplayController.searchResultsTableView){
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 220)];
        
        [containerView addSubview:mapView];
        
               [containerView addSubview:mapPanLabel];
        
        
        return containerView;
    }
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return @"Nearby";
    }
    else return  nil;
}

-(void)searchFromServer{
    
    if (!searchModel) {
        searchModel = [[MMLocationSearch alloc] init];
        
    }
    
    [SVProgressHUD showWithStatus:@"Downloading Locations from Server"];
    [searchModel locationsInfoForCategory:nil searchString:self.searchDisplayController.searchBar.text rangeInYards:@88000 success:^(NSArray *locationInformations) {
        
        
        NSMutableArray *locationsToAdd = [NSMutableArray array];
        
        for (MMLocationInformation *location in locationInformations){
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.locationID = %@", location.locationID];
            
            MMLocationInformation *locationExists = [[searchResults filteredArrayUsingPredicate:predicate] lastObject];
            
            if(!locationExists){
                [locationsToAdd addObject:location];
            }
        }
        
     NSMutableArray *updatedSearchResults = [NSMutableArray arrayWithArray:searchResults];
     [updatedSearchResults addObjectsFromArray:locationsToAdd];
     searchResults = updatedSearchResults;
    loadFromServer = YES;
     [self.searchDisplayController.searchResultsTableView reloadData];
     [SVProgressHUD dismiss];
     
    } failure:^(NSError *error) {
        NSLog(@"Success");
        [SVProgressHUD showErrorWithStatus:@"Couldn't Search for Locations on Server"];
    }];
    
    
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        if(indexPath.row < searchResults.count){
            MMLocationInformation *locationInformation = [searchResults objectAtIndex:indexPath.row];
            
            MMLocationViewController *locationViewController = [[MMLocationViewController alloc] initWithStyle:UITableViewStyleGrouped];
            #warning FIX THIS BEFORE OYU IMPLEMENT NEW VIEW CONTROLLER LOCATION
            //locationViewController.locationInformation = locationInformation;
            
            [self.navigationController pushViewController:locationViewController animated:YES];
            return;
        }else{
            [self searchFromServer];
        }
        
        
    }
    
    switch (indexPath.section) {
        case 0:
        {
            int lastRowInSectionZero = [tableView numberOfRowsInSection:0] - 1;
            if(indexPath.section == 0 && indexPath.row == lastRowInSectionZero){
                
                [self showMoreLocations];
            }else{
                
                MMLocationInformation *locationInformation = [nearbyLocations objectAtIndex:indexPath.row];
                
                MMLocationViewController *locationViewController = [[MMLocationViewController alloc] initWithStyle:UITableViewStyleGrouped];
                #warning FIX THIS BEFORE OYU IMPLEMENT NEW VIEW CONTROLLER LOCATION
                //locationViewController.locationInformation = locationInformation;
                
                [self.navigationController pushViewController:locationViewController animated:YES];
            }
            break;
        }
        case 1:
        {
            if (indexPath.row == 0) {
                [self showSearchHistory];
            }else if(indexPath.row == 1){
                [self showCategorySearch];
            }
            break;
        }
            
            
        default:
            break;
    }
    
    
    
    
    
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - MapViewDelegate

#pragma mark - Search Bar 

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    loadFromServer = NO;
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect newFrame = headerView.frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.tableView.contentOffset.y;
    headerView.frame = newFrame;
}

@end
