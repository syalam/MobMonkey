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
#import "LocationViewController.h"
#import "SignUpViewController.h"

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
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background~iphone"]]];
    
    UIButton *filterNavBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [filterNavBarButton setFrame:CGRectMake(0, 0, 52, 30)];
    [filterNavBarButton setBackgroundImage:[UIImage imageNamed:@"FilterBtn~iphone"] forState:UIControlStateNormal];
    [filterNavBarButton addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    filterButton = [[UIBarButtonItem alloc]initWithCustomView:filterNavBarButton];
    self.navigationItem.leftBarButtonItem = filterButton;
    
    UIButton *mapNavBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mapNavBarButton setFrame:CGRectMake(0, 0, 33, 30)];
    [mapNavBarButton setBackgroundImage:[UIImage imageNamed:@"GlobeBtn~iphone"] forState:UIControlStateNormal];
    [mapNavBarButton addTarget:self action:@selector(mapButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    mapButton = [[UIBarButtonItem alloc]initWithCustomView:mapNavBarButton];
    self.navigationItem.rightBarButtonItem = mapButton;
    
    cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonClicked:)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    prefs = [NSUserDefaults standardUserDefaults];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //add nav bar view and button
    UIView *navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(37, 9.5, 127, 25)];
    notificationsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(titleImageView.frame.origin.x + titleImageView.frame.size.width, 9.5, 18, 18)];
    notificationsCountLabel = [(AppDelegate *)[[UIApplication sharedApplication] delegate] notificationsCountLabel];
    notificationsCountLabel.frame = notificationsImageView.frame;
    
    notificationsImageView.image = [UIImage imageNamed:@"Notifications~iphone"];
    
    titleImageView.image = [UIImage imageNamed:@"logo~iphone"];
    titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIButton *mmNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mmNavButton setFrame:titleImageView.frame];
    [mmNavButton addTarget:self action:@selector(notificationsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [navBarView addSubview:titleImageView];
    [navBarView addSubview:notificationsImageView];
    [navBarView addSubview:notificationsCountLabel];
    [navBarView addSubview:mmNavButton];
    
    self.navigationItem.titleView = navBarView;
    
    if ([notificationsCountLabel.text isEqualToString:@"0"] || !notificationsCountLabel.text) {
        [notificationsCountLabel setHidden:YES];
        [notificationsImageView setHidden:YES];
    }

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
    return _queryResult.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
    {
        cell = [[SearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    
    if (_queryResult != nil) {
        FactualRow* row = [_queryResult.rows objectAtIndex:indexPath.row];
        cell.locationNameLabel.text = [row valueForName:@"name"];
        
        cell.requestButton.tag = indexPath.row;
        
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
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
    /*LocationViewController* lvc = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
    lvc.venueData = [_queryResult.rows objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:lvc animated:YES];*/
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 98;
}

#pragma mark - Bar Button Action Methods
- (void)filterButtonClicked:(id)sender {
    FilterViewController *fvc = [[FilterViewController alloc]initWithNibName:@"FilterViewController" bundle:nil];
    fvc.delegate = self;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:fvc];
    [self.navigationController presentViewController:navc animated:YES completion:NULL];
}

- (void)mapButtonClicked:(id)sender {
    MapViewController *mvc = [[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:mvc];
    [self.navigationController presentViewController:nvc animated:YES completion:NULL];
}

- (void)cancelButtonClicked:(id)sender {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration: 0.2];
    [UIView setAnimationDelegate: self];

    self.navigationItem.leftBarButtonItem = filterButton;
    self.navigationItem.rightBarButtonItem = mapButton;
    [categoryTextField resignFirstResponder];
    [nearTextField resignFirstResponder];
    [headerView setFrame:CGRectMake(0, 0, 320, 44)];
    [self.tableView setTableHeaderView:headerView];
    
    [UIView commitAnimations];
}

- (void)notificationsButtonTapped:(id)sender {
    UIViewController * target = [[self.tabBarController viewControllers] objectAtIndex:0];
    [target.navigationController popToRootViewControllerAnimated: NO];
    [self.tabBarController setSelectedIndex:0];
    
    /*NSArray *navViewControllers = [self.tabBarController viewControllers];
    UINavigationController *homeNavC = [navViewControllers objectAtIndex:0];
    HomeViewController *homeScreen = [homeNavC.viewControllers objectAtIndex:0];
    [homeScreen notificationsButtonTapped:nil];*/
}

#pragma mark - Search Cell Delegate Methods
- (void)requestButtonClicked:(id)sender {
    LocationViewController* lvc = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
    lvc.venueData = [_queryResult.rows objectAtIndex:[sender tag]];
    [self.navigationController pushViewController:lvc animated:YES];
}

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration: 0.2];
    [UIView setAnimationDelegate: self];
    self.navigationItem.leftBarButtonItem = nil;
    [headerView setFrame:CGRectMake(0, 0, 320, 84)];
    [self.tableView setTableHeaderView:headerView];
    [UIView commitAnimations];
    
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration: 0.2];
    [UIView setAnimationDelegate: self];
    
    self.navigationItem.leftBarButtonItem = filterButton;
    self.navigationItem.rightBarButtonItem = mapButton;
    [categoryTextField resignFirstResponder];
    [nearTextField resignFirstResponder];
    [headerView setFrame:CGRectMake(0, 0, 320, 44)];
    [self.tableView setTableHeaderView:headerView];
    
    [UIView commitAnimations];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self performFactualQuery];
}

-(void)performFactualQuery
{

    FactualQuery* queryObject = [FactualQuery query];
    
    // set limit
    queryObject.limit = 50;
    
    // set geo location 
    CLLocationCoordinate2D coordinate = [AppDelegate getDelegate].currentLocation.coordinate;  
        
    // set geo filter 
    if ([prefs integerForKey:@"filteredRadius"] <= 0) {
        [queryObject setGeoFilter:coordinate radiusInMeters:100000.0];
    }
    else{
        [queryObject setGeoFilter:coordinate radiusInMeters:[prefs doubleForKey:@"filteredRadius"]];
    }
        
    // set the sort criteria 
    FactualSortCriteria* primarySort = [[FactualSortCriteria alloc] initWithFieldName:@"$relevance" sortOrder:FactualSortOrder_Ascending];
    [queryObject setPrimarySortCriteria:primarySort];
    
    // full text term  
    [queryObject addFullTextQueryTerms:categoryTextField.text,nil];
    
    // check if locality filter is on ... 
    [queryObject addRowFilter:[FactualRowFilter fieldName:@"country" equalTo:@"US"]];    
    
    // check if category filter is on ... 
    if ([prefs valueForKey:@"filteredCategory"] != nil) 
        [queryObject addRowFilter:[FactualRowFilter fieldName:@"category" beginsWith:[prefs valueForKey:@"filteredCategory"]]];
        
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
    _queryResult = queryResultObj;
    [self.tableView reloadData];
}

#pragma mark - FilterViewDelegate
-(void)performSearchFromFilteredQuery
{
    [self performFactualQuery];
}

@end
