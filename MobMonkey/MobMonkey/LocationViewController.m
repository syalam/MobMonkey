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
#import "LocationMediaViewController.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "GetRelativeTime.h"
#import "LocationInfoViewController.h"

//ActionSheet Constants
NSUInteger const kCameraSheet = 0;
NSUInteger const kLoginSheet = 1;
NSUInteger const kRequestSheet = 2;
NSUInteger const kPopupSheet = 3;

//Factual Constants
NSString* const kNeighborhood = @"neighborhood";
NSString* const kDistance = @"distance";
NSString* const kLongitude = @"longitude";
NSString* const kAddress = @"address";
NSString* const kLatitude = @"latitude";
NSString* const kRegion = @"region";
NSString* const kLocality = @"locality";
NSString* const kName = @"name";
NSString* const kPostcode = @"postcode";
NSString* const kCountry = @"country";
NSString* const kTelephone = @"tel";
NSString* const kStatus = @"status";
NSString* const kFactualId = @"factual_id";



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
@synthesize tableView = _tableView;
@synthesize contentList = _contentList;
@synthesize requestScreen = _requestScreen;
@synthesize requestObject = _requestObject;
@synthesize locationNameLabel = _locationNameLabel;
@synthesize locationName = _locationName;
@synthesize venueData;

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    if (_requestScreen) {
        [requestButton setHidden:YES];
        [_mapView setHidden:YES];
        [_tableView setHidden:YES];
    }

    _contentList = [[NSMutableArray alloc]init];
    
    _locationNameLabel.textColor = [UIColor colorWithRed:.8941 green:.4509 blue:.1725 alpha:1];
    
    //setup location imageview
    locationImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    //update notifications badge count
    NSArray *navViewControllers = [self.tabBarController viewControllers];
    UINavigationController *homeNavC = [navViewControllers objectAtIndex:0];
    HomeViewController *homeScreen = [homeNavC.viewControllers objectAtIndex:0];
    notificationsCountLabel.text = [NSString stringWithFormat:@"%d", homeScreen.pendingRequestsArray.count];
    
    //Add custom Camera button to the nav bar
    UIButton *cameraButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 30)];
    [cameraButton addTarget:self action:@selector(cameraButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"CameraBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem *cameraBarButton = [[UIBarButtonItem alloc]initWithCustomView:cameraButton];
    self.navigationItem.rightBarButtonItem = cameraBarButton;

     
    //Add custom back button to the nav bar
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    // Setup scroll view
    [scrollView setContentSize:CGSizeMake(320,420)];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[venueData valueForName:kLatitude]doubleValue], [[venueData valueForName:kLongitude]doubleValue]);
    
    MMLocationAnnotation *annotation = [[MMLocationAnnotation alloc]initWithName:self.title address:[venueData valueForName:kAddress] coordinate:coordinate];
    [_mapView addAnnotation:(id)annotation];

    //zoom out of map
    MKCoordinateRegion region;
    region.center = coordinate;
    region.span.latitudeDelta = 0.005;
    region.span.longitudeDelta = 0.005;
    [_mapView setRegion:region animated:YES];
    
    //show latest picture available for this location
    [self getLatestMediaForThisLocation];
    
    //get media counts
    [self getMediaCount:@"photo"];
    [self getMediaCount:@"video"];
    
    //Add requests modal to view
    [requestModalView setFrame:CGRectMake(0, self.view.frame.origin.y - requestModalView.frame.size.height - 100, requestModalView.frame.size.width, requestModalView.frame.size.height)];
    [self.scrollView addSubview:requestModalView];
    
    //initialize variables
    videoRequested = NO;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [scrollView setContentOffset:CGPointMake(0, 0)animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (_requestScreen) {
        self.title = [_requestObject objectForKey:@"locationName"];
        _locationNameLabel.text = [_requestObject objectForKey:@"locationName"];
    }
    else {
        self.title = [venueData stringValueForName:kName];
        _locationNameLabel.text = [venueData stringValueForName:kName];
    }
    
    //add nav bar view and button
    UIView *navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(45, 9.5, 127, 25)];
    notificationsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(titleImageView.frame.origin.x + titleImageView.frame.size.width, 9.5, 18, 18)];
    notificationsCountLabel = [(AppDelegate *)[[UIApplication sharedApplication] delegate] notificationsCountLabel];
    notificationsCountLabel.frame = notificationsImageView.frame;
    
    notificationsImageView.image = [UIImage imageNamed:@"Notifications~iphone"];
    
    titleImageView.image = [UIImage imageNamed:@"logo~iphone"];
    titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIButton *mmNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mmNavButton setFrame:titleImageView.frame];
    [mmNavButton addTarget:self action:@selector(notificationsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [navBarView addSubview:titleImageView];
    [navBarView addSubview:notificationsImageView];
    [navBarView addSubview:notificationsCountLabel];
    [navBarView addSubview:mmNavButton];
    
    if ([notificationsCountLabel.text isEqualToString:@"0"] || !notificationsCountLabel.text) {
        [notificationsCountLabel setHidden:YES];
        [notificationsImageView setHidden:YES];
    }
    
    self.navigationItem.titleView = navBarView;
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
            picker.showsCameraControls = YES;
        }
        
        if ([buttonTitle isEqualToString:@"A Picture"]) {
            mediaType = @"photo";
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
            mediaType = @"video";
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [picker setVideoQuality:UIImagePickerControllerQualityTypeLow];
                //Maximum video length
                [picker setVideoMaximumDuration:10];
                picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
                picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                [self presentViewController:picker animated:YES completion:nil];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to take a video using this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
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
    
    else if (currentActionSheetCall == kPopupSheet) {
        switch (buttonIndex) {
            case 0: {
                if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
                    
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Facebook Sign In Required" message:@"You must sign in with a facebook account to use this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign In", nil];
                    [alert show];
                }
            }
                break;
            case 4: {
                PFObject *flagLocation = [PFObject objectWithClassName:@"flaggedLocations"];
                [flagLocation setObject:[PFUser currentUser] forKey:@"user"];
                [flagLocation setObject:[venueData valueForName:kFactualId] forKey:@"factualId"];
                [flagLocation setObject:[venueData valueForName:kName] forKey:@"locationName"];
                [flagLocation saveEventually];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - UIImagePickerController Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [SVProgressHUD showWithStatus:@"Saving"];
    
    NSLog(@"%@", info);
    
    NSString *fileType = [info objectForKey: UIImagePickerControllerMediaType];
    NSData *dataObj;
    
    if (CFStringCompare ((__bridge CFStringRef) fileType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [[UIImage alloc]initWithCGImage:image.CGImage scale:.25 orientation:UIImageOrientationUp];
        dataObj = UIImageJPEGRepresentation(image, .1);
    }
    
    else if (CFStringCompare ((__bridge CFStringRef) fileType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        dataObj = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:moviePath]];
    }
    
    PFFile *imageFile;
    if ([mediaType isEqualToString:@"photo"]) {
        imageFile = [PFFile fileWithName:@"photo.jpg" data:dataObj];
    }
    else {
        imageFile = [PFFile fileWithName:@"video.mov" data:dataObj];

    }
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFObject *locationImage = [PFObject objectWithClassName:@"locationImages"];
            [locationImage setObject:imageFile forKey:@"image"];
            if (_requestObject) {
                [locationImage setObject:_requestObject forKey:@"requestObject"];
                [locationImage setObject:[_requestObject objectForKey:@"factualId"] forKey:@"factualId"];
                [locationImage setObject:[_requestObject objectForKey:@"requestor"] forKey:@"requestor"];
            }
            else {
                [locationImage setObject:[venueData valueForName:kFactualId] forKey:@"factualId"];
            }
            [locationImage setObject:[PFUser currentUser] forKey:@"uploadedBy"];
            [locationImage setObject:mediaType forKey:@"mediaType"];
            
            if (_requestScreen) {
                [_requestScreen responseComplete:_requestObject];
                PFObject *requestorObject = [_requestObject objectForKey:@"requestor"];
                [requestorObject fetchIfNeededInBackgroundWithBlock:^(PFObject *person, NSError *error) {
                    if (!error) {
                        NSString *notificationText = [NSString stringWithFormat:@"%@ %@ has responded to your request to take a %@ of %@", [[PFUser currentUser]objectForKey:@"firstName"], [[PFUser currentUser]objectForKey:@"lastName"], [_requestObject objectForKey:@"requestType"], [_requestObject objectForKey:@"locationName"]];
                        PFObject *notificationObject = [PFObject objectWithClassName:@"notifications"];
                        [notificationObject setObject:notificationText forKey:@"notificationText"];
                        [notificationObject setObject:requestorObject forKey:@"requestor"];
                        [notificationObject setObject:_requestObject forKey:@"requestObject"];
                        [notificationObject setObject:[_requestObject objectForKey:@"locationName"] forKey:@"locationName"];
                        [notificationObject setObject:[NSNumber numberWithBool:NO] forKey:@"notificationViewed"];
                        [notificationObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                [locationImage setObject:notificationObject forKey:@"notificationObject"];
                                [locationImage saveEventually];
                                
                                [SVProgressHUD dismissWithSuccess:@"Saved"];
                                [PFPush sendPushMessageToChannelInBackground:[NSString stringWithFormat:@"MM%@",[person objectForKey:@"uuid"]] withMessage:notificationText];
                                [picker dismissModalViewControllerAnimated:YES];
                            }
                            else {
                                [SVProgressHUD dismissWithError:@"Error"];
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Unable to respond to this request at this time. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                                [alert show];
                            }
                        }];
                    } 
                }];
            }
            else {
                [locationImage saveEventually];
                if ([mediaType isEqualToString:@"photo"]) {
                    [self performSelector:@selector(getMediaCount:) withObject:@"photo" afterDelay:2];
                }
                else {
                    [self performSelector:@selector(getMediaCount:) withObject:@"video" afterDelay:2];
                }
                [self performSelector:@selector(getLatestMediaForThisLocation) withObject:nil afterDelay:2];
                [SVProgressHUD dismissWithSuccess:@"Saved"];
                [picker dismissModalViewControllerAnimated:YES];
            }
        }
        else {
            [SVProgressHUD dismissWithError:@"Error"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Unable to save. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [alert show];
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

- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)thumbsDownButtonTapped:(id)sender {
    [thumbsDownButton setEnabled:NO];
    PFObject *ratingObject = [PFObject objectWithClassName:@"ratings"];
    [ratingObject setObject:[PFUser currentUser] forKey:@"user"];
    [ratingObject setObject:[NSNumber numberWithBool:NO] forKey:@"thumbsUp"];
    [ratingObject setObject:[venueData valueForName:kFactualId] forKey:@"factualId"];
    [ratingObject setObject:[venueData valueForName:kName] forKey:@"locationName"];
    [ratingObject saveEventually];
}

- (IBAction)thumbsUpButton:(id)sender {
    [thumbsUpButton setEnabled:NO];
    PFObject *ratingObject = [PFObject objectWithClassName:@"ratings"];
    [ratingObject setObject:[PFUser currentUser] forKey:@"user"];
    [ratingObject setObject:[NSNumber numberWithBool:YES] forKey:@"thumbsUp"];
    [ratingObject setObject:[venueData valueForName:kFactualId] forKey:@"factualId"];
    [ratingObject setObject:[venueData valueForName:kName] forKey:@"locationName"];
    [ratingObject saveEventually];
}

- (IBAction)photosButtonTapped:(id)sender {
    LocationMediaViewController *lmvc = [[LocationMediaViewController alloc]initWithNibName:@"LocationMediaViewController" bundle:nil];
    if (_requestObject) {
        [lmvc getLocationItems:@"photo" factualId:[_requestObject objectForKey:@"factualId"]];
    }
    else {
        [lmvc getLocationItems:@"photo" factualId:[venueData valueForName:kFactualId]];
    }
    lmvc.title = self.title;
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:lmvc];
    [self.navigationController presentViewController:navC animated:YES completion:NULL];
}

- (IBAction)videosButtonTapped:(id)sender {
    LocationMediaViewController *lmvc = [[LocationMediaViewController alloc]initWithNibName:@"LocationMediaViewController" bundle:nil];
    if (_requestObject) {
        [lmvc getLocationItems:@"video" factualId:[_requestObject objectForKey:@"factualId"]];
    }
    else {
        [lmvc getLocationItems:@"video" factualId:[venueData valueForName:kFactualId]];
    }
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:lmvc];
    [self.navigationController presentViewController:navC animated:YES completion:NULL];
}

- (IBAction)requestButtonTapped:(id)sender {
    if ([PFUser currentUser]) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration: 0.5];
        [UIView setAnimationDelegate: self];
        [scrollView setContentSize:CGSizeMake(320,510)];
        [scrollView setContentOffset:CGPointMake(0, 0)animated:YES];
        [requestModalView setFrame:CGRectMake(0, 10, requestModalView.frame.size.width, requestModalView.frame.size.height)];
        [UIView commitAnimations];
        
        /*UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"Select Request Type" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo", @"Video", nil];
        currentActionSheetCall = kRequestSheet;
        if (_requestScreen) {
            [sheet showInView:self.view];
        }
        else {
            [sheet showFromTabBar:self.navigationController.tabBarController.tabBar];
        }*/
    }
    else {
        //show login view
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"Please login" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"MobMonkey", @"Facebook", nil];
        currentActionSheetCall = kLoginSheet;
        
        [sheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    }
}

- (IBAction)locationInfoButtonTapped:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[venueData valueForName:kLatitude]doubleValue], [[venueData valueForName:kLongitude]doubleValue]);
    
    LocationInfoViewController *livc = [[LocationInfoViewController alloc]initWithNibName:@"LocationInfoViewController" bundle:nil];
    livc.locationName = self.title;
    livc.address = [venueData valueForName:kAddress];
    livc.coordinate = coordinate;
    livc.locality = [venueData valueForName:kLocality];
    livc.region = [venueData valueForName:kRegion];
    livc.postCode = [venueData valueForName:kPostcode];
    livc.country = [venueData valueForName:kCountry];
    livc.phoneNumber = [venueData valueForName:kTelephone];
    livc.categories = [venueData valueForName:@"category"];
    
    [self.navigationController pushViewController:livc animated:YES];
}

- (IBAction)bookmarkButtonTapped:(id)sender {
}

- (IBAction)shareButtonTapped:(id)sender {
    
}

- (IBAction)popupButtonTapped:(id)sender {
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:self.title delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", @"Bookmark", @"Notification Settings", @"Flag as Inappropriate", nil];
    currentActionSheetCall = kPopupSheet;
    [sheet showFromTabBar:self.navigationController.tabBarController.tabBar];
}

- (IBAction)notificationsButtonTapped:(id)sender {
    NSArray *navViewControllers = [self.tabBarController viewControllers];
    UINavigationController *homeNavC = [navViewControllers objectAtIndex:0];
    HomeViewController *homeScreen = [homeNavC.viewControllers objectAtIndex:0];
    [homeScreen notificationsButtonTapped:nil];
}

//Request Modal IBAction Methods
- (IBAction)requestVideoButtonTapped:(id)sender {
    [requestPhotoButton setImage:[UIImage imageNamed:@"ModalPictureBtn1~iphone"] forState:UIControlStateNormal];
    [requestVideoButton setImage:[UIImage imageNamed:@"ModalVideoBtn2~iphone"] forState:UIControlStateNormal];
    
    videoRequested = YES;
}
- (IBAction)requestPhotoButtonTapped:(id)sender {
    [requestPhotoButton setImage:[UIImage imageNamed:@"ModalPictureBtn2~iphone"] forState:UIControlStateNormal];
    [requestVideoButton setImage:[UIImage imageNamed:@"ModalVideoBtn1~iphone"] forState:UIControlStateNormal];
    
    videoRequested = NO;
}
- (IBAction)activeSwitchTapped:(id)sender {
    
}
- (IBAction)cancelButtonTapped:(id)sender {
    [requestTextView resignFirstResponder];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationDelegate: self];
    [scrollView setContentSize:CGSizeMake(320,420)];
    [scrollView setContentOffset:CGPointMake(0, 0)animated:YES];
    [requestModalView setFrame:CGRectMake(0, self.view.frame.origin.y - requestModalView.frame.size.height - 100, requestModalView.frame.size.width, requestModalView.frame.size.height)];
    [UIView commitAnimations];
}
- (IBAction)requestItButtonTapped:(id)sender {
    if (![requestTextView.text isEqualToString:@""]) {
        if (videoRequested) {
            [self makeRequest:@"video"];
        }
        else {
            [self makeRequest:@"photo"];
        }
    }
}


#pragma mark - Helper Methods

- (void)makeRequest:(NSString*)requestType {
    PFGeoPoint *requestLocation = [PFGeoPoint geoPointWithLatitude:[[venueData valueForName:kLatitude]doubleValue] longitude:[[venueData valueForName:kLongitude]doubleValue]];
    
    //find all users within range
    PFQuery *findUsersNearLocation = [PFUser query];
    [findUsersNearLocation whereKey:@"userLocation" nearGeoPoint:requestLocation withinMiles:25000];
    //limit results to people who have been at the location in the last two hours
    [findUsersNearLocation whereKey:@"updatedAt" greaterThan:[NSDate dateWithTimeIntervalSinceNow:-3600]];
    [findUsersNearLocation findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //create the request
            NSString *requestText = [NSString stringWithFormat:@"%@ %@ requests that you post a %@ of %@", [[PFUser currentUser]objectForKey:@"firstName"], [[PFUser currentUser]objectForKey:@"lastName"], requestType, [venueData valueForName:kName]];
            NSString *userRequest = requestTextView.text;
            
            PFObject *request = [PFObject objectWithClassName:@"requests"]; 
            [request setObject:requestLocation forKey:@"locationCoordinates"];
            [request setObject:requestType forKey:@"requestType"];
            [request setObject:userRequest forKey:@"userRequest"];
            if (activeSwitch.on) {
                [request setObject:[NSNumber numberWithInt:900] forKey:@"requestActiveTime"];
            }
            else {
                [request setObject:[NSNumber numberWithInt:7200] forKey:@"requestActiveTime"];
            }
            [request setObject:[PFUser currentUser] forKey:@"requestor"];
            [request setObject:[venueData valueForName:kFactualId] forKey:@"factualId"];
            [request setObject:[venueData valueForName:kName] forKey:@"locationName"];
            [request setObject:requestText forKey:@"requestText"];
            NSLog(@"%@", request);
            [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"%@", request);
                    
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    [UIView beginAnimations:nil context:context];
                    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                    [UIView setAnimationDuration: 0.5];
                    [UIView setAnimationDelegate: self];
                    [scrollView setContentSize:CGSizeMake(320,420)];
                    [scrollView setContentOffset:CGPointMake(0, 0)animated:YES];
                    [requestModalView setFrame:CGRectMake(0, self.view.frame.origin.y - requestModalView.frame.size.height - 100, requestModalView.frame.size.width, requestModalView.frame.size.height)];
                    [UIView commitAnimations];
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Your request has been sent" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    //Send push notifications to all the users in range
                    for (PFObject* person in objects) {
                        [PFPush sendPushMessageToChannelInBackground:[NSString stringWithFormat:@"MM%@",[person objectForKey:@"uuid"]] withMessage:[NSString stringWithFormat:@"%@ %@ requests that you post a %@ of %@", [[PFUser currentUser]objectForKey:@"firstName"], [[PFUser currentUser]objectForKey:@"lastName"], requestType, [venueData valueForName:kName]]];
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

- (void)getMediaCount:(NSString*)mediaTypeToCount {
    PFQuery *queryForItems = [PFQuery queryWithClassName:@"locationImages"];
    if (_requestObject) {
        [queryForItems whereKey:@"factualId" equalTo:[_requestObject objectForKey:@"factualId"]];
    }
    else {
        [queryForItems whereKey:@"factualId" equalTo:[venueData valueForName:kFactualId]];
    }
    [queryForItems whereKey:@"mediaType" equalTo:mediaTypeToCount];
    [queryForItems orderByAscending:@"updatedAt"];
    [queryForItems countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            if ([mediaTypeToCount isEqualToString:@"photo"]) {
                photoCountLabel.text = [NSString stringWithFormat:@"%d", number];
            }
            else {
                videoCountLabel.text = [NSString stringWithFormat:@"%d", number];
            }
        }
    }];
}

- (void)getLatestMediaForThisLocation {
    PFQuery *queryForItems = [PFQuery queryWithClassName:@"locationImages"];
    if (_requestObject) {
        [queryForItems whereKey:@"factualId" equalTo:[_requestObject objectForKey:@"factualId"]];
    }
    else {
        [queryForItems whereKey:@"factualId" equalTo:[venueData valueForName:kFactualId]];
    }
    [queryForItems orderByDescending:@"updatedAt"];
    [queryForItems setLimit:1];
    [queryForItems findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                PFObject *locationItemObject = [objects objectAtIndex:0];
                PFFile *mediaFile = [locationItemObject objectForKey:@"image"];
                if ([[locationItemObject objectForKey:@"mediaType"]isEqualToString:@"photo"]) {
                    [locationImageView reloadWithUrl:mediaFile.url];
                }
                else {
                    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:mediaFile.url] options:nil];
                    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                    generate.appliesPreferredTrackTransform = YES;
                    NSError *err = NULL;
                    CMTime time = CMTimeMake(0, 60);
                    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
                    locationImageView.image =  [UIImage imageWithCGImage:imgRef];
                }
                timeLabel.text = [[GetRelativeTime alloc]getRelativeTime:locationItemObject.createdAt];
            }
        }
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
    }
    
    if (_requestScreen) {
        
    }
    else {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@, %@ %@\n%@", [venueData valueForName:@"address"], [venueData valueForName:@"locality"], [venueData valueForName:@"region"], [venueData valueForName:@"postcode"], [venueData valueForName:@"country"]];
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"Phone: %@", [venueData valueForName:@"tel"]];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"Category: %@", [venueData valueForName:@"category"]];
                break;
            default:
                break;
        }
    }
    
    
    
    return cell;
}


#pragma mark - MapView Delegate Methods
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MMLocation";
    if ([annotation isKindOfClass:[MMLocationAnnotation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.animatesDrop = YES;
            
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSArray* permissions = [NSArray arrayWithObjects:@"publish_stream", @"user_questions", nil];
        [PFFacebookUtils linkUser:[PFUser currentUser] permissions:permissions block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"MobMonkey"
                                                                    message:@"You have successfully linked your MobMonkey account to your Facebook acccount. You can now login to MobMonkey using the Sign in with Facebook option"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
            else {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"MobMonkey"
                                                                    message:@"This facebook account is associated with another user"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }
}

#pragma mark - UITextView Delegate Methods
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        [placeholderLabel setHidden:YES];
    }
    else {
        [placeholderLabel setHidden:NO];
    }
    characterCountLabel.text = [NSString stringWithFormat:@"%d", textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)aRange replacementText:(NSString *)aText {
    
    NSString* newText = [textView.text stringByReplacingCharactersInRange:aRange withString:aText];
    
    if([newText length] > 100)
    {
        return NO; // can't enter more text
    }
    else
        return YES; // let the textView know that it should handle the inserted text
}

@end
