//
//  MMEditHotSpotViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 5/2/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMEditHotSpotViewController.h"
#import "MMTextFieldCell.h"

@interface MMEditHotSpotViewController ()

@end

@implementation MMEditHotSpotViewController

@synthesize parentLocation = _parentLocation;
@synthesize sublocationInformation;

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
    
    self.title = @"New Hot Spot";
    
    self.sublocationInformation = [[MMLocationInformation alloc] init];

    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    self.tableView.backgroundView = nil;
    
    
    self.mapSelectView = [[MMMapSelectView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    self.tableView.tableHeaderView = self.mapSelectView;
    self.mapSelectView.parentLocation = self.parentLocation;
    self.mapSelectView.delegate =self;
    
    self.cellLabels = @[@"Name", @"Description", @"Range"];
    
    createSubLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, 50)];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"deselectedRectRed@2x"];
    [createSubLocationButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [createSubLocationButton setTitle:@"Create Hot Spot" forState:UIControlStateNormal];
    //createSubLocationButton.backgroundColor = [UIColor redColor];
    [createSubLocationButton addTarget:self action:@selector(createSubLocation:) forControlEvents:UIControlEventTouchUpInside];

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    
    [footerView addSubview:createSubLocationButton];
    self.tableView.tableFooterView = footerView;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)createSubLocation:(id)sender{
    
    if(!sublocationInformation.latitude){
        sublocationInformation.latitude = self.parentLocation.latitude;
    }
    
    if(!sublocationInformation.longitude){
         sublocationInformation.longitude = self.parentLocation.longitude;
    }
    
   
    
    
    sublocationInformation.name = [[((MMTextFieldCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]])textField]text];
    sublocationInformation.details = [[((MMTextFieldCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]])textField]text];
    sublocationInformation.parentLocation = self.parentLocation;
    sublocationInformation.locationID = nil;
    
    [SVProgressHUD showWithStatus:@"Creating Hot Spot"];
    [MMAPI createSubLocationWithLocationInformation:sublocationInformation success:^{
        [SVProgressHUD showSuccessWithStatus:@"Hot Spot Created"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Hot Spot Creation Failed"];
    }];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.cellLabels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MMTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[MMTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textField.placeholder = [self.cellLabels objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Hot Spot Details";
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
#pragma mark - Map Select View Delegate
-(void)mapSelectView:(MMMapSelectView *)mapSelectView didSelectLocation:(CLLocationCoordinate2D)coordinate{
    
    self.sublocationInformation.latitude = [NSNumber numberWithFloat:coordinate.latitude];
    self.sublocationInformation.longitude = [NSNumber numberWithFloat:coordinate.longitude];

}
@end
