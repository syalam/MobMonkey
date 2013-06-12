//
//  MMWatchLiveVideoViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 6/11/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMLiveVideoCell.h"

@interface MMWatchLiveVideoViewController : UITableViewController <MMLiveVideoCellDelegate>

@property (nonatomic, strong) NSArray * mediaObjects;

@end
