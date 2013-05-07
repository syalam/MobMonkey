//
//  MMLocationViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 5/6/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMLocationHeaderView.h"
#import "MMLocationInformation.h"
#import "MMLocationMediaViewController.h"


@interface MMLocationDetailCellData : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) LocationCellType cellType;

@end


@interface MMLocationViewController : UITableViewController <MMLocationHeaderViewDelegate> {
    MMLocationHeaderView *_headerView;
    dispatch_queue_t  backgroundQueue;
    BOOL uiAdjustedForNotificationSetting;
}

@property (nonatomic, strong) MMLocationHeaderView *headerView;
@property (nonatomic, strong) MMLocationInformation *locationInformation;
@property (nonatomic, strong) NSArray *mediaArray;
@property (strong, nonatomic) MPMoviePlayerViewController *player;

@end
