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
    
    
    sectionTitleArray = [NSArray arrayWithObjects:@"Bookmarks", @"My Interests", @"Top Viewed", nil];
    NSMutableArray *bookmarksArray = [NSMutableArray arrayWithObjects:@"bookmarks", @"2", nil];
    NSMutableArray *myInterestsArray = [NSMutableArray arrayWithObjects:@"my interests", nil];
    NSMutableArray *topViewedArray = [NSMutableArray arrayWithObjects:@"top viewed", nil];
    
    NSMutableArray *tableContentArray = [NSMutableArray arrayWithObjects:bookmarksArray, myInterestsArray, topViewedArray, nil];

    
    /*if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.tableView])) {
		
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		
		for (NSMutableArray *sectionContent in tableContentArray) {
			
			SectionInfo *sectionInfo = [[SectionInfo alloc] init];
			sectionInfo.title = [sectionContent objectAtIndex:0];
			sectionInfo.open = NO;
			
            NSNumber *defaultRowHeight = [NSNumber numberWithInteger:DEFAULT_ROW_HEIGHT];
			NSInteger countOfQuotations = 5;
			for (NSInteger i = 0; i < countOfQuotations; i++) {
				[sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
			}
			
			[infoArray addObject:sectionInfo];
		}
		
		self.sectionInfoArray = infoArray;
	}*/

    [self setContentList:tableContentArray];
    
    UIPinchGestureRecognizer* pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
	[self.tableView addGestureRecognizer:pinchRecognizer];
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
    //return _contentList.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return _contentList.count;
    //return 5;
    //SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
	//NSInteger numStoriesInSection = 5;
	
    //return sectionInfo.open ? numStoriesInSection : 0;
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section, indexPath.row];
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
    return 200;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMLocationViewController *locationVC = [[MMLocationViewController alloc]initWithNibName:@"MMLocationViewController" bundle:nil];
    //REPLACE WITH REAL LOCATION NAME;
    locationVC.title = @"Nando's";
    [self.navigationController pushViewController:locationVC animated:YES];
}


#pragma mark Section header delegate
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
	
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
	
	sectionInfo.open = YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    //NSInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
    
    NSArray *sectionContent = [_contentList objectAtIndex:sectionOpened];
    NSInteger countOfRowsToInsert = sectionContent.count;
    
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
		
		/*SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.play.quotations count];*/
        
        NSArray *prevSectionContent = [_contentList objectAtIndex:previousOpenSectionIndex];
        NSInteger countOfRowsToDelete = prevSectionContent.count;
        
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    self.openSectionIndex = sectionOpened;
}


-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
	//SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];
	
    
    //sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
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

#pragma mark Gesture recognizers
-(void)handlePinch:(UIPinchGestureRecognizer*)pinchRecognizer {
    
    /*
     There are different actions to take for the different states of the gesture recognizer.
     * In the Began state, use the pinch location to find the index path of the row with which the pinch is associated, and keep a reference to that in pinchedIndexPath. Then get the current height of that row, and store as the initial pinch height. Finally, update the scale for the pinched row.
     * In the Changed state, update the scale for the pinched row (identified by pinchedIndexPath).
     * In the Ended or Canceled state, set the pinchedIndexPath property to nil.
     */
    
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint pinchLocation = [pinchRecognizer locationInView:self.tableView];
        NSIndexPath *newPinchedIndexPath = [self.tableView indexPathForRowAtPoint:pinchLocation];
		self.pinchedIndexPath = newPinchedIndexPath;
        
		SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:newPinchedIndexPath.section];
        self.initialPinchHeight = [[sectionInfo objectInRowHeightsAtIndex:newPinchedIndexPath.row] floatValue];
        // Alternatively, set initialPinchHeight = uniformRowHeight.
        
        [self updateForPinchScale:pinchRecognizer.scale atIndexPath:newPinchedIndexPath];
    }
    else {
        if (pinchRecognizer.state == UIGestureRecognizerStateChanged) {
            [self updateForPinchScale:pinchRecognizer.scale atIndexPath:self.pinchedIndexPath];
        }
        else if ((pinchRecognizer.state == UIGestureRecognizerStateCancelled) || (pinchRecognizer.state == UIGestureRecognizerStateEnded)) {
            self.pinchedIndexPath = nil;
        }
    }
}


-(void)updateForPinchScale:(CGFloat)scale atIndexPath:(NSIndexPath*)indexPath {
    
    if (indexPath && (indexPath.section != NSNotFound) && (indexPath.row != NSNotFound)) {
        
		CGFloat newHeight = round(MAX(self.initialPinchHeight * scale, DEFAULT_ROW_HEIGHT));
        
		SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
        [sectionInfo replaceObjectInRowHeightsAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:newHeight]];
        // Alternatively, set uniformRowHeight = newHeight.
        
        /*
         Switch off animations during the row height resize, otherwise there is a lag before the user's action is seen.
         */
        BOOL animationsEnabled = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [UIView setAnimationsEnabled:animationsEnabled];
    }
}



@end
