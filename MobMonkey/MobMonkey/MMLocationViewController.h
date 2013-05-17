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


@interface MMLocationViewController : UITableViewController <MMLocationHeaderViewDelegate, MPMediaPickerControllerDelegate> {
    MMLocationHeaderView *_headerView;
    dispatch_queue_t  backgroundQueue;
    BOOL uiAdjustedForNotificationSetting;
    BOOL loadingInfo;
    BOOL canDelete;
}

@property (nonatomic, strong) MMLocationHeaderView *headerView;
@property (nonatomic, strong) MMLocationInformation *locationInformation;
@property (nonatomic, strong) NSArray *mediaArray;
@property (strong, nonatomic) MPMoviePlayerViewController *player;

@property (nonatomic, strong) NSString *locationID;
@property (nonatomic, strong) NSString *providerID;

- (void)loadLocationDataWithLocationId:(NSString*)locationId providerId:(NSString*)providerId;

@end
