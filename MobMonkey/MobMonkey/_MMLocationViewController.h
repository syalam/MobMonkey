//
//  MMLocationViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/2/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "TCImageView.h"
#import "MMNotificationSettingsViewController.h"
#import "MMAPI.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
#import "MMLocationInformation.h"
#import "UIImageView+AFNetworking.h"

@interface MMlocationDetailCellData : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) LocationCellType cellType;

@end

@interface MMLocationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MMNotificationSettingsDelegate, MMAPIDelegate, UIGestureRecognizerDelegate, NSURLConnectionDelegate> {
    NSArray *mediaArray;
    
    UITapGestureRecognizer *expandImageGesture;
    
    BOOL uiAdjustedForNotificationSetting;
    
    dispatch_queue_t backgroundQueue;
    
    IBOutlet UIImageView *liveStreamImage;
    IBOutlet UIImageView *playButtonImageView;
    
    
}

//@property (nonatomic, retain) NSMutableDictionary* contentList;

@property (nonatomic, weak, readonly)IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UIView *overlayButtonView;

@property (nonatomic, weak) IBOutlet UIButton *likeButton;
@property (nonatomic, weak) IBOutlet UIButton *dislikeButton;
@property (nonatomic, weak) IBOutlet UIButton *videosButton;
@property (nonatomic, weak) IBOutlet UIButton *photosButton;
@property (nonatomic, weak) IBOutlet UIButton *liveStreamButton;
@property (nonatomic, weak) IBOutlet UIButton *makeRequestButton;
@property (nonatomic, weak) IBOutlet UILabel *makeRequestLabel;
@property (nonatomic, weak) IBOutlet UILabel *numberOfPeopleLabel;
@property (nonatomic, weak) IBOutlet UIButton *flagButton;
@property (nonatomic, weak) IBOutlet UIButton *bookmarkButton;
@property (nonatomic, weak) IBOutlet UIButton *notificationSettingsButton;
@property (nonatomic, weak) IBOutlet UIButton *phoneNumberButton;
@property (nonatomic, weak) IBOutlet UIButton *addressButton;
@property (nonatomic, weak) IBOutlet UILabel *uploadDateLabel;
@property (nonatomic, weak) IBOutlet UIImageView *clockImageView;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UIView *mediaToolbarView;
@property (nonatomic, weak) IBOutlet UIView *mediaView;
@property (nonatomic, strong) IBOutlet UIView *mediaLoadingView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *mediaIndicatorView;

@property (nonatomic, retain) IBOutlet UIImageView *locationLatestImageView;

@property (nonatomic, weak) IBOutlet UIView *notificationSettingView;
@property (nonatomic, weak) IBOutlet UIView *bookmarkView;

@property (nonatomic, weak) IBOutlet UILabel *locationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *streamingCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *videoCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *photoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *monkeyCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *notificationSettingLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIImageView *topBlackGradient;
@property (nonatomic, strong) IBOutlet UIImageView *bottonBlackGradient;
@property (strong, nonatomic) MPMoviePlayerViewController *player;

@property (nonatomic, strong) NSString *locationID;
@property (nonatomic, strong) NSString *providerID;
@property (nonatomic, strong) MMLocationInformation *locationInformation;


@property (nonatomic) int rowIndex;

- (IBAction)mediaButtonTapped:(id)sender;
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

- (void)loadLocationDataWithLocationId:(NSString*)locationId providerId:(NSString*)providerId;

@end