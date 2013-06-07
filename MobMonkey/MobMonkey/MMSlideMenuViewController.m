//
//  MMSlideMenuViewController.m
//  MobMonkey_LVF
//
//  Created by Michael Kral on 4/17/13.
//  Copyright (c) 2013 MobMonkey. All rights reserved.
//

#import "MMSlideMenuViewController.h"
#import "MMAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "MMMenuItems.h"
#import "MMMenuItem.h"
#import "MMTrendingViewController.h"
#import "MMNavigationViewController.h"
#import "MMInboxViewController.h"
#import "MMBookmarksViewController.h"
#import "MMSettingsViewController.h"
#import "MMHotSpotViewController.h"
#import "MMPlaceViewController.h"
#import "MMSearchPlacesViewController.h"
#import "MMRequestInboxViewController.h"
#import "MMCreateHotSpotMapViewController.h"
#import "MMSettingsViewController.h"
#import "MMMakeARequestTableViewController.h"

@interface MMSlideMenuViewController ()

@end

@implementation MMSlideMenuViewController

@synthesize menuTableView, searchBar, menuItems;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)setupViews{
    
    [searchBar setBackgroundImage:[UIImage new]];
    [searchBar setTranslucent:YES];
    [searchBar setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.600]];
    
    //self.view.backgroundColor = [UIColor redColor];
    
    UIImage *image = [UIImage imageNamed:@"darkLinenBackground.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:self.menuTableView.bounds];
    [self.menuTableView setBackgroundView:imageView];
    [self.menuTableView setBackgroundColor:[UIColor clearColor]];
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupViews];
    
    MMMenuItems *menuItemsModel = [MMMenuItems menuItems];
    
    menuItems = [menuItemsModel allMenuItems];
    
    _selectedMenuItem = [menuItems  objectAtIndex:0];
    selectedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    [menuTableView reloadData];
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    
    
    
    
    [self.slidingViewController setAnchorRightRevealAmount:265.0f];
    
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
}
-(void)viewDidAppear:(BOOL)animated {
    
    [menuTableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/* The following is from http://blog.shoguniphicus.com/2011/06/15/working-with-uigesturerecognizers-uipangesturerecognizer-uipinchgesturerecognizer/ */

#pragma mark - Table View Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuItems.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIView *cellBackgroundView = [[UIView alloc] init];
        [cellBackgroundView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.500]];
        cell.opaque = NO;
        [cell setBackgroundView:cellBackgroundView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        CGRect newFrame = cell.textLabel.frame;
        newFrame.origin.x = 60;
        cell.textLabel.frame = newFrame;
    }
    
    
    MMMenuItem *menuItem = [self.menuItems objectAtIndex:indexPath.row];
    
    if(menuItem.menuItemType == MMMenuItemTypeLocations){
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    }else{
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    }

    if([menuItem isEqual:_selectedMenuItem]){
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        cell.imageView.image = menuItem.selectedImage;
    }else{
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        cell.imageView.image = menuItem.image;
    }
    
    if(menuItem.titleTextAlignment == NSTextAlignmentCenter){
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    }else{
        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
    }
    

    
    cell.textLabel.text = menuItem.title;
    
    return cell;
    
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"TOUCH");
    return indexPath;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MMMenuItem *menuItem = [menuItems objectAtIndex:indexPath.row];
    
    //If user clicks the selected menu item close the menu and do nothing
    if([menuItem isEqual:_selectedMenuItem]){
        [self.slidingViewController resetTopView];
        return;
    }
    
#warning May want to keep instances of view controllers if this slows down
    switch (menuItem.menuItemType) {
            
        case MMMenuItemTypeLocations:{
            
            /*MMHotSpotViewController *hotSpotViewController = [[MMHotSpotViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            hotSpotViewController.title = @"Locations";
            
            MMNavigationViewController *hotSpotNVC = [[MMNavigationViewController alloc] initWithRootViewController:hotSpotViewController];
            
            [self.slidingViewController setTopViewController:hotSpotNVC];
            
            break;*/
            
            MMPlaceViewController *placeViewController = [[MMPlaceViewController alloc] initWithTableViewStyle:UITableViewStylePlain defaultMapHeight:128 parallaxFactor:0.5];
            
            MMNavigationViewController *placeNVC = [[MMNavigationViewController alloc] initWithRootViewController:placeViewController];
            
            [self.slidingViewController setTopViewController:placeNVC];
            
            break;
            
        }
            
        case MMMenuItemTypeTrending: {
            
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            
            MMTrendingViewController *trendingViewContoller = [[MMTrendingViewController alloc] initWithCollectionViewLayout:layout];
            
            trendingViewContoller.title = @"What's Trending Now!";
            
            MMNavigationViewController *trendingNVC = [[MMNavigationViewController alloc] initWithRootViewController:trendingViewContoller];
            
            [self.slidingViewController setTopViewController:trendingNVC];
            
            break;
        }
        case MMMenuItemTypeInbox: {
            
            MMRequestInboxViewController *inboxViewController = [[MMRequestInboxViewController alloc] initWithStyle:UITableViewStylePlain];
            
            inboxViewController.title = @"Inbox";
            
            MMNavigationViewController *inboxNVC = [[MMNavigationViewController alloc] initWithRootViewController:inboxViewController];
            
            [self.slidingViewController setTopViewController:inboxNVC];
            
            break;
        }
            
        case MMMenuItemTypeFavorites: {
            
            MMBookmarksViewController * favoritesViewController = [[MMBookmarksViewController alloc] initWithNibName:@"MMLocationsViewController" bundle:nil];
            
            favoritesViewController.title = @"Favorites";
            
            MMNavigationViewController *favoritesNVC = [[MMNavigationViewController alloc] initWithRootViewController:favoritesViewController];
            
            [self.slidingViewController setTopViewController:favoritesNVC];
            
             break;
        }
            
        case MMMenuItemTypeSettings: {
            
            MMSettingsViewController * settingsViewController = [[MMSettingsViewController alloc] initWithNibName:@"MMSettingsViewController" bundle:nil];
            
            settingsViewController.title = @"Settings";
            
            MMNavigationViewController *settingsNVC = [[MMNavigationViewController alloc] initWithRootViewController:settingsViewController];
            
            [self.slidingViewController setTopViewController:settingsNVC];
            
            break;
        }
        case MMMenuItemTypeSearch: {
            MMSearchPlacesViewController *searchViewController = [[MMSearchPlacesViewController alloc] initWithStyle:UITableViewStylePlain];
            searchViewController.title = @"Search";
            
            MMNavigationViewController *searchNVC = [[MMNavigationViewController alloc] initWithRootViewController:searchViewController];
            
            [self.slidingViewController setTopViewController:searchNVC];
            break;
        }
        case MMMenuItemCreateHotSpot: {
            
            MMCreateHotSpotMapViewController *createHotSpotMapViewController = [[MMCreateHotSpotMapViewController alloc] initWithNibName:nil bundle:nil];
            createHotSpotMapViewController.title = @"Choose a location";
            
            MMNavigationViewController *createHotSpotNVC = [[MMNavigationViewController alloc] initWithRootViewController:createHotSpotMapViewController];
            
            [self.slidingViewController setTopViewController:createHotSpotNVC];
            break;
        }
        case MMMenuItemSnapShot: {
            MMMakeARequestTableViewController *makeARequestTableViewController = [[MMMakeARequestTableViewController alloc] initWithNibName:@"MMMakeARequestTableViewController" bundle:nil];
            
            MMNavigationViewController *snapShotNVC = [[MMNavigationViewController alloc] initWithRootViewController:makeARequestTableViewController];
            
            [self.slidingViewController setTopViewController:snapShotNVC];
            break;
        }
        case MMMenuItemNotifications: {
            MMPlaceViewController *placeViewController = [[MMPlaceViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped defaultMapHeight:100 parallaxFactor:0.4];
            
            MMNavigationViewController * notificationsNVC = [[MMNavigationViewController alloc] initWithRootViewController:placeViewController];
            
            [self.slidingViewController setTopViewController:notificationsNVC];
            
        }
                
            
        default:
            break;
    }
    self.selectedMenuItem = menuItem;
    
    
    
    
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    UITableViewCell * previouslySelectedCell = [tableView cellForRowAtIndexPath:selectedIndexPath];
    
    MMMenuItem *previousMenuItem = [menuItems objectAtIndex:selectedIndexPath.row];
    
    selectedIndexPath = indexPath;
    
    UIView *cellBackgroundView = [[UIView alloc] init];
    [cellBackgroundView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.500]];
    cell.opaque = NO;
    [cell setBackgroundView:cellBackgroundView];
    
    [UIView animateWithDuration:0.2 animations:^{
        [cellBackgroundView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.500]];
        [cell setBackgroundView:cellBackgroundView];
        //[cell.textLabel setTextColor:[UIColor colorWithRed:0.882 green:0.506 blue:0.133 alpha:1.000]];
        cell.imageView.image = menuItem.selectedImage;
        
        previouslySelectedCell.imageView.image = previousMenuItem.image;
        [previouslySelectedCell.textLabel setTextColor:[UIColor whiteColor]];
        
    }];
    
    [self.slidingViewController resetTopView];
    
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMMenuItem *menuItem = [menuItems objectAtIndex:indexPath.row];
    
    if(menuItem.cellHeight){
        return menuItem.cellHeight.floatValue;
    }
    
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
    
    // If you are not using ARC:
    // return [[UIView new] autorelease];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    MMMenuItem *menuItem = [menuItems objectAtIndex:indexPath.row];
    
    if(menuItem.menuItemType == MMMenuItemTypeHappening){

        cell.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        
        for(UIView *view in cell.subviews){
            view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        }
    }/*else if(menuItem.menuItemType == MMMenuItemSubscribe){
        
        cell.backgroundColor = [UIColor colorWithWhite:0.28 alpha:0.5];
        
        for(UIView *view in cell.subviews){
            view.backgroundColor = [UIColor colorWithWhite:0.28 alpha:0.5];
        }
        
    }*/else{
        cell.backgroundColor = [UIColor colorWithWhite:0.25 alpha:0.5];
        
        for(UIView *view in cell.subviews){
            view.backgroundColor = [UIColor colorWithWhite:0.25 alpha:0.5];
        }
    }
}





@end
