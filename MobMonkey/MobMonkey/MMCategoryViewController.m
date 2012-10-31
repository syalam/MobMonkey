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
    
    
    if (![userDefaults valueForKey:@"selectedInterests"]) {
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
        cell.textLabel.text = [favorite valueForKey:@"name"];
        if ([cell.textLabel.text isEqualToString:@"Coffee Shops"]) {
            cell.imageView.image = [UIImage imageNamed:@"coffeeShopsIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Shopping"]) {
            cell.imageView.image = [UIImage imageNamed:@"supermarketsIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Travel & Tourism"]) {
            cell.imageView.image = [UIImage imageNamed:@"locationsOfInterestIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Community & Government"] || [cell.textLabel.text isEqualToString:@"Schools"]) {
            cell.imageView.image = [UIImage imageNamed:@"schoolsIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Lodging"]) {
            cell.imageView.image = [UIImage imageNamed:@"hotelsIcon"];
        }
        else if (!([cell.textLabel.text rangeOfString:@"Arts, Entertainment"].location == NSNotFound)) {
            cell.imageView.image = [UIImage imageNamed:@"cinemasIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Food & Beverage"] || [cell.textLabel.text isEqualToString:@"Restaurants"]) {
            cell.imageView.image = [UIImage imageNamed:@"restaurantsIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Health & Medicine"]) {
            cell.imageView.image = [UIImage imageNamed:@"healthClubsIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Sports & Recreation"]) {
            cell.imageView.image = [UIImage imageNamed:@"stadiumsIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Outdoor Recreation"]) {
            cell.imageView.image = [UIImage imageNamed:@"dogParksIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Education"]) {
            cell.imageView.image = [UIImage imageNamed:@"conferencesIcon"];
        }
        else if ([cell.textLabel.text isEqualToString:@"Art Dealers & Galleries"]) {
            cell.imageView.image = [UIImage imageNamed:@"nightClubsIcon"];
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
            [selectedItemsDictionary setValue:@"YES" forKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]];
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
