//
//  MMInboxDetailViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 11/15/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMInboxDetailViewController.h"
#import "SVProgressHUD.h"
#import "MMInboxCell.h"
#import "NSData+Base64.h"
#import "MMLocationViewController.h"
#import "MMAnswerTextRequestViewController.h"

@interface MMInboxDetailViewController ()

@end

@implementation MMInboxDetailViewController

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
    
    if ([self.title isEqualToString:@"Open Requests"]) {
        [self fetchOpenRequests];
    }
    else {
        [self fetchAssignedRequests];
    }
    
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    MMInboxCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MMInboxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.location = [_contentList objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
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
    // Navigation logic may go here. Create and push another view controller.
    if ([self.title isEqualToString:@"Open Requests"]) {
        selectedIndexToClear = indexPath.row;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Open Request" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles: nil];
        [actionSheet showInView:self.tabBarController.tabBar];
    }
    else {
        requestId = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"requestId"];
        NSLog(@"%@", _contentList);
        if ([[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaType"]intValue] == 4) {
            MMAnswerTextRequestViewController *answerTextRequest = [[MMAnswerTextRequestViewController alloc]initWithNibName:@"MMAnswerTextRequestViewController" bundle:nil];
            answerTextRequest.requestObject = [_contentList objectAtIndex:indexPath.row];
            UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:answerTextRequest];
            [self.navigationController presentViewController:navC animated:YES completion:NULL];
        }
        else {
            [self openCameraSheet:indexPath.row];
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: {
            NSString *selectedRequestId = [[_contentList objectAtIndex:selectedIndexToClear]valueForKey:@"requestId"];
            NSString *isRecurring;
            if ([[[_contentList objectAtIndex:selectedIndexToClear]valueForKey:@"frequencyInMS"]intValue] > 0) {
                isRecurring = @"true";
            }
            else {
                isRecurring = @"false";
            }
            NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                                    selectedRequestId, @"requestId",
                                    isRecurring, @"isRecurring", nil];
            [MMAPI deleteMediaRequest:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@", responseObject);
                [self fetchOpenRequests];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                id jsonObject;
                NSString *message;
                if (operation.responseData) {
                    jsonObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
                    message = [jsonObject valueForKey:@"description"];
                }
                else {
                    message = @"Unable to clear request at this time. Please try again later";
                }
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
  // nothing to do here for now
}

#pragma mark - Button tap methods
- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helper Methods
- (void)fetchOpenRequests {
    [SVProgressHUD showWithStatus:@"Loading Open Requests"];
    [MMAPI getOpenRequestsOnSuccess:^(id responseObject) {
        [SVProgressHUD dismiss];
        [self setContentList:responseObject];
        [self.tableView reloadData];
        if (_contentList.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Unable to load open requests"];
    }];
}

- (void)fetchAssignedRequests {
    [SVProgressHUD showWithStatus:@"Loading Assigned Requests"];
    [MMAPI getAssignedRequests:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [self setContentList:responseObject];
        [self.tableView reloadData];
        if (_contentList.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Unable to load assigned requests"];
    }];
    /*[MMAPI getAssignedRequestsOnSuccess:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"%@", responseObject);
        [self setContentList:responseObject];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Unable to load assigned requests"];
    }];*/
}

- (id)failureBlock
{
    [SVProgressHUD showErrorWithStatus:@"Epic Fail"];
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

- (void)openCameraSheet:(int)arrayIndex {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.showsCameraControls = YES;
        
        if ([[[_contentList objectAtIndex:arrayIndex]valueForKey:@"mediaType"]intValue] == 1) {
            picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        }
        else {
            //[picker setVideoMaximumDuration:10];
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

#pragma mark - UIImagePickerController Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaRequested;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:requestId forKey:@"requestId"];
    [params setObject:[NSNumber numberWithInt:0] forKey:@"requestType"];
    
    NSData *dataObj;
    NSString *fileType = [info objectForKey: UIImagePickerControllerMediaType];
    if (CFStringCompare ((__bridge CFStringRef) fileType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        mediaRequested = @"image";
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [self resizeImage:image];
        //image = [self imageWithImage:image scaledToSize:CGSizeMake(image.size.width * .15, image.size.height * .15)];
        dataObj = UIImageJPEGRepresentation(image, 1);
        
        [params setObject:@"image/jpeg" forKey:@"contentType"];
        [params setObject:[dataObj base64EncodedString] forKey:@"mediaData"];
    }
    else if (CFStringCompare ((__bridge CFStringRef) fileType, kUTTypeMovie, 0)
             == kCFCompareEqualTo) {
        mediaRequested = @"video";
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        dataObj = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:moviePath]];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/vid1.mp4"];
        
        [dataObj writeToFile:tempPath atomically:NO];
        
        dataObj = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:tempPath]];
        
        NSLog(@"%@", tempPath);
        
        
        [params setObject:@"video/mp4" forKey:@"contentType"];
        [params setObject:[dataObj base64EncodedString] forKey:@"mediaData"];
    }
  
    [SVProgressHUD showWithStatus:@"Uploading Media"];

    [MMAPI fulfillRequest:mediaRequested
                   params:params
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [SVProgressHUD showSuccessWithStatus:@"Success"];
                      [self.navigationController popViewControllerAnimated:YES];
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"%@", operation.responseString);
                      [SVProgressHUD showErrorWithStatus:@"Epic Fail"];
                  }];
    
    [picker dismissModalViewControllerAnimated:YES];
}


#pragma mark - Helper Methods
// Shrink to 640x480 if larger. Aspect ratio is already correct.
- (UIImage *)resizeImage:(UIImage *)image {
    CGFloat sourceWidth = image.size.width;
    CGFloat sourceHeight = image.size.height;
    
    NSLog(@"sourceWidth: %f", sourceWidth);
    NSLog(@"sourceHeight: %f", sourceHeight);
    NSLog(@"imageOrientation: %d", image.imageOrientation);
    
    if (sourceWidth <= 640 && sourceHeight <= 480) {
        return image;
    } else {
        UIGraphicsBeginImageContext(CGSizeMake(640, 480));
        [image drawInRect:CGRectMake(0, 0, 640, 480)];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resizedImage;
    }
}

@end
