//
//  MMLocationViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/2/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCImageView.h"
#import "MMNotificationSettingsViewController.h"
#import "MMMakeRequestViewController.h"

@interface MMLocationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MMNotificationSettingsDelegate>

@property (nonatomic, readonly)IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain)IBOutlet UIView *overlayButtonView;

@property (nonatomic, retain)IBOutlet UIButton *likeButton;
@property (nonatomic, retain)IBOutlet UIButton *dislikeButton;
@property (nonatomic, retain)IBOutlet UIButton *videosButton;
@property (nonatomic, retain)IBOutlet UIButton *photosButton;
@property (nonatomic, retain)IBOutlet UIButton *makeRequestButton;
@property (nonatomic, retain)IBOutlet UIButton *flagButton;
@property (nonatomic, retain)IBOutlet UIButton *bookmarkButton;
@property (nonatomic, retain)IBOutlet UIButton *notificationSettingsButton;
@property (nonatomic, retain)IBOutlet UIButton *phoneNumberButton;
@property (nonatomic, retain)IBOutlet UIButton *addressButton;

@property (nonatomic, retain)IBOutlet TCImageView *locationLatestImageView;
@property (nonatomic, retain)IBOutlet UIImageView *notificationSettingImageView;

@property (nonatomic, retain)IBOutlet UILabel *locationNameLabel;
@property (nonatomic, retain)IBOutlet UILabel *videoCountLabel;
@property (nonatomic, retain)IBOutlet UILabel *photoCountLabel;
@property (nonatomic, retain)IBOutlet UILabel *phoneNumberLabel;
@property (nonatomic, retain)IBOutlet UILabel *addressLabel;
@property (nonatomic, retain)IBOutlet UILabel *notificationSettingLabel;

@property (nonatomic) int rowIndex;

- (IBAction)makeRequestButtonTapped:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;
- (IBAction)enlargeButtonTapped:(id)sender;
- (IBAction)flagButtonTapped:(id)sender;
- (IBAction)notificationSettingsButtonTapped:(id)sender;
- (IBAction)bookmarkButtonTapped:(id)sender;
- (IBAction)phoneNumberButtonTapped:(id)sender;
- (IBAction)addressButtonTapped:(id)sender;

@end
