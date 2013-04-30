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

-(void)loadNearByLocations{
    
    if(!self.nearbyLocations){
        [SVProgressHUD showWithStatus:@"Finding Nearby Locations"];
       
        MMLocationSearch *locationSearch = [[MMLocationSearch alloc] init];
        
        [locationSearch locationsForCategory:nil searchString:nil success:^(NSArray *locations) {
            
            self.nearbyLocations = locations;
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            
        } failure:^(NSError *error) {
            
            NSLog(@"Failed: %@", error);
            [SVProgressHUD showErrorWithStatus:@"Couldn't Load Nearby Locations"];
            
        }];
        
    }else{
        
        [self.tableView reloadData];
        
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Master Location";
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    self.tableView.backgroundView = nil;
    
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(section == 0){
        return self.nearbyLocations.count > 4 ? 5 : self.nearbyLocations.count;
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
    
    if(indexPath.section == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSection1];
        
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierSection1];
        }
        
        int lastRowInSectionZero = [tableView numberOfRowsInSection:0] - 1;
        if(indexPath.section == 0 && indexPath.row == lastRowInSectionZero){
            cell.textLabel.text = @"Load More";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }else{
            MMLocationInformation *locationInformation = [self.nearbyLocations objectAtIndex:indexPath.row];
            cell.textLabel.text = locationInformation.name;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSection2];
        
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierSection2];
        }
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"Add a New Location";
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.backgroundColor = [UIColor colorWithRed:1.000 green:0.645 blue:0.337 alpha:1.000];
        cell.backgroundColor = [UIColor colorWithRed:1.000 green:0.645 blue:0.337 alpha:1.000];
        return cell;
    }
    
    
    // Configure the cell...
    
   
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return @"Choose the Hot-Spot Location";
    }
    return nil;
}
#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 1){
        cell.backgroundColor = [UIColor colorWithRed:0.866 green:0.888 blue:0.901 alpha:1.000];
        for (UIView* view in cell.contentView.subviews) {
            view.backgroundColor = cell.backgroundColor;
        }
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0 && indexPath.row != self.nearbyLocations.count){
        MMLocationHotSpotsViewController *hotSpotsLocationVC = [[MMLocationHotSpotsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:hotSpotsLocationVC animated:YES];
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
