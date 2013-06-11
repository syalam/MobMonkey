//
//  MMMediaTimelineViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMMediaTimelineViewController.h"
#import "MMMediaObject.h"
#import "MMJSONCommon.h"
#import "MMRequestInboxCell.h"

@interface MMMediaTimelineViewController ()

@end

@implementation MMMediaTimelineViewController

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

    [self loadMediaObjects];
    self.view.backgroundColor = [UIColor MMEggShell];
    self.tableView.backgroundView = nil;
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    UILabel * sortByLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 30)];
    sortByLabel.text = @"Sort By:";
    sortByLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    sortByLabel.textColor = [UIColor darkGrayColor];
    sortByLabel.backgroundColor = self.view.backgroundColor;
    
    [headerView addSubview:sortByLabel];
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"Time", @"Type"]];
                                          
                                          
    segmentControl.frame = CGRectMake(sortByLabel.frame.origin.x + sortByLabel.frame.size.width + 10, 8, self.view.frame.size.width - 110, 34);
    
    [headerView addSubview:segmentControl];
    
    self.tableView.tableHeaderView = headerView;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        requestWrapper.isAnswered = YES;
        
        MMRequestObject * requestObject = [[MMRequestObject alloc] init];
        requestObject.mediaObject = mediaObject;
        
        requestWrapper.requestObject = requestObject;
        
    
        
        
        [arrayOfWrappers addObject:requestWrapper];
        
    }
    return arrayOfWrappers;
    
}
-(void)loadMediaObjects {
    [MMAPI getMediaObjectsForLocationID:self.locationInformation.locationID providerID:self.locationInformation.providerID success:^(NSArray *mediaObjects) {
        
        NSLog(@"MEDIA: %@", mediaObjects);
        MMMediaObject * mediaObject;
        if(mediaObjects.count > 0) {
            mediaObject= [mediaObjects objectAtIndex:0];
        }
       
        NSLog(@"");
        
        self.mediaObjects = mediaObjects;
        self.mediaCellWrappers = [self mediaCellWrappersWithMediaObjects:mediaObjects];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.mediaCellWrappers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MMRequestInboxCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[MMRequestInboxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        
    }
    
    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    test.backgroundColor = [UIColor redColor];
    
    [cell setRequestInboxWrapper: [self.mediaCellWrappers objectAtIndex:indexPath.row]];
    
    
    //[cell redisplay];
    // Configure the cell...
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = [[self.mediaCellWrappers objectAtIndex:indexPath.row] cellHeight];
    return cellHeight;
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
