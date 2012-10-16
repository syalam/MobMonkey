//
//  MMSearchViewController.m
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/15/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMSearchViewController.h"

@interface MMSearchViewController ()

@property (strong, nonatomic) NSArray *categories;

- (void)showFilterView:(id)sender;

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

//    _filterNavBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_filterNavBarButton setFrame:CGRectMake(0, 0, 52, 30)];
//    [_filterNavBarButton setBackgroundImage:[UIImage imageNamed:@"FilterBtn~iphone"] forState:UIControlStateNormal];
//    [_filterNavBarButton addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.searchBar.backgroundImage = [UIImage imageNamed:@"SearchBG~iphone.png"];
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(showFilterView:)];
    self.navigationItem.leftBarButtonItem = filterButton;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:226.0/255.0
                                                                        green:112.0/225.0
                                                                         blue:36.0/255.0
                                                                        alpha:1.0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MMAPI getCategoriesOnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Received Categories");
        self.categories = responseObject;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showFilterView:(id)sender
{
    
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
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        CGFloat grey = 220.0/255.0;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor colorWithRed:grey green:grey blue:grey alpha:1.0];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
        cell.imageView.image = [UIImage imageNamed:@"picture"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *category = self.categories[indexPath.row];
    cell.textLabel.text = [category valueForKey:@"name"];
    
    return cell;
}

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

- (void)viewDidUnload {
    [self setSearchBar:nil];
    [super viewDidUnload];
}
@end
