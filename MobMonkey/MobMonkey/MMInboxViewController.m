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

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 180.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface MMInboxViewController ()

@property (strong, nonatomic) NSMutableArray *openRequests;
@property (strong, nonatomic) NSMutableArray *assignedRequests;
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_categorySelected) {
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
    [self reloadInbox];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)reloadInbox
{
    [MMAPI getOpenRequestsOnSuccess:^(id responseObject) {
        self.openRequests = responseObject;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        //
    }];
    [MMAPI getAssignedRequestsOnSuccess:^(id responseObject) {
        self.assignedRequests = responseObject;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        //
    }];
    [MMAPI getFulfilledRequestsOnSuccess:^(id responseObject) {
        self.fulfilledRequests = responseObject;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        //
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
    return _contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *InboxCategoryCellIdentifier = @"InboxCategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InboxCategoryCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:InboxCategoryCellIdentifier];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [_contentList objectAtIndex:indexPath.row];
    
    switch (indexPath.row) {
        case 0:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", self.openRequests.count];
            break;
        case 1:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", self.fulfilledRequests.count];
            break;
        case 2:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", self.assignedRequests.count];
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (_categorySelected) {
//        if ([self.title isEqualToString:@"Assigned Requests"]) {
//            selectedRequestId = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"requestId"];
//            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//                UIImagePickerController* picker = [[UIImagePickerController alloc] init];
//                picker.delegate = self;
//                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                picker.showsCameraControls = YES;
//                
//                if ([[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaType"]intValue] == 1) {
//                    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
//                    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
//                }
//                else {
//                    [picker setVideoMaximumDuration:10];
//                    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
//                    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
//                }
//                [self presentViewController:picker animated:YES completion:nil];
//            }
//            else {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to take a photo or video using this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//        }
//    }
//    else {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
            [MMAPI sharedAPI].delegate = self;
            switch (indexPath.row) {
                case 0:
                    [self.navigationController pushViewController:self.locationsViewController animated:YES];
                    self.locationsViewController.locations = self.openRequests;
                    break;
                case 1:
                    //[[MMClientSDK sharedSDK]answeredRequestsScreen:self answeredItemsToDisplay:self.fulfilledRequests];
                    break;
                case 2:
                    [self.navigationController pushViewController:self.locationsViewController animated:YES];
                    self.locationsViewController.locations = self.fulfilledRequests;
                    break;
                default:
                    
                    break;
            }
        }
        else {
            [[MMClientSDK sharedSDK]signInScreen:self];
        }
//    }
    
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
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        if ([[response valueForKey:@"status"] isEqualToString:@"Unauthorized"]) {
            [[MMClientSDK sharedSDK] signInScreen:self];
        }
    };
    return _failureBlock;
}

#pragma mark - UIImagePickerController Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
//    NSString *mediaRequested;
//    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
//    [params setObject:selectedRequestId forKey:@"requestId"];
//    [params setObject:[NSNumber numberWithInt:0] forKey:@"requestType"];
//    
//    NSData *dataObj;
//    NSString *fileType = [info objectForKey: UIImagePickerControllerMediaType];
//    if (CFStringCompare ((__bridge CFStringRef) fileType, kUTTypeImage, 0)
//        == kCFCompareEqualTo) {
//        mediaRequested = @"image";
//        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        image = [self imageWithImage:image scaledToSize:CGSizeMake(image.size.width * .15, image.size.height * .15)];
//        dataObj = UIImagePNGRepresentation(image);
//        
//        [params setObject:[dataObj base64EncodedString] forKey:@"mediaData"];
//    }
//    else if (CFStringCompare ((__bridge CFStringRef) fileType, kUTTypeMovie, 0)
//             == kCFCompareEqualTo) {
//        mediaRequested = @"video";
//        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
//        dataObj = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:moviePath]];
//    }
//    [MMAPI fulfillRequest:mediaRequested
//                   params:params
//                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                      [self.navigationController popViewControllerAnimated:YES];
//                  }
//                  failure:[self failureBlock]];
//    
//    [picker dismissModalViewControllerAnimated:YES];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
