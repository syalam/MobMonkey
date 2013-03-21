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


- (void)viewDidLoad
{
    [super viewDidLoad];
    SelectedInterestsKey = [NSString stringWithFormat:@"%@ selectedInterests", [[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    if (![userDefaults valueForKey:SelectedInterestsKey]) {
        [userDefaults setValue:[[NSMutableDictionary alloc] initWithCapacity:1] forKey:SelectedInterestsKey];
    }
    
    
    //Add custom back button to the nav bar
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    if (_addingLocation) {
        if (_selectedItems) {
            selectedItemsDictionary = [_selectedItems mutableCopy];
        }
        else {
            selectedItemsDictionary = [[NSMutableDictionary alloc]init];
        }
        UIImage *doneButtonImage = [[UIImage imageNamed:@"navBarButtonBlank"]
                                      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
        UIButton* doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.bounds = CGRectMake(0, 0, 80, 31);
        [doneButton setBackgroundImage:doneButtonImage forState:UIControlStateNormal];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton.titleLabel setTextColor:[UIColor whiteColor]];
        [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [doneButton.titleLabel setShadowColor:[UIColor darkGrayColor]];
        [doneButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
        self.navigationItem.rightBarButtonItem = doneBarButton;
    }
    else {
        selectedItemsDictionary = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults valueForKey:SelectedInterestsKey]];
    }
    
    /*UIImage *selectAllButtonBG = [[UIImage imageNamed:@"navBarButtonBlank"]
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
    self.navigationItem.rightBarButtonItem = selectAllBarButton;*/
    
    allCategories = [[NSUserDefaults standardUserDefaults]objectForKey:@"allCategories"];
    
    NSLog(@"%@", selectedItemsDictionary);
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
    checkMarkCount = 0;
    if (_subCategoryIndex) {
        categoriesArray = [[allCategories allValues] objectAtIndex:_subCategoryIndex];
        [self setTableContent];
    }
    else {
        categoriesArray = [allCategories allKeys];
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
- (void)backButtonTapped:(id)sender {
    [_delegate categoriesSelected:selectedItemsDictionary];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)toggleSelectAll:(id)sender
{
    UITableViewCell *cell;
    NSIndexPath *indexPath;
    NSDictionary *category;
    NSString *categoryName;
    NSArray *subCategories;
    
    if ([[selectAllButton titleLabel].text isEqualToString: @"Deselect All"]) {
        [selectAllButton setTitle:@"Select All" forState:UIControlStateNormal];
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        for (int i = 0; i < _contentList.count; i++) {
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            cell = [_tableView cellForRowAtIndexPath:indexPath];
            if (!_subCategoryIndex) {
                categoryName = [_contentList objectAtIndex:indexPath.row];
                if ([selectedItemsDictionary valueForKey:[NSString stringWithFormat:@"%@", categoryName]]) {
                    [selectedItemsDictionary setValue:nil forKey:[NSString stringWithFormat:@"%@", categoryName]];
                }
                if ([[[allCategories allValues]objectAtIndex:indexPath.row] count] > 1) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    subCategories = [[allCategories allValues]objectAtIndex:indexPath.row];
                    for (int j = 0; j < subCategories.count; j++) {
                        category = [subCategories objectAtIndex:j];
                        categoryName = category[@"en"];
                        if ([selectedItemsDictionary valueForKey:[NSString stringWithFormat:@"%@", categoryName]]) {
                            [selectedItemsDictionary setValue:nil forKey:[NSString stringWithFormat:@"%@", categoryName]];
                        }
                        
                    }
                    
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                }
                
            }
            else {
                categoryName = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"en"];
                if ([selectedItemsDictionary valueForKey:[NSString stringWithFormat:@"%@", categoryName]]) {
                    [selectedItemsDictionary setValue:nil forKey:[NSString stringWithFormat:@"%@", categoryName]];
                }
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
        }
    }
    else {
        [selectAllButton setTitle:@"Deselect All" forState:UIControlStateNormal];
        for (int i = 0; i < _contentList.count; i++) {
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            cell = [_tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            if (!_subCategoryIndex) {
                categoryName = [_contentList objectAtIndex:indexPath.row];
                if (![selectedItemsDictionary valueForKey:[NSString stringWithFormat:@"%@", categoryName]]) {
                    [selectedItemsDictionary setValue:categoryName forKey:[NSString stringWithFormat:@"%@", categoryName]];
                }
                if ([[[allCategories allValues]objectAtIndex:indexPath.row] count] > 1) {
                    subCategories = [[allCategories allValues]objectAtIndex:indexPath.row];
                    for (int j = 0; j < subCategories.count; j++) {
                        category = [subCategories objectAtIndex:j];
                        categoryName = category[@"en"];
                        if (![selectedItemsDictionary valueForKey:[NSString stringWithFormat:@"%@", categoryName]]) {
                            [selectedItemsDictionary setValue:categoryName forKey:[NSString stringWithFormat:@"%@", categoryName]];
                        }
                        
                    }
                    
                }
                
            }
            else {
                categoryName = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"en"];
                if (![selectedItemsDictionary valueForKey:[NSString stringWithFormat:@"%@", categoryName]]) {
                    [selectedItemsDictionary setValue:categoryName forKey:[NSString stringWithFormat:@"%@", categoryName]];
                }
            }
            
            category = [_contentList objectAtIndex:indexPath.row];
            categoryName = category[@"en"];
            [selectedItemsDictionary setValue:[category[@"categoryId"] description] forKey:[NSString stringWithFormat:@"%@", categoryName]];
            [_tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:selectedItemsDictionary forKey:SelectedInterestsKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    UIBarButtonItem *selectAllBarButton = [[UIBarButtonItem alloc] initWithCustomView:selectAllButton];
    self.navigationItem.rightBarButtonItem = selectAllBarButton;
}

- (void)doneButtonTapped:(id)sender {
    [_delegate categoriesSelected:selectedItemsDictionary];
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
    
    static NSString *CellIdentifier = @"Cell";
    MMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    cell.textLabel.text = nil;
    cell.imageView.image = [UIImage imageNamed:@"picture"];
    
    NSDictionary *category;
    NSString *categoryName;
    NSArray *subCategories = [[NSArray alloc]init];
    
    if (_subCategoryIndex) {
        category = _contentList[indexPath.row];
        categoryName = [category objectForKey:@"en"];
    }
    else {
        categoryName = _contentList[indexPath.row];
        subCategories = [[allCategories allValues]objectAtIndex:indexPath.row];
        
    }

    cell.textLabel.text = categoryName;
    cell.imageView.image = [self assignIconToSearchCategoryWithCategoryName:categoryName];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = categoryName;
        cell.imageView.image = [self assignIconToSearchCategoryWithCategoryName:categoryName];
    }
    if ([selectedItemsDictionary valueForKey:[NSString stringWithFormat:@"%@", categoryName]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        checkMarkCount++;
    }
    else if (subCategories.count > 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.row == _contentList.count - 1) {
        if (checkMarkCount == _contentList.count) {
            [selectAllButton setTitle:@"Deselect All" forState:UIControlStateNormal];
            UIBarButtonItem *selectAllBarButton = [[UIBarButtonItem alloc] initWithCustomView:selectAllButton];
            self.navigationItem.rightBarButtonItem = selectAllBarButton;
        }
        else {
            [selectAllButton setTitle:@"Select All" forState:UIControlStateNormal];
            UIBarButtonItem *selectAllBarButton = [[UIBarButtonItem alloc] initWithCustomView:selectAllButton];
            self.navigationItem.rightBarButtonItem = selectAllBarButton;
        }
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSDictionary *category;
        NSString *categoryName;
        NSArray *subCategories = [[NSArray alloc]init];
        if (_subCategoryIndex) {
            category = _contentList[indexPath.row];
            categoryName = [category objectForKey:@"en"];
        }
        else {
            categoryName = _contentList[indexPath.row];
            subCategories = [[allCategories allValues]objectAtIndex:indexPath.row];

        }


        if ([selectedItemsDictionary valueForKey:categoryName]) {
            [selectedItemsDictionary setValue:nil forKey:categoryName];
            if (subCategories.count <= 1) {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            }
            else {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                for (int j = 0; j < subCategories.count; j++) {
                    category = [subCategories objectAtIndex:j];
                    categoryName = category[@"en"];
                    if ([selectedItemsDictionary valueForKey:categoryName]) {
                        [selectedItemsDictionary setValue:nil forKey:categoryName];
                    }
                }
            }
            if (!_addingLocation) {
                [[NSUserDefaults standardUserDefaults] setValue:selectedItemsDictionary forKey:SelectedInterestsKey];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        }
        else {
            if (subCategories.count <= 1) {
                [selectedItemsDictionary setValue:categoryName forKey:categoryName];
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                
                if (!_addingLocation) {
                    [[NSUserDefaults standardUserDefaults] setValue:selectedItemsDictionary forKey:SelectedInterestsKey];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
            }
            else {
                MMCategoryViewController *mmcvc = [[MMCategoryViewController alloc]initWithNibName:@"MMCategoryViewController" bundle:nil];
                mmcvc.subCategoryIndex = indexPath.row;
                mmcvc.title = self.title;
                if (_addingLocation) {
                    mmcvc.addingLocation = YES;
                    mmcvc.selectedItems = selectedItemsDictionary;
                    mmcvc.delegate = self;
                }
                [self.navigationController pushViewController:mmcvc animated:YES];
            }
            
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
    else if ([categoryName isEqualToString:@"Beaches"]) {
        cellIconImage = [UIImage imageNamed:@"beachesIcon"];
    }
    else if ([categoryName isEqualToString:@"Dog Parks"]) {
        cellIconImage = [UIImage imageNamed:@"dogParksIcon"];
    }
    else if ([categoryName isEqualToString:@"Restaurants"]) {
        cellIconImage = [UIImage imageNamed:@"restaurantsIcon"];
    }
    else if ([categoryName isEqualToString:@"Pubs/Bars"]) {
        cellIconImage = [UIImage imageNamed:@"pubsIcon"];
    }
    else if ([categoryName isEqualToString:@"Middle Schools & High Schools"]) {
        cellIconImage = [UIImage imageNamed:@"schoolsIcon"];
    }
    else if (!([categoryName rangeOfString:@"Stadiums"].location == NSNotFound)) {
        cellIconImage = [UIImage imageNamed:@"stadiumsIcon"];
    }
    else if ([categoryName isEqualToString:@"Nightclubs"]) {
        cellIconImage = [UIImage imageNamed:@"nightclubsIcon"];
    }
    else if ([categoryName isEqualToString:@"Health Clubs"]) {
        cellIconImage = [UIImage imageNamed:@"healthClubsIcon"];
    }
    else if ([categoryName isEqualToString:@"Coffee Shops"]) {
        cellIconImage = [UIImage imageNamed:@"coffeeShopsIcon"];
    }
    else if ([categoryName isEqualToString:@"Hotels"]) {
        cellIconImage = [UIImage imageNamed:@"hotelsIcon"];
    }
    else if ([categoryName isEqualToString:@"Supermarkets"]) {
        cellIconImage = [UIImage imageNamed:@"supermarketsIcon"];
    }
    else if ([categoryName isEqualToString:@"Conferences"]) {
        cellIconImage = [UIImage imageNamed:@"conferencesIcon"];
    }
    else if ([categoryName isEqualToString:@"Cinemas"]) {
        cellIconImage = [UIImage imageNamed:@"cinemasIcon"];
    }
    return cellIconImage;
}

#pragma mark - MMCategoryViewController delegate 
- (void)categoriesSelected:(NSMutableDictionary*)selectedCategories {
    selectedItemsDictionary = [selectedCategories mutableCopy];
}


@end
