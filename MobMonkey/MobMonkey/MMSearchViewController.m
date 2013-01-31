//
//  MMSearchViewController.m
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/15/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMSearchViewController.h"
#import "MMLocationsViewController.h"
#import "MMFilterViewController.h"
#import "MMLocationViewController.h"

@interface MMSearchViewController ()

@property (strong, nonatomic) NSArray           *categories;
@property (strong, nonatomic) NSArray           *sections;
@property (strong, nonatomic) NSArray           *filteredCategories;
@property (strong, nonatomic) NSString          *savedSearchTerm;
@property (assign, nonatomic) BOOL              searchWasActive;

@property (strong, nonatomic) MMLocationsViewController *searchResultsViewController;

- (void)showFilterView:(id)sender;
- (void)showSearchResultsForCategory:(NSDictionary *)category;

@end

@implementation MMSearchViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[UISearchBar appearance] setTranslucent:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    prefs = [NSUserDefaults standardUserDefaults];

    self.searchBar.backgroundImage = [UIImage imageNamed:@"SearchBG~iphone.png"];
    UIImage *customButtonImage = [[UIImage imageNamed:@"navBarButtonBlank"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    
    if (_parentId) {
        UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
        [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
        
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
        self.navigationItem.leftBarButtonItem = backButton;
    }
    else {
        UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        customButton.bounds = CGRectMake(0, 0, 52, 31);
        [customButton setBackgroundImage:customButtonImage forState:UIControlStateNormal];
        [customButton setTitle:@"Filter" forState:UIControlStateNormal];
        [customButton.titleLabel setTextColor:[UIColor whiteColor]];
        [customButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [customButton.titleLabel setShadowColor:[UIColor darkGrayColor]];
        [customButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [customButton addTarget:self action:@selector(showFilterView:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* filterButton = [[UIBarButtonItem alloc] initWithCustomView:customButton];
        self.navigationItem.leftBarButtonItem = filterButton;
    }
  
    UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusButton setFrame:CGRectMake(0, 0, 31, 31)];
    [plusButton setBackgroundImage:customButtonImage forState:UIControlStateNormal];
    [plusButton addTarget:self action:@selector(showMapView:)
         forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *plusButtonLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -3, plusButton.frame.size.width, plusButton.frame.size.height)];
    [plusButtonLabel setBackgroundColor:[UIColor clearColor]];
    [plusButtonLabel setText:@"+"];
    [plusButtonLabel setTextColor:[UIColor whiteColor]];
    [plusButtonLabel setShadowColor:[UIColor darkGrayColor]];
    [plusButtonLabel setShadowOffset:CGSizeMake(0, -1)];
    [plusButtonLabel setFont:[UIFont boldSystemFontOfSize:24]];
    [plusButtonLabel setTextAlignment:NSTextAlignmentCenter];
    [plusButton addSubview:plusButtonLabel];
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:plusButton];
  self.navigationItem.rightBarButtonItem = addButton;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:219.0/255.0
                                                                        green:100.0/225.0
                                                                         blue:24.0/255.0
                                                                        alpha:1.0];
    self.filteredCategories = @[];
    self.savedSearchTerm = @"";
    self.sections = @[self.savedSearchTerm, self.filteredCategories];
    if (self.savedSearchTerm) {
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setText:self.savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
    allCategoriesArray = [prefs objectForKey:@"allCategories"];
    [self.tableView reloadData];
    self.tableView.scrollEnabled = YES;
}

- (void)viewDidUnload {
    self.categories = nil;
    self.filteredCategories = nil;
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![prefs objectForKey:@"userName"]) {
        [[MMClientSDK sharedSDK]signInScreen:self];
    }
    else {
        if (_parentId) {
            NSString *parent = [NSString stringWithFormat:@"[%@]", _parentId];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parents CONTAINS %@", parent];
            self.categories = [allCategoriesArray filteredArrayUsingPredicate:predicate];
            [self.tableView reloadData];
        }
        else {
            NSString *parent = [NSString stringWithFormat:@"[%@]", @"1"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parents CONTAINS %@", parent];
            self.categories = [allCategoriesArray filteredArrayUsingPredicate:predicate];
            [self.tableView reloadData];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [SVProgressHUD dismiss];
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showFilterView:(id)sender
{
    MMFilterViewController *fvc = [[MMFilterViewController alloc]initWithNibName:@"MMFilterViewController" bundle:nil];
    fvc.delegate = (id <MMFilterViewDelegate>)self;
    fvc.title = @"Filter";
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:fvc];
    [self.navigationController presentViewController:navc animated:YES completion:NULL];
}

- (void)showMapView:(id)sender
{
    MMMapFilterViewController *mvc = [[MMMapFilterViewController alloc] init];
    mvc.title = @"Add Location";
    mvc.delegate = self;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:mvc];
    [self.navigationController presentViewController:navc animated:YES completion:nil];
}

- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showSearchResultsForCategory:(NSDictionary *)category
{
    double latitude, longitude;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [self.searchBar resignFirstResponder];
    if (!self.searchResultsViewController) {
        self.searchResultsViewController = [[MMLocationsViewController alloc] initWithNibName:@"MMLocationsViewController" bundle:nil];
    }
  
    self.searchResultsViewController.category = category;
    self.searchResultsViewController.locations = [NSMutableArray array];
    [self.searchResultsViewController.tableView reloadData];
    self.searchResultsViewController.isSearching = YES;
    self.searchResultsViewController.isHistory = NO;
    if (category) {
        self.searchResultsViewController.title = category[@"en"];
        [params setValue:category[@"categoryId"] forKey:@"categoryIds"];
    } else {
        if ([self.searchBar.text length] > 0) {
            self.searchResultsViewController.title = [NSString stringWithFormat:@"“%@”", self.searchBar.text];
        }
        else {
            self.searchResultsViewController.title = @"All Nearby";
        }
        
        //[params setValue:@"" forKey:@"categoryIds"];
    }
    [params setValue:self.searchBar.text forKey:@"name"];
    
    latitude = [[prefs  valueForKey:@"latitude"]doubleValue];
    longitude = [[prefs  valueForKey:@"longitude"]doubleValue];
    NSLog(@"%f, %f", latitude, longitude);
    
    [params setValue:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
    [params setValue:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
    
    //if ([self.searchBar.text length] < 1) {
        if ([prefs valueForKey:@"savedSegmentValue"]) {
            [params setObject:[prefs valueForKey:@"savedSegmentValue"] forKey:@"radiusInYards"];
        }
        else {
            [params setValue:[NSNumber numberWithInt:880] forKey:@"radiusInYards"];
        }
    //}
    /*else {
        [params setValue:[NSNumber numberWithInt:704000] forKey:@"radiusInYards"];
    }*/
    
    NSString *mediaType;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"liveFeedFilter"]) {
        mediaType = @"3";
    }
    NSLog(@"%@", params);
    [SVProgressHUD showWithStatus:@"Searching"];
    [MMAPI searchForLocation:params mediaType:mediaType success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.searchResultsViewController.isSearching = NO;
        [SVProgressHUD dismiss];
        NSArray *responseObjectArray = responseObject;
        if (responseObjectArray.count < 1) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"No locations found" delegate:self.searchResultsViewController cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        self.searchResultsViewController.locations = responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
        [SVProgressHUD showErrorWithStatus:[error description]];
    }];

    
    [self.navigationController pushViewController:self.searchResultsViewController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSInteger numberOfSections = 0;
        numberOfSections += self.savedSearchTerm.length > 0;
        numberOfSections += self.filteredCategories.count > 0;
        return numberOfSections;
    }
    else if (_parentId) {
        return 1;
    }
    else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        switch (section) {
            case 0:
                numberOfRows = 1;
                break;
            case 1:
                numberOfRows = self.filteredCategories.count;
                break;
            default:
                numberOfRows = 0;
                break;
        }
        return numberOfRows;
    }
    else if (_parentId) {
        numberOfRows = self.categories.count;
    }
    else {
        switch (section) {
            case 0:
                numberOfRows = 2;
                break;
            case 1:
                numberOfRows = self.categories.count;
                break;
            default:
                numberOfRows = 0;
                break;
        }
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CategoryCellIdentifier = @"CategoryCell";
    static NSString *SearchTermCellIdentifier = @"SearchTermCell";
    if (tableView == self.searchDisplayController.searchResultsTableView && indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchTermCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SearchTermCellIdentifier];
            cell.textLabel.textColor = [UIColor grayColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = [UIImage imageNamed:@"searchIcon"];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"Search “%@”", self.savedSearchTerm];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CategoryCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CategoryCellIdentifier];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *category;
    NSString *categoryName;
    int section;
    if (_parentId) {
        section = indexPath.section + 1;
    }
    else {
        section = indexPath.section;
    }
    switch (section) {
        case 0:
            if (indexPath.row == 0) {
                categoryName = @"Show All Nearby";
            }
            else {
                categoryName = @"History";
            }
            break;
        case 1: {
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                category = self.filteredCategories[indexPath.row];
            } else {
                category = self.categories[indexPath.row];
            }
            cell.imageView.image = [UIImage imageNamed:@"picture"];
            categoryName = [category[@"en"] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        }
            break;
        default:
            break;
    }
    cell.textLabel.text = categoryName;
    cell.imageView.image = [self assignIconToSearchCategoryWithCategoryName:categoryName];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *category = nil;

    int section;
    if (_parentId) {
        section = indexPath.section + 1;
    }
    else {
        section = indexPath.section;
    }

    
    if (section == 1) {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            category = self.filteredCategories[indexPath.row];
        } else {
            category = self.categories[indexPath.row];
        }
        NSString *categoryId = category[@"categoryId"];
        categoryId = [NSString stringWithFormat:@"[%@]", categoryId];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parents CONTAINS %@", categoryId];
        NSArray *subCategories = [allCategoriesArray filteredArrayUsingPredicate:predicate];
        
        if (subCategories.count > 0) {
            MMSearchViewController *searchVC = [[MMSearchViewController alloc]initWithNibName:@"MMSearchViewController" bundle:nil];
            searchVC.parentId = category[@"categoryId"];
            searchVC.title = category[@"en"];
            [self.navigationController pushViewController:searchVC animated:YES];
        }
        else {
            category = self.categories[indexPath.row];
            [self showSearchResultsForCategory:category];
        }
    }
    else if (section == 0 && indexPath.row == 0) {
        [self showSearchResultsForCategory:category];
    }
    else {
        [self showSearchHistory];
    }

}

#pragma mark - Helper Methods
- (UIImage*)assignIconToSearchCategoryWithCategoryName:(NSString*)categoryName {
    UIImage *cellIconImage;
    cellIconImage = [UIImage imageNamed:@"picture"];
    if ([categoryName isEqualToString:@"Show All Nearby"]) {
        cellIconImage = [UIImage imageNamed:@"myLocationsIcon"];
    }
    else if ([categoryName isEqualToString:@"Coffee Shops"]) {
        cellIconImage = [UIImage imageNamed:@"coffeeShopsIcon"];
    }
    else if ([categoryName isEqualToString:@"Retail"]) {
        cellIconImage = [UIImage imageNamed:@"supermarketsIcon"];
    }
    else if ([categoryName isEqualToString:@"Travel"]) {
        cellIconImage = [UIImage imageNamed:@"beachesIcon"];
    }
    else if ([categoryName isEqualToString:@"Community and Government"] || [categoryName isEqualToString:@"Landmarks"]) {
        cellIconImage = [UIImage imageNamed:@"schoolsIcon"];
    }
    else if ([categoryName isEqualToString:@"Services and Supplies"] || [categoryName isEqualToString:@"History"]) {
        cellIconImage = [UIImage imageNamed:@"historyIcon"];
    }
    else if (!([categoryName rangeOfString:@"Automotive"].location == NSNotFound)) {
        cellIconImage = [UIImage imageNamed:@"editedCinemasIcon"];
    }
    else if ([categoryName isEqualToString:@"Social"]) {
        cellIconImage = [UIImage imageNamed:@"coffeeShopsIcon"];
    }
    else if ([categoryName isEqualToString:@"Healthcare"]) {
        cellIconImage = [UIImage imageNamed:@"hotelsIcon"];
    }
    else if ([categoryName isEqualToString:@"Sports and Recreation"]) {
        cellIconImage = [UIImage imageNamed:@"stadiumsIcon"];
    }
    else if ([categoryName isEqualToString:@"Transportation"]) {
        cellIconImage = [UIImage imageNamed:@"locationsOfInterestIcon"];
    }
    else if ([categoryName isEqualToString:@"Education"]) {
        cellIconImage = [UIImage imageNamed:@"conferencesIcon"];
    }
    else if ([categoryName isEqualToString:@"Art Dealers & Galleries"]) {
        cellIconImage = [UIImage imageNamed:@"nightclubsIcon"];
    }
    else if ([categoryName isEqualToString:@"Pools & Spas"]) {
        cellIconImage = [UIImage imageNamed:@"beachesIcon"];
    }
    return cellIconImage;
}

- (void)showSearchHistory {
    if (!self.searchResultsViewController) {
        self.searchResultsViewController = [[MMLocationsViewController alloc] initWithNibName:@"MMLocationsViewController" bundle:nil];
    }
    NSMutableArray *searchHistory;
    NSString *historyKey = [NSString stringWithFormat:@"%@ history", [[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:historyKey]) {
        searchHistory = [prefs  mutableArrayValueForKey:historyKey];
        //reverse order of items in array so that its displayed as latest viewed to oldest
        NSArray *reverse = [[searchHistory reverseObjectEnumerator]allObjects];
        searchHistory = [reverse mutableCopy];
    }
    else {
        searchHistory = [[NSMutableArray alloc]init];
    }
    self.searchResultsViewController.locations = searchHistory;
    [self.searchResultsViewController.tableView reloadData];
    self.searchResultsViewController.isHistory = YES;
    self.searchResultsViewController.title = @"History";
    
    [self.navigationController pushViewController:self.searchResultsViewController animated:YES];

}

#pragma mark - Search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self showSearchResultsForCategory:nil];
}

#pragma mark - Search display controller delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.savedSearchTerm = searchString;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[C] %@", searchString];
    self.filteredCategories = [self.categories filteredArrayUsingPredicate:predicate];
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    tableView.backgroundView = nil;
}


#pragma mark - MMMapFilterDelegate
- (void)locationAddedViaMapViewWithLocationID:(NSString*)locationId providerId:(NSString*)providerId {
    MMLocationViewController *locationViewController = [[MMLocationViewController alloc]initWithNibName:@"MMLocationViewController" bundle:nil];
    [locationViewController loadLocationDataWithLocationId:locationId providerId:providerId];
    [self.navigationController pushViewController:locationViewController animated:YES];
}


@end
