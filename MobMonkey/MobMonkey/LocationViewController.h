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

@interface LocationViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate> {
    UIImage *image;
    UIImageView *notificationsImageView;
    UILabel *notificationsCountLabel;
    
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *photoCountLabel;
    IBOutlet UILabel *videoCountLabel;
    IBOutlet TCImageView *locationImageView;
    
    NSString *mediaType;
    
    int currentActionSheetCall;
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
@property (nonatomic, retain) NSString* locationName;
@property (nonatomic, retain) RequestsViewController *requestScreen;
@property (nonatomic, retain) PFObject *requestObject;
@property (nonatomic, retain) FactualRow* venueData;
@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

- (IBAction)videosButtonTapped:(id)sender;
- (IBAction)requestButtonTapped:(id)sender;
- (IBAction)bookmarkButtonTapped:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;
- (IBAction)notificationsButtonTapped:(id)sender;
- (IBAction)photosButtonTapped:(id)sender;
- (IBAction)popupButtonTapped:(id)sender;

- (void)makeRequest:(NSString*)requestType;

@end
