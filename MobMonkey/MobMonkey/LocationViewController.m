//
//  LocationViewController.m
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationViewController.h"

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
    
    [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
}

#pragma mark - ActionSheet Delegate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
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

#pragma mark - UIImagePickerController Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
}

#pragma mark - IBAction Methods
- (IBAction)videosButtonTapped:(id)sender {
}

- (IBAction)requestButtonTapped:(id)sender {
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
