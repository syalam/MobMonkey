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
        NSString *locationId = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"locationId"];
        NSString *providerId = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"providerId"];
        
        MMLocationViewController *locationViewController = [[MMLocationViewController alloc]initWithNibName:@"MMLocationViewController" bundle:nil];
        [locationViewController loadLocationDataWithLocationId:locationId providerId:providerId];
        [self.navigationController pushViewController:locationViewController animated:YES];
    }
    else {
        requestId = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"requestId"];
        [self openCameraSheet:indexPath.row];
    }
}

#pragma mark - Helper Methods
- (void)fetchOpenRequests {
    [SVProgressHUD showWithStatus:@"Loading Open Requests"];
    [MMAPI getOpenRequestsOnSuccess:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"%@", responseObject);
        [self setContentList:responseObject];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismissWithError:@"Unable to load open requests"];
    }];
}

- (void)fetchAssignedRequests {
    [SVProgressHUD showWithStatus:@"Loading Assigned Requests"];
    [MMAPI getAssignedRequests:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"%@", responseObject);
        [self setContentList:responseObject];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismissWithError:@"Unable to load assigned requests"];
    }];
    /*[MMAPI getAssignedRequestsOnSuccess:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"%@", responseObject);
        [self setContentList:responseObject];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismissWithError:@"Unable to load assigned requests"];
    }];*/
}

- (id)failureBlock
{
    [SVProgressHUD dismissWithError:@"Epic Fail"];
    id _failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        if ([[response valueForKey:@"status"] isEqualToString:@"Unauthorized"]) {
            [[MMClientSDK sharedSDK] signInScreen:self];
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
                      [SVProgressHUD dismissWithSuccess:@"Success"];
                      [self.navigationController popViewControllerAnimated:YES];
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"%@", operation.responseString);
                      [SVProgressHUD dismissWithError:@"Epic Fail"];
                  }];
    
    [picker dismissModalViewControllerAnimated:YES];
}


#pragma mark - Helper Methods
-(UIImage *)resizeImage:(UIImage*)imageToResize
{
    CGFloat sourceWidth = imageToResize.size.width;
    CGFloat sourceHeight = imageToResize.size.height;
    
    CGFloat destinationHeight = sourceHeight/3;
    CGFloat destinationWidth = sourceWidth/3;
    
    UIGraphicsBeginImageContext(CGSizeMake(640.0, 480.0));
    
    [imageToResize drawInRect:CGRectMake(0.0, 0.0,destinationWidth, destinationHeight)];
    
    UIImage * resizedImage =  UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

@end
