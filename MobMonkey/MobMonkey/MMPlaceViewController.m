//
//  MMPlaceViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 5/22/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMPlaceViewController.h"
#import "MMNavigationBar.h"
#import "MMPlaceInformationCellView.h"
#import "UITableViewCell+CellShadows.h"
#import "MMPlaceInformationCell.h"
#import "MMPlaceInformationCellWrapper.h"

#define kMMPlaceInformationCellHeight 71.0f

@interface MMPlaceViewController ()

@end

@implementation MMPlaceViewController

-(id)initWithTableViewStyle:(UITableViewCellStyle)tableViewStyle defaultMapHeight:(CGFloat)defaultMapHeight parallaxFactor:(CGFloat)parallaxFactor {
    if(self = [super initWithTableViewStyle:tableViewStyle defaultMapHeight:defaultMapHeight parallaxFactor:parallaxFactor]){
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.tableBackground.backgroundColor = [UIColor MMEggShell];
    self.title = @"Testing";
    wrapper = [[MMPlaceInformationCellWrapper alloc] init];
    wrapper.nameText = @"Taco Bell";
    wrapper.address1Text = @"1234 Fake St.";
    wrapper.address2Text = @"Tempe, AZ 85282";
    wrapper.distanceText = @"2.3 miles";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    if(section == 0){
        return 3;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0 && indexPath.row == 0){
        static NSString *CellIdentifier = @"MMPlaceInformationCell";
		
        MMPlaceInformationCell *placeInformationCell = (MMPlaceInformationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (placeInformationCell == nil) {
            placeInformationCell = [[MMPlaceInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            placeInformationCell.frame = CGRectMake(0.0, 0.0, 320.0, kMMPlaceInformationCellHeight);
        }
        
        [placeInformationCell setPlaceInformationWrapper:wrapper];
        
        return placeInformationCell;
    }
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.section == 0 && indexPath.row == 0){
        MMPlaceInformationCellView *cellView = (MMPlaceInformationCellView *)[[[NSBundle mainBundle] loadNibNamed:@"MMPlaceInformationCellView" owner:self options:nil] lastObject];
        
        [cell.contentView addSubview:cellView];
    }

    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0){
        return kMMPlaceInformationCellHeight;
    }
    return UITableViewAutomaticDimension;
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

/*-(void)mapTableViewController:(MMMapTableViewController *)mapTableViewController didScrollOffMapView:(MKMapView *)mapView {
    MMNavigationBar *navBar = (MMNavigationBar*)self.navigationController.navigationBar;
    navBar.translucentFactor = 0.4;
}
-(void)mapTableViewController:(MMMapTableViewController *)mapTableViewController didScrollOnMapView:(MKMapView *)mapView {
    MMNavigationBar *navBar = (MMNavigationBar*)self.navigationController.navigationBar;
    navBar.translucentFactor = 0.2;
}*/
-(void)mapTableViewController:(MMMapTableViewController *)mapTableViewController isScrollingOffScreen:(MKMapView *)mapView visibility:(CGFloat)visibility {
    MMNavigationBar *navBar = (MMNavigationBar*)self.navigationController.navigationBar;
    navBar.translucentFactor = 1.0 - ((0.6 - 0.2) * visibility + 0.2);
}
@end
