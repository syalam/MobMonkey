//
//  MMLocationMediaViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/5/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "MMLocationMediaCell.h"
#import "GSAdDelegate.h"
#import "GSFullscreenAd.h"


typedef enum {
    MMLiveCameraMediaType,
    MMVideoMediaType,
    MMPhotoMediaType
} MobMonkeyMediaType;

@interface MMLocationMediaViewController : UIViewController <UITabBarControllerDelegate, UITableViewDataSource, UIActionSheetDelegate, GSAdDelegate> {
    dispatch_queue_t backgroundQueue;
    NSInteger views;
    BOOL didShowModal;
    BOOL didShowAd;
    
}

@property (nonatomic, strong) NSDictionary *location;
@property (assign, nonatomic) MobMonkeyMediaType mediaType;
@property (nonatomic, retain) NSMutableDictionary *thumbnailCache;
@property (strong, nonatomic) GSFullscreenAd* myFullscreenAd;

//Protocol methods for defining basic ad behaviors
- (NSString *)greystripeGUID;
//Delegate "events" to be notified of ad lifecycle
- (void)greystripeAdFetchSucceeded:(id<GSAd>)a_ad;
- (void)greystripeAdFetchFailed:(id<GSAd>)a_ad withError:(GSAdError)a_error;
- (void)greystripeAdClickedThrough:(id<GSAd>)a_ad;
- (void)greystripeWillPresentModalViewController;
- (void)greystripeDidDismissModalViewController;


@end
