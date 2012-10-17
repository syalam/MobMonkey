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
#import "NSData+Base64.h"
#import "MMInboxFullScreenImageViewController.h"
#import "MMInboxCategoryCell.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 180.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface MMInboxViewController () {
    NSString *selectedRequestId;
    NSArray *openRequestsArray;
    NSArray *fulfilledRequestsArray;
    NSArray *assignedRequestsArray;
}

@property (nonatomic, retain) UIImageView *mmTitleImageView;
@property (nonatomic, retain) NSMutableArray *contentList;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_categorySelected) {
        //Add custom back button to the nav bar
        UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
        [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
        
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
        self.navigationItem.leftBarButtonItem = backButton;
        
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"Loading %@", self.title]];
        [self fetchInboxContent];
        return;
    }
    NSMutableArray *tableContent = [NSMutableArray arrayWithObjects:@"Open Requests", @"Answered Requests", @"Assigned Requests", nil];
    [self setContentList:tableContent];
    
    [SVProgressHUD showWithStatus:@"Updating"];
    _currentAPICall = kAPICallFulfilledRequests;
    [self performSelector:@selector(fetchInboxContent) withObject:nil afterDelay:2];
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
    static NSString *InboxCellIdentifier = @"InboxCell";
    static NSString *InboxCategoryCellIdentifier = @"InboxCategoryCell";
    if (_categorySelected) {
        MMInboxCell *cell = [tableView dequeueReusableCellWithIdentifier:InboxCellIdentifier];
        if (!cell) {
             cell = [[MMInboxCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InboxCellIdentifier];
        }
        /*if (![[[_contentList objectAtIndex:indexPath.row]valueForKey:@"requestDate"]isKindOfClass:[NSNull class]]) {
         NSTimeInterval requestDate = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"requestDate"]doubleValue];
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
         [dateFormatter setDateFormat:@"h:mm a"];
         NSString *dateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:requestDate]];
         cell.timestampLabel.text = dateString;
         }*/
        
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

            cell.clipsToBounds = YES;
            [cell.backgroundImageView setFrame:CGRectMake(0, 0, 286, 400)];
        }
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InboxCategoryCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:InboxCategoryCellIdentifier];
        CGFloat grey = 220.0/255.0;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor colorWithRed:grey green:grey blue:grey alpha:1.0];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [_contentList objectAtIndex:indexPath.row];
    
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            NSLog(@"%d", fulfilledRequestsArray.count);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", fulfilledRequestsArray.count];
            break;
        case 2:
        
            break;
        default:
            break;
    }
    
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
    if (_categorySelected) {
        if ([self.title isEqualToString:@"Assigned Requests"]) {
            selectedRequestId = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"requestId"];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController* picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.showsCameraControls = YES;
                
                if ([[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaType"]intValue] == 1) {
                    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
                    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                }
                else {
                    [picker setVideoMaximumDuration:10];
                    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
                    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                }
                [self presentViewController:picker animated:YES completion:nil];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to take a photo or video using this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    else {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
            [MMAPI sharedAPI].delegate = self;
            switch (indexPath.row) {
                case 0:
                    [[MMClientSDK sharedSDK]inboxScreen:self selectedCategory:@"Open Requests" currentAPICall:kAPICallOpenRequests];
                    break;
                case 1:
                    [[MMClientSDK sharedSDK]answeredRequestsScreen:self answeredItemsToDisplay:fulfilledRequestsArray];
                    break;
                case 2:
                    [[MMClientSDK sharedSDK]inboxScreen:self selectedCategory:@"Assigned Requests" currentAPICall:kAPICallAssignedRequests];
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

#pragma mark - UInavbar action methods
- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helper Methods
- (void)fetchInboxContent {
    [MMAPI sharedAPI].delegate = self;
    switch (_currentAPICall) {
        case kAPICallOpenRequests:
            [[MMAPI sharedAPI]openRequests];
            break;
        case kAPICallAssignedRequests:
            [[MMAPI sharedAPI]assignedRequests];
        case kAPICallFulfilledRequests:
            [[MMAPI sharedAPI]fulfilledRequests];
        default:
            break;
    }
}

#pragma mark - UIImagePickerController Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [SVProgressHUD showWithStatus:@"Saving"];
    NSString *mediaRequested;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:selectedRequestId forKey:@"requestId"];
    [params setObject:[NSNumber numberWithInt:0] forKey:@"requestType"];
    
    NSData *dataObj;
    NSString *fileType = [info objectForKey: UIImagePickerControllerMediaType];
    if (CFStringCompare ((__bridge CFStringRef) fileType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        mediaRequested = @"image";
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [self imageWithImage:image scaledToSize:CGSizeMake(image.size.width * .15, image.size.height * .15)];
        dataObj = UIImagePNGRepresentation(image);
        
        [params setObject:[dataObj base64EncodedString] forKey:@"mediaData"];
    }
    else if (CFStringCompare ((__bridge CFStringRef) fileType, kUTTypeMovie, 0)
             == kCFCompareEqualTo) {
        mediaRequested = @"video";
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        dataObj = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:moviePath]];
    }
    _currentAPICall = kAPICallFulfillRequest;
    [MMAPI sharedAPI].delegate = self;
    [[MMAPI sharedAPI]fulfillRequest:mediaRequested params:params];
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - MMAPI Delegate Methods
- (void)MMAPICallSuccessful:(id)response {
    [SVProgressHUD dismiss];
    NSLog(@"%@", response);
    switch (_currentAPICall) {
        case kAPICallFulfillRequest:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case kAPICallFulfilledRequests:
            fulfilledRequestsArray = response;
            [self.tableView reloadData];
            break;
        default:
            [self setContentList:response];
            [self.tableView reloadData];
            break;
    }
}

- (void)MMAPICallFailed:(AFHTTPRequestOperation*)operation {
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
    if ([response valueForKey:@"description"]) {
        NSString *responseString = [response valueForKey:@"description"];
        
        [SVProgressHUD dismissWithError:responseString];
    }
}

@end
