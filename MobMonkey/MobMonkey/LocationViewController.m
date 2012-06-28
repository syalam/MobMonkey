//
//  LocationViewController.m
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationViewController.h"

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
    
    if (actionSheet.tag == kCameraSheet) {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.showsCameraControls = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        switch (buttonIndex) {
            case 0:
                [self presentViewController:picker animated:YES completion:nil];
                break;
            case 1:
                [self presentViewController:picker animated:YES completion:nil];
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
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"loggedIn"]) {
        //show alert view
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
}

- (IBAction)photosButtonTapped:(id)sender {
}
@end
