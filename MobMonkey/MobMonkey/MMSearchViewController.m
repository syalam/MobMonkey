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
#import "MMMapFilterViewController.h"

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

    self.searchBar.backgroundImage = [UIImage imageNamed:@"SearchBG~iphone.png"];
    UIImage *customButtonImage = [[UIImage imageNamed:@"navBarButtonBlank"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
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
  
  UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
  plusButton.bounds = CGRectMake(0, 0, 31, 31);
  [plusButton setBackgroundImage:customButtonImage forState:UIControlStateNormal];
  [plusButton setTitle:@"+" forState:UIControlStateNormal];
  [plusButton.titleLabel setTextColor:[UIColor whiteColor]];
  [plusButton.titleLabel setFont:[UIFont boldSystemFontOfSize:24]];
  [plusButton.titleLabel setShadowColor:[UIColor darkGrayColor]];
  [plusButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];
  [plusButton addTarget:self action:@selector(showMapView:)
       forControlEvents:UIControlEventTouchUpInside];
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:plusButton];
  self.navigationItem.rightBarButtonItem = addButton;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:226.0/255.0
                                                                        green:112.0/225.0
                                                                         blue:36.0/255.0
                                                                        alpha:1.0];
    self.filteredCategories = @[];
    self.savedSearchTerm = @"";
    self.sections = @[self.savedSearchTerm, self.filteredCategories];
    if (self.savedSearchTerm) {
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setText:self.savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
    [self.tableView reloadData];
    self.tableView.scrollEnabled = YES;
}

- (void)viewDidUnload {
    self.categories = nil;
    self.filteredCategories = nil;
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [SVProgressHUD dismiss];
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
        [[MMClientSDK sharedSDK]signInScreen:self];
    }
    else {
        [MMAPI getCategoriesOnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Received Categories");
            self.categories = responseObject;
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            if ([[response valueForKey:@"status"] isEqualToString:@"Unauthorized"]) {
                [[MMClientSDK sharedSDK] signInScreen:self];
            }
        }];
    }
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
  UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:mvc];
  [self.navigationController presentViewController:navc animated:YES completion:nil];
}

- (void)showSearchResultsForCategory:(NSDictionary *)category
{
    double latitude, longitude;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSData* jsonData;
    id jsonObject;
    
    [self.searchBar resignFirstResponder];
    if (!self.searchResultsViewController) {
        self.searchResultsViewController = [[MMLocationsViewController alloc] initWithNibName:@"MMLocationsViewController" bundle:nil];
    }
    self.searchResultsViewController.locations = [NSMutableArray array];
    [self.searchResultsViewController.tableView reloadData];
    self.searchResultsViewController.isSearching = YES;
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
        
        [params setValue:@"" forKey:@"categoryIds"];
    }
    [params setValue:self.searchBar.text forKey:@"name"];
    latitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"]doubleValue];
    longitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"]doubleValue];
    NSLog(@"%f, %f", latitude, longitude);
    
    [params setValue:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
    [params setValue:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
    if ([self.filters valueForKey:@"radius"]) {
        [params setObject:[self.filters valueForKey:@"radius"] forKey:@"radiusInYards"];
    }
    else {
    [params setValue:[NSNumber numberWithInt:10000] forKey:@"radiusInYards"];
    }
    jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSLog(@"%@", jsonObject);
    [MMAPI searchForLocation:params success:^(id responseObject) {
        self.searchResultsViewController.isSearching = NO;
        [SVProgressHUD dismiss];
        
        NSArray *responseObjectArray = responseObject;
        if (responseObjectArray.count < 1) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"No locations found" delegate:self.searchResultsViewController cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            // A hack because of AFNetworking
            if (responseObject) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
                responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
            
            // End of hack
            self.searchResultsViewController.locations = responseObject;
        }
    } failure:^(NSError *error) {
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
    return 2;
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
    switch (section) {
        case 0:
            numberOfRows = 1;
            break;
        case 1:
            numberOfRows = self.categories.count;
            break;
        default:
            numberOfRows = 0;
            break;
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
    switch (indexPath.section) {
        case 0:
            categoryName = @"Show All Nearby";
            break;
        case 1:
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                category = self.filteredCategories[indexPath.row];
            } else {
                category = self.categories[indexPath.row];
            }
            
            cell.imageView.image = [UIImage imageNamed:@"picture"];
            categoryName = [category[@"en"] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
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
    NSDictionary *category = nil;

    if (indexPath.section == 1) {
        category = self.categories[indexPath.row];
    }

    [self showSearchResultsForCategory:category];
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
    else if ([categoryName isEqualToString:@"Services and Supplies"]) {
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
@end
