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

@interface LocationViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImage *image;
    
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
@property (nonatomic, retain) NSString* locationName;
@property (nonatomic, retain) RequestsViewController *requestScreen;
@property (nonatomic, retain) PFObject *requestObject;
@property (nonatomic, retain) FactualRow* venueData;

- (IBAction)videosButtonTapped:(id)sender;
- (IBAction)requestButtonTapped:(id)sender;
- (IBAction)bookmarkButtonTapped:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;
- (IBAction)notificationsButtonTapped:(id)sender;
- (IBAction)photosButtonTapped:(id)sender;

- (void)makeRequest:(NSString*)requestType;

@end
