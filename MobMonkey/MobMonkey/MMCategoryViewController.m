//
//  MMCategoryViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/10/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMCategoryViewController.h"

@interface MMCategoryViewController ()

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
    
    
    NSMutableArray *sectionOneArray = [[NSMutableArray alloc]initWithObjects:@"Set Notifications", nil];
    NSMutableArray *sectionTwoArray = [[NSMutableArray alloc]initWithObjects:@"Health Clubs", @"Coffee Shops", @"Nightclubs", @"Pubs/Bars", @"Restaurants", @"Supermarkets", @"Cinemas", @"Dog Parks", @"Beaches", @"Hotels", @"Stadiums", @"Conferences" , @"Middle Schools & High Schools", nil];
    
    NSMutableArray *sectionThreeArray = [[NSMutableArray alloc]initWithObjects:@"History", @"My Locations", @"Events", @"Locations of Interest", nil];
    
    NSMutableArray *tableContentArray = [NSMutableArray arrayWithObjects:sectionOneArray, sectionTwoArray, sectionThreeArray, nil];
    
    [self setContentList:tableContentArray];
    
    selectedItemsDictionary = [[NSMutableDictionary alloc]initWithCapacity:1];
    
    
    //Add custom back button to the nav bar
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = nil;
    
    cell.textLabel.text = contentForThisRow;
    if ([selectedItemsDictionary objectForKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
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
    if ([selectedItemsDictionary objectForKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]]) {
        [selectedItemsDictionary removeObjectForKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]];
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        [selectedItemsDictionary setObject:@"YES" forKey:[NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row]];
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
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


#pragma mark - UINav Bar Action Methods
- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
