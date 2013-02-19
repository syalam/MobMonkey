//
//  MMTrendingDetailViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 1/9/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MMTrendingCell.h"

@interface MMTrendingDetailViewController : UITableViewController <MMTrendingCellDelegate, UIActionSheetDelegate> {
    int selectedRow;
    dispatch_queue_t backgroundQueue;
}

@property (nonatomic, retain) NSArray *contentList;
@property (nonatomic, retain) NSMutableDictionary *thumbnailCache;

@end
