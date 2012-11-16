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
    }
    
    
    return cell;
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

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 370;
}

#pragma mark - UINavBar Action Methods

#pragma mark - MMAnsweredRequestCell delegate
-(void)moreButtonTapped:(id)sender {
    
}
-(void)acceptButtonTapped:(id)sender {
    
}
-(void)rejectButtonTapped:(id)sender {
    
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

@end
