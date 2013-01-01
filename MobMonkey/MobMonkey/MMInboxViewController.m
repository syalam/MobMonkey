//
//  MMInboxViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/31/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMInboxViewController.h"
#import "MMClientSDK.h"
#import "MMSetTitleImage.h"
#import "MMInboxCell.h"
#import "NSData+Base64.h"
#import "MMInboxFullScreenImageViewController.h"
#import "MMInboxCategoryCell.h"
#import "MMLocationsViewController.h"
#import "MMInboxDetailViewController.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 180.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface MMInboxViewController ()

@property (strong, nonatomic) NSMutableArray *openRequests;
@property (strong, nonatomic) NSMutableArray *locationsInOpenRequests;
@property (strong, nonatomic) NSMutableArray *assignedRequests;
@property (strong, nonatomic) NSMutableArray *locationsInAssignedRequests;
@property (strong, nonatomic) NSMutableArray *fulfilledRequests;
@property (nonatomic, retain) UIImageView *mmTitleImageView;
@property (nonatomic, retain) NSMutableArray *contentList;
@property (strong, nonatomic) MMLocationsViewController *locationsViewController;

@end

@implementation MMInboxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:226.0/255.0
                                                                          green:112.0/225.0
                                                                           blue:36.0/255.0
                                                                          alpha:1.0]];
    self.locationsViewController = [[MMLocationsViewController alloc] initWithNibName:@"MMLocationsViewController" bundle:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushNotificationReceived:)
                                                 name:@"pushNotificationReceived"
                                               object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [SVProgressHUD dismiss];
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
        [[MMClientSDK sharedSDK]signInScreen:self];
    }
    
    else if (_categorySelected) {
        //Add custom back button to the nav bar
        UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
        [backNavbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
        
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
        self.navigationItem.leftBarButtonItem = backButton;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setContentList:[@[@"Open Requests", @"Answered Requests", @"Assigned Requests", @"Notifications"] mutableCopy]];
    [self.tableView reloadData];
    [self getInboxCounts];
    //[self reloadInbox];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)getInboxCounts {
    [MMAPI getInboxCounts:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        inboxCountDictionary = responseObject;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
    }];
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *InboxCategoryCellIdentifier = @"InboxCategoryCell";
    MMInboxCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:InboxCategoryCellIdentifier];
    
    if (!cell) {
        cell = [[MMInboxCategoryCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:InboxCategoryCellIdentifier];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Open Requests";
            if ([[inboxCountDictionary valueForKey:@"openrequests"]intValue] > 0) {
                cell.categoryItemCountLabel.text = [NSString stringWithFormat:@"%i", [[inboxCountDictionary valueForKey:@"openrequests"]intValue]];
            }
            else {
                cell.categoryItemCountLabel.text = @"";
                cell.backgroundColor = [UIColor lightGrayColor];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case 1:
            cell.textLabel.text = @"Answered Requests";
            if ([[inboxCountDictionary valueForKey:@"fulfilledCount"]intValue] > 0) {
                cell.categoryItemCountLabel.text = [NSString stringWithFormat:@"%i", [[inboxCountDictionary valueForKey:@"fulfilledCount"]intValue]];
            }
            else {
                cell.categoryItemCountLabel.text = @"";
                cell.backgroundColor = [UIColor lightGrayColor];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case 2:
            cell.textLabel.text = @"Assigned Requests";
            if ([[inboxCountDictionary valueForKey:@"assignedrequests"]intValue] > 0) {
                cell.categoryItemCountLabel.text = [NSString stringWithFormat:@"%i", [[inboxCountDictionary valueForKey:@"assignedrequests"]intValue]];
            }
            else {
                cell.categoryItemCountLabel.text = @"";
                cell.backgroundColor = [UIColor lightGrayColor];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case 3:
            cell.textLabel.text = @"Notifications";
            cell.backgroundColor = [UIColor lightGrayColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
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
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
        MMInboxDetailViewController *inboxDetailVC = [[MMInboxDetailViewController alloc]initWithNibName:@"MMInboxDetailViewController" bundle:nil];
        switch (indexPath.row) {
            case 0:
                if ([[inboxCountDictionary valueForKey:@"openrequests"]intValue] > 0) {
                    inboxDetailVC.title = @"Open Requests";
                    [self.navigationController pushViewController:inboxDetailVC animated:YES];
                }
                break;
            case 1:
                if ([[inboxCountDictionary valueForKey:@"fulfilledCount"]intValue] > 0) {
                    [[MMClientSDK sharedSDK] answeredRequestsScreen:self answeredItemsToDisplay:self.fulfilledRequests];
                }
                break;
            case 2:
                if ([[inboxCountDictionary valueForKey:@"assignedrequests"]intValue] > 0) {
                    inboxDetailVC.title = @"Assigned Requests";
                    [self.navigationController pushViewController:inboxDetailVC animated:YES];
                }
                break;
            default:
                
                break;
        }
    }
    else {
        [[MMClientSDK sharedSDK]signInScreen:self];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight;

    if (_categorySelected) {
        if (![[[_contentList objectAtIndex:indexPath.row]valueForKey:@"message"]isKindOfClass:[NSNull class]]) {
            NSString *message = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"message"];
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            CGFloat height = MAX(size.height, 44.0f);
            
            cellHeight = height + (CELL_CONTENT_MARGIN * 2) + 50;
        }
        else {
            cellHeight = 100;
        }
    }
    else {
        cellHeight = 45;
    }
    
    return cellHeight;
}

#pragma mark - Helper Methods
- (id)failureBlock
{
    id _failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.responseData) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            if ([[response valueForKey:@"status"] isEqualToString:@"Unauthorized"]) {
                [[MMClientSDK sharedSDK] signInScreen:self];
            }
        }
        
    };
    return _failureBlock;
}

#pragma mark - Notification Methods
- (void)pushNotificationReceived:(NSNotification*)notification {
    [self getInboxCounts];
}


@end
