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
#import "Reachability.h"

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
    self.mediaArray = @[];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.mediaArray objectAtIndex:indexPath.row] valueForKey:@"mediaURL"];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.segmentedControl selectedSegmentIndex] == MMLiveCameraMediaType) {
        NSString *hostName = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
        Reachability *reachability = [Reachability reachabilityWithHostname:hostName];
        if ([reachability isReachable]) {
            self.moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:hostName]];
            [self.navigationController presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"The web cam cannot be reached due to a network error. Please try again later." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
