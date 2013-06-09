//
//  MMAdvancedSearchTableViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 6/7/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMAdvancedSearchTableViewController.h"
#import "MMAPI.h"
#import "MMLocationSearch.h"

@interface MMAdvancedSearchTableViewController ()

@end

@implementation MMAdvancedSearchTableViewController

- (id)initWithStyle:(UITableViewStyle)style searchByType:(MMSearchByType)searchByType
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _searbyByType = searchByType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.allPlaces = @[];
    
    if(_searbyByType == MMSearchByFavorites){
        [self loadAllFavorites];
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)loadAllFavorites{
    [MMAPI getBookmarkLocationInformationOnSuccess:^(AFHTTPRequestOperation *operation, NSArray *locationInformations) {
        self.allPlaces = locationInformations;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(NSArray *)favoritesMatchingString:(NSString *)searchString{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF.name contains[cd] %@",
                                    searchString];
    
    return [self.allPlaces filteredArrayUsingPredicate:resultPredicate];
   
}
-(void)loadPlacesWithSearchString:(NSString *)searchString {
    
    _isSearching = YES;
    
    MMLocationSearch *searchModel = [[MMLocationSearch alloc] init];
    
    switch (_searbyByType) {
        case MMSearchByFavorites:
            
            self.searchResults = [self favoritesMatchingString:searchString];
            [self.tableView reloadData];
            
            break;
            
        case MMSearchByInterests:
            //TODO: Search by my interests, not sure what the api parameter is...
            
            break;
        case MMSearchByNearby:{
            
            NSNumber *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
            NSNumber *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
            
            [searchModel locationsInfoForCategory:nil atLocationCoordinates:CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue) withRadiusInYards:@1000 searchString:searchString success:^(NSArray *locationInformations) {
                self.searchResults = locationInformations;
                [self.tableView reloadData];
            } failure:^(NSError *error) {
                
            }];
            
            break;
        }
        case MMSearchByCategory:
            //TODO: Search by my interests, not sure what the api parameter is...
            
            break;
        
            
        default:
            break;
    }
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _isSearching ? self.searchResults.count : self.allPlaces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
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
#pragma mark - Search Delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if(searchText.length > 0){
        _isSearching = YES;
        [self loadPlacesWithSearchString:searchText];
    }else{
        _isSearching = NO;
    }
    
}

@end
