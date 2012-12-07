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
#import "MMLocationsViewController.h"

@interface MMTrendingViewController ()

@property (strong, nonatomic) MMLocationsViewController *locationsViewController;

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
    _cellToggleOnState = [[NSMutableDictionary alloc]initWithCapacity:1];
    
    NSMutableArray *sectionContent;
    
    if (_sectionSelected) {
        //Add custom back button to the nav bar
        if (!_bookmarkTab) {
            UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
            [backNavbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
            [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
            
            UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
            self.navigationItem.leftBarButtonItem = backButton;

        }
        
        sectionContent = [[NSMutableArray alloc]init];
        for (int i = 0; i < 20; i++) {
            [sectionContent addObject:@""];
        }
    }
    else {
        sectionContent = [NSMutableArray arrayWithObjects:@"Bookmarks", @"My Interests", @"Top Viewed", @"Near Me", nil];
    }
    
    [self setContentList:sectionContent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
        [[MMClientSDK sharedSDK]signInScreen:self];
    }
    else {
        [self.tableView reloadData];
    }
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return NO;
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
        if (!cell) {
            cell = [[MMResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
        }
        
        
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
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
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
    double latitude, longitude;
    NSMutableDictionary *params = [@{@"timeSpan":@"week"} mutableCopy];
    
    
    latitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"]doubleValue];
    longitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"]doubleValue];
    
    switch (indexPath.row) {
        case 0:
            [params setValue:@"true" forKey:@"bookmarksonly"];
            break;
        case 1: {
            NSDictionary *favorites = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedInterests"];
            NSString *favoritesParams = [[favorites allValues] componentsJoinedByString:@","];
            if (favoritesParams && ![favoritesParams isEqualToString:@""]) {
                [params setValue:favoritesParams forKey:@"categoryIds"];
                [params setValue:@"true" forKey:@"myinterests"];
            }
        }
            break;
        case 3:
            [params setValue:@"true" forKey:@"nearby"];
            [params setValue:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
            [params setValue:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
            [params setValue:[NSNumber numberWithInt:10000] forKey:@"radius"];
            break;
        default:
            break;
    }

    
    if (!self.locationsViewController) {
        self.locationsViewController = [[MMLocationsViewController alloc] initWithNibName:@"MMLocationsViewController" bundle:nil];
    }
    [self.navigationController pushViewController:self.locationsViewController animated:YES];
    self.locationsViewController.locations = [@[] mutableCopy];
    self.locationsViewController.title = [_contentList objectAtIndex:indexPath.row];
    
    NSLog(@"%@", params);
    
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"Loading %@", [_contentList objectAtIndex:indexPath.row]]];
    [MMAPI getTrendingType:@"topviewed" params:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.locationsViewController.isSearching = NO;
        [SVProgressHUD dismiss];
        NSLog(@"%d", [operation.response statusCode]);
        NSLog(@"%@", responseObject);
        self.locationsViewController.locations = responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%d", [operation.response statusCode]);
        NSLog(@"%@", operation.responseString);
        [SVProgressHUD showErrorWithStatus:@"Unable to load"];
        [self.locationsViewController.navigationController popViewControllerAnimated:YES];
    }];
}
    
@end
