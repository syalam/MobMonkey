//
//  MMLocationViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 5/6/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMLocationViewController.h"
#import "MMLocationHeaderView.h"
#import "MMLocationMediaView.h"
#import <QuartzCore/QuartzCore.h>
#import "MMRequestViewController.h"

@interface MMLocationViewController ()

@end

@implementation MMLocationViewController

@synthesize mediaArray;

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
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    self.tableView.backgroundView = nil;
    
    headerView = [[MMLocationHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
    headerView.layer.zPosition = 100;
    headerView.backgroundColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    
    UIView *headerViewSpacer = [[UIView alloc] initWithFrame:headerView.frame];
    [self.tableView addSubview:headerView];
    [self.tableView setTableHeaderView:headerViewSpacer];
    
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    [self.tableView setTableFooterView:footerView];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   // [self.tableView reloadData];
    
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    headerView.mediaView.liveStreamButton.tag = MMLiveCameraMediaType;
    headerView.mediaView.videosButton.tag = MMVideoMediaType;
    headerView.mediaView.photosButton.tag = MMPhotoMediaType;
    
    [headerView.mediaView.videosButton addTarget:self action:@selector(mediaButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.mediaView.liveStreamButton addTarget:self action:@selector(mediaButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.mediaView.photosButton addTarget:self action:@selector(mediaButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView.makeARequestButton addTarget:self action:@selector(makeRequestButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //No Rows if there is no location information
    if(!self.locationInformation && section == 0){
        return 1;
    }
    
    NSUInteger rowCount = 0;
    if(section == 0){
        rowCount = self.locationCellData.count;
    }else if(section == 2){
        
        // Row for "Add to Favorites
        rowCount  = 1;
    }else if(section == 1){
        return self.locationInformation.sublocations.count ;
    }
    
    return rowCount;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"Test";
    
    
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

#pragma mark - ScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect newFrame = headerView.frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.tableView.contentOffset.y;
    headerView.frame = newFrame;
}

#pragma mark Button methods
#pragma mark - IBAction Methods
- (IBAction)mediaButtonTapped:(id)sender
{
    switch ([sender tag]) {
        case MMLiveCameraMediaType:
            if ([[self.locationInformation.livestreaming description] intValue] == 0)
                return;
            
            break;
            
        case MMVideoMediaType:
            if ([[self.locationInformation.videos description] intValue] == 0)
                return;
            
            break;
            
        case MMPhotoMediaType:
            if ([[self.locationInformation.images description] intValue] == 0)
                return;
            
            break;
            
        default:
            break;
    }
    
    MMLocationMediaViewController *lmvc = [[MMLocationMediaViewController alloc] initWithNibName:@"MMLocationMediaViewController" bundle:nil];
    //lmvc.location = self.contentList;
    lmvc.locationInformation = self.locationInformation;
    lmvc.title = self.title;
    lmvc.providerId = self.locationInformation.locationID;
    lmvc.locationId = self.locationInformation.providerID;
    lmvc.mediaType = [sender tag];
    
    UINavigationController *locationMediaNavC = [[UINavigationController alloc] initWithRootViewController:lmvc];
    [self presentViewController:locationMediaNavC animated:YES completion:NULL];
}
- (IBAction)videoMediaButtonTapped:(id)sender {
    
}

- (IBAction)makeRequestButtonTapped:(id)sender {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Request" bundle:nil];
        UINavigationController *navVC = [storyboard instantiateInitialViewController];
        MMRequestViewController *requestVC = (MMRequestViewController *)navVC.viewControllers[0];
        requestVC.locationInformation = self.locationInformation;
        //[requestVC setContentList:self.contentList];
        [self.navigationController presentViewController:navVC animated:YES completion:nil];
    }
    else {
        [[MMClientSDK sharedSDK] signInScreen:self];
    }
}
- (IBAction)shareButtonTapped:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    BOOL isVideo = NO;
    [params setValue:headerView.locationTitleLabel.text forKey:@"initialText"];
    if (mediaArray.count > 0) {
        if ([[[mediaArray objectAtIndex:0]valueForKey:@"type"]isEqualToString:@"video"]) {
            [params setValue:[[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"] forKey:@"url"];
            isVideo = YES;
        }
        else {
            [params setValue:headerView.mediaView.mediaImageView.image forKey:@"image"];
        }
    }
    if (![self.locationInformation.website isKindOfClass:[NSNull class]] && ![self.locationInformation.website isEqualToString:@""] && !isVideo) {
        [params setValue:self.locationInformation.website forKey:@"url"];
    }
    
    [[MMClientSDK sharedSDK]showMoreActionSheet:self showFromTabBar:YES paramsForPublishingToSocialNetwork:params];
}


@end
