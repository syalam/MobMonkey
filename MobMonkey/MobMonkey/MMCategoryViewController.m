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

- (void)notificationSwitchChangedValue:(id)sender;

@end

@implementation MMCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedItemsDictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    
    //Add custom back button to the nav bar
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
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
    return _contentList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *sectionContent = [_contentList objectAtIndex:section];
    return sectionContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionContent = [_contentList objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionContent objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    MMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *notificationSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [notificationSwitch setOnTintColor:[UIColor colorWithRed:230.0/255.0 green:113.0/255.0 blue:34.0/255.0 alpha:1.0]];
        [notificationSwitch addTarget:self action:@selector(notificationSwitchChangedValue:) forControlEvents:UIControlEventValueChanged];
        [notificationSwitch sizeToFit];
        cell.accessoryView = notificationSwitch;
    }
    cell.textLabel.text = nil;
    cell.imageView.image = [UIImage imageNamed:@"picture"];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [contentForThisRow valueForKey:@"name"];
    }
    else {
        cell.textLabel.text = contentForThisRow;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if ([selectedItemsDictionary valueForKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]]) {
        [(UISwitch *)[cell accessoryView] setOn:YES];
    } else {
        [(UISwitch *)[cell accessoryView] setOn:NO];
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if ([selectedItemsDictionary objectForKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]]) {
            [selectedItemsDictionary removeObjectForKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]];
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        }
        else {
            [selectedItemsDictionary setObject:@"YES" forKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]];
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
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
    NSMutableArray *sectionTwoArray = [categoriesArray mutableCopy];
    
    NSMutableArray *sectionThreeArray = [[NSMutableArray alloc]initWithObjects:@"History", @"My Locations", @"Events", @"Locations of Interest", nil];
    
    NSMutableArray *tableContentArray = [NSMutableArray arrayWithObjects:sectionTwoArray, sectionThreeArray, nil];
    
    [self setContentList:tableContentArray];
    [self.tableView reloadData];
}


#pragma mark - UINav Bar Action Methods
- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)notificationSwitchChangedValue:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[[sender superview] superview] superview]];
    [selectedItemsDictionary setValue:[NSNumber numberWithBool:[(UISwitch *)sender isOn]] forKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]];
}

@end
