//
//  MMCreateHotSpotViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 4/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMCreateHotSpotViewController.h"
#import "MMLocationSearch.h"
#import "MMLocationHotSpotsViewController.h"
#import "MMEditHotSpotViewController.h"
#import "MMLocationListCell.h"
#import "MMCreateHotSpotMapViewController.h"

@interface MMCreateHotSpotViewController ()

@end

@implementation MMCreateHotSpotViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadNearbyLocations {
    MMLocationSearch *locationSearchModel = [[MMLocationSearch alloc] init];
    [locationSearchModel locationsInfoForCategory:nil searchString:nil success:^(NSArray *locationInformations) {
        self.nearbyLocations = locationInformations;
        [self.tableView reloadData];
        // [mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES]
        
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        NSLog(@"Failed: %@", error);
        [SVProgressHUD showErrorWithStatus:@"Failed to retreive locations"];
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.title = @"Master Location";
    
    self.view.backgroundColor = [UIColor MMEggShell];
    self.tableView.backgroundView = nil;
    
    numberOfLocations = 5;
    
    
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:)
            forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"]
                             forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadNearbyLocations];
}

-(void)showMoreLocations {
    
    int numberOfCellsToAdd;
    
    
    
    if (numberOfLocations + 5 < self.nearbyLocations.count) {
        numberOfCellsToAdd = 5;
    }else{
        numberOfCellsToAdd =  self.nearbyLocations.count - numberOfLocations;
    }
    
    NSMutableArray *cellIndexPaths = [NSMutableArray array];
    NSIndexPath *lastCellIndex = nil;
    
    for(int i=0; i < numberOfCellsToAdd; i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:numberOfLocations + i inSection:0];
        
        if(numberOfLocations + i == self.nearbyLocations.count - 1){
            lastCellIndex = indexPath;
        }else{
            [cellIndexPaths addObject:indexPath];
        }
        
    }
    
    numberOfLocations += numberOfCellsToAdd ;
    
    if(numberOfCellsToAdd > 0){
        
        [self.tableView beginUpdates];
        
        if(cellIndexPaths.count > 0){
            [self.tableView insertRowsAtIndexPaths:cellIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
        }
        
        
        if(lastCellIndex){
            NSIndexPath *lastIndex = [NSIndexPath indexPathForItem:[self.tableView numberOfRowsInSection:0]-1 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[lastIndex] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        [self.tableView endUpdates];
        
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(section == 0){
        return self.nearbyLocations.count > numberOfLocations ? numberOfLocations + 1 : self.nearbyLocations.count;

    }else if(section == 1){
        return 1;
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierSection1 = @"Section1";
    static NSString *CellIdentifierSection2 = @"Section2";
    
    if(indexPath.section == 0 && (indexPath.row != numberOfLocations || indexPath.row == self.nearbyLocations.count-1)){
        MMLocationListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSection1];
        
        if(cell == nil){
            cell = [[MMLocationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierSection1];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        MMLocationInformation *locationInformation = [self.nearbyLocations objectAtIndex:indexPath.row];
        [cell setLocationInformation:locationInformation];
        
        return cell;
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSection2];
        
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierSection2];
        }
        
        cell.textLabel.text = @"Load More";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    
    // Configure the cell...
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && (indexPath.row != numberOfLocations || indexPath.row == self.nearbyLocations.count-1)){
        return 80;
    }
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 55;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    for(UIView * view in cell.contentView.subviews){
        view.backgroundColor = [UIColor MMEggShell];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return @"Choose the Hot Spot Location";
    }
    return nil;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0 && indexPath.row != numberOfLocations){
        MMLocationInformation *parentLocation = [self.nearbyLocations objectAtIndex:indexPath.row];
        
        
        if(parentLocation.sublocations.count > 0){
            MMLocationHotSpotsViewController *hotSpotsLocationVC = [[MMLocationHotSpotsViewController alloc] initWithStyle:UITableViewStyleGrouped];
            hotSpotsLocationVC.parentLocation = parentLocation;
            hotSpotsLocationVC.hotSpots = parentLocation.sublocations.allObjects;
            [self.navigationController pushViewController:hotSpotsLocationVC animated:YES];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"No Hot Spots Found. Creating a New One"];
            MMCreateHotSpotMapViewController *editHotSpotVC = [[MMCreateHotSpotMapViewController alloc] initWithNibName:nil bundle:nil];
            editHotSpotVC.parentLocationInformation = parentLocation;
            [self.navigationController pushViewController:editHotSpotVC animated:YES];

        }
        
    }else{
        [self showMoreLocations];
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
