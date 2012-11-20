//
//  MMAnsweredRequestsViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/7/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAnsweredRequestsCell.h"

@interface MMAnsweredRequestsViewController : UITableViewController <UIActionSheetDelegate, MMAnsweredRequestsCellDelegate> {
    dispatch_queue_t backgroundQueue;
    
    NSMutableDictionary *thumbnailCache;
}

@property (nonatomic, retain) NSArray *contentList;
@property (strong, nonatomic) IBOutlet UITableViewCell *acceptRejectCell;

@end
