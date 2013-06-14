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
#import "MMMakeARequestTableViewController.h"
#import "MMMediaObject.h"
#import "MMWatchLiveVideoViewController.h"

#define kMMPlaceInformationCellHeight 85.0f
#define kMMPlaceActionCellHeight

@interface MMPlaceViewController ()

@property (nonatomic, strong) NSArray *numberOfCellsInSections;
@property (nonatomic, strong) NSArray *actionCellWrappers;
@property (nonatomic, assign) BOOL hasLiveVideo;
@property (nonatomic, strong) NSArray * liveVideos;

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
    UIBarButtonItem *menuItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"whiteBackButton"] selectedImage:nil target:self action:@selector(backButtonPressed:)];
    self.navigationItem.leftBarButtonItem = menuItem;
    
    self.title = @"Taco Bell";
    [self loadLocationInformation];
    self.navigationController.navigationBar.translucent = YES;
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _numberOfCellsInSections = @[@3,@3,@3,@3];
    
    liveVideoActionWrapper = [[MMPlaceActionWrapper alloc] init];
    liveVideoActionWrapper.text = @"Watch Live Video";
    liveVideoActionWrapper.image = [UIImage imageNamed:@"videoCamera"];
    liveVideoActionWrapper.backgroundColor = [UIColor MMLightMainColor];
    liveVideoActionWrapper.selectedBackgroundColor = [UIColor colorWithRed:0.275 green:0.431 blue:0.670 alpha:1.000];
    
    requestActionWrapper = [[MMPlaceActionWrapper alloc] init];
    requestActionWrapper.text = @"Make a Request";
    requestActionWrapper.badgeCount = self.locationInformation.monkeys;                                
    requestActionWrapper.image = [UIImage imageNamed:@"paperPlane"];
    requestActionWrapper.backgroundColor = [UIColor MMLightAccentColor];
    requestActionWrapper.selectedBackgroundColor = [UIColor colorWithRed:0.681 green:0.266 blue:0.225 alpha:1.000];
    
    _actionCellWrappers = @[liveVideoActionWrapper, requestActionWrapper];
    
                                              
    //Create the wrapper for media section header
    mediaSectionHeader = [[MMPlaceSectionHeaderWrapper alloc] init];
    mediaSectionHeader.title = @"Media Timeline";
    mediaSectionHeader.icon = [UIImage imageNamed:@"clock"];
    CustomBadge *badge = [CustomBadge customBadgeWithString:@"0" withStringColor:[UIColor blackColor] withInsetColor:[UIColor whiteColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor blackColor] withScale:0.8 withShining:NO];
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
    //hotSpotSectionHeader.backgroundColor = [UIColor colorWithRed:0.910 green:0.921 blue:0.968 alpha:1.000];
    
    notificationSectionHeader = [[MMPlaceSectionHeaderWrapper alloc] init];
    notificationSectionHeader.title = @"Notifications";
    notificationSectionHeader.icon = [UIImage imageNamed:@"speechBubble"];
    notificationSectionHeader.showDisclosureIndicator = YES;
    
    
}
-(void)backButtonPressed:(id)sender{
    if((self.isMapFullScreen && !self.isMapAnimating) || (!self.isMapFullScreen && self.isMapAnimating)){
        [self closeMapView];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)reloadValues{
  /* [MMAPI getMediaForLocationID:self.locationInformation.locationID providerID:self.locationInformation.providerID success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
       NSArray * mediaArray = [responseObject objectForKey:@"media"];
       
       for(NSDictionary * mediaDictionary in mediaArray){
           NSLog(@"MEDIA: %@", mediaDictionary);
           if([[mediaDictionary objectForKey:@"type"] isEqualToString:@"livestreaming"]){
               _hasLiveVideo = YES;
           }
       }
       
       NSUInteger mediaCount = mediaArray.count;
       
       CustomBadge *badge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", mediaCount] withStringColor:[UIColor blackColor] withInsetColor:[UIColor whiteColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor blackColor] withScale:1.0 withShining:NO];
       mediaSectionHeader.accessoryView = badge;
       
       [self.tableView reloadData];
       
       
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
   }];*/
    
    NSAssert(self.locationInformation.locationID, @"NO LOCATION ID");
    NSAssert(self.locationInformation.providerID, @"NO PROVIDER ID");
    
    [MMAPI getMediaObjectsForLocationID:self.locationInformation.locationID providerID:self.locationInformation.providerID success:^(NSArray *mediaObjects) {
        
        NSMutableArray * liveVideos = [[NSMutableArray alloc] initWithCapacity:mediaObjects.count];
        for(MMMediaObject * mediaObject in mediaObjects){
            if(mediaObject.mediaType == MMMediaTypeLiveVideo){
                _hasLiveVideo = YES;
                [liveVideos addObject:mediaObject];
                
            }
        }
        self.liveVideos = liveVideos;
        
        NSUInteger mediaCount = mediaObjects.count;
        
        CustomBadge *mediaBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", mediaCount] withStringColor:[UIColor blackColor] withInsetColor:[UIColor whiteColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor blackColor] withScale:0.8 withShining:NO];
        
        
        mediaSectionHeader.accessoryView = mediaBadge;
        liveVideoActionWrapper.badgeCount = [NSNumber numberWithInt: liveVideos.count];
        
        [self.tableView reloadData];

        
    } failure:^(NSError *error) {
        NSLog(@"Failed");
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor MMDarkMainColor];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if(self.newlyCreatedHotSpot){
        NSMutableSet * newHotSpots = [NSMutableSet setWithSet:self.locationInformation.sublocations];
        [newHotSpots addObject:_newlyCreatedHotSpot];
        self.locationInformation.sublocations = newHotSpots;
    }
    
    [self reloadLocationInfo];
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
    RIButtonItem * removeFromFavorites = [RIButtonItem itemWithLabel:@"Remove from Favorites"];
    RIButtonItem * addVideo = [RIButtonItem itemWithLabel:@"Add Video"];
    RIButtonItem * addPhoto = [RIButtonItem itemWithLabel:@"Add Photo"];
    RIButtonItem * addComment = [RIButtonItem itemWithLabel:@"Add Comment"];
    
    [createHotSpotButton setAction:^{
        MMCreateHotSpotMapViewController *createHotSpotMapViewController = [[MMCreateHotSpotMapViewController alloc] initWithNibName:nil bundle:nil];
        
        createHotSpotMapViewController.parentLocationInformation = _locationInformation;
        
        [self.navigationController pushViewController:createHotSpotMapViewController animated:YES];
    }];
    
    [addToFavorites setAction:^{
        [MMAPI createBookmarkWithLocationID:self.locationInformation.locationID providerID:self.locationInformation.providerID success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"Favorite Added"];
            self.locationInformation.isBookmark = YES;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Could not add to Favorites."];
        }];
    }];
    
    [removeFromFavorites setAction:^{
        [MMAPI deleteBookmarkWithLocationID:self.locationInformation.locationID providerID:self.locationInformation.providerID success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [SVProgressHUD showSuccessWithStatus:@"Favorite Removed"];
            self.locationInformation.isBookmark = NO;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Could not remove from Favorites."];
        }];
    }];
    
    
    
    UIActionSheet *actionsheet;
    
    if(self.locationInformation.isBookmark){
        
        actionsheet = [[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:cancelButton destructiveButtonItem:nil otherButtonItems:createHotSpotButton, removeFromFavorites, addVideo, addPhoto, addComment, nil];
        
    }else{
        
        actionsheet = [[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:cancelButton destructiveButtonItem:nil otherButtonItems:createHotSpotButton, addToFavorites, addVideo, addPhoto, addComment, nil];
    }
    
    
    [actionsheet showInView:self.view];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return !_locationInformation.parentLocation ? 4 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    if(section == 0){
        NSUInteger rows = 2;
        
        //If has live streaming need 3 rows
        if(_hasLiveVideo){
            rows++;
        }
        
        return rows;
    }else if (section == 1){
        return 1;
    }else if (section == 2 && !_locationInformation.parentLocation){
        return 1 + _locationInformation.sublocations.count;
    }else if(section == 3 || (section == 2 && _locationInformation.parentLocation)){
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
        
        NSUInteger arrayOffset = 1;
        
        if(!_hasLiveVideo){
            arrayOffset = 0;
        }
        [placeActionCell setPlaceActionWrapper:[_actionCellWrappers objectAtIndex:indexPath.row - arrayOffset]];
        
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
            else if(indexPath.section == 2 && !_locationInformation.parentLocation){
                [cell setPlaceSectionHeaderWrapper:hotSpotSectionHeader];
                cell.placeSectionHeaderView.backgroundColor = highLightedbackgroundColor;
                highlighted = YES;
                highLightedbackgroundColor = hotSpotSectionHeader.backgroundColor;
            }
            else if(indexPath.section == 3 || (_locationInformation.parentLocation && indexPath.section == 2))
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
        
        
    } else {
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
    }else if((indexPath.section == 0 && indexPath.row == 2 && _hasLiveVideo) ||
             (indexPath.section == 0 && indexPath.row == 1 && !_hasLiveVideo)
             ){
        MMMakeARequestTableViewController * makeARequestViewController = [[MMMakeARequestTableViewController alloc] initWithNibName:@"MMMakeARequestTableViewController" bundle:nil];
        makeARequestViewController.locationInformation = self.locationInformation;
        [self.navigationController pushViewController:makeARequestViewController animated:YES];
    }else if(indexPath.section == 0 && indexPath.row == 1 && _hasLiveVideo){
    
        MMWatchLiveVideoViewController * watchLiveVideoViewController = [[MMWatchLiveVideoViewController alloc] initWithStyle:UITableViewStylePlain];
        watchLiveVideoViewController.mediaObjects = self.liveVideos;
        [self.navigationController pushViewController:watchLiveVideoViewController animated:YES];
    }
    
    
   if(indexPath.section == 1 && indexPath.row == 0){
        MMMediaTimelineViewController *mediaTimelineViewController = [[MMMediaTimelineViewController alloc] initWithStyle:UITableViewStylePlain];
       mediaTimelineViewController.locationInformation = self.locationInformation;
        [self.navigationController pushViewController:mediaTimelineViewController animated:YES];
    }
    
    if(indexPath.section == 2 && !_locationInformation.parentLocation){
        if(indexPath.row == 0){//create hotspot
        
            MMCreateHotSpotMapViewController * createHotSpotViewController = [[MMCreateHotSpotMapViewController alloc] initWithNibName:nil bundle:nil];
            createHotSpotViewController.parentLocationInformation = _locationInformation;
            
            [self.navigationController pushViewController:createHotSpotViewController animated:YES];
        }else{
            MMPlaceViewController *placeViewController = [[MMPlaceViewController alloc] initWithTableViewStyle:UITableViewStylePlain defaultMapHeight:120 parallaxFactor:0.4];
            placeViewController.locationInformation = [_locationInformation.sublocations.allObjects objectAtIndex:indexPath.row - 1];
            [self.navigationController pushViewController:placeViewController animated:YES];
        }
    }
}

-(void)reloadLocationInfo {
    
    [MMAPI getLocationWithID:self.locationInformation.locationID providerID:self.locationInformation.providerID success:^(AFHTTPRequestOperation *operation, MMLocationInformation *locationInformation) {
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
        requestActionWrapper.badgeCount = self.locationInformation.monkeys;
        [self reloadValues];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    }];
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
