//
//  LocationViewController.h
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "RequestsViewController.h"
#import <FactualSDK/FactualAPI.h>
#import <MapKit/MapKit.h>
#import "MMLocationAnnotation.h"
#import "TCImageView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LocationViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, UITextViewDelegate> {
    UIImage *image;
    UIImageView *notificationsImageView;
    UILabel *notificationsCountLabel;
    
    IBOutlet UILabel *locationInfoLabel;
    IBOutlet UIButton *locationInfoButton;
    
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *photoCountLabel;
    IBOutlet UILabel *videoCountLabel;
    IBOutlet TCImageView *locationImageView;
    
    NSString *mediaType;
    int currentActionSheetCall;
    
    //request view items
    IBOutlet UIView *requestModalView;
    IBOutlet UITextView *requestTextView;
    IBOutlet UILabel *placeholderLabel;
    IBOutlet UILabel *characterCountLabel;
    IBOutlet UIButton *requestVideoButton;
    IBOutlet UIButton *requestPhotoButton;
    IBOutlet UISwitch *activeSwitch;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *requestItButton;
    
    BOOL videoRequested;
    
    IBOutlet UIButton *thumbsDownButton;
    IBOutlet UIButton *thumbsUpButton;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UILabel *locationNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *photosButton;
@property (strong, nonatomic) IBOutlet UIButton *videosButton;
@property (strong, nonatomic) IBOutlet UIButton *requestButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *bookmarkButton;
@property (strong, nonatomic) IBOutlet UIButton *notificationsButton;
@property (strong, nonatomic) IBOutlet UIButton *popupButton;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSString* locationName;
@property (nonatomic, retain) RequestsViewController *requestScreen;
@property (nonatomic, retain) PFObject *requestObject;
@property (nonatomic, retain) FactualRow* venueData;
@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;


- (IBAction)locationInfoButtonTapped:(id)sender;
- (IBAction)thumbsDownButtonTapped:(id)sender;
- (IBAction)thumbsUpButton:(id)sender;
- (IBAction)videosButtonTapped:(id)sender;
- (IBAction)requestButtonTapped:(id)sender;
- (IBAction)bookmarkButtonTapped:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;
- (IBAction)notificationsButtonTapped:(id)sender;
- (IBAction)photosButtonTapped:(id)sender;
- (IBAction)popupButtonTapped:(id)sender;
- (IBAction)requestVideoButtonTapped:(id)sender;
- (IBAction)requestPhotoButtonTapped:(id)sender;
- (IBAction)activeSwitchTapped:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)requestItButtonTapped:(id)sender;


- (void)makeRequest:(NSString*)requestType;

@end
