//
//  LocationViewController.m
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationViewController.h"
#import "NotificationsViewController.h"
#import "SignUpViewController.h"
#import "AppDelegate.h"


NSUInteger const kCameraSheet = 0;
NSUInteger const kLoginSheet = 1;
NSUInteger const kRequestSheet = 2;


@interface LocationViewController ()

@end

@implementation LocationViewController
@synthesize scrollView;
@synthesize photosButton;
@synthesize videosButton;
@synthesize requestButton;
@synthesize shareButton;
@synthesize bookmarkButton;
@synthesize notificationsButton;
@synthesize requestScreen = _requestScreen;
@synthesize requestObject = _requestObject;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
        
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera 
                                                                                           target:self 
                                                                                           action:@selector(cameraButtonTapped:)];
    
    // Setup scroll view
    [scrollView setContentSize:CGSizeMake(320,520)];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setPhotosButton:nil];
    [self setVideosButton:nil];
    [self setRequestButton:nil];
    [self setShareButton:nil];
    [self setBookmarkButton:nil];
    [self setNotificationsButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - ActionSheet elegate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d", buttonIndex);
    
    if (currentActionSheetCall == kCameraSheet) {
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            picker.showsCameraControls = YES;
        }
        
        if ([buttonTitle isEqualToString:@"A Picture"]) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
                picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                [self presentViewController:picker animated:YES completion:nil];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to take a picture using this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        
        else if ([buttonTitle isEqualToString:@"A Video"]) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
                picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                [self presentViewController:picker animated:YES completion:nil];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to take a video using this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        
        /*switch (buttonIndex) {
            case 0:
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                    [self presentViewController:picker animated:YES completion:nil];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to take a picture using this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                break;
            case 1:
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                    [self presentViewController:picker animated:YES completion:nil];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to take a video using this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                break;
            default:
                break;
        }*/
    }
    else if (currentActionSheetCall == kLoginSheet){
        switch (buttonIndex) {
            case 0: {
                SignUpViewController *suvc = [[SignUpViewController alloc]initWithNibName:@"SignUpViewController" bundle:nil];
                UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:suvc];
                [self.navigationController presentViewController:navc animated:YES completion:NULL];
            }
                break;
            case 1: {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Facebook login has not yet been implemented" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            default:
                break;
        }
    }
    
    else if (currentActionSheetCall == kRequestSheet) {
        switch (buttonIndex) {
            case 0:
                [self makeRequest:@"photo"];
                break;
            case 1:
                [self makeRequest:@"video"];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - UIImagePickerController Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    /*UIImage *imageToSave;
    if (image.imageOrientation != UIImageOrientationUp) {
        imageToSave = [[UIImage alloc]initWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationUp];
    }*/
    
    UIImage *imageToSave = [[UIImage alloc]initWithCGImage:image.CGImage scale:.5 orientation:UIImageOrientationUp];
    
    NSData *dataObj = UIImageJPEGRepresentation(imageToSave, .1);
    PFFile *imageFile = [PFFile fileWithData:dataObj];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFObject *locationImage = [PFObject objectWithClassName:@"locationImages"];
            [locationImage setObject:imageFile forKey:@"image"];
            [locationImage setObject:[PFUser currentUser] forKey:@"uploadedBy"];
            [locationImage setObject:@"LocationId" forKey:@"location"];
            [locationImage setObject:[_requestObject objectForKey:@"requestor"] forKey:@"respondingTo"];
            [locationImage saveEventually];
            
            if (_requestScreen) {
                [_requestScreen responseComplete:_requestObject];
                PFObject *requestorObject = [_requestObject objectForKey:@"requestor"];
                [requestorObject fetchIfNeededInBackgroundWithBlock:^(PFObject *person, NSError *error) {
                    if (!error) {
                        [PFPush sendPushMessageToChannelInBackground:[NSString stringWithFormat:@"MM%@",[person objectForKey:@"uuid"]] withMessage:[NSString stringWithFormat:@"%@ %@ has responded to your request", [[PFUser currentUser]objectForKey:@"firstName"], [[PFUser currentUser]objectForKey:@"lastName"]]];
                    } 
                }];
            }
            
            [picker dismissModalViewControllerAnimated:YES];
        } 
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - IBAction Methods
-(void)cameraButtonTapped:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
    actionSheet.delegate = self;
    if (!_requestObject) {
        [actionSheet addButtonWithTitle:@"A Picture"];
        [actionSheet addButtonWithTitle:@"A Video"];
    }
    else if ([[_requestObject objectForKey:@"requestType"]isEqualToString:@"photo"]) {
        [actionSheet addButtonWithTitle:@"A Picture"];
    }
    else {
        [actionSheet addButtonWithTitle:@"A Video"];
    }
    
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    
    currentActionSheetCall = kCameraSheet;
    
    if (_requestScreen) {
        [actionSheet showInView:self.view];
    }
    else {
        [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    }
}

- (IBAction)videosButtonTapped:(id)sender {

}

- (IBAction)requestButtonTapped:(id)sender {
    if ([PFUser currentUser]) {
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"Select Request Type" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo", @"Video", nil];
        currentActionSheetCall = kRequestSheet;
        if (_requestScreen) {
            [sheet showInView:self.view];
        }
        else {
            [sheet showFromTabBar:self.navigationController.tabBarController.tabBar];
        }
    }
    else {
        //show login view
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"Please login" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"MobMonkey", @"Facebook", nil];
        currentActionSheetCall = kLoginSheet;
        
        [sheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    }
}

- (IBAction)bookmarkButtonTapped:(id)sender {
}

- (IBAction)shareButtonTapped:(id)sender {
}

- (IBAction)notificationsButtonTapped:(id)sender {
    NotificationsViewController *notificationsVc = [[NotificationsViewController alloc]initWithNibName:@"NotificationsViewController" bundle:nil];
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:notificationsVc];
    [self.navigationController presentViewController:navC animated:YES completion:NULL];
}

- (IBAction)photosButtonTapped:(id)sender {

}

#pragma mark - Helper Methods
- (void)makeRequest:(NSString*)requestType {
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:[AppDelegate getDelegate].currentLocation.coordinate.latitude longitude:[AppDelegate getDelegate].currentLocation.coordinate.longitude];
    
    //find all users within range
    PFQuery *findUsersNearLocation = [PFUser query];
    [findUsersNearLocation whereKey:@"userLocation" nearGeoPoint:point withinMiles:25000];
    //limit results to people who have been at the location in the last two hours
    [findUsersNearLocation whereKey:@"updatedAt" greaterThan:[NSDate dateWithTimeIntervalSinceNow:-3600]];
    [findUsersNearLocation findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //create the request
            NSString *requestText = [NSString stringWithFormat:@"%@ %@ requests that you post a %@ of this location", [[PFUser currentUser]objectForKey:@"firstName"], [[PFUser currentUser]objectForKey:@"lastName"], requestType];
            
            PFObject *request = [PFObject objectWithClassName:@"requests"]; 
            [request setObject:point forKey:@"locationCoordinates"];
            [request setObject:requestType forKey:@"requestType"];
            [request setObject:[PFUser currentUser] forKey:@"requestor"];
            [request setObject:requestText forKey:@"requestText"];
            [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"%@", request);
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Your request has been sent" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    //Send push notifications to all the users in range
                    for (PFObject* person in objects) {
                        [PFPush sendPushMessageToChannelInBackground:[NSString stringWithFormat:@"MM%@",[person objectForKey:@"uuid"]] withMessage:[NSString stringWithFormat:@"%@ %@ requests that you post a %@ of this location", [[PFUser currentUser]objectForKey:@"firstName"], [[PFUser currentUser]objectForKey:@"lastName"], requestType]];
                    }
                    
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Unable to send your request at this time. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        } 
    }];
}


@end
