//
//  RequestsViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestsViewController.h"
#import "LocationViewController.h"
#import "HomeViewController.h"
#import "ImageDetailViewController.h"

#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 180.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface RequestsViewController ()

@end

@implementation RequestsViewController
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
    
    self.title = @"Requests";
    
    indexPathArray = [[NSMutableArray alloc]init];

    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.rightBarButtonItem = doneBarButton;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    return _contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    RequestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[RequestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.delegate = self;
    
    if ([[_contentList objectAtIndex:indexPath.row]objectForKey:@"notificationText"]) {
        cell.notificationTextLabel.text = [[_contentList objectAtIndex:indexPath.row]objectForKey:@"notificationText"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.respondButton setHidden:YES];
        [cell.ignoreButton setHidden:YES];
    }
    else {
        cell.notificationTextLabel.text = [[_contentList objectAtIndex:indexPath.row]objectForKey:@"requestText"];
        cell.respondButton.tag = indexPath.row;
        cell.ignoreButton.tag = indexPath.row;
    }
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [indexPathArray insertObject:indexPath atIndex:indexPath.row];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_contentList objectAtIndex:indexPath.row]objectForKey:@"notificationText"]) {
        PFObject *notificationObject = [_contentList objectAtIndex:indexPath.row];
        ImageDetailViewController *idvc = [[ImageDetailViewController alloc]initWithNibName:@"ImageDetailViewController" bundle:nil];
        idvc.title = @"Image";
        if ([notificationObject objectForKey:@"locationName"]) {
            idvc.title = [notificationObject objectForKey:@"locationName"];
        }
        [idvc loadImage:notificationObject];
        [self.navigationController pushViewController:idvc animated:YES];
    }
}

#pragma mark - Nav BarButton Action Methods
- (void)doneButtonTapped:(id)sender {
    UITabBarController *tabBarController = (UITabBarController*) self.navigationController.presentingViewController;
    NSArray *navControllers = [tabBarController viewControllers];
    UINavigationController *homeNavC = [navControllers objectAtIndex:0];
    
    
    HomeViewController *homeScreen = (HomeViewController*)[homeNavC.viewControllers objectAtIndex:0];
    [homeScreen checkForNotifications];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - RequestCell Delegate Methods
- (void)respondButtonTapped:(id)sender event:event{
    currentIndex = [sender tag];
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    responseIndexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    PFObject *requestObject = [_contentList objectAtIndex:[sender tag]];
    LocationViewController *locationScreen = [[LocationViewController alloc]initWithNibName:@"LocationViewController" bundle:nil];
    locationScreen.requestObject = requestObject;
    locationScreen.requestScreen = self;
    [self.navigationController pushViewController:locationScreen animated:YES];
}

- (void)ignoreButtonTapped:(id)sender event:event {
    PFObject *requestObject = [_contentList objectAtIndex:[sender tag]];
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    responseIndexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    PFObject *respond = [PFObject objectWithClassName:@"requestResponses"];
    [respond setObject:requestObject forKey:@"requestObject"];
    [respond setObject:[NSNumber numberWithBool:NO] forKey:@"responded"];
    [respond setObject:[PFUser currentUser] forKey:@"responder"];
    [respond saveEventually];
    
    [self.tableView beginUpdates];
    [_contentList removeObjectAtIndex:[sender tag]];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:responseIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView endUpdates];
    
    [self.tableView reloadData];
}

#pragma mark - Helper Methods
- (void)responseComplete:(PFObject *)requestObject {
    PFObject *response = [PFObject objectWithClassName:@"requestResponses"];
    [response setObject:requestObject forKey:@"requestObject"];
    [response setObject:[requestObject objectForKey:@"requestor"] forKey:@"requestor"];
    [response setObject:[NSNumber numberWithBool:YES] forKey:@"responded"];
    [response setObject:[PFUser currentUser] forKey:@"responder"];
    [response saveEventually];
    
    [self.tableView beginUpdates];
    [_contentList removeObjectAtIndex:currentIndex];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:responseIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView endUpdates];
    
    [self.tableView reloadData];
}


@end
