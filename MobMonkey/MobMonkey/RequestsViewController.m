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
#import "SignUpViewController.h"

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
    
    indexPathArray = [[NSMutableArray alloc]init];

    if (_fromHome) {
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped:)];
        self.navigationItem.rightBarButtonItem = doneBarButton;
    }
    
    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 127/2, 9.5, 127, 25)];
    titleImageView.image = [UIImage imageNamed:@"logo~iphone"];
    titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.navigationItem.titleView = titleImageView;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![PFUser currentUser]) {
        SignUpViewController *signUpVc = [[SignUpViewController alloc]initWithNibName:@"SignUpViewController" bundle:nil];
        UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:signUpVc];
        [self.navigationController presentViewController:navC animated:YES completion:NULL];
    }
    else {
        [self separateSections];
    }
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
    return _contentList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *sectionArray = [_contentList objectAtIndex:section];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArray = [_contentList objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    RequestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[RequestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.delegate = self;
    
    if ([contentForThisRow objectForKey:@"notificationText"]) {
        cell.notificationTextLabel.text = [NSString stringWithFormat:@"%@", [contentForThisRow objectForKey:@"notificationText"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.respondButton setHidden:YES];
        [cell.ignoreButton setHidden:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    else {
        cell.notificationTextLabel.text = [NSString stringWithFormat:@"%@.\n%@", [contentForThisRow objectForKey:@"requestText"], [contentForThisRow objectForKey:@"userRequest"]];
        cell.respondButton.tag = indexPath.row;
        cell.ignoreButton.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // Configure the cell...
    
    
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
    if (indexPath.section == 0) {
        return 120;
    }
    else {
        return 85;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *sectionArray = [_contentList objectAtIndex:section];
    if (sectionArray.count > 0) {
        if (section == 0) {
            return @"Requests";
        }
        else {
            return @"Notifications";
        }
    }
    else {
        return @"";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArray = [_contentList objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionArray objectAtIndex:indexPath.row];
    
    if ([contentForThisRow objectForKey:@"notificationText"]) {
        PFObject *notificationObject = contentForThisRow;
        ImageDetailViewController *idvc = [[ImageDetailViewController alloc]initWithNibName:@"ImageDetailViewController" bundle:nil];
        idvc.title = @"Image";
        if ([notificationObject objectForKey:@"locationName"]) {
            idvc.title = [notificationObject objectForKey:@"locationName"];
        }
        [idvc loadImage:notificationObject];
        [self.navigationController pushViewController:idvc animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    NSMutableArray *requestSectionArray = [_contentList objectAtIndex:0];
    PFObject *requestObject = [requestSectionArray objectAtIndex:[sender tag]];
    LocationViewController *locationScreen = [[LocationViewController alloc]initWithNibName:@"LocationViewController" bundle:nil];
    locationScreen.requestObject = requestObject;
    locationScreen.requestScreen = self;
    [self.navigationController pushViewController:locationScreen animated:YES];
}

- (void)ignoreButtonTapped:(id)sender event:event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    responseIndexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    NSMutableArray *requestSectionArray = [_contentList objectAtIndex:0];
    PFObject *requestObject = [requestSectionArray objectAtIndex:[sender tag]];
    
    PFObject *respond = [PFObject objectWithClassName:@"requestResponses"];
    [respond setObject:requestObject forKey:@"requestObject"];
    [respond setObject:[NSNumber numberWithBool:NO] forKey:@"responded"];
    [respond setObject:[PFUser currentUser] forKey:@"responder"];
    [respond saveEventually];
    
    [self.tableView beginUpdates];
    [requestSectionArray removeObjectAtIndex:[sender tag]];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:responseIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    [_contentList replaceObjectAtIndex:0 withObject:requestSectionArray];
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
    
    NSMutableArray *requestSectionArray = [_contentList objectAtIndex:0];
    [self.tableView beginUpdates];
    [requestSectionArray removeObjectAtIndex:currentIndex];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:responseIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView endUpdates];
    [_contentList replaceObjectAtIndex:0 withObject:requestSectionArray];
    
    [self.tableView reloadData];
}

- (void)separateSections { 
    NSMutableArray *allItems = [_requestQueryItems mutableCopy];
    NSMutableArray *notificationArray = [[NSMutableArray alloc]init];
    NSMutableArray *requestArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < allItems.count; i++) {
        if ([[allItems objectAtIndex:i]objectForKey:@"notificationText"]) {
            [notificationArray addObject:[allItems objectAtIndex:i]];
        }
        else {
            [requestArray addObject:[allItems objectAtIndex:i]];
        }
    }
    NSMutableArray *itemsToDisplay = [[NSMutableArray alloc]initWithObjects:requestArray, notificationArray, nil];
    [self setContentList:itemsToDisplay];
    [self.tableView reloadData];
}

@end
