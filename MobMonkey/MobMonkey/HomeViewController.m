//
//  HomeViewController.m
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "LocationViewController.h"
#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize screen = _screen;
@synthesize pendingRequestsArray = _pendingRequestsArray;
@synthesize contentList = _contentList;
@synthesize queryResult = _queryResult;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    //set background color
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background~iphone"]]];
    
    //notificationScreen = [(AppDelegate *)[[UIApplication sharedApplication] delegate] requestsViewController];
    navViewControllers = [self.tabBarController viewControllers];
    UINavigationController *requestsNavC = [navViewControllers objectAtIndex:2];
    notificationScreen = [[RequestsViewController alloc]initWithNibName:@"RequestsViewController" bundle:nil];
    tabBarNotificationScreenInstance = (RequestsViewController*)[requestsNavC.viewControllers objectAtIndex:0];
    NSLog(@"%@", tabBarNotificationScreenInstance);
    
    
    //call query to grab nearby locations
    [self doQuery:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //add nav bar view and button
    UIView *navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(96.5, 9.5, 127, 25)];
    notificationsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(titleImageView.frame.origin.x + titleImageView.frame.size.width, 9.5, 18, 18)];
    //get the notification label instance from app delegate. We will be using this since this value will be updated on all screens
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
    [navBarView addSubview:mmNavButton];
    [navBarView addSubview:notificationsCountLabel];
    
    self.navigationItem.titleView = navBarView;
    
    if (!notificationsCountLabel.text || [notificationsCountLabel.text isEqualToString:@"0"]) {
        [notificationsCountLabel setHidden:YES];
        [notificationsImageView setHidden:YES];
    }

    NSLog(@"%@", self.title);
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
    NSLog(@"%d", _queryResult.rows.count);
    
    return _queryResult.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    HomeCell *cell = (HomeCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    FactualRow* row = [self.queryResult.rows objectAtIndex:indexPath.row];

    // Configure the cell...
    cell.locationNameLabel.text = [row valueForName:@"name"];
    cell.timeLabel.text = @"14m ago";
    
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
    FactualRow* venueData = [self.queryResult.rows objectAtIndex:indexPath.row];
    
    LocationViewController* locationViewController = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
    locationViewController.venueData = venueData;
    [self.navigationController pushViewController:locationViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

#pragma mark - Helper Methods
- (void)setNavButtons {
    /*if ([self.title isEqualToString:@"Home"]) {
        self.navigationItem.rightBarButtonItem = nil;
        
        if ([PFUser currentUser]) {
            UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc]initWithTitle:@"Sign Out" style:UIBarButtonItemStyleBordered target:self action:@selector(signOutButtonClicked:)];
            self.navigationItem.rightBarButtonItem = signOutButton;
            
            UIBarButtonItem *notificationsBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Requests" style:UIBarButtonItemStyleBordered target:self action:@selector(notificationsButtonClicked:)];
            self.navigationItem.leftBarButtonItem = notificationsBarButton;
        }
        else {
            UIBarButtonItem *signInButton = [[UIBarButtonItem alloc]initWithTitle:@"Sign Up" style:UIBarButtonItemStyleBordered target:self action:@selector(signInButtonClicked:)];
            self.navigationItem.rightBarButtonItem = signInButton;
            self.navigationItem.leftBarButtonItem = nil;
        }
    }
    else if ([self.title isEqualToString:@"Bookmarks"]) {
        [headerView setFrame:CGRectMake(0, 0, 320, 46)];
        [self.tableView setTableHeaderView:headerView];
    }*/
}

- (void)checkForNotifications {
    NSMutableArray *requestsToDisplay = [[NSMutableArray alloc]init];
    
    PFQuery *getNotifications = [PFQuery queryWithClassName:@"notifications"];
    [getNotifications whereKey:@"requestor" equalTo:[PFUser currentUser]];
    [getNotifications orderByDescending:@"updatedAt"];
    getNotifications.limit = 15;
    [getNotifications findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *notification in objects) {
                [requestsToDisplay addObject:notification];
            }
            
            [self setPendingRequestsArray:requestsToDisplay];
            
            notificationsCountLabel.text = [NSString stringWithFormat:@"%d", _pendingRequestsArray.count];
            
            if (_pendingRequestsArray.count < 1) {
                [notificationsImageView setHidden:YES];
                [notificationsCountLabel setHidden:YES];
            }
            else {
                [notificationsCountLabel setHidden:NO];
                [notificationsImageView setHidden:NO];
            }
            notificationScreen.requestQueryItems = _pendingRequestsArray;
            tabBarNotificationScreenInstance.requestQueryItems = _pendingRequestsArray;
            
            PFGeoPoint *currentLocation = [PFGeoPoint geoPointWithLatitude:[[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"]floatValue] longitude:[[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]floatValue]];
            NSLog(@"%f, %f", currentLocation.latitude, currentLocation.longitude);
            PFQuery *getRequests = [PFQuery queryWithClassName:@"requests"];
            [getRequests whereKey:@"locationCoordinates" nearGeoPoint:currentLocation withinMiles:25000];
            [getRequests whereKey:@"updatedAt" greaterThan:[NSDate dateWithTimeIntervalSinceNow:-7200]];
            [getRequests whereKey:@"requestor" notEqualTo:[PFUser currentUser]];
            [getRequests orderByDescending:@"updatedAt"];
            [getRequests findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    for (PFObject *requestObject in objects) {
                        PFQuery *requestResponseQuery = [PFQuery queryWithClassName:@"requestResponses"];
                        [requestResponseQuery whereKey:@"responder" equalTo:[PFUser currentUser]];
                        [requestResponseQuery whereKey:@"requestObject" equalTo:requestObject];
                        [requestResponseQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            if (!error) {
                                if (objects.count < 1) {
                                    [requestsToDisplay addObject:requestObject];
                                    [self setPendingRequestsArray:requestsToDisplay];
                                    if (_pendingRequestsArray.count < 1) {
                                        [notificationsImageView setHidden:YES];
                                        [notificationsCountLabel setHidden:YES];
                                    }
                                    else {
                                        [notificationsCountLabel setHidden:NO];
                                        [notificationsImageView setHidden:NO];
                                    }
                                    notificationScreen.requestQueryItems = _pendingRequestsArray;
                                    tabBarNotificationScreenInstance.requestQueryItems = _pendingRequestsArray;
                                    notificationsCountLabel.text = [NSString stringWithFormat:@"%d", _pendingRequestsArray.count];
                                }
                            }
                        }];
                    }
                }
            }];
        } 
    }];
}

- (void)doQuery:(id)sender {
    FactualQuery* queryObject = [FactualQuery query];
    
    // set limit
    queryObject.limit = 50;
    
    //CLLocationCoordinate2D coordinate = [AppDelegate getDelegate].currentLocation.coordinate;
    CLLocationCoordinate2D coordinate = {
        [((NSNumber*)[[NSUserDefaults standardUserDefaults]valueForKey:@"latitude"])doubleValue],
        [((NSNumber*)[[NSUserDefaults standardUserDefaults]valueForKey:@"longitude"])doubleValue]
    };
    
    
    NSLog(@"current location: %f,%f", coordinate.latitude, coordinate.longitude);
    
    [queryObject setGeoFilter:coordinate radiusInMeters:16093.0];
    
    [queryObject addRowFilter:[FactualRowFilter fieldName:@"country" equalTo:@"US"]]; 
    
    _activeRequest = [[AppDelegate getAPIObject] queryTable:@"global" optionalQueryParams:queryObject withDelegate:self];
    
    
}

#pragma mark - UIBarButtonItem Action Methods
- (void)signInButtonClicked:(id)sender {
    SignUpViewController *signUpVc = [[SignUpViewController alloc]initWithNibName:@"SignUpViewController" bundle:nil];
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:signUpVc];
    [self.navigationController presentViewController:navC animated:YES completion:NULL];
}

- (void)notificationsButtonTapped:(id)sender {
    if (![notificationsCountLabel.text isEqualToString:@"0"] && notificationsCountLabel.text ) {
        if ([self.title isEqualToString:@"Trending"]) {
            if ([PFUser currentUser]) {
                notificationScreen.fromHome = YES;
                UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:notificationScreen];
                [self.navigationController presentViewController:navC animated:YES completion:NULL];
            }
            else {
                SignUpViewController *signUpVc = [[SignUpViewController alloc]initWithNibName:@"SignUpViewController" bundle:nil];
                UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:signUpVc];
                [self.navigationController presentViewController:navC animated:YES completion:NULL];
            }
        }
        else {
            UINavigationController *homeNavC = [navViewControllers objectAtIndex:0];
            HomeViewController *homeScreen = [homeNavC.viewControllers objectAtIndex:0];
            [homeScreen notificationsButtonTapped:nil];
        }
    }
}

- (void)signOutButtonClicked:(id)sender {
    [PFUser logOut];
    [self setNavButtons];
}

#pragma mark FactualAPIDelegate methods

- (void)requestDidReceiveInitialResponse:(FactualAPIRequest *)request {
    if (request == _activeRequest) {
        NSLog(@"Received Initial Response");
    }
}

- (void)requestDidReceiveData:(FactualAPIRequest *)request { 
    if (request == _activeRequest) {
        NSLog(@"Received Data");
    }  
}


-(void) requestComplete:(FactualAPIRequest *)request failedWithError:(NSError *)error {
    if (_activeRequest == request) {
        
        NSLog(@"Active request failed with Error:%@", [error localizedDescription]);
    }
}


-(void) requestComplete:(FactualAPIRequest *)request receivedQueryResult:(FactualQueryResult *)queryResultObj {
    if (_activeRequest == request) {
        NSLog(@"%@", queryResultObj);
        self.queryResult = queryResultObj;
        [self.tableView reloadData];
    }
}


@end
