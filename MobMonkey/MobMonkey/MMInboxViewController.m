//
//  MMInboxViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/31/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "SVProgressHUD.h"
#import "MMClientSDK.h"
#import "MMInboxViewController.h"
#import "MMSetTitleImage.h"
#import "MMInboxCell.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 180.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface MMInboxViewController ()

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
    
    if (_categorySelected) {
        //Add custom back button to the nav bar
        UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
        [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
        
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
        self.navigationItem.leftBarButtonItem = backButton;
        
        NSLog(@"%@", _contentList);
    }
    else {
        [_screenBackground setImage:nil];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        NSMutableArray *tableContent = [NSMutableArray arrayWithObjects:@"Open requests", @"Answered requests", @"Requests from other users", nil];
        [self setContentList:tableContent];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    if (_categorySelected) {
        MMInboxCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MMInboxCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (![[[_contentList objectAtIndex:indexPath.row]valueForKey:@"requestDate"]isKindOfClass:[NSNull class]]) {
            NSTimeInterval requestDate = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"requestDate"]doubleValue];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"HH:mm"];
            NSString *dateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:requestDate]];
            cell.timestampLabel.text = dateString;
        }
        
        if (![[[_contentList objectAtIndex:indexPath.row]valueForKey:@"nameOfLocation"]isKindOfClass:[NSNull class]]) {
            cell.locationNameLabel.text = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"nameOfLocation"];
        }
        if (![[[_contentList objectAtIndex:indexPath.row]valueForKey:@"message"]isKindOfClass:[NSNull class]]) {
            cell.messageLabel.text = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"message"];
            [cell.messageLabel sizeToFit];
        }
        if (![[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaType"]isKindOfClass:[NSNull class]]) {
            NSString *mediaType;
            if ([[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaType"]intValue] == 1) {
                mediaType = @"Image";
            }
            else {
                mediaType = @"Video";
            }
            cell.requestTypeLabel.text = mediaType;
        }
        
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.text = [_contentList objectAtIndex:indexPath.row];
        return cell;
    }
    
    
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
    if (_categorySelected) {
        
    }
    else {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
            [SVProgressHUD show];
            [MMAPI sharedAPI].delegate = self;
            switch (indexPath.row) {
                case 0:
                    currentAPICall = kAPICallOpenRequests;
                    [[MMAPI sharedAPI]openRequests];
                    break;
                case 1:
                    
                    break;
                case 2:
                    currentAPICall = kAPICallAssignedRequests;
                    [[MMAPI sharedAPI]assignedRequests];
                    break;
                default:
                    break;
            }
        }
        else {
            [[MMClientSDK sharedSDK]signInScreen:self];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight;

    if (_categorySelected) {
        NSString *message = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"message"];
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat height = MAX(size.height, 44.0f);
        
        cellHeight = height + (CELL_CONTENT_MARGIN * 2) + 50;
    }
    else {
        return 45;
    }
    
    
    return cellHeight;
}

#pragma mark - UInavbar action methods
- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MMAPI Delegate Methods
- (void)MMAPICallSuccessful:(id)response {
    [SVProgressHUD dismiss];
    NSLog(@"%@", response);
    switch (currentAPICall) {
        case kAPICallAssignedRequests:
            [[MMClientSDK sharedSDK]inboxScreen:self selectedCategory:@"Assigned Requests" inboxItems:response];
            break;
        case kAPICallOpenRequests:
            [[MMClientSDK sharedSDK]inboxScreen:self selectedCategory:@"Requests From Other Users" inboxItems:response];
        default:
            break;
    }
}

- (void)MMAPICallFailed:(AFHTTPRequestOperation*)operation {
    [SVProgressHUD dismiss];
    NSLog(@"%d", operation.response.statusCode);
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
    NSLog(@"%@", response);
}

@end
