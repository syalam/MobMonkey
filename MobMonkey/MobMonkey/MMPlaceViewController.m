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

#define kMMPlaceInformationCellHeight 85.0f
#define kMMPlaceActionCellHeight

@interface MMPlaceViewController ()

@property (nonatomic, strong) NSArray *numberOfCellsInSections;
@property (nonatomic, strong) NSArray *actionCellWrappers;

@end

@implementation MMPlaceViewController

-(id)initWithTableViewStyle:(UITableViewCellStyle)tableViewStyle defaultMapHeight:(CGFloat)defaultMapHeight parallaxFactor:(CGFloat)parallaxFactor {
    if(self = [super initWithTableViewStyle:tableViewStyle defaultMapHeight:defaultMapHeight parallaxFactor:parallaxFactor]){
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.tableBackground.backgroundColor = [UIColor MMEggShell];
    self.title = @"Testing";
    wrapper = [[MMPlaceInformationCellWrapper alloc] init];
    wrapper.nameText = @"Taco Bell";
    wrapper.address1Text = @"1234 Fake St.";
    wrapper.address2Text = @"Tempe, AZ 85282";
    wrapper.distanceText = @"2.3 miles";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _numberOfCellsInSections = @[@3,@3,@3,@3];
    
    MMPlaceActionWrapper *liveVideoActionWrapper = [[MMPlaceActionWrapper alloc] init];
    liveVideoActionWrapper.text = @"Watch Live Video";
    liveVideoActionWrapper.image = [UIImage imageNamed:@"videoCamera"];
    liveVideoActionWrapper.backgroundColor = [UIColor colorWithRed:0.322 green:0.365 blue:0.588 alpha:1.000];
    
    MMPlaceActionWrapper *requestActionWrapper = [[MMPlaceActionWrapper alloc] init];
    requestActionWrapper.text = @"Make a Request";
    requestActionWrapper.image = [UIImage imageNamed:@"paperPlane"];
    requestActionWrapper.backgroundColor = [UIColor colorWithRed:0.792 green:0.216 blue:0.173 alpha:1.000];
    
    _actionCellWrappers = @[liveVideoActionWrapper, requestActionWrapper];
    
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(33.639347, -112.418339);
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.02;     
    span.longitudeDelta= 0.02;
    
    region.span=span;
    region.center =self.mapView.centerCoordinate;     // to locate to the center
    [self.mapView setRegion:region animated:TRUE];
    [self.mapView regionThatFits:region];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cellWithShadow;
    
    if(indexPath.section == 0 && indexPath.row == 0){
        static NSString *CellIdentifier = @"MMPlaceInformationCell";
		
        MMPlaceInformationCell *placeInformationCell = (MMPlaceInformationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (placeInformationCell == nil) {
            placeInformationCell = [[MMPlaceInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            placeInformationCell.frame = CGRectMake(0.0, 0.0, 320.0, kMMPlaceInformationCellHeight);
            //placeInformationCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [placeInformationCell setPlaceInformationWrapper:wrapper];
        
        cellWithShadow = placeInformationCell;
    } else if(indexPath.section == 0 ) {
        
        static NSString * CellIdentifier = @"ActionCell";
        
        MMPlaceActionCell *placeActionCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(placeActionCell == nil) {
            placeActionCell = [[MMPlaceActionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            //placeActionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [placeActionCell setPlaceActionWrapper:[_actionCellWrappers objectAtIndex:indexPath.row - 1]];
        
        cellWithShadow =  placeActionCell;
        
    }else if(indexPath.section == 1){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = @"Hot Spots";
        
        if(indexPath.section == 0 && indexPath.row == 0){
            MMPlaceInformationCellView *cellView = (MMPlaceInformationCellView *)[[[NSBundle mainBundle] loadNibNamed:@"MMPlaceInformationCellView" owner:self options:nil] lastObject];
            
            [cell.contentView addSubview:cellView];
        }
        cellWithShadow = cell;
    }else{
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
    
    
    
    int lastRowInSection = [tableView numberOfRowsInSection:indexPath.section] - 1;
    
    BOOL isShadowBG = [cellWithShadow.backgroundView isKindOfClass:[MMShadowCellBackground class]];
    
    switch (indexPath.row) {
        case 0:
            if (isShadowBG) {
                MMShadowCellBackground *bg = (MMShadowCellBackground*)cellWithShadow.backgroundView;
                if(bg.cellPosition != MMGroupedCellPositionTop){
                    [bg setCellPosition:MMGroupedCellPositionTop];
                }
            }else{
                CGRect frame = cellWithShadow.backgroundView.frame;
                MMShadowCellBackground *newBG = [[MMShadowCellBackground alloc] initWithFrame:frame];
                newBG.showSeperator = YES;
                newBG.cellPosition = MMGroupedCellPositionTop;
                cellWithShadow.backgroundView = newBG;
            }
            
            break;
            
        default:
            
            if(indexPath.row == lastRowInSection){
                if (isShadowBG) {
                    MMShadowCellBackground *bg = (MMShadowCellBackground*)cellWithShadow.backgroundView;
                    if(bg.cellPosition != MMGroupedCellPositionBottom){
                        [bg setCellPosition:MMGroupedCellPositionBottom];
                    }
                }else{
                    CGRect frame = cellWithShadow.backgroundView.frame;
                    MMShadowCellBackground *newBG = [[MMShadowCellBackground alloc] initWithFrame:frame];
                    newBG.cellPosition = MMGroupedCellPositionBottom;
                     newBG.showSeperator = YES;
                    cellWithShadow.backgroundView = newBG;
                }
            break;

            }
            if (isShadowBG) {
                MMShadowCellBackground *bg = (MMShadowCellBackground*)cellWithShadow.backgroundView;
                if(bg.cellPosition != MMGroupedCellPositionMiddle){
                    [bg setCellPosition:MMGroupedCellPositionMiddle];
                }
            }else{
                CGRect frame = cellWithShadow.backgroundView.frame;
                MMShadowCellBackground *newBG = [[MMShadowCellBackground alloc] initWithFrame:frame];
                newBG.cellPosition = MMGroupedCellPositionMiddle;
                 newBG.showSeperator = YES;
                cellWithShadow.backgroundView = newBG;
            }
            
            break;
    }
    

    
    return cellWithShadow;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0){
        return kMMPlaceInformationCellHeight;
    }
    
    NSNumber *numberOfCells = [_numberOfCellsInSections objectAtIndex:indexPath.section];
    
    if(indexPath.section ==  1){
        return 50;
    }

    
    return UITableViewAutomaticDimension;
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
    navBar.translucentFactor = 1.0 - ((0.6 - 0.2) * visibility + 0.2);
}
@end
