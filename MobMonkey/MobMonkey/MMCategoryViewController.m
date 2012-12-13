//
//  MMCategoryViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/10/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMCategoryViewController.h"
#import "MMCategoryCell.h"

@interface MMCategoryViewController ()

@end

@implementation MMCategoryViewController

static NSString *const SelectedInterestsKey = @"selectedInterests";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"My Interests";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    if (![userDefaults valueForKey:SelectedInterestsKey]) {
        [userDefaults setValue:[[NSMutableDictionary alloc] initWithCapacity:1] forKey:SelectedInterestsKey];
    }
    selectedItemsDictionary = [[userDefaults valueForKey:SelectedInterestsKey] mutableCopy];
    
    //Add custom back button to the nav bar
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    allCategoriesArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"allCategories"];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [SVProgressHUD dismiss];
    
    /*[MMAPI getCategoriesOnSuccess:^(AFHTTPRequestOperation *operation, id response) {
        categoriesArray = response;
        [self setTableContent];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];*/
    if (!_parentId || [_parentId isEqualToString:@"1"]) {
        NSString *parent = [NSString stringWithFormat:@"[%@]", @"1"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parents CONTAINS %@", parent];
        categoriesArray = [allCategoriesArray filteredArrayUsingPredicate:predicate];
        [self setTableContent];
    }
    else {
        UIImage *selectAllButtonBG = [[UIImage imageNamed:@"navBarButtonBlank"]
                                      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
        selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectAllButton.bounds = CGRectMake(0, 0, 80, 31);
        [selectAllButton setBackgroundImage:selectAllButtonBG forState:UIControlStateNormal];
        [selectAllButton setTitle:@"Select All" forState:UIControlStateNormal];
        [selectAllButton.titleLabel setTextColor:[UIColor whiteColor]];
        [selectAllButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [selectAllButton.titleLabel setShadowColor:[UIColor darkGrayColor]];
        [selectAllButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [selectAllButton addTarget:self action:@selector(toggleSelectAll:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *selectAllBarButton = [[UIBarButtonItem alloc] initWithCustomView:selectAllButton];
        self.navigationItem.rightBarButtonItem = selectAllBarButton;
        
        self.navigationItem.rightBarButtonItem = selectAllBarButton;
        NSString *parent = [NSString stringWithFormat:@"[%@]", _parentId];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parents CONTAINS %@", parent];
        categoriesArray = [allCategoriesArray filteredArrayUsingPredicate:predicate];
        [self setTableContent];

    }

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

#pragma mark - Button taps
- (void)toggleSelectAll:(id)sender
{
    UITableViewCell *cell;
    NSIndexPath *indexPath;
    if ([[selectAllButton titleLabel].text isEqualToString: @"Deselect All"]) {
        [selectAllButton setTitle:@"Select All" forState:UIControlStateNormal];
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        for (int i = 0; i < _contentList.count; i++) {
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            cell = [_tableView cellForRowAtIndexPath:indexPath];
            if (cell.accessoryType != UITableViewCellAccessoryDisclosureIndicator) {
                if ([selectedItemsDictionary valueForKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]]) {
                    [selectedItemsDictionary setValue:nil forKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    [[NSUserDefaults standardUserDefaults] setValue:selectedItemsDictionary forKey:SelectedInterestsKey];
                }

            }

        }
    }
    else {
        [selectAllButton setTitle:@"Deselect All" forState:UIControlStateNormal];
        for (int i = 0; i < _contentList.count; i++) {
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            cell = [_tableView cellForRowAtIndexPath:indexPath];
            if (cell.accessoryType != UITableViewCellAccessoryDisclosureIndicator) {
                if (cell.accessoryType != UITableViewCellAccessoryDisclosureIndicator) {
                    NSDictionary *favorite = [_contentList objectAtIndex:indexPath.row];
                    [selectedItemsDictionary setValue:[favorite[@"categoryId"] description] forKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]];
                    [_tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                    [[NSUserDefaults standardUserDefaults] setValue:selectedItemsDictionary forKey:SelectedInterestsKey];
                }

            }
        }
    }
    UIBarButtonItem *selectAllBarButton = [[UIBarButtonItem alloc] initWithCustomView:selectAllButton];
    self.navigationItem.rightBarButtonItem = selectAllBarButton;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *favorite = [_contentList objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    MMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    cell.textLabel.text = nil;
    cell.imageView.image = [UIImage imageNamed:@"picture"];
    
    NSString *categoryId = favorite[@"categoryId"];
    categoryId = [NSString stringWithFormat:@"[%@]", categoryId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parents CONTAINS %@", categoryId];
    NSArray *subCategories = [allCategoriesArray filteredArrayUsingPredicate:predicate];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [favorite[@"en"] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        cell.imageView.image = [self assignIconToSearchCategoryWithCategoryName:[favorite[@"en"] stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
    }
    if ([selectedItemsDictionary valueForKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]] && subCategories.count == 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else if (subCategories.count > 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([tableView cellForRowAtIndexPath:indexPath].accessoryType != UITableViewCellAccessoryDisclosureIndicator) {
            if ([selectedItemsDictionary valueForKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]]) {
                [selectedItemsDictionary setValue:nil forKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]];
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            }
            else {
                NSDictionary *favorite = [_contentList objectAtIndex:indexPath.row];
                
                [selectedItemsDictionary setValue:[favorite[@"categoryId"] description] forKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]];
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            }
            [[NSUserDefaults standardUserDefaults] setValue:selectedItemsDictionary forKey:SelectedInterestsKey];
        }
        else {
            MMCategoryViewController *mmcvc = [[MMCategoryViewController alloc]initWithNibName:@"MMCategoryViewController" bundle:nil];
            NSDictionary *category = [_contentList objectAtIndex:indexPath.row];
            mmcvc.parentId = category[@"categoryId"];
            [self.navigationController pushViewController:mmcvc animated:YES];
        }
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    /*if(section == 1 || section == 2)
        return @" ";
    else
        return nil;*/
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    else {
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 7;
}

#pragma mark - Helper Methods
- (void)setTableContent {
  NSLog(@"categoriesArray: %@", categoriesArray); // asdf
  
    [self setContentList:[categoriesArray mutableCopy]];
    [self.tableView reloadData];
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


@end
