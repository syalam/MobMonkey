//
//  MMSearchCitySelectViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 6/13/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//
#define kPreviouslySearchedCities @"previouslySearchedGoogleCityObjects"

#import "MMSearchCitySelectViewController.h"

@interface MMSearchCitySelectViewController ()

@property (nonatomic, strong) NSArray * citiesMatchingSearch;

@property (nonatomic, strong) NSArray * citiesPreviouslySearched;

@property (nonatomic, strong) NSArray * citiesToDisplay;

@property (nonatomic, assign) CLLocationCoordinate2D myLocation;

@property (nonatomic, assign) BOOL showCurrentLocation;

@end

@implementation MMSearchCitySelectViewController

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
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _searchBar.delegate = self;
    
    
    self.tableView.tableHeaderView = _searchBar;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    _myLocation = CLLocationCoordinate2DMake([[defaults objectForKey:@"latitude"] doubleValue], [[defaults objectForKey:@"longitude"] doubleValue]);
    
    _showCurrentLocation = YES;
    
    //Load previously search cities from NSUserDefaults
    NSData *savedArrayData = [defaults objectForKey:kPreviouslySearchedCities];
    if (savedArrayData != nil)
    {
        NSArray *unencodedArray = [NSKeyedUnarchiver unarchiveObjectWithData:savedArrayData];
        if (unencodedArray != nil) {
            _citiesPreviouslySearched = [[NSMutableArray alloc] initWithArray:unencodedArray];
        } else {
            _citiesPreviouslySearched = [[NSMutableArray alloc] init];
        }
    }
    
    self.citiesToDisplay = _citiesPreviouslySearched;
    
    [self.tableView reloadData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)removeDuplicatesFromArray:(NSArray *)combindedCitiesArray{
    
    NSMutableSet *cityIDs = [NSMutableSet set];
    
    NSPredicate *dupCitiesPred = [NSPredicate predicateWithBlock: ^BOOL(id obj, NSDictionary *bind) {
        MMGoogleCityDataObject *city = (MMGoogleCityDataObject*)obj;
        BOOL cityAlreadyExists = [cityIDs containsObject:city.referenceID];
        if (!cityAlreadyExists) {
            [cityIDs addObject:city.referenceID];
        }
        return !cityAlreadyExists;
    }];
    
    return [combindedCitiesArray filteredArrayUsingPredicate:dupCitiesPred];
    
}
-(void)updateCitiesWithSearchString:(NSString *)searchString {
    
    NSPredicate * searchSavedCityPredicate = [NSPredicate predicateWithFormat:@"SELF.formattedLocalityPoliticalGeocodeString BEGINSWITH[cd] %@", searchString];
    
    NSArray * savedCities = [self.citiesPreviouslySearched filteredArrayUsingPredicate:searchSavedCityPredicate];
    
    //Only search google if the search string is length (2) or larger
    if(searchString.length >= 2){
        [[MMGooglePlacesCitySearch sharedCitySearch] searchCityNamesForSearchString:searchString atCoordinate:_myLocation success:^(NSArray *googleCityObjects) {
            NSMutableArray * combinedCityObjects = [NSMutableArray arrayWithArray:savedCities];
            [combinedCityObjects addObjectsFromArray:googleCityObjects];
            
            self.citiesToDisplay = [self removeDuplicatesFromArray:combinedCityObjects];
            NSLog(@"CITIES: %@", self.citiesToDisplay);
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            
        }];
    }else{
        self.citiesToDisplay = savedCities;
        [self.tableView reloadData];
    }
    
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
    
    
    return _showCurrentLocation ? _citiesToDisplay.count + 1 : _citiesToDisplay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(_showCurrentLocation && indexPath.row == 0){
        cell.textLabel.text = @"Current Location";
        return cell;
    }
    
    
    NSUInteger cityIndex = _showCurrentLocation ? indexPath.row - 1 : indexPath.row;
    
    
    
    MMGoogleCityDataObject * cityDetails = [_citiesToDisplay objectAtIndex:cityIndex];
    
    cell.textLabel.text = cityDetails.formattedLocalityPoliticalGeocodeString;
    
    
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
    
    if(_showCurrentLocation && indexPath.row == 0){
        if([self.delegate respondsToSelector:@selector(citySelectVC:didSelectCityObject:)]){
            [self.delegate citySelectVC:self didSelectCityObject:nil];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
    NSUInteger cityIndex = _showCurrentLocation ? indexPath.row - 1 : indexPath.row;
    
    MMGoogleCityDataObject * googleCityObject = [self.citiesToDisplay objectAtIndex:cityIndex];
    
    
    [googleCityObject updatePlaceWithDetails:^(MMGoogleCityDataObject *updatedObject, NSError *error) {
        
        if([self.delegate respondsToSelector:@selector(citySelectVC:didSelectCityObject:)]){
            [self.delegate citySelectVC:self didSelectCityObject:updatedObject];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Search Bar Delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if(searchText.length <= 0){
        _showCurrentLocation = YES;
        [self.tableView reloadData];
        return;
    }else{
        _showCurrentLocation = NO;
    }
    [self updateCitiesWithSearchString:searchText];
}
@end
