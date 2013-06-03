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
    //[self.tableView addSubview:_headerView];
    
    self.fixedTableHeaderView = _headerView;
    
    _searchDisplayModel = [[MMSearchDisplayModel alloc] init];
    
    _defaultList = [self.searchDisplayModel defaultSearchItems];

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
    
    if(self.isSearching){
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
            return self.placesSearchResults.count;
        }
        
    }else{
        return self.defaultList.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    //Grab the correct search item
    MMSearchItem *searchItem;

    if(self.isSearching){
        
        if(indexPath.section == 0){
            
            searchItem = [self.categorySearchResults objectAtIndex:indexPath.row];
      
        }else if(indexPath.section == 1){
        
            searchItem = [self.placesSearchResults objectAtIndex:indexPath.row];
        }
        
    } else {
        
        searchItem = [self.defaultList objectAtIndex:indexPath.row];
    
    }
    
    cell.textLabel.text = searchItem.mainText;
    cell.accessoryType = searchItem.accessoryType;
    
    
    // Configure the cell...
    
    return cell;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 22.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - Search Bar Delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _isSearching = searchText.length > 0 ? YES : NO;
    
    self.categorySearchResults = [self.searchDisplayModel categoriesMatchingSearchString:searchText];
    
    [self.tableView reloadData];
    
    //Only query the server if the search string length is over 3
    //if(searchText.length >= 3){
        
        NSNumber *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
        NSNumber *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
        
        [self.searchDisplayModel placesMatchingSearchString:searchText atLocation:CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue) radius:@100 success:^(NSArray *searchItems) {
            self.placesSearchResults = searchItems;
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"Failed to get places: %@", error);
            self.placesSearchResults = @[];
            [self.tableView reloadData];
        }];

    //}
    
    
}

@end
