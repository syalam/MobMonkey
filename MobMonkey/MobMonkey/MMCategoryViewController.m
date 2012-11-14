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
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [MMAPI getCategoriesOnSuccess:^(AFHTTPRequestOperation *operation, id response) {
        categoriesArray = response;
        [self setTableContent];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
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
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [favorite[@"en"] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if ([cell.textLabel.text isEqualToString:@"Show All Nearby"]) {
            cell.imageView.image = [UIImage imageNamed:@"myLocationsIcon"];
        }
        if ([cell.textLabel.text isEqualToString:@"Coffee Shops"]) {
            cell.imageView.image = [UIImage imageNamed:@"coffeeShopsIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Retail"]) {
            cell.imageView.image = [UIImage imageNamed:@"supermarketsIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Travel"]) {
            cell.imageView.image = [UIImage imageNamed:@"beachesIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Community and Government"] || [cell.textLabel.text isEqualToString:@"Landmarks"]) {
            cell.imageView.image = [UIImage imageNamed:@"schoolsIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Services and Supplies"]) {
            cell.imageView.image = [UIImage imageNamed:@"historyIcon"];
        }
        else if (!([cell.textLabel.text rangeOfString:@"Automotive"].location == NSNotFound)) {
            cell.imageView.image = [UIImage imageNamed:@"editedCinemasIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Social"]) {
            cell.imageView.image = [UIImage imageNamed:@"coffeeShopsIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Healthcare"]) {
            cell.imageView.image = [UIImage imageNamed:@"hotelsIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Sports and Recreation"]) {
            cell.imageView.image = [UIImage imageNamed:@"stadiumsIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Transportation"]) {
            cell.imageView.image = [UIImage imageNamed:@"locationsOfInterestIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Education"]) {
            cell.imageView.image = [UIImage imageNamed:@"conferencesIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Art Dealers & Galleries"]) {
            cell.imageView.image = [UIImage imageNamed:@"nightclubsIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Pools & Spas"]) {
            cell.imageView.image = [UIImage imageNamed:@"beachesIcon"];
        }

    }
    if ([selectedItemsDictionary valueForKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([selectedItemsDictionary valueForKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]]) {
            [selectedItemsDictionary setValue:nil forKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]];
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        }
        else {
            NSDictionary *favorite = [_contentList objectAtIndex:indexPath.row];
            
            [selectedItemsDictionary setValue:[favorite[@"categoryId"] description] forKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]];
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:selectedItemsDictionary forKey:SelectedInterestsKey];
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
    [self setContentList:[categoriesArray mutableCopy]];
    [self.tableView reloadData];
}

@end
