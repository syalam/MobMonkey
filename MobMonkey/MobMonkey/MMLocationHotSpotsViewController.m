//
//  MMLocationHotSpotsViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 4/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMLocationHotSpotsViewController.h"
#import "MMHotSpotInformation.h"
#import "MMEditHotSpotViewController.h"
#import "MMLocationViewController.h"
#import "UIBarButtonItem+NoBorder.h"
#import "MMCreateHotSpotMapViewController.h"

@interface MMLocationHotSpotsViewController ()

@end

@implementation MMLocationHotSpotsViewController

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
    
    self.title = [NSString stringWithFormat:@"Existing Hot Spots"];
    
    UIBarButtonItem *menuItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"whiteBackButton"] selectedImage:nil target:self.navigationController action:@selector(popViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = menuItem;
    
    self.view.backgroundColor = [UIColor MMEggShell];
    self.tableView.backgroundView = nil;

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.hotSpots.count > 0 ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0){
        return self.hotSpots.count;
    }else if(section == 1){
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0: {
            MMHotSpotInformation *hotSpot = [self.hotSpots objectAtIndex:indexPath.row];
            cell.textLabel.text = hotSpot.name;
            break;
        }
        case 1:
            cell.textLabel.text = @"Create Hot-Spot";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            
        default:
            break;
    }
    
    
    // Configure the cell...
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Existing Hot Spots";
            break;
            
        default:
            return nil;
            break;
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
    
    if(indexPath.section == 1){
        MMCreateHotSpotMapViewController *editHotSpotVC = [[MMCreateHotSpotMapViewController alloc] initWithNibName:nil bundle:nil];
        editHotSpotVC.parentLocationInformation = self.parentLocation;
        [self.navigationController pushViewController:editHotSpotVC animated:YES];
    }else if(indexPath.section == 0){
        MMLocationInformation *subLocationInformation = [self.hotSpots objectAtIndex:indexPath.row];
        MMLocationViewController *locationViewController = [[MMLocationViewController alloc] initWithStyle:UITableViewStyleGrouped];
        locationViewController.locationInformation = subLocationInformation;
        UINavigationController *navController = self.navigationController;
        [self.navigationController popToRootViewControllerAnimated:NO];
        [navController pushViewController:locationViewController animated:YES];
    }
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
