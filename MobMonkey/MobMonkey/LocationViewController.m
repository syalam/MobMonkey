//
//  LocationViewController.m
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationViewController.h"
#import "NotificationsViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

NSUInteger const kCameraSheet = 0;
NSUInteger const kLoginSheet = 1;


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


#pragma mark - IBAction Methods
-(void)cameraButtonTapped:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"What would you like to capture?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"A Picture", @"A Video", nil];
    actionSheet.tag = kCameraSheet;
    
    [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
}

#pragma mark - ActionSheet elegate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d", buttonIndex);
    
    if (actionSheet.tag == kCameraSheet) {
        
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            picker.showsCameraControls = YES;
        }
        
        switch (buttonIndex) {
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
        }
    }
    else if (actionSheet.tag = kLoginSheet){
        switch (buttonIndex) {
            case 0:
                //show mob monkey login
                break;
            case 1:
                //do a facebooklogin
                break;
            default:
                break;
        }
    }
}

#pragma mark - UIImagePickerController Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
}

#pragma mark - IBAction Methods
- (IBAction)videosButtonTapped:(id)sender {

}

- (IBAction)requestButtonTapped:(id)sender {
    if ([PFUser currentUser]) {
        PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:[AppDelegate getDelegate].currentLocation.coordinate.latitude longitude:[AppDelegate getDelegate].currentLocation.coordinate.longitude];
        
        //find all users within range
        PFQuery *findUsersNearLocation = [PFUser query];
        [findUsersNearLocation whereKey:@"userLocation" nearGeoPoint:point withinMiles:25000];
        //limit results to people who have been at the location in the last two hours
        [findUsersNearLocation whereKey:@"updatedAt" greaterThan:[NSDate dateWithTimeIntervalSinceNow:-3600]];
        [findUsersNearLocation findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                //create the request
                NSString *requestText = [NSString stringWithFormat:@"%@ %@ requests that you post a picture or video of this location", [[PFUser currentUser]objectForKey:@"firstName"], [[PFUser currentUser]objectForKey:@"lastName"]];
                
                PFObject *request = [PFObject objectWithClassName:@"requests"]; 
                [request setObject:point forKey:@"locationCoordinates"];
                [request setObject:[PFUser currentUser] forKey:@"requestor"];
                [request setObject:requestText forKey:@"requestText"];
                [request setObject:[NSNumber numberWithBool:NO] forKey:@"requestFulfilled"];
                [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Your request has been sent" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                        
                        //Send push notifications to all the users in range
                        for (PFObject* person in objects) {
                            [PFPush sendPushMessageToChannelInBackground:[NSString stringWithFormat:@"MM%@",[person objectForKey:@"uuid"]] withMessage:[NSString stringWithFormat:@"%@ %@ requests that you post a picture or video of this location", [[PFUser currentUser]objectForKey:@"firstName"], [[PFUser currentUser]objectForKey:@"lastName"]]];
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
    else {
        //show login view
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"Please login" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"MobMonkey", @"Facebook", nil];
        sheet.tag = kLoginSheet;
        
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
@end
