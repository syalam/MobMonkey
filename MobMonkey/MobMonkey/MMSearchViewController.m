//
//  MMSearchViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/2/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMSearchViewController.h"
#import "MMLocationViewController.h"
#import "MMResultCell.h"
#import "MMSetTitleImage.h"

@interface MMSearchViewController ()

@end

@implementation MMSearchViewController

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

    self.navigationItem.titleView = [[MMSetTitleImage alloc]setTitleImageView];
    
    // Uncomment the following line to preserve selection between presentations.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background~iphone"]]];
    
    _cellToggleOnState = [[NSMutableDictionary alloc]initWithCapacity:1];
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
    MMResultCell *cell = (MMResultCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[MMResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.delegate = self;
    
    // Configure the cell...
    
    cell.timeLabel.text = @"14m ago";
    cell.locationNameLabel.text = @"Tarka Chinese Bistro";
    cell.thumbnailImageView.image = [UIImage imageNamed:@"monkey.jpg"];
    
    
    //set tags
    cell.likeButton.tag = indexPath.row;
    cell.dislikeButton.tag = indexPath.row;
    cell.flagButton.tag = indexPath.row;
    cell.shareButton.tag = indexPath.row;
    cell.toggleOverlayButton.tag = indexPath.row;
    
    if ([[_cellToggleOnState valueForKey:[NSString stringWithFormat:@"%d", indexPath.row]]isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        [cell.overlayBGImageView setAlpha:1];
        [cell.overlayButtonView setAlpha:1];
    }
    else {
        [cell.overlayBGImageView setAlpha:0];
        [cell.overlayButtonView setAlpha:0];
    }
    
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
    MMLocationViewController *locationVC = [[MMLocationViewController alloc]initWithNibName:@"MMLocationViewController" bundle:nil];
    [self.navigationController pushViewController:locationVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

#pragma mark - MMResultCell delegate methods
- (void)toggleOverlayButtonTapped:(id)sender {
    MMResultCell *cell = (MMResultCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration: 0.3];
    [UIView setAnimationDelegate: self];
    if (cell.overlayButtonView.alpha == 0) {
        [_cellToggleOnState setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d", [sender tag]]];
        [cell.overlayBGImageView setAlpha:1];
        [cell.overlayButtonView setAlpha:1];
    }
    else {
        [_cellToggleOnState setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d", [sender tag]]];
        [cell.overlayBGImageView setAlpha:0];
        [cell.overlayButtonView setAlpha:0];
    }
    [UIView commitAnimations];
}
- (void)likeButtonTapped:(id)sender {
    
}
- (void)dislikeButtonTapped:(id)sender {
    
}
- (void)flagButtonTapped:(id)sender {
    
}
- (void)enlargeButtonTapped:(id)sender {
    
}
- (void)shareButtonTapped:(id)sender {
    
}

#pragma mark - UITextField delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //TAP THROUGH CODE. DELETE WHEN COMMUNICATING WITH SERVER
    _contentList = [[NSMutableArray alloc]initWithCapacity:1];
    for (int i = 0; i < 20; i++) {
        [_contentList addObject:@""];
    }
    [self.tableView reloadData];
    
    [textField resignFirstResponder];
    return YES;
}

@end
