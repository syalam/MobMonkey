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
        // Custom initialization
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
    }
    
    
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

- (void)getTrendingCounts {
    NSDictionary *params = [NSDictionary dictionaryWithObject:@"true" forKey:@"countsonly"];
    [MMAPI getTrendingType:@"topviewed" params:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        trendingCategoryCountsDictionary = responseObject;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
    }];
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
            cell.textLabel.text = @"Bookmarks";
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
            if ([[trendingCategoryCountsDictionary valueForKey:@"interestsCount"]intValue] > 0) {
                cell.categoryItemCountLabel.text = [NSString stringWithFormat:@"%i", [[trendingCategoryCountsDictionary valueForKey:@"interestsCount"]intValue]];
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
                [self loadTrendingItem:params categoryTitle:@"Bookmarks"];
            }
            break;
        case 1: {
            if ([[trendingCategoryCountsDictionary valueForKey:@"interestsCount"]intValue] > 0) {
                NSDictionary *favorites = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedInterests"];
                NSString *favoritesParams = [[favorites allValues] componentsJoinedByString:@","];
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
    if (!self.locationsViewController) {
        self.locationsViewController = [[MMLocationsViewController alloc] initWithNibName:@"MMLocationsViewController" bundle:nil];
    }
    [self.navigationController pushViewController:self.locationsViewController animated:YES];
    self.locationsViewController.locations = [@[] mutableCopy];
    self.locationsViewController.title = categoryTitle;
    
    NSLog(@"%@", params);
    
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"Loading %@", categoryTitle]];
    [MMAPI getTrendingType:@"topviewed" params:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.locationsViewController.isSearching = NO;
        [SVProgressHUD dismiss];
        NSLog(@"%d", [operation.response statusCode]);
        NSLog(@"%@", responseObject);
        self.locationsViewController.locations = responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%d", [operation.response statusCode]);
        NSLog(@"%@", operation.responseString);
        [SVProgressHUD showErrorWithStatus:@"Unable to load"];
        [self.locationsViewController.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - MMTrendingCell Delegate Methods
-(void)locationNameButtonTapped:(id)sender {
    NSString *locationId = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"locationId"];
    NSString *providerId = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"providerId"];
    
    MMLocationViewController *locationViewController = [[MMLocationViewController alloc]initWithNibName:@"MMLocationViewController" bundle:nil];
    [locationViewController loadLocationDataWithLocationId:locationId providerId:providerId];
    [self.navigationController pushViewController:locationViewController animated:YES];
}
-(void)moreButtonTapped:(id)sender {
    selectedRow = [sender tag];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", @"Flag for Review", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}
-(void)imageButtonTapped:(id)sender {
    MMTrendingCell *cell = (MMTrendingCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    if ([[[_contentList objectAtIndex:[sender tag]]valueForKey:@"mediaType"]intValue] != 4) {
        if ([[[_contentList objectAtIndex:[sender tag]]valueForKey:@"mediaType"]intValue] == 1) {
            [[MMClientSDK sharedSDK] inboxFullScreenImageScreen:self imageToDisplay:cell.locationImageView.image locationName:cell.locationNameLabel.text];
        }
        else {
            NSArray *mediaArray  = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"media"];
            if (mediaArray.count > 0) {
                NSURL *url = [NSURL URLWithString:[[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"]];
                NSLog(@"%@", url);
                MPMoviePlayerViewController* player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
                [self.navigationController presentMoviePlayerViewControllerAnimated:player];
            }
        }
    }
}


#pragma mark - Action Sheet Delegate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Share on Facebook"]) {
        if ([FBSession.activeSession.permissions
             indexOfObject:@"publish_actions"] == NSNotFound) {
            // No permissions found in session, ask for it
            [FBSession.activeSession
             reauthorizeWithPublishPermissions:
             [NSArray arrayWithObject:@"publish_actions"]
             defaultAudience:FBSessionDefaultAudienceFriends
             completionHandler:^(FBSession *session, NSError *error) {
                 if (!error) {
                     // If permissions granted, publish the story
                     [self publishStoryToFacebook];
                 }
             }];
        }
        else {
            [self publishStoryToFacebook];
        }
    }
    else if ([buttonTitle isEqualToString:@"Share on Twitter"]) {
        [self publishOnTwitter];
    }
    else if ([buttonTitle isEqualToString:@"Flag for Review"]) {
        
    }
}


#pragma mark - Helper Methods
- (void)publishStoryToFacebook
{
    MMTrendingCell *cell = (MMTrendingCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    BOOL isVideo = NO;
    NSArray *mediaArray  = [[_contentList objectAtIndex:selectedRow]valueForKey:@"media"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:cell.locationNameLabel.text forKey:@"initialText"];
    if (mediaArray.count > 0) {
        if ([[[_contentList objectAtIndex:selectedRow]valueForKey:@"mediaType"]intValue] == 1) {
            [params setValue:cell.locationImageView.image forKey:@"image"];
        }
        else if ([[[_contentList objectAtIndex:selectedRow]valueForKey:@"mediaType"]intValue] == 2) {
            [params setValue:[[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"] forKey:@"url"];
            isVideo = YES;
        }
        else if ([[[_contentList objectAtIndex:selectedRow]valueForKey:@"mediaType"]intValue] == 4) {
            NSString *initialText = [params valueForKey:@"initialText"];
            if (![[[mediaArray objectAtIndex:0]valueForKey:@"text"]isKindOfClass:[NSNull class]]) {
                initialText = [NSString stringWithFormat:@"%@. %@", initialText, [[mediaArray objectAtIndex:0]valueForKey:@"text"]];
            }
            [params setValue:initialText forKey:@"initialText"];
        }
    }
    if (!isVideo) {
        if (![[[_contentList objectAtIndex:selectedRow]valueForKey:@"webSite"] isKindOfClass:[NSNull class]] && ![[[_contentList objectAtIndex:selectedRow]valueForKey:@"webSite"]isEqualToString:@""]) {
            [params setValue:[[_contentList objectAtIndex:selectedRow]valueForKey:@"webSite"] forKey:@"url"];
        }
    }
    
    [[MMClientSDK sharedSDK]shareViaFacebook:params presentingViewController:self];
}

- (void)publishOnTwitter {
    MMTrendingCell *cell = (MMTrendingCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    BOOL isVideo = NO;
    NSArray *mediaArray  = [[_contentList objectAtIndex:selectedRow]valueForKey:@"media"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:cell.locationNameLabel.text forKey:@"initialText"];
    if (mediaArray.count > 0) {
        if ([[[_contentList objectAtIndex:selectedRow]valueForKey:@"mediaType"]intValue] == 1) {
            [params setValue:cell.locationImageView.image forKey:@"image"];
        }
        else if ([[[_contentList objectAtIndex:selectedRow]valueForKey:@"mediaType"]intValue] == 2) {
            [params setValue:[[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"] forKey:@"url"];
            isVideo = YES;
        }
        else if ([[[_contentList objectAtIndex:selectedRow]valueForKey:@"mediaType"]intValue] == 4) {
            NSString *initialText = [params valueForKey:@"initialText"];
            if (![[[mediaArray objectAtIndex:0]valueForKey:@"text"]isKindOfClass:[NSNull class]]) {
                initialText = [NSString stringWithFormat:@"%@. %@", initialText, [[mediaArray objectAtIndex:0]valueForKey:@"text"]];
            }
            [params setValue:initialText forKey:@"initialText"];
        }
    }
    if (!isVideo) {
        if (![[[_contentList objectAtIndex:selectedRow]valueForKey:@"webSite"] isKindOfClass:[NSNull class]] && ![[[_contentList objectAtIndex:selectedRow]valueForKey:@"webSite"]isEqualToString:@""]) {
            [params setValue:[[_contentList objectAtIndex:selectedRow]valueForKey:@"webSite"] forKey:@"url"];
        }
    }
    
    
    [[MMClientSDK sharedSDK]shareViaTwitter:params presentingViewController:self];
}
    
@end
