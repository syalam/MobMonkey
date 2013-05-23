//
//  MMPlaceViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 5/22/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMPlaceViewController.h"

@interface MMPlaceViewController ()

@end

@implementation MMPlaceViewController

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
    
    //_mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, -(self.view.frame.size.height - 200), self.view.frame.size.width, self.view.frame.size.height)];
    
    CGFloat defaultVisibleMapHeight = 200;
    
    self.defaultMapViewFrame = CGRectMake(0.0,
                                          -defaultVisibleMapHeight * 0.5 * 2,
                                          self.tableView.frame.size.width,
                                          defaultVisibleMapHeight + (defaultVisibleMapHeight * 0.5 * 4));
    
    
    
    
    


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if(!_mapView){
        _mapView = [[MKMapView alloc] initWithFrame:self.defaultMapViewFrame];
        self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.mapView.scrollEnabled = NO;
        self.mapView.zoomEnabled = NO;
        self.mapView.delegate = self;
        
        UIView *fakeHeader = [[UIView alloc] initWithFrame:CGRectMake(0, -300, self.view.frame.size.width, 500)];
        
        CGSize currentSize = self.tableView.contentSize;
        currentSize.height -= 300;
        self.tableView.contentSize = currentSize;
        
        CGPoint currentOffset = self.tableView.contentOffset;
        currentOffset.y -= 300;
        self.tableView.contentOffset = currentOffset;
        
        fakeHeader.clipsToBounds = YES;
        [fakeHeader addSubview:_mapView];
        self.tableView.tableHeaderView = fakeHeader;
        
        //[self.tableView addSubview:_mapView];
        //[self.tableView sendSubviewToBack:_mapView];
       // [self.tableView.superview insertSubview:_mapView aboveSubview:self.tableView];
        
    }
    
    
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
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    // Configure the cell...
    
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
#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollOffset = scrollView.contentOffset.y;
    
   // NSLog(@"FLOAT: %f", y);
    // did we drag ?
    NSLog(@"OFFSET: %f", scrollOffset);
    
        CGFloat mapFrameYAdjustment = 0.0;
        

    mapFrameYAdjustment = self.defaultMapViewFrame.origin.y + (scrollOffset * 0.5);
    
    // Don't move the map way off-screen
    if (mapFrameYAdjustment <= -(self.defaultMapViewFrame.size.height)) {
        mapFrameYAdjustment = -(self.defaultMapViewFrame.size.height);
    }


    if (mapFrameYAdjustment) {
        CGRect newMapFrame = self.mapView.frame;
        newMapFrame.origin.y = mapFrameYAdjustment;
        self.mapView.frame = newMapFrame;
    }

}
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
