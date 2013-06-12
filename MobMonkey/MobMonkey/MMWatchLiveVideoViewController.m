//
//  MMWatchLiveVideoViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 6/11/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMWatchLiveVideoViewController.h"
#import "MMMediaObject.h"
#import "MMLiveVideoWrapper.h"
#import "MMLiveVideoCell.h"
#import "BrowserViewController.h"
#import "UIBarButtonItem+NoBorder.h"
@interface MMWatchLiveVideoViewController ()

@property (nonatomic, strong) NSArray *liveVideoWrappers;

@end

@implementation MMWatchLiveVideoViewController

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
    
    self.title = @"Live Video Cameras";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.930 green:0.911 blue:0.920 alpha:1.000];
    
    UIBarButtonItem *menuItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"whiteBackButton"] selectedImage:nil target:self.navigationController action:@selector(popViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = menuItem;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadWrappers];
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
    return self.liveVideoWrappers.count;
}

-(void)loadWrappers {
    NSMutableArray * liveVideoWrappers = [NSMutableArray arrayWithCapacity:self.mediaObjects.count];
    
    
    for (MMMediaObject * mediaObject in self.mediaObjects){
        MMLiveVideoWrapper * wrapper = [[MMLiveVideoWrapper alloc] init];
        wrapper.cameraName = @"Test Live Video";
        wrapper.messageString = @"Come check out our great deals at MobMonkey";
        wrapper.messageURL = [NSURL URLWithString:@"http://mobmonkey.com"];
        wrapper.webcamPlaceholder = [UIImage imageNamed:@"liveStreamPlaceholder"];
        wrapper.mediaURL = mediaObject.mediaURL;
        wrapper.mediaObject = mediaObject;
        
        [liveVideoWrappers addObject:wrapper];
    }
    
    self.liveVideoWrappers = liveVideoWrappers;
    
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LiveVideoCell";
    MMLiveVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[MMLiveVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
    }
    
    [cell setLiveVideoWrapper:[self.liveVideoWrappers objectAtIndex:indexPath.row]];
    
    // Configure the cell...
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMLiveVideoWrapper * wrapper = [self.liveVideoWrappers objectAtIndex:indexPath.row];
    return wrapper.cellHeight;
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

#pragma mark - Live Video Cell Delegate

-(void)liveVideoCell:(MMLiveVideoCell *)cell openMessageURL:(NSURL *)messageURL {
    BrowserViewController *bvc = [[BrowserViewController alloc] initWithUrls:messageURL];
    /*UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    bvc.navigationItem.leftBarButtonItem = backButton;*/
    
    //Add backbutton
    UIBarButtonItem *menuItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"whiteBackButton"] selectedImage:nil target:self.navigationController action:@selector(popViewControllerAnimated:)];
     bvc.navigationItem.leftBarButtonItem = menuItem;
    
    [self.navigationController pushViewController:bvc animated:YES];
}

@end
