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


typedef enum {
    MMLiveCameraMediaType,
    MMVideoMediaType,
    MMPhotoMediaType
} MobMonkeyMediaType;

@interface MMLocationMediaViewController : UIViewController <UITabBarControllerDelegate, UITableViewDataSource> {
    dispatch_queue_t backgroundQueue;
}

@property (nonatomic, strong) NSDictionary *location;
@property (assign, nonatomic) MobMonkeyMediaType mediaType;
@property (nonatomic, retain) NSMutableDictionary *thumbnailCache;

@end
