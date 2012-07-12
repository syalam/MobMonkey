//
//  SearchViewController.m
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "MapViewController.h"
#import "FilterViewController.h"
#import "AppDelegate.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
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

    self.title = @"Search";
    
    headerView.clipsToBounds = YES;

    [self.tableView setTableHeaderView:headerView];
    
    filterButton = [[UIBarButtonItem alloc]initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterButtonClicked:)];
    self.navigationItem.leftBarButtonItem = filterButton;
    
    mapButton = [[UIBarButtonItem alloc]initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(mapButtonClicked:)];
    self.navigationItem.rightBarButtonItem = mapButton;
    
    cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonClicked:)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self performFactualQuery];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[SearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.iconImageView.image = [UIImage imageNamed:@"monkey.jpg"];
    cell.locationNameLabel.text = @"Majerle's";
    cell.timeLabel.text = @"10m ago";
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - Bar Button Action Methods
- (void)filterButtonClicked:(id)sender {
    FilterViewController *fvc = [[FilterViewController alloc]initWithNibName:@"FilterViewController" bundle:nil];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:fvc];
    [self.navigationController presentViewController:navc animated:YES completion:NULL];
}

- (void)mapButtonClicked:(id)sender {
    MapViewController *mvc = [[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:mvc];
    [self.navigationController presentViewController:nvc animated:YES completion:NULL];
}

- (void)cancelButtonClicked:(id)sender {
    self.navigationItem.leftBarButtonItem = filterButton;
    self.navigationItem.rightBarButtonItem = mapButton;
    [categoryTextField resignFirstResponder];
    [nearTextField resignFirstResponder];
    [headerView setFrame:CGRectMake(0, 0, 320, 44)];
    [self.tableView setTableHeaderView:headerView];
    
}

#pragma mark - Search Cell Delegate Methods
- (void)requestButtonClicked:(id)sender {
    
}

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.navigationItem.rightBarButtonItem = cancelButton;
    self.navigationItem.leftBarButtonItem = nil;
    [headerView setFrame:CGRectMake(0, 0, 320, 84)];
    [self.tableView setTableHeaderView:headerView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.navigationItem.leftBarButtonItem = filterButton;
    self.navigationItem.rightBarButtonItem = mapButton;
    [categoryTextField resignFirstResponder];
    [nearTextField resignFirstResponder];
    [headerView setFrame:CGRectMake(0, 0, 320, 44)];
    [self.tableView setTableHeaderView:headerView];
    
    return YES;
}

-(void)performFactualQuery
{
    FactualQuery* queryObject = [FactualQuery query];
    
    // set limit
    queryObject.limit = 50;
    
    // set geo location 
    CLLocationCoordinate2D coordinate = [AppDelegate getDelegate].currentLocation.coordinate;       
        
    // set geo filter 
    [queryObject setGeoFilter:coordinate radiusInMeters:100.0];
        
    // set the sort criteria 
    FactualSortCriteria* primarySort = [[FactualSortCriteria alloc] initWithFieldName:@"$relevance" sortOrder:FactualSortOrder_Ascending];
    [queryObject setPrimarySortCriteria:primarySort];
    
    // full text term  
    [queryObject addFullTextQueryTerms:@"coffee", nil];
    
    // check if locality filter is on ... 
    [queryObject addRowFilter:[FactualRowFilter fieldName:@"country" equalTo:@"US"]];    
    
    // check if category filter is on ... 
    [queryObject addRowFilter:[FactualRowFilter fieldName:@"category" beginsWith:@"Food & Beverage"]];
        
    // start the request ... 
    _activeRequest = [[AppDelegate getAPIObject] queryTable:@"global" optionalQueryParams:queryObject withDelegate:self];
}

#pragma mark -
#pragma mark FactualAPIDelegate methods

- (void)requestDidReceiveInitialResponse:(FactualAPIRequest *)request {
    NSLog(@"received factual response");
}

- (void)requestDidReceiveData:(FactualAPIRequest *)request { 
    NSLog(@"received factual data");
}

-(void) requestComplete:(FactualAPIRequest *)request failedWithError:(NSError *)error {
    NSLog(@"Active request failed with Error:%@", [error localizedDescription]);
}


-(void) requestComplete:(FactualAPIRequest *)request receivedQueryResult:(FactualQueryResult *)queryResultObj {
    NSLog(@"Active request Completed!");
}


@end
