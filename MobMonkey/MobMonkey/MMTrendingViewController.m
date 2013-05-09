//
//  MMTrendingViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/31/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMTrendingViewController.h"
#import "MMSetTitleImage.h"
#import "MMLocationViewController.h"
#import "MMFullScreenImageViewController.h"
#import "MMAppDelegate.h"
#import "SectionInfo.h"
#import "MMClientSDK.h"
#import "MMLocationsViewController.h"
#import "MMInboxCategoryCell.h"
#import "MMTrendingDetailViewController.h"
#import "UAPush.h"

@interface MMTrendingViewController ()

@property (strong, nonatomic) MMLocationsViewController *locationsViewController;

@end

#define DEFAULT_ROW_HEIGHT 78
#define HEADER_HEIGHT 80

@implementation MMTrendingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
        [[MMClientSDK sharedSDK]signInScreen:self];
    }
    else {
        [self getTrendingCounts];
        [[UAPush shared] setAlias:[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]];
        [[UAPush shared] updateRegistration];
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MMInboxCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[MMInboxCategoryCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor blackColor];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Favorites";
            if ([[trendingCategoryCountsDictionary valueForKey:@"bookmarkCount"]intValue] > 0) {
                cell.categoryItemCountLabel.text = [NSString stringWithFormat:@"%i", [[trendingCategoryCountsDictionary valueForKey:@"bookmarkCount"]intValue]];
            }
            else {
                cell.categoryItemCountLabel.text = @"";
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case 1:
            cell.textLabel.text = @"My Interests";
            if (myInterestsArray.count > 0) {
                cell.categoryItemCountLabel.text = [NSString stringWithFormat:@"%i", myInterestsArray.count];
            }
            else {
                cell.categoryItemCountLabel.text = @"";
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case 2:
            cell.textLabel.text = @"Top Viewed";
            if ([[trendingCategoryCountsDictionary valueForKey:@"topviewedCount"]intValue] > 0) {
                cell.categoryItemCountLabel.text = [NSString stringWithFormat:@"%i", [[trendingCategoryCountsDictionary valueForKey:@"topviewedCount"]intValue]];
            }
            else {
                cell.categoryItemCountLabel.text = @"";
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case 3:
            cell.textLabel.text = @"Near Me";
            if ([[trendingCategoryCountsDictionary valueForKey:@"nearbyCount"]intValue] > 0) {
                cell.categoryItemCountLabel.text = [NSString stringWithFormat:@"%i", [[trendingCategoryCountsDictionary valueForKey:@"nearbyCount"]intValue]];
            }
            else {
                cell.categoryItemCountLabel.text = @"";
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        default:
            break;
    }
    
    cell.pillboxImageView.image = nil;
    
    if (cell.categoryItemCountLabel.text.length == 1) {
        cell.pillboxImageView.image = [UIImage imageNamed:@"pillBoxSmall"];
    }
    else if (cell.categoryItemCountLabel.text.length == 2) {
        cell.pillboxImageView.image = [UIImage imageNamed:@"pillBoxMed"];
    }
    else if (cell.categoryItemCountLabel.text.length == 3) {
        cell.pillboxImageView.image = [UIImage imageNamed:@"pillBoxLarge"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    double latitude, longitude;
    NSMutableDictionary *params = [@{@"timeSpan":@"week"} mutableCopy];
    
    
    latitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"]doubleValue];
    longitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"]doubleValue];
    
    switch (indexPath.row) {
        case 0:
            if ([[trendingCategoryCountsDictionary valueForKey:@"bookmarkCount"]intValue] > 0) {
                [params setValue:@"true" forKey:@"bookmarksonly"];
                [self loadTrendingItem:params categoryTitle:@"Favorites"];
            }
            break;
        case 1: {
            if (myInterestsArray.count > 0) {
                NSString *selectedInterestsKey = [NSString stringWithFormat:@"%@ selectedInterests", [[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
                NSDictionary *favorites = [[NSUserDefaults standardUserDefaults] valueForKey:selectedInterestsKey];                NSString *favoritesParams = [[favorites allValues] componentsJoinedByString:@","];
                if (favoritesParams && ![favoritesParams isEqualToString:@""]) {
                    [params setValue:favoritesParams forKey:@"categoryIds"];
                    [params setValue:@"true" forKey:@"myinterests"];
                }
                [self loadTrendingItem:params categoryTitle:@"My Interests"];
            }
        }
            break;
        case 2:
            if ([[trendingCategoryCountsDictionary valueForKey:@"topviewedCount"]intValue] > 0) {
                [self loadTrendingItem:params categoryTitle:@"Top Viewed"];
            }
            break;
        case 3:
            if ([[trendingCategoryCountsDictionary valueForKey:@"nearbyCount"]intValue] > 0) {
                [params setValue:@"true" forKey:@"nearby"];
                [params setValue:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
                [params setValue:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
                [params setValue:[NSNumber numberWithInt:10000] forKey:@"radius"];
                
                [self loadTrendingItem:params categoryTitle:@"Nearby"];
            }
            break;
        default:
            break;
    }
}


#pragma mark - Helper Methods
- (void)loadTrendingItem:(NSDictionary*)params categoryTitle:(NSString*)categoryTitle {
    MMTrendingDetailViewController *trendingDetailViewController = [[MMTrendingDetailViewController alloc]initWithNibName:@"MMTrendingDetailViewController" bundle:nil];
    trendingDetailViewController.title = categoryTitle;
    [self.navigationController pushViewController:trendingDetailViewController animated:YES];
   
    
    NSLog(@"%@", params);
    
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"Loading %@", categoryTitle]];
    [MMAPI getTrendingType:@"topviewed" params:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.locationsViewController.isSearching = NO;
        [SVProgressHUD dismiss];
        NSLog(@"%@", responseObject);
        trendingDetailViewController.contentList = responseObject;
        [trendingDetailViewController.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%d", [operation.response statusCode]);
        NSLog(@"%@", operation.responseString);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Unable to load %@", categoryTitle]];
        [trendingDetailViewController.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)getTrendingCounts {
    NSDictionary *params = [NSDictionary dictionaryWithObject:@"true" forKey:@"countsonly"];
    NSLog(@"Start");
    [MMAPI getTrendingType:@"topviewed" params:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Stop");
        NSLog(@"%@", responseObject);
        trendingCategoryCountsDictionary = responseObject;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
    }];
    
    [self getMyInterestsCount];
}

- (void)getMyInterestsCount {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSString *selectedInterestsKey = [NSString stringWithFormat:@"%@ selectedInterests", [[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    NSDictionary *favorites = [[NSUserDefaults standardUserDefaults] valueForKey:selectedInterestsKey];
    NSString *favoritesParams = [[favorites allValues] componentsJoinedByString:@","];
    if (favoritesParams && ![favoritesParams isEqualToString:@""]) {
        [params setValue:favoritesParams forKey:@"categoryIds"];
        [params setValue:@"true" forKey:@"myinterests"];
        [MMAPI getTrendingType:@"topviewed" params:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
            myInterestsArray = responseObject;
            NSLog(@"My Interests Count: %d", myInterestsArray.count);
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", operation.responseString);
        }];
    }
    else {
        myInterestsArray = [[NSArray alloc]init];
        [self.tableView reloadData];
    }
    
}

@end
