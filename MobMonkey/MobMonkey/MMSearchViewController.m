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

@interface MMSearchViewController ()

@property (strong, nonatomic) NSArray           *categories;
@property (strong, nonatomic) NSArray           *sections;
@property (strong, nonatomic) NSArray           *filteredCategories;
@property (strong, nonatomic) NSString          *savedSearchTerm;
@property (assign, nonatomic) BOOL              searchWasActive;

@property (strong, nonatomic) MMLocationsViewController *searchResultsViewController;

- (void)showFilterView:(id)sender;
- (void)showSearchResultsForCategory:(NSString *)category;

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
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(showFilterView:)];
    self.navigationItem.leftBarButtonItem = filterButton;
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

- (void)showSearchResultsForCategory:(NSString *)category
{
    [self.searchBar resignFirstResponder];
    if (!self.searchResultsViewController) {
        self.searchResultsViewController = [[MMLocationsViewController alloc] initWithNibName:@"MMLocationsViewController" bundle:nil];
    }
    self.searchResultsViewController.locations = [NSMutableArray array];
    [self.searchResultsViewController.tableView reloadData];
    self.searchResultsViewController.isSearching = YES;
    if (category) {
        self.searchResultsViewController.title = category;
    } else {
        self.searchResultsViewController.title = [NSString stringWithFormat:@"“%@”", self.searchBar.text];
    }
    
    double latitude = [[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"]doubleValue];
    double longitude = [[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]doubleValue];
    NSLog(@"%f, %f", latitude, longitude);
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.searchBar.text forKey:@"name"];
    [params setValue:[NSNumber numberWithDouble:latitude]forKey:@"latitude"];
    [params setValue:[NSNumber numberWithDouble:longitude]forKey:@"longitude"];
    if ([self.filters valueForKey:@"radius"]) {
        [params setObject:[self.filters valueForKey:@"radius"] forKey:@"radiusInYards"];
    }
    else {
    [params setValue:[NSNumber numberWithInt:200] forKey:@"radiusInYards"];
    }
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSLog(@"%@", jsonObject);
    [MMAPI searchForLocation:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.searchResultsViewController.isSearching = NO;
        [SVProgressHUD dismiss];
        
        // A hack because of AFNetworking
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
        responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        // End of hack
        self.searchResultsViewController.locations = responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismissWithError:[error description]];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSInteger numberOfRows;
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
    return self.categories.count;
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        category = self.filteredCategories[indexPath.row];
    } else {
        category = self.categories[indexPath.row];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"picture"];
    cell.textLabel.text = [category valueForKey:@"name"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView && indexPath.section == 0) {
        [self showSearchResultsForCategory:nil];
        return;
    }
    [self showSearchResultsForCategory:[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]];
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
