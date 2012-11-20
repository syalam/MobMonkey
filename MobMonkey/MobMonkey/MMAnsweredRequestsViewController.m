//
//  MMAnsweredRequestsViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/7/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMAnsweredRequestsViewController.h"
#import "MMClientSDK.h"
#import "GetRelativeTime.h"
#import "MMLocationViewController.h"

@interface MMAnsweredRequestsViewController ()

@end

@implementation MMAnsweredRequestsViewController

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
    
    backgroundQueue = dispatch_queue_create("com.MobMonkey.GenerateThumbnailQueue", NULL);
    
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;

    /*[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:226.0/255.0
                                                                          green:112.0/225.0
                                                                           blue:36.0/255.0
                                                                          alpha:1.0]];*/
    
    
    [self fetchAnsweredRequests];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MMAnsweredRequestsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MMAnsweredRequestsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    
    cell.timeStampLabel.text = @"";
    cell.locationImageView.image = nil;
    cell.locationNameLabel.text = @"";
    
    if (![[[_contentList objectAtIndex:indexPath.row]valueForKey:@"nameOfLocation"] isKindOfClass:[NSNull class]]) {
        cell.locationNameLabel.text = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"nameOfLocation"];
    }
    if (![[[_contentList objectAtIndex:indexPath.row]valueForKey:@"fulfilledDate"] isKindOfClass:[NSNull class]]) {
        double unixTime = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"fulfilledDate"] floatValue]/1000;
        NSDate *dateAnswered = [NSDate dateWithTimeIntervalSince1970:
                             (NSTimeInterval)unixTime];
        
        cell.timeStampLabel.text = [GetRelativeTime getRelativeTime:dateAnswered];
    }
    if (![[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaUrl"] isKindOfClass:[NSNull class]]) {
        if ([[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaType"]intValue] == 1) {
            [cell.locationImageView reloadWithUrl:[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaUrl"]];
        }
        else {
            dispatch_async(backgroundQueue, ^(void) {
                cell.locationImageView.image =  [self generateThumbnailForVideo:indexPath.row];
            });
        }
    }
    
    cell.moreButton.tag = indexPath.row;
    cell.locationNameButton.tag = indexPath.row;
    cell.imageButton.tag = indexPath.row;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 370;
}

#pragma mark - UINavBar Action Methods

#pragma mark - MMAnsweredRequestCell delegate
-(void)locationNameButtonTapped:(id)sender {
    NSString *locationId = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"locationId"];
    NSString *providerId = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"providerId"];
    
    MMLocationViewController *locationViewController = [[MMLocationViewController alloc]initWithNibName:@"MMLocationViewController" bundle:nil];
    [locationViewController loadLocationDataWithLocationId:locationId providerId:providerId];
    [self.navigationController pushViewController:locationViewController animated:YES];
}

-(void)moreButtonTapped:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", @"Flag for Review", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}
-(void)acceptButtonTapped:(id)sender {
    
}
-(void)rejectButtonTapped:(id)sender {
    
}
-(void)imageButtonTapped:(id)sender {
    MMAnsweredRequestsCell *cell = (MMAnsweredRequestsCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    
    if ([[[_contentList objectAtIndex:[sender tag]]valueForKey:@"mediaType"]intValue] == 1) {
        [[MMClientSDK sharedSDK] inboxFullScreenImageScreen:self imageToDisplay:cell.locationImageView.image locationName:cell.locationNameLabel.text];
    }
    else {
        NSURL *url = [NSURL URLWithString:[[_contentList objectAtIndex:[sender tag]]valueForKey:@"mediaUrl"]];
        NSLog(@"%@", url);
        MPMoviePlayerViewController* player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self.navigationController presentMoviePlayerViewControllerAnimated:player];
    }
    
    
}

- (void)viewDidUnload {
    [self setAcceptRejectCell:nil];
    [super viewDidUnload];
}


#pragma mark - Helper Methods
- (void)fetchAnsweredRequests {
    [SVProgressHUD showWithStatus:@"Loading Answered Requests"];
    [MMAPI getFulfilledRequestsOnSuccess:^(id responseObject) {
        NSLog(@"%@", responseObject);
        [SVProgressHUD dismiss];
        [self setContentList:responseObject];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismissWithError:@"Unable to load"];
    }];
}

- (UIImage*)generateThumbnailForVideo:(int)row {
    UIImage *thumbnailImage;
    
    if ([_thumbnailCache valueForKey:[NSString stringWithFormat:@"%d", row]]) {
        thumbnailImage = [_thumbnailCache valueForKey:[NSString stringWithFormat:@"%d", row]];
    }
    else {
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:[[_contentList objectAtIndex:row]valueForKey:@"mediaUrl"]] options:nil];
        AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generate.appliesPreferredTrackTransform = YES;
        NSError *err = NULL;
        CMTime time = CMTimeMake(0, 60);
        CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
        
        thumbnailImage = [UIImage imageWithCGImage:imgRef];
        [_thumbnailCache setValue:thumbnailImage forKey:[NSString stringWithFormat:@"%d", row]];
    }
    
    return thumbnailImage;
}

@end
