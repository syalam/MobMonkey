//
//  MMSearchPlacesViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 5/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMSearchPlacesViewController.h"
#import "MMSearchHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "MMLocationSearch.h"
#import "MMPlaceViewController.h"
#import "MMNavigationViewController.h"
#import "MMSectionHeaderWithBadgeView.h"
#import "MMLocationListCell.h"
#import "MMSearchCitySelectViewController.h"

@interface MMSearchPlacesViewController ()

@property (nonatomic, strong) MMSearchHeaderView *headerView;
@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, strong) MMSearchDisplayModel *searchDisplayModel;

@end

@implementation MMSearchPlacesViewController

@synthesize headerView = _headerView;
@synthesize isSearching = _isSearching;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        // Custom initialization
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //Add Search Bar to titleView of Navigation Bar
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width, 44)];
       //hides background
    [[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
    [_searchBar setBackgroundColor:[UIColor clearColor]];
    [_searchBar setDelegate:self];
    
    self.navigationItem.titleView = _searchBar;
    
    //Add Header View to Table
    
    _headerView = [[MMSearchHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _headerView.layer.zPosition = 100;
    
    //Action for pressing location
    __weak typeof(self) weakSelf = self;
    [_headerView setClickAction:^{
        [weakSelf nearButtonPressed];
    }];
    [self.tableView addSubview:_headerView];
    
    self.fixedTableHeaderView = _headerView;
    
    _searchDisplayModel = [[MMSearchDisplayModel alloc] init];
    
    _defaultList = [self.searchDisplayModel defaultSearchItems];

}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self searchBar:self.searchBar textDidChange:self.searchBar.text];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

-(void)keyboardWasShown:(id)sender {
    [super keyboardWasShown:sender];
    CGRect frame = self.tableView.frame;
    frame.size.height -= self.keyboardSize.height + 30;
    self.tableView.frame  = frame;
}
-(void)keyboardWillHide:(id)sender {
    [super keyboardWillHide:sender];
    
    CGRect frame = self.tableView.frame;
    frame.size.height = self.view.frame.size.height - _headerView.frame.size.height + 30;
    self.tableView.frame  = frame;
    }
-(void)nearButtonPressed {
    MMSearchCitySelectViewController *searchCityViewController = [[MMSearchCitySelectViewController alloc] initWithStyle:UITableViewStylePlain];
    searchCityViewController.delegate = self;
    searchCityViewController.title = @"Choose a City";
    
    [self.navigationController pushViewController:searchCityViewController animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    
    if(_isSearching){
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    if(self.isSearching){
        
        if(section == 0){
            return self.categorySearchResults.count;
        }else if(section == 1){
            return self.locationInformationCollection.count;
        }
        
    }else{
        return self.defaultList.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if((_isSearching && indexPath.section != 1) || !_isSearching){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.textLabel.textColor = [UIColor MMMainTextColor];
            cell.backgroundColor = [UIColor MMEggShell];
        }
        
        
        //Grab the correct search item
        MMSearchItem *searchItem;
        
        if(self.isSearching){
            
            if(indexPath.section == 0){
                
                searchItem = [self.categorySearchResults objectAtIndex:indexPath.row];
                
            }else if(indexPath.section == 1){
                
                searchItem = [MMSearchItem searchItemFromLocationInformation:[self.locationInformationCollection objectAtIndex:indexPath.row]];
            
            }
            
        } else {
            
            searchItem = [self.defaultList objectAtIndex:indexPath.row];
            
        }
        
        if(![searchItem.mainText isEqual:[NSNull null]]){
            cell.textLabel.text = searchItem.mainText;
        }
        
        cell.accessoryType = searchItem.accessoryType;
        
        
        // Configure the cell...
        
        return cell;
    }else{
        static NSString * CellIdentifier2 =  @"ListLocation";
        MMLocationListCell * listCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        if(listCell == nil){
            listCell = [[MMLocationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        
        [listCell setLocationInformation:[self.locationInformationCollection objectAtIndex:indexPath.row]];
        
        return listCell;
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
    [_searchBar resignFirstResponder];
    //If Searching Section 0 is Categories and Section 1 is Places
    if(_isSearching){
        
        switch (indexPath.section) {
            case 0:
                //TODO: go to category page
                break;
            case 1: {
                MMPlaceViewController *placeViewController = [[MMPlaceViewController alloc] initWithTableViewStyle:UITableViewStylePlain defaultMapHeight:100 parallaxFactor:0.4];
                placeViewController.locationInformation = [self.locationInformationCollection objectAtIndex:indexPath.row];
                
                [self.navigationController pushViewController:placeViewController animated:YES];
            }
                
                break;
                
            default:
                break;
        }
        
        
    }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(_isSearching){
        
        if(section == 0){
            if(self.categorySearchResults.count > 0){
                return 25.0f;
            }else{
                return 0.0f;
            }
        }
        return 25.0f;
    }else{
        return 0.0f;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString * title;
    NSNumber * badgeNumber;
    
    if(section == 0){
        title = @"Categories";
        badgeNumber = [NSNumber numberWithInt:self.categorySearchResults.count];
    }else if(section == 1){
        title = @"Places";
        badgeNumber = [NSNumber numberWithInt:self.locationInformationCollection.count];
    }
    
    
    MMSectionHeaderWithBadgeView * headerView = [[MMSectionHeaderWithBadgeView alloc] initWithTitle:title andBadgeNumber:badgeNumber];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1 && _isSearching){
        return 74.0f;
    }
    return UITableViewAutomaticDimension;
}
#pragma mark - Search Bar Delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _isSearching = searchText.length > 0 ? YES : NO;
    
    if(!_isSearching)return;
    
    self.categorySearchResults = [self.searchDisplayModel categoriesMatchingSearchString:searchText];
    
    [self.tableView reloadData];
    
    CLLocationCoordinate2D searchCoordinate;
    
    if(_googleCityObject){
        searchCoordinate = CLLocationCoordinate2DMake(_googleCityObject.cooridnates.latitude, _googleCityObject.cooridnates.longitude);
    }else{
        NSNumber *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
        NSNumber *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
        
        searchCoordinate = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
    }
    
        [self.searchDisplayModel placesMatchingSearchString:searchText atLocation:searchCoordinate radius:@48280.3 success:^(NSArray *searchItems) {
            self.locationInformationCollection = searchItems;
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"Failed to get places: %@", error);
            self.placesSearchResults = @[];
            [self.tableView reloadData];
        }];

    //}
    
    
}

#pragma mark - Search City Delegate
-(void)citySelectVC:(MMSearchCitySelectViewController *)viewController didSelectCityObject:(MMGoogleCityDataObject *)cityObject {
    
    _googleCityObject = cityObject;
    
    if(cityObject){
        _headerView.locationLabel.text = cityObject.formattedLocalityPoliticalGeocodeString;
    }else{
        _headerView.locationLabel.text = @"Current Location";
    }
    
    
    
    
}

@end
