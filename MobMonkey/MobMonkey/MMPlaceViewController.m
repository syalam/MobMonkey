//
//  MMPlaceViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 5/22/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMPlaceViewController.h"
#import "MMNavigationBar.h"
#import "MMPlaceInformationCellView.h"
#import "UITableViewCell+CellShadows.h"
#import "MMPlaceInformationCell.h"
#import "MMPlaceInformationCellWrapper.h"
#import "MMPlaceActionCell.h"
#import "MMShadowCellBackground.h"
#import "MMPlaceActionWrapper.h"
#import "CustomBadge.h"
#import "MMSectionHeaderCell.h"
#import "MMMediaTimelineViewController.h"
#import "MMAPI.h"
#import "UIBarButtonItem+NoBorder.h"
#import "UIActionSheet+Blocks.h"
#import "MMCreateHotSpotMapViewController.h"

#define kMMPlaceInformationCellHeight 85.0f
#define kMMPlaceActionCellHeight

@interface MMPlaceViewController ()

@property (nonatomic, strong) NSArray *numberOfCellsInSections;
@property (nonatomic, strong) NSArray *actionCellWrappers;

@end

@implementation MMPlaceViewController

-(id)initWithTableViewStyle:(UITableViewCellStyle)tableViewStyle defaultMapHeight:(CGFloat)defaultMapHeight parallaxFactor:(CGFloat)parallaxFactor {
    if(self = [super initWithTableViewStyle:tableViewStyle defaultMapHeight:170 parallaxFactor:0.4]){
        
    }
    return self;
}

-(void)displayLocationInformation {
    self.title = _locationInformation.name;
    
    wrapper = [[MMPlaceInformationCellWrapper alloc] init];
    wrapper.nameText = _locationInformation.name;
    wrapper.address1Text = [_locationInformation formattedAddressStringLine1];
    wrapper.address2Text = [_locationInformation formattedAddressStringLine2];
    wrapper.distanceText = @"2.3 miles";
    
    
    
    
}
-(void)mapAnimation{
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(_locationInformation.latitude.doubleValue, _locationInformation.longitude.doubleValue);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:self.mapView.centerCoordinate];
    [annotation setTitle:_locationInformation.name]; //You can set the subtitle too
    [self.mapView addAnnotation:annotation];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.02;
    span.longitudeDelta= 0.02;
    
    region.span=span;
    region.center =self.mapView.centerCoordinate;     // to locate to the center
    [self.mapView setRegion:region animated:TRUE];
    [self.mapView regionThatFits:region];
}
-(void)loadLocationInformation {
    
    if(_locationInformation){
        [self displayLocationInformation];
    }
    
    /*[MMAPI getLocationWithID:_locationInformation.locationID providerID:providerId success:^(AFHTTPRequestOperation *operation, MMLocationInformation *locationInformation) {
        
        [SVProgressHUD dismiss];
        
        
        
        if(!self.locationInformation){
            self.locationInformation = locationInformation;
        }else{
            self.locationInformation.monkeys = locationInformation.monkeys;
            self.locationInformation.videos = locationInformation.videos;
            self.locationInformation.images = locationInformation.images;
            self.locationInformation.livestreaming = locationInformation.livestreaming;
            self.locationInformation.message = locationInformation.message;
            self.locationInformation.messageURL = locationInformation.messageURL;
            self.locationInformation.parentLocationID = locationInformation.parentLocationID;
            self.locationInformation.isBookmark = locationInformation.isBookmark;
            self.locationInformation.createdBy = locationInformation.createdBy;
            NSLog(@"created by: %@", locationInformation.createdBy);
        }
        
        if(![self.locationInformation.createdBy isEqual:[NSNull null]] && [self.locationInformation.createdBy isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"userName"]]){
            
            canDelete = YES;
        }
        
        if(self.locationInformation.sublocations.count > 0){
            self.headerView.hotSpotBadge.badgeNumber = [NSNumber numberWithInt:self.locationInformation.sublocations.count];
            self.headerView.hotSpotBadge.hidden = NO;
        }
        [self setLocationDetailItems];
        [self fetchLatestMediaForLocation];
        loadingInfo = NO;
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(operation.response.statusCode == 401){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm Email Address" message:@"Please check your email and confirm the registration." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
        [self.headerView hideLoadingViewShowMedia:NO];
        NSLog(@"Failed: %@", error);
    }];*/
    

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.tableBackground.backgroundColor = [UIColor MMEggShell];
    
    
    //Add backbutton
    UIBarButtonItem *menuItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"whiteBackButton"] selectedImage:nil target:self.navigationController action:@selector(popViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = menuItem;
    
    self.title = @"Taco Bell";
    [self loadLocationInformation];
    self.navigationController.navigationBar.translucent = YES;
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _numberOfCellsInSections = @[@3,@3,@3,@3];
    
    MMPlaceActionWrapper *liveVideoActionWrapper = [[MMPlaceActionWrapper alloc] init];
    liveVideoActionWrapper.text = @"Watch Live Video";
    liveVideoActionWrapper.image = [UIImage imageNamed:@"videoCamera"];
    liveVideoActionWrapper.backgroundColor = [UIColor colorWithRed:0.349 green:0.548 blue:0.851 alpha:1.000];
    liveVideoActionWrapper.selectedBackgroundColor = [UIColor colorWithRed:0.275 green:0.431 blue:0.670 alpha:1.000];
    
    MMPlaceActionWrapper *requestActionWrapper = [[MMPlaceActionWrapper alloc] init];
    requestActionWrapper.text = @"Make a Request";
    requestActionWrapper.image = [UIImage imageNamed:@"paperPlane"];
    requestActionWrapper.backgroundColor = [UIColor colorWithRed:0.879 green:0.343 blue:0.290 alpha:1.000];
    requestActionWrapper.selectedBackgroundColor = [UIColor colorWithRed:0.681 green:0.266 blue:0.225 alpha:1.000];
    
    _actionCellWrappers = @[liveVideoActionWrapper, requestActionWrapper];
    
    
    //Create the wrapper for media section header
    mediaSectionHeader = [[MMPlaceSectionHeaderWrapper alloc] init];
    mediaSectionHeader.title = @"Media Timeline";
    mediaSectionHeader.icon = [UIImage imageNamed:@"clock"];
    CustomBadge *badge = [CustomBadge customBadgeWithString:@"8" withStringColor:[UIColor blackColor] withInsetColor:[UIColor whiteColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor blackColor] withScale:1.0 withShining:NO];
    mediaSectionHeader.accessoryView = badge;
    mediaSectionHeader.showDisclosureIndicator = YES;
    
    //Create the wrapper for hot spot section header
    hotSpotSectionHeader = [[MMPlaceSectionHeaderWrapper alloc] init];
    hotSpotSectionHeader.title = @"Hot Spots";
    hotSpotSectionHeader.icon = [UIImage imageNamed:@"fire"];
    UIButton * addHotSpotButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [addHotSpotButton setImage:[UIImage imageNamed:@"circlePlus"] forState:UIControlStateNormal];
    hotSpotSectionHeader.accessoryView = addHotSpotButton;
    hotSpotSectionHeader.showDisclosureIndicator = NO;
    hotSpotSectionHeader.backgroundColor = [UIColor colorWithRed:0.910 green:0.921 blue:0.968 alpha:1.000];
    
    notificationSectionHeader = [[MMPlaceSectionHeaderWrapper alloc] init];
    notificationSectionHeader.title = @"Notifications";
    notificationSectionHeader.icon = [UIImage imageNamed:@"speechBubble"];
    notificationSectionHeader.showDisclosureIndicator = YES;
    
    
    
    
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self mapAnimation];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showActionsheet {
    
    RIButtonItem * cancelButton = [RIButtonItem itemWithLabel:@"Cancel"];
    RIButtonItem * createHotSpotButton = [RIButtonItem itemWithLabel:@"Create Hot Spot"];
    RIButtonItem * addToFavorites = [RIButtonItem itemWithLabel:@"Add to Favorites"];
    RIButtonItem * addVideo = [RIButtonItem itemWithLabel:@"Add Video"];
    RIButtonItem * addPhoto = [RIButtonItem itemWithLabel:@"Add Photo"];
    RIButtonItem * addComment = [RIButtonItem itemWithLabel:@"Add Comment"];
    
    [createHotSpotButton setAction:^{
        MMCreateHotSpotMapViewController *createHotSpotMapViewController = [[MMCreateHotSpotMapViewController alloc] initWithNibName:nil bundle:nil];
        
        createHotSpotMapViewController.parentLocationInformation = _locationInformation;
        
        [self.navigationController pushViewController:createHotSpotMapViewController animated:YES];
    }];
    
    
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:cancelButton destructiveButtonItem:nil otherButtonItems:createHotSpotButton, addToFavorites, addVideo, addPhoto, addComment, nil];
    
    [actionsheet showInView:self.view];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    if(section == 0){
        return 3;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 1 + _locationInformation.sublocations.count;
    }else if(section == 3){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cellWithShadow;
    BOOL drawSeperator = NO;
    BOOL highlighted = NO;
    UIColor *highLightedbackgroundColor = [UIColor blueColor] ;
    if(indexPath.section == 0 && indexPath.row == 0){
        static NSString *CellIdentifier = @"MMPlaceInformationCell";
		
        MMPlaceInformationCell *placeInformationCell = (MMPlaceInformationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (placeInformationCell == nil) {
            placeInformationCell = [[MMPlaceInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            placeInformationCell.frame = CGRectMake(0.0, 0.0, 320.0, kMMPlaceInformationCellHeight);
            placeInformationCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [placeInformationCell setPlaceInformationWrapper:wrapper];
        
        cellWithShadow = placeInformationCell;
    } else if(indexPath.section == 0 ) {
        
        static NSString * CellIdentifier = @"ActionCell";
        
        MMPlaceActionCell *placeActionCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(placeActionCell == nil) {
            placeActionCell = [[MMPlaceActionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            placeActionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [placeActionCell setPlaceActionWrapper:[_actionCellWrappers objectAtIndex:indexPath.row - 1]];
        
        cellWithShadow =  placeActionCell;
        
    }else if(indexPath.section == 1 ||
              indexPath.section == 2 ||
              indexPath.section == 3){
        
        
        static NSString *CellIdentifier = @"HeaderCell";
        MMSectionHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil){
            cell = [[MMSectionHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        if(indexPath.row == 0){
            if(indexPath.section == 1)
                [cell setPlaceSectionHeaderWrapper:mediaSectionHeader];
            else if(indexPath.section == 2){
                [cell setPlaceSectionHeaderWrapper:hotSpotSectionHeader];
                cell.placeSectionHeaderView.backgroundColor = highLightedbackgroundColor;
                highlighted = YES;
                highLightedbackgroundColor = hotSpotSectionHeader.backgroundColor;
            }
            else if(indexPath.section == 3)
                [cell setPlaceSectionHeaderWrapper:notificationSectionHeader];
        }else{
            MMPlaceSectionHeaderWrapper *subLocationWrapper = [[MMPlaceSectionHeaderWrapper alloc] init];
            MMLocationInformation *subLocation = [_locationInformation.sublocations.allObjects objectAtIndex:indexPath.row-1];
            subLocationWrapper.title = subLocation.name;
            subLocationWrapper.showSeperator = YES;
            subLocationWrapper.showDisclosureIndicator = YES;
            
            
            [cell setPlaceSectionHeaderWrapper:subLocationWrapper];
            drawSeperator = YES;
            
        }
        
        
        cellWithShadow = cell;
        
        
    } else if(indexPath.section == 2) {
        
    }else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if(indexPath.section == 0 && indexPath.row == 0){
            MMPlaceInformationCellView *cellView = (MMPlaceInformationCellView *)[[[NSBundle mainBundle] loadNibNamed:@"MMPlaceInformationCellView" owner:self options:nil] lastObject];
            
            [cell.contentView addSubview:cellView];
        }
    cellWithShadow = cell;
    }
    
    [MMShadowCellBackground addShadowToCell:cellWithShadow showSeperator:drawSeperator backgroundColor:highlighted ? highLightedbackgroundColor : nil inTable:tableView AtIndexPath:indexPath];

    return cellWithShadow;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if(indexPath.row == 0)
            return kMMPlaceInformationCellHeight;
        else
            return UITableViewAutomaticDimension;
    }
    
    return 50;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 1){
        //cell.backgroundColor = [UIColor colorWithWhite:0.843 alpha:1.000];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    if(indexPath.section == 0 && indexPath.row == 0){
        [self showActionsheet];
    }
   if(indexPath.section == 1 && indexPath.row == 0){
        MMMediaTimelineViewController *mediaTimelineViewController = [[MMMediaTimelineViewController alloc] initWithStyle:UITableViewStyleGrouped];
        
        [self.navigationController pushViewController:mediaTimelineViewController animated:YES];
    }
}

/*-(void)mapTableViewController:(MMMapTableViewController *)mapTableViewController didScrollOffMapView:(MKMapView *)mapView {
    MMNavigationBar *navBar = (MMNavigationBar*)self.navigationController.navigationBar;
    navBar.translucentFactor = 0.4;
}
-(void)mapTableViewController:(MMMapTableViewController *)mapTableViewController didScrollOnMapView:(MKMapView *)mapView {
    MMNavigationBar *navBar = (MMNavigationBar*)self.navigationController.navigationBar;
    navBar.translucentFactor = 0.2;
}*/
-(void)mapTableViewController:(MMMapTableViewController *)mapTableViewController isScrollingOffScreen:(MKMapView *)mapView visibility:(CGFloat)visibility {
    MMNavigationBar *navBar = (MMNavigationBar*)self.navigationController.navigationBar;
    navBar.translucentFactor = 1.0 - ((0.5 - 0.1) * visibility + 0.1);
}
@end
