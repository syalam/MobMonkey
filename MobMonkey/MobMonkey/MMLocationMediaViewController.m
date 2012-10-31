//
//  MMLocationMediaViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/5/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMLocationMediaViewController.h"
#import "MMClientSDK.h"

@interface MMLocationMediaViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;

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
    self.navigationItem.titleView = self.segmentedControl;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.segmentedControl setSelectedSegmentIndex:self.mediaType];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MMLocationMediaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MMLocationMediaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.locationImageView reloadWithUrl:[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaURL"]];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MMLocationMediaCell *cell = (MMLocationMediaCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    UIImage *imageToDisplay = cell.locationImageView.image;
    
    [[MMClientSDK sharedSDK]inboxFullScreenImageScreen:self imageToDisplay:imageToDisplay locationName:self.title];
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
