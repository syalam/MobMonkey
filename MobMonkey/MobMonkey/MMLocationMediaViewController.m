//
//  MMLocationMediaViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/5/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMLocationMediaViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MMClientSDK.h"

@interface MMLocationMediaViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSArray __block *mediaArray;
@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayerViewController;

- (void)selectMediaType:(id)sender;

@end

@implementation MMLocationMediaViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    backgroundQueue = dispatch_queue_create("com.MobMonkey.GenerateThumbnailQueue", NULL);
    
    //Add custom back button to the nav bar
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self.navigationController action:@selector(dismissModalViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Live Camera", @"Videos", @"Photos"]];
    [self.segmentedControl setTintColor:[UIColor colorWithRed:230.0/255.0 green:113.0/255.0 blue:34.0/255.0 alpha:1.0]];
    [self.segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [self.segmentedControl addTarget:self action:@selector(selectMediaType:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentedControl;
    
    _thumbnailCache = [[NSMutableDictionary alloc]init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.segmentedControl setSelectedSegmentIndex:self.mediaType];
    [self selectMediaType:self.segmentedControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectMediaType:(id)sender
{
    _mediaArray = nil;
    self.mediaType = [sender selectedSegmentIndex];
    [self.tableView reloadData];
    NSArray *mediaTypes = @[@"livestreaming", @"video", @"image"];
    [MMAPI getMediaForLocationID:[self.location valueForKey:@"locationId"] providerID:[self.location valueForKey:@"providerId"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type LIKE %@", mediaTypes[[sender selectedSegmentIndex]]];
        self.mediaArray = [[responseObject valueForKey:@"media"] filteredArrayUsingPredicate:predicate];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Could not add Bookmark!");
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mediaArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MMLocationMediaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MMLocationMediaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([self.segmentedControl selectedSegmentIndex] == MMPhotoMediaType) {
        [cell.locationImageView reloadWithUrl:[[self.mediaArray objectAtIndex:indexPath.row] valueForKey:@"mediaURL"]];
    }
    else {
        cell.locationImageView.image = nil;
        dispatch_async(backgroundQueue, ^(void) {
            cell.locationImageView.image =  [self generateThumbnailForVideo:indexPath.row];
        });
    }
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *urlString = [[self.mediaArray objectAtIndex:indexPath.row] valueForKey:@"mediaURL"];
    if ([self.segmentedControl selectedSegmentIndex] != MMPhotoMediaType) {
        self.moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:urlString]];
        [self.navigationController presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];
    } else {
        MMLocationMediaCell *cell = (MMLocationMediaCell*)[tableView cellForRowAtIndexPath:indexPath];
        [[MMClientSDK sharedSDK] inboxFullScreenImageScreen:self imageToDisplay:cell.locationImageView.image locationName:self.title];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - Helper Methods
- (UIImage*)generateThumbnailForVideo:(int)row {
    UIImage *thumbnailImage;
    
    if ([_thumbnailCache valueForKey:[NSString stringWithFormat:@"%d", row]]) {
        thumbnailImage = [_thumbnailCache valueForKey:[NSString stringWithFormat:@"%d", row]];
    }
    else {
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:[[self.mediaArray objectAtIndex:row] valueForKey:@"mediaURL"]] options:nil];
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
