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
#import "MMAPI.h"

@interface MMLocationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MMNotificationSettingsDelegate, MMAPIDelegate, UIGestureRecognizerDelegate> {
    NSArray *mediaArray;
    
    UITapGestureRecognizer *expandImageGesture;
    
    BOOL uiAdjustedForNotificationSetting;
}

@property (nonatomic, retain) NSMutableDictionary* contentList;

@property (nonatomic, weak, readonly)IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UIView *overlayButtonView;

@property (nonatomic, weak) IBOutlet UIButton *likeButton;
@property (nonatomic, weak) IBOutlet UIButton *dislikeButton;
@property (nonatomic, weak) IBOutlet UIButton *videosButton;
@property (nonatomic, weak) IBOutlet UIButton *photosButton;
@property (nonatomic, weak) IBOutlet UIButton *makeRequestButton;
@property (nonatomic, weak) IBOutlet UIButton *flagButton;
@property (nonatomic, weak) IBOutlet UIButton *bookmarkButton;
@property (nonatomic, weak) IBOutlet UIButton *notificationSettingsButton;
@property (nonatomic, weak) IBOutlet UIButton *phoneNumberButton;
@property (nonatomic, weak) IBOutlet UIButton *addressButton;

@property (nonatomic, weak) IBOutlet TCImageView *locationLatestImageView;

@property (nonatomic, weak) IBOutlet UIView *notificationSettingView;
@property (nonatomic, weak) IBOutlet UIView *bookmarkView;

@property (nonatomic, weak) IBOutlet UILabel *locationNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *videoCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *photoCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *notificationSettingLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) int rowIndex;

- (IBAction)photoMediaButtonTapped:(id)sender;
- (IBAction)videoMediaButtonTapped:(id)sender;
- (IBAction)makeRequestButtonTapped:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;
- (IBAction)enlargeButtonTapped:(id)sender;
- (IBAction)flagButtonTapped:(id)sender;
- (IBAction)notificationSettingsButtonTapped:(id)sender;
- (IBAction)bookmarkButtonTapped:(id)sender;
- (IBAction)phoneNumberButtonTapped:(id)sender;
- (IBAction)addressButtonTapped:(id)sender;
- (IBAction)clearNotificationSettingButtonTapped:(id)sender;

@end
