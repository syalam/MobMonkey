//
//  MMTrendingViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/31/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMTrendingViewController.h"
#import "MMSetTitleImage.h"
#import "MMLocationViewController.h"
#import "MMFullScreenImageViewController.h"
#import "MMAppDelegate.h"
#import "SectionInfo.h"
#import "MMClientSDK.h"

@interface MMTrendingViewController ()

@end

#define DEFAULT_ROW_HEIGHT 78
#define HEADER_HEIGHT 80

@implementation MMTrendingViewController

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
    
    //set background color
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background~iphone"]]];
    
    _cellToggleOnState = [[NSMutableDictionary alloc]initWithCapacity:1];
    
    NSMutableArray *sectionContent;
    
    if (_sectionSelected) {
        //Add custom back button to the nav bar
        UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
        [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
        
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
        self.navigationItem.leftBarButtonItem = backButton;
        
        sectionContent = [[NSMutableArray alloc]init];
        for (int i = 0; i < 20; i++) {
            [sectionContent addObject:@""];
        }
    }
    else {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        sectionContent = [NSMutableArray arrayWithObjects:@"Bookmarks", @"My Interests", @"Top Viewed", @"Near Me", nil];
    }
    
    [self setContentList:sectionContent];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section, indexPath.row];
    if (_sectionSelected) {
        MMResultCell *cell = (MMResultCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[MMResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.delegate = self;
        
        // Configure the cell...
        
        cell.timeLabel.text = @"14m ago";
        cell.locationNameLabel.text = @"Nando's";
        cell.thumbnailImageView.image = [UIImage imageNamed:@"monkey.jpg"];
        
        
        //set tags
        cell.likeButton.tag = indexPath.row;
        cell.dislikeButton.tag = indexPath.row;
        cell.flagButton.tag = indexPath.row;
        cell.shareButton.tag = indexPath.row;
        cell.toggleOverlayButton.tag = indexPath.row;
        cell.enlargeButton.tag = indexPath.row;
        if ([[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"row%dFlagged", indexPath.row]]) {
            [cell.flagButton setBackgroundColor:[UIColor blueColor]];
        }
        else {
            [cell.flagButton setBackgroundColor:[UIColor clearColor]];
        }
        
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
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = @"";
        
        cell.textLabel.text = [_contentList objectAtIndex:indexPath.row];
        
        return cell;
    }
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

/*-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {

	SectionInfo *sectionInfo = [[SectionInfo alloc]init];
    if (!sectionInfo.headerView) {
        sectionInfo.headerView = [[SectionHeaderView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_HEIGHT) title:[sectionTitleArray objectAtIndex:section] section:section delegate:self];
    }
    
    return sectionInfo.headerView;
}*/

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_sectionSelected) {
        return 200;
    }
    else {
        return 45;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_sectionSelected) {
        [[MMClientSDK sharedSDK]locationScreen:self];
    }
    else {
        [[MMClientSDK sharedSDK]trendingScreen:self selectedCategory:[_contentList objectAtIndex:indexPath.row]];
    }
}


#pragma mark - MMResultCell Delegate Methods
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
    MMResultCell *cell = (MMResultCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"row%dFlagged", [sender tag]]]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:[NSString stringWithFormat:@"row%dFlagged", [sender tag]]];
        [cell.flagButton setBackgroundColor:[UIColor blueColor]];
    }
    else {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:[NSString stringWithFormat:@"row%dFlagged", [sender tag]]];
        [cell.flagButton setBackgroundColor:[UIColor clearColor]];
    }
    
}
- (void)enlargeButtonTapped:(id)sender {
    MMFullScreenImageViewController *fullScreenVC = [[MMFullScreenImageViewController alloc]initWithNibName:@"MMFullScreenImageViewController" bundle:nil];
    fullScreenVC.imageToDisplay = [UIImage imageNamed:@"monkey.jpg"];
    fullScreenVC.rowIndex = [sender tag];
    UINavigationController *fullScreenNavC = [[UINavigationController alloc]initWithRootViewController:fullScreenVC];
    fullScreenNavC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:fullScreenNavC animated:YES completion:NULL];
}
- (void)shareButtonTapped:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark - Nav Bar Action Methods
- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
