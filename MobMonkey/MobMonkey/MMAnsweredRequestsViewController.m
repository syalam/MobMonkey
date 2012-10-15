//
//  MMAnsweredRequestsViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/7/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMAnsweredRequestsViewController.h"
#import "MMClientSDK.h"

@interface MMAnsweredRequestsViewController ()

@end

enum AcceptRejectCellViewTag {
    LocationNameTag = 10,
    MediaViewTag,
    TimeAgoTag,
    ShareButtonTag,
    AcceptButtonTag,
    RejectButtonTag
};

@implementation MMAnsweredRequestsViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Add custom back button to the nav bar
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    NSLog(@"%@", _contentList);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 2;//_contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    MMAnsweredRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (!cell) {
//        cell = [[MMAnsweredRequestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.delegate = self;
//    }
//    [cell.responseImageView reloadWithUrl:[[_contentList objectAtIndex:indexPath.row] valueForKey:@"mediaUrl"]];
//    cell.expandImageButton.tag = indexPath.row;
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    // Configure the cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[self acceptRejectCell]];
        cell = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    UIButton *shareButton = (UIButton *)[cell viewWithTag:ShareButtonTag];
    [shareButton addTarget:self action:@selector(actionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *acceptButton = (UIButton *)[cell viewWithTag:AcceptButtonTag];
    [acceptButton addTarget:self action:@selector(acceptButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rejectButon = (UIButton *)[cell viewWithTag:RejectButtonTag];
    [rejectButon addTarget:self action:@selector(rejectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:LocationNameTag];
    UIView  *mediaView = [cell viewWithTag:MediaViewTag];
    UILabel *timeAgoLabel = (UILabel *)[cell viewWithTag:TimeAgoTag];
    
    
    //NSDictionary *location = [_contentList objectAtIndex:indexPath.row];
    nameLabel.text = @"A Location"; //[location valueForKey:@"name"];
    
    
    return cell;
}

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
    return 370;
}

#pragma mark - UINavBar Action Methods
- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MMAnsweredRequestCell delegate
- (void)actionButtonTapped:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", @"Flag for Review", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}
- (void)acceptButtonTapped:(id)sender {
    int row = [[self.tableView indexPathForCell:(UITableViewCell *)[[[sender superview] superview] superview]] row];
    NSLog(@"Accept Button Tapped for Row: %d", row);
}
- (void)rejectButtonTapped:(id)sender {
    int row = [[self.tableView indexPathForCell:(UITableViewCell *)[[[sender superview] superview] superview]] row];
    NSLog(@"Reject Button Tapped for Row: %d", row);
}

- (void)expandImageButtonTapped:(id)sender {
    MMAnsweredRequestCell *cell = (MMAnsweredRequestCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    UIImage *imageToDisplay = cell.responseImageView.image;
    
    [[MMClientSDK sharedSDK]inboxFullScreenImageScreen:self imageToDisplay:imageToDisplay locationName:self.title];
}

- (void)viewDidUnload {
    [self setAcceptRejectCell:nil];
    [super viewDidUnload];
}
@end
