//
//  MMRequestInboxViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMRequestInboxViewController.h"
#import "MMRequestInboxCell.h"
#import "MMRequestWrapper.h"
#import "MMShadowCellBackground.h"
#import "MMSectionHeaderWithBadgeView.h"
#import "MMRequestObject.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NSData+Base64.h"
#import "MMAnswerTextRequestViewController.h"

@interface MMRequestInboxViewController ()
@property (nonatomic, strong) MMMediaRequestWrapper *wrapper;
@property (nonatomic, strong) MMRequestObject *selectedRequest;
@end

@implementation MMRequestInboxViewController

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
    
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.930 green:0.911 blue:0.920 alpha:1.000];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _wrapper = [[MMMediaRequestWrapper alloc] initWithTableWidth:self.tableView.frame.size.width];
    _wrapper.durationSincePost = @"8 mins ago";
    _wrapper.nameOfLocation = @"Maya Pool";
    _wrapper.nameOfParentLocation = @"@ Maya Day and Night Club";
    _wrapper.questionText = @"I have an image!!";
    _wrapper.placeholderImage = [UIImage imageNamed:@"poolParty.jpg"];
    _wrapper.cellStyle = MMRequestCellStyleInbox;
    
    NSMutableArray * tempCellWrapper = [NSMutableArray array];
    
    [tempCellWrapper addObject:_wrapper];
    
    
    MMMediaRequestWrapper * wrapperNotAnswered = [[MMMediaRequestWrapper alloc] initWithTableWidth:self.tableView.frame.size.width];
    wrapperNotAnswered.durationSincePost = @"8 mins ago";
    wrapperNotAnswered.nameOfLocation = @"Maya Pool";
    wrapperNotAnswered.nameOfParentLocation = @"@ Maya Day and Night Club";
    wrapperNotAnswered.questionText = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. I dont have an image";
    wrapperNotAnswered.placeholderImage = [UIImage imageNamed:@"poolParty.jpg"];
    wrapperNotAnswered.cellStyle = MMRequestCellStyleTimeline;
    
    
    MMTextRequestWrapper * textWrapper = [[MMTextRequestWrapper alloc] initWithTableWidth:self.tableView.frame.size.width];
    textWrapper = [[MMTextRequestWrapper alloc] initWithTableWidth:self.tableView.frame.size.width];
    textWrapper.durationSincePost = @"8 mins ago";
    textWrapper.nameOfLocation = @"Maya Pool";
    textWrapper.nameOfParentLocation = @"@ Maya Day and Night Club";
    textWrapper.questionText = @"I have a text request, but no answer yet";
    //textWrapper.placeholderImage = [UIImage imageNamed:@"poolParty.jpg"];
    textWrapper.cellStyle = MMRequestCellStyleTimeline;
    textWrapper.answerText = @"This is a new answer!";
    
    [tempCellWrapper addObject:wrapperNotAnswered];
    [tempCellWrapper addObject:textWrapper];
    
    self.cellWrappers = tempCellWrapper;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewDidAppear:(BOOL)animated {
    [self loadRequests];
}

-(NSArray *)wrappersForRequests:(NSArray *)requests type:(MMRequestType)requestType{
    
    NSMutableArray * arrayOfWrappers = [NSMutableArray arrayWithCapacity:requests.count];
    
    switch (requestType) {
        case MMRequestTypeAssigned:
            for(MMRequestObject *requestObject in requests) {
                
                MMRequestWrapper * assingedRequest = [[MMRequestWrapper alloc] initWithTableWidth:320];
                assingedRequest.nameOfLocation = requestObject.nameOfLocation;
                assingedRequest.mediaType = requestObject.mediaType;
                assingedRequest.durationSincePost = [requestObject dateStringDurationSinceDate:requestObject.assignedDate];
                assingedRequest.nameOfParentLocation = @"Not Implemented Yet";
                assingedRequest.isAnswered = NO;
                assingedRequest.questionText = ![requestObject.message isEqual:[NSNull null]] ? requestObject.message : @" No Text";
                assingedRequest.cellStyle = MMRequestCellStyleInbox;
                assingedRequest.requestObject = requestObject;
                [arrayOfWrappers addObject:assingedRequest];

            }
            break;
        case MMRequestTypeAnswered:
            for (MMRequestObject * requestObject in requests){
                
                MMRequestWrapper * requestWrapper;
                if(requestObject.mediaType == MMMediaTypeVideo){
                    
                    requestWrapper = [[MMMediaRequestWrapper alloc] initWithTableWidth:320];
                    ((MMMediaRequestWrapper *)requestWrapper).mediaURL = requestObject.mediaObject.thumbURL;
                    
                }else if(requestObject.mediaType == MMMediaTypePhoto){
                    
                    requestWrapper = [[MMMediaRequestWrapper alloc] initWithTableWidth:320];
                    ((MMMediaRequestWrapper *)requestWrapper).mediaURL = requestObject.mediaObject.mediaURL;
                    
                }else{
                    requestWrapper = [[MMRequestWrapper alloc] initWithTableWidth:320];
                }
                
                requestWrapper.nameOfLocation = requestObject.nameOfLocation;
                requestWrapper.mediaType = requestObject.mediaType;
                requestWrapper.durationSincePost = [requestObject dateStringDurationSinceDate:requestObject.requestDate];
                requestWrapper.nameOfParentLocation = @"Not Implemented Yet";
                requestWrapper.isAnswered = YES;
                requestWrapper.questionText = ![requestObject.message isEqual:[NSNull null]] ? requestObject.message : @" No Text";
                
                //if(requestObject.requestFulfilled.boolValue){
                //    requestWrapper.cellStyle = MMRequestCellStyleInbox;
                //}else{
                    requestWrapper.cellStyle = MMRequestCellStyleInboxNeedsReview;
                //}
                
                requestWrapper.requestObject = requestObject;
                //Video
                
                
                [arrayOfWrappers addObject:requestWrapper];
                
            }
            
        default:
            break;
    }
    
        
    return arrayOfWrappers;
    
    
}
-(void)loadRequests {
    
    [MMAPI getAssignedRequestObjectsWithSuccess:^(NSArray *requestObjects) {
        self.assignedRequests = requestObjects;
        self.assingedRequestWrappers = [self wrappersForRequests:requestObjects type:MMRequestTypeAssigned];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"ERROR: %@", error);
    }];
    
    
    [MMAPI getFulfilledRequestsWithSuccess:^(NSArray *fulfilledRequests) {
        NSLog(@"fulfilled: %@", fulfilledRequests);
        self.answeredRequests = fulfilledRequests;
        self.answeredRequestWrappers = [self wrappersForRequests:fulfilledRequests type:MMRequestTypeAnswered];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    //Assigned Request
    if(section == 0){
        return self.assignedRequests.count;
    }else if(section == 1){
        return self.answeredRequests.count;
    }else if(section == 2){
        return self.notifications.count;
    }else if (section == 3){
        return self.openRequests.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MMRequestInboxCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[MMRequestInboxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        
    }
    
    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    test.backgroundColor = [UIColor redColor];
    
    NSUInteger toggle = indexPath.row % 3;
    MMRequestWrapper *wrapper = [self.cellWrappers objectAtIndex:toggle];
    
    if(indexPath.section == 0){
        [cell setRequestInboxWrapper:[self.assingedRequestWrappers objectAtIndex:indexPath.row]];
    }else if (indexPath.section == 1){
        [cell setRequestInboxWrapper:[self.answeredRequestWrappers objectAtIndex:indexPath.row]];
    }else{
        [cell setRequestInboxWrapper:wrapper];
    }
    
      
    //[cell redisplay];
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 27;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    NSNumber *number = nil;
    
    switch (section) {
        case 0:
            title = @"Assigned Requests";
            number = [NSNumber numberWithInt:self.assignedRequests.count];
            break;
        case 1:
            title = @"Answered Requests";
            number = [NSNumber numberWithInt:self.answeredRequests.count];
            break;
        case 2:
            title = @"Notifications";
            number = [NSNumber numberWithInt:self.notifications.count];
            break;
        case 3:
            title = @"Open Requests";
            number = [NSNumber numberWithInt:self.openRequests.count];
            break;
            
        default:
            break;
    }
    
    return [[MMSectionHeaderWithBadgeView alloc] initWithTitle:title andBadgeNumber:number];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        MMRequestWrapper *wrapper = [self.assingedRequestWrappers objectAtIndex:indexPath.row];
        return [wrapper cellHeight];
    }else if(indexPath.section == 1){
        
        MMRequestWrapper *wrapper = [self.answeredRequestWrappers objectAtIndex:indexPath.row];
        
        if([wrapper isKindOfClass:[MMMediaRequestWrapper class]]){
            NSLog(@"MEDIA");
        }
        return [wrapper cellHeight];
    }
    
    NSUInteger toggle = indexPath.row % 3;
    MMRequestWrapper *wrapper = [self.cellWrappers objectAtIndex:toggle];
    return [wrapper cellHeight];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:0.930 green:0.911 blue:0.920 alpha:1.000];
    
    for(UIView *view in cell.subviews){
        view.backgroundColor = [UIColor colorWithRed:0.930 green:0.911 blue:0.920 alpha:1.000];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0: {
            _selectedRequest = [self.assignedRequests objectAtIndex:indexPath.row];
            
            if(_selectedRequest.mediaType == MMMediaTypeText){
                MMAnswerTextRequestViewController *answerTextRequest = [[MMAnswerTextRequestViewController alloc]initWithNibName:@"MMAnswerTextRequestViewController" bundle:nil];
                answerTextRequest.requestObject = _selectedRequest.jsonParameters;
                [self.navigationController pushViewController:answerTextRequest animated:YES];

            }else{
                 [self openCameraSheet:indexPath.row];
            }
            
            
            break;
            
        }
            
        case 1:
            _selectedRequest = [self.answeredRequests objectAtIndex:indexPath.row];
            
        default:
            break;
    }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


- (void)openCameraSheet:(int)arrayIndex {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.showsCameraControls = YES;
        
        if ([[self.assignedRequests objectAtIndex:arrayIndex] mediaType] == MMMediaTypePhoto) {
            picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        }
        else {
            //[picker setVideoMaximumDuration:10];
            picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
            [picker setVideoQuality:UIImagePickerControllerQualityTypeMedium];
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            [picker setVideoMaximumDuration:10];
            
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
    [params setObject:self.selectedRequest.requestID forKey:@"requestId"];
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
    
    [picker dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) { //Check if our iOS version supports multitasking I.E iOS 4
        if ([[UIDevice currentDevice] isMultitaskingSupported]) { //Check if device supports mulitasking
            UIApplication *application = [UIApplication sharedApplication]; //Get the shared application instance
            __block UIBackgroundTaskIdentifier background_task; //Create a task object
            background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
                [application endBackgroundTask: background_task]; //Tell the system that we are done with the tasks
                background_task = UIBackgroundTaskInvalid; //Set the task to be invalid
                //System will be shutting down the app at any point in time now
            }];
            //Background tasks require you to use asyncrous tasks
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //Perform your tasks that your application requires
                [MMAPI fulfillRequest:mediaRequested
                               params:params
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  NSLog(@"%@", responseObject);
                                  
                                  [[NSNotificationCenter defaultCenter]postNotificationName:@"checkForUpdatedCounts" object:nil];
                                  
                                  [application endBackgroundTask: background_task]; //End the task so the system knows that you are done with what you need to perform
                                  background_task = UIBackgroundTaskInvalid; //Invalidate the background_task
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSLog(@"%@", operation.responseString);
                                  [application endBackgroundTask: background_task]; //End the task so the system knows that you are done with what you need to perform
                                  background_task = UIBackgroundTaskInvalid; //Invalidate the background_task
                              }];
                
                
                
            });
        }
    }
}


#pragma mark - Helper Methods
// Shrink to 640x480 if larger. Aspect ratio is already correct.
- (UIImage *)resizeImage:(UIImage *)image {
    CGFloat sourceWidth = image.size.width;
    CGFloat sourceHeight = image.size.height;
    
    // Float comparison works with height/width but not width/height
    if ((sourceHeight / sourceWidth) == (480 / 640.0)) {
        return image;
    } else {
        CGRect cropRect;
        
        if ((sourceHeight / sourceWidth) > (480 / 640.0)) {
            // Too tall
            CGFloat destinationHeight = sourceWidth * 480 / 640;
            CGFloat cropMargin = (sourceHeight - destinationHeight) / 2;
            
            // When calculating crop rectangle, note that actual images are UIImageOrientationUp with rotation meta data
            if (image.imageOrientation == UIImageOrientationUp   || image.imageOrientation == UIImageOrientationUpMirrored ||
                image.imageOrientation == UIImageOrientationDown || image.imageOrientation == UIImageOrientationDownMirrored ) {
                cropRect = CGRectMake(0, cropMargin, sourceWidth, destinationHeight);
            } else if (image.imageOrientation == UIImageOrientationLeft  || image.imageOrientation == UIImageOrientationLeftMirrored ||
                       image.imageOrientation == UIImageOrientationRight || image.imageOrientation == UIImageOrientationRightMirrored  ) {
                cropRect = CGRectMake(cropMargin, 0, destinationHeight, sourceWidth);
            }
        } else {
            // Too wide
            CGFloat destinationWidth = sourceHeight * 640 / 480;
            CGFloat cropMargin = (sourceWidth - destinationWidth) / 2;
            
            // When calculating crop rectangle, note that actual images are UIImageOrientationUp with rotation meta data
            if (image.imageOrientation == UIImageOrientationUp   || image.imageOrientation == UIImageOrientationUpMirrored ||
                image.imageOrientation == UIImageOrientationDown || image.imageOrientation == UIImageOrientationDownMirrored ) {
                cropRect = CGRectMake(cropMargin, 0, destinationWidth, sourceHeight);
            } else if (image.imageOrientation == UIImageOrientationLeft  || image.imageOrientation == UIImageOrientationLeftMirrored ||
                       image.imageOrientation == UIImageOrientationRight || image.imageOrientation == UIImageOrientationRightMirrored  ) {
                cropRect = CGRectMake(0, cropMargin, sourceHeight, destinationWidth);
            }
        }
        
        // Draw new image in current graphics context
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
        
        // Create new resized UIImage
        UIImage *resizedImage = [[UIImage alloc] initWithCGImage:imageRef scale:1.0 orientation:image.imageOrientation];
        
        CGImageRelease(imageRef);
        
        return resizedImage;
    }
}

@end
