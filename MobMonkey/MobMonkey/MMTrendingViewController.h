//
//  MMTrendingViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/31/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MMTrendingCell.h"

@interface MMTrendingViewController : UITableViewController <MMTrendingCellDelegate> {
    CLLocation* _queryLocation;
    NSMutableDictionary* _cellToggleOnState;
}

@property (nonatomic, retain)NSMutableArray *contentList;

@end
