//
//  SettingsViewController.m
//  MobMonkey
//
//  Created by Sheehan Alam on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "SignUpViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize contentList = _contentList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    selectionDictionary = [[NSMutableDictionary alloc]init];
    
    NSArray *socialNetworksArray = [NSArray arrayWithObjects:@"Facebook", @"Twitter", nil];
    NSArray *favoritesArray = [NSArray arrayWithObjects:@"Clubs", @"Coffee Shops", @"Concerts", @"Taco Shops", nil];
    NSMutableArray *tableContentArray = [NSMutableArray arrayWithObjects:socialNetworksArray, favoritesArray, nil];
    
    [self setContentList:tableContentArray];
    
    self.title = @"Settings";
    
    

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
    // Return the number of sections.
    return _contentList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *sectionContent = [_contentList objectAtIndex:section];
    
    return sectionContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionConent = [_contentList objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionConent objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = contentForThisRow;
    
    if (indexPath.section == 0) {
        UISwitch *socialSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(215, 9, 0, 0)];
        [socialSwitch setOn:NO];
        socialSwitch.tag = indexPath.row;
        [cell.contentView addSubview:socialSwitch];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Social Networks";
    }
    else {
        return @"Favorite Categories";
    }
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    if (indexPath.section == 1) {
        if ([selectionDictionary valueForKey:[NSString stringWithFormat:@"%d", indexPath.row]]) {
            [selectionDictionary removeObjectForKey:[NSString stringWithFormat:@"%d", indexPath.row]];
            [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        }
        else {
            [selectionDictionary setObject:@"selected" forKey:[NSString stringWithFormat:@"%d", indexPath.row]];
            [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
}

#pragma mark - UIBarButtonItem Action Methods
- (void)signInButtonClicked:(id)sender {
    SignUpViewController *signUpVc = [[SignUpViewController alloc]initWithNibName:@"SignUpViewController" bundle:nil];
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:signUpVc];
    [self.navigationController presentViewController:navC animated:YES completion:NULL];
}

- (void)signOutButtonClicked:(id)sender {
    [PFUser logOut];
    [self setNavButtons];
}

#pragma mark - Helper Methods
- (void)setNavButtons {
    if ([PFUser currentUser]) {
        UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc]initWithTitle:@"Sign Out" style:UIBarButtonItemStyleBordered target:self action:@selector(signOutButtonClicked:)];
        self.navigationItem.rightBarButtonItem = signOutButton;
    }
    else {
        UIBarButtonItem *signInButton = [[UIBarButtonItem alloc]initWithTitle:@"Sign Up" style:UIBarButtonItemStyleBordered target:self action:@selector(signInButtonClicked:)];
        self.navigationItem.rightBarButtonItem = signInButton;
        self.navigationItem.leftBarButtonItem = nil;
    }
}

@end
