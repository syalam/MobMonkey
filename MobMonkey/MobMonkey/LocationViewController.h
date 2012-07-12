//
//  LocationViewController.h
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "RequestsViewController.h"

@interface LocationViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImage *image;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *photosButton;
@property (strong, nonatomic) IBOutlet UIButton *videosButton;
@property (strong, nonatomic) IBOutlet UIButton *requestButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *bookmarkButton;
@property (strong, nonatomic) IBOutlet UIButton *notificationsButton;
@property (nonatomic, retain) RequestsViewController *requestScreen;
@property (nonatomic, retain) PFObject *requestObject;

- (IBAction)videosButtonTapped:(id)sender;
- (IBAction)requestButtonTapped:(id)sender;
- (IBAction)bookmarkButtonTapped:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;
- (IBAction)notificationsButtonTapped:(id)sender;
- (IBAction)photosButtonTapped:(id)sender;
@end
