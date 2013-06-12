//
//  MMHappeningViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 6/11/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMHappeningViewController.h"
#import "MMTrendingMedia.h"
#import "MMMediaObject.h"
#import "MMJSONCommon.h"
#import "MMRequestInboxCell.h"
#import "MMSectionHeaderWithBadgeView.h"
#import "UIBarButtonItem+NoBorder.h"

@interface MMHappeningViewController ()

@property (nonatomic, strong) NSArray *favoriteMedia;
@property (nonatomic, strong) NSArray *topViewedMedia;
@property (nonatomic, strong) NSArray *myInterestsMedia;
@property (nonatomic, strong) NSArray *nearByMedia;

@property (nonatomic, strong) NSArray *favoriteMediaWrappers;
@property (nonatomic, strong) NSArray *topViewedMediaWrappers;
@property (nonatomic, strong) NSArray *myInterestsMediaWrappers;
@property (nonatomic, strong) NSArray *nearByMediaWrappers;

@property (nonatomic, strong) UIImageView * noMediaImageView;

@end

@implementation MMHappeningViewController

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
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor MMEggShell];
    
    UIBarButtonItem *menuItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"whiteBackButton"] selectedImage:nil target:self.navigationController action:@selector(popViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = menuItem;
    
    
    _noMediaImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 149)/2, 120, 149, 95)];
    [_noMediaImageView setImage:[UIImage imageNamed:@"noMedia"]];
    [self.view addSubview:_noMediaImageView];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewDidAppear:(BOOL)animated {
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
        [[MMClientSDK sharedSDK]signInScreen:self];
    }else{
        NSLog(@"USERNAME: %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]);
    }
    
    [self reloadMedia];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)mediaCellWrappersWithMediaObjects:(NSArray *)mediaObjects {
    
    NSMutableArray * arrayOfWrappers = [NSMutableArray arrayWithCapacity:mediaObjects.count];
    for (MMMediaObject * mediaObject in mediaObjects){
        
        MMRequestWrapper * requestWrapper;
        if(mediaObject.mediaType == MMMediaTypeVideo){
            
            requestWrapper = [[MMMediaRequestWrapper alloc] initWithTableWidth:320];
            ((MMMediaRequestWrapper *)requestWrapper).mediaURL = mediaObject.thumbURL;
            
        }else if(mediaObject.mediaType == MMMediaTypePhoto){
            
            requestWrapper = [[MMMediaRequestWrapper alloc] initWithTableWidth:320];
            ((MMMediaRequestWrapper *)requestWrapper).mediaURL = mediaObject.mediaURL;
            
        }else if(mediaObject.mediaType == MMMediaTypeLiveVideo){
            requestWrapper = [[MMMediaRequestWrapper alloc] initWithTableWidth:320];
        }else{
            requestWrapper = [[MMRequestWrapper alloc] initWithTableWidth:320];
        }
        
        requestWrapper.mediaType = mediaObject.mediaType;
        requestWrapper.durationSincePost = [MMJSONCommon dateStringDurationSinceDate:mediaObject.uploadDate];
        requestWrapper.cellStyle = MMRequestCellStyleTimeline;
        requestWrapper.nameOfLocation = mediaObject.nameOfPlace;
        requestWrapper.isAnswered = YES;
        
        MMRequestObject * requestObject = [[MMRequestObject alloc] init];
        requestObject.mediaObject = mediaObject;
        
        requestWrapper.requestObject = requestObject;
        
        
        
        
        [arrayOfWrappers addObject:requestWrapper];
        
    }
    return arrayOfWrappers;
    
}

-(void)reloadMedia{
    [MMTrendingMedia getTrendingMediaForAllTypesCompletion:^(NSArray *mediaObjects, MMTrendingType trendingType, NSError *error) {
        
        switch (trendingType) {
            case MMTrendingTypeFavorites:
                self.favoriteMedia = mediaObjects;
                self.favoriteMediaWrappers = [self mediaCellWrappersWithMediaObjects:mediaObjects];
                [self.tableView reloadData];
                break;
            case MMTrendingTypeMyInterests:
                self.myInterestsMedia = mediaObjects;
                self.myInterestsMediaWrappers = [self mediaCellWrappersWithMediaObjects:mediaObjects];
                [self.tableView reloadData];
                break;
            case MMTrendingTypeNearBy:
                self.nearByMedia = mediaObjects;
                self.nearByMediaWrappers = [self mediaCellWrappersWithMediaObjects:mediaObjects];
                [self.tableView reloadData];
                break;
            case MMTrendingTypeTopViewed:
                self.topViewedMedia = mediaObjects;
                self.topViewedMediaWrappers = [self mediaCellWrappersWithMediaObjects:mediaObjects];
                [self.tableView reloadData];
                break;
                
            default:
                break;
        }
        
        if(!self.favoriteMedia.count > 0 &&
           !self.myInterestsMedia.count > 0 &&
           !self.nearByMedia.count > 0 &&
           !self.topViewedMedia.count > 0 ) {
           _noMediaImageView.hidden = NO;
        }else{
            _noMediaImageView.hidden = YES;
        }
        
        [self.tableView reloadData];
    }];
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
    
    switch (section) {
        case 0:
            return self.favoriteMedia.count;
        case 1:
            return self.myInterestsMedia.count;
        case 2:
            return self.nearByMedia.count;
        case 3:
            return self.topViewedMedia.count;
            
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MMRequestInboxCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[MMRequestInboxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    MMRequestWrapper * wrapper;
    
    switch (indexPath.section) {
        case 0:
            wrapper = [self.favoriteMediaWrappers objectAtIndex:indexPath.row];
            break;
        case 1:
            wrapper = [self.myInterestsMediaWrappers objectAtIndex:indexPath.row];
            break;
        case 2:
            wrapper = [self.nearByMediaWrappers objectAtIndex:indexPath.row];
            break;
        case 3:
            wrapper = [self.topViewedMediaWrappers objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    
    [cell setRequestInboxWrapper:wrapper];
    
    
    // Configure the cell...
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMRequestWrapper * wrapper;
    
    switch (indexPath.section) {
        case 0:
            wrapper = [self.favoriteMediaWrappers objectAtIndex:indexPath.row];
            break;
        case 1:
            wrapper = [self.myInterestsMediaWrappers objectAtIndex:indexPath.row];
            break;
        case 2:
            wrapper = [self.nearByMediaWrappers objectAtIndex:indexPath.row];
            break;
        case 3:
            wrapper = [self.topViewedMediaWrappers objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    
    return [wrapper cellHeight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSNumber *number = nil;
    
    switch (section) {
        case 0:
            number = [NSNumber numberWithInt:self.favoriteMediaWrappers.count];
            break;
        case 1:
            number = [NSNumber numberWithInt:self.myInterestsMediaWrappers.count];
            break;
        case 2:
            number = [NSNumber numberWithInt:self.nearByMediaWrappers.count];
            break;
        case 3:
            number = [NSNumber numberWithInt:self.topViewedMediaWrappers.count];
            break;
            
        default:
            break;
    }
    
    if(number.intValue > 0){
        return 25.0f;
    }else{
        return 0.0f;
    }

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    NSNumber *number = nil;
    
    switch (section) {
        case 0:
            title = @"Favorites";
            number = [NSNumber numberWithInt:self.favoriteMediaWrappers.count];
            break;
        case 1:
            title = @"My Interests";
            number = [NSNumber numberWithInt:self.myInterestsMediaWrappers.count];
            break;
        case 2:
            title = @"Nearby";
            number = [NSNumber numberWithInt:self.nearByMediaWrappers.count];
            break;
        case 3:
            title = @"Top Viewed";
            number = [NSNumber numberWithInt:self.topViewedMediaWrappers.count];
            break;
            
        default:
            break;
    }
    
    return [[MMSectionHeaderWithBadgeView alloc] initWithTitle:title andBadgeNumber:number];
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

@end
