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

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize screen = _screen;
@synthesize pendingRequestsArray = _pendingRequestsArray;

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
        notificationScreen = [[RequestsViewController alloc]initWithNibName:@"RequestsViewController" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavButtons];
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    HomeCell *cell = (HomeCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    cell.locationNameLabel.text = @"Majerle's";
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
    HomeCell* cell = (HomeCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    LocationViewController* locationViewController = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
    locationViewController.title = cell.locationNameLabel.text;
    [self.navigationController pushViewController:locationViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

#pragma mark - Helper Methods
- (void)setNavButtons {
    if ([self.title isEqualToString:@"Home"]) {
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
        }
    }
    else if ([self.title isEqualToString:@"Bookmarks"]) {
        [headerView setFrame:CGRectMake(0, 0, 320, 46)];
        [self.tableView setTableHeaderView:headerView];
    }
}

- (void)checkForNotifications {
    PFQuery *getRequests = [PFQuery queryWithClassName:@"requests"];
    [getRequests whereKey:@"locationCoordinates" nearGeoPoint:[[PFUser currentUser]objectForKey:@"userLocation"] withinMiles:25000];
    [getRequests whereKey:@"updatedAt" lessThan:[NSDate dateWithTimeIntervalSinceNow:43200]];
    [getRequests whereKey:@"requestor" notEqualTo:[PFUser currentUser]];
    [getRequests findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *requestsToDisplay = [[NSMutableArray alloc]init];
            for (PFObject *requestObject in objects) {
                PFQuery *requestResponseQuery = [PFQuery queryWithClassName:@"requestResponses"];
                [requestResponseQuery whereKey:@"responder" equalTo:[PFUser currentUser]];
                [requestResponseQuery whereKey:@"requestObject" equalTo:requestObject];
                [requestResponseQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        if (objects.count < 1) {
                            [requestsToDisplay addObject:requestObject];
                            [self setPendingRequestsArray:requestsToDisplay];
                            notificationScreen.contentList = _pendingRequestsArray;
                        }
                    }
                }];
            }
        }
    }];
}


#pragma mark - UIBarButtonItem Action Methods
- (void)signInButtonClicked:(id)sender {
    SignUpViewController *signUpVc = [[SignUpViewController alloc]initWithNibName:@"SignUpViewController" bundle:nil];
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:signUpVc];
    [self.navigationController presentViewController:navC animated:YES completion:NULL];
}

- (void)notificationsButtonClicked:(id)sender {
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:notificationScreen];
    [self.navigationController presentViewController:navc animated:YES completion:NULL];
}

- (void)signOutButtonClicked:(id)sender {
    [PFUser logOut];
    [self setNavButtons];
}

@end
