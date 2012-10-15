//
//  MMSocialNetworksViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/11/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMSocialNetworksViewController.h"

@interface MMSocialNetworksViewController ()

@end

@implementation MMSocialNetworksViewController

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
    NSArray *sectionOneArray = [[NSArray alloc]initWithObjects:@"Facebook", @"Twitter", nil];
    
    NSArray *tableContentArray = [NSArray arrayWithObjects:sectionOneArray, nil];
    
    [self setContentList:tableContentArray];
    
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
    NSArray *sectionContent = [_contentList objectAtIndex:section];
    return sectionContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionContent = [_contentList objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionContent objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    MMSocialNetworksCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MMSocialNetworksCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat grey = 220.0/255.0;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor colorWithRed:grey green:grey blue:grey alpha:1.0];
    }
    cell.mmSocialNetworkTextLabel.text = contentForThisRow;
    cell.mmSocialNetworkSwitch.tag = indexPath.row;
    switch (indexPath.row) {
        case 0:
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"facebookEnabled"]) {
                cell.mmSocialNetworkSwitch.on = YES;
            }
            else {
                cell.mmSocialNetworkSwitch.on = NO;
            }
            break;
        case 1:
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"twitterEnabled"]) {
                cell.mmSocialNetworkSwitch.on = YES;
            }
            else {
                cell.mmSocialNetworkSwitch.on = NO;
            }
            break;
        default:
            break;
    }
    
    // Configure the cell...
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - MMSocialNetworksCell delegate
- (void)mmSocialNetworksSwitchTapped:(id)sender {
    UISwitch *toggleSwitch = sender;
    switch ([sender tag]) {
        case 0:
            if (toggleSwitch.on) {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"facebookEnabled"];
            }
            else {
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"facebookEnabled"];
            }
            break;
        case 1:
            if (toggleSwitch.on) {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"twitterEnabled"];
            }
            else {
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"twitterEnabled"];
            }
            break;
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - UINavBar Action Methods
- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
