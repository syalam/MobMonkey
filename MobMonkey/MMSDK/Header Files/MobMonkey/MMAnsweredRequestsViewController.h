//
//  MMAnsweredRequestsViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/7/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAnsweredRequestsCell.h"

@protocol AnsweredRequestsDelegate

@optional
- (void)updateInboxCount;

@end

@interface MMAnsweredRequestsViewController : UITableViewController <UIActionSheetDelegate, MMAnsweredRequestsCellDelegate> {
    dispatch_queue_t backgroundQueue;
    
    int selectedRow;
   
}

@property (nonatomic, retain) NSArray *contentList;
@property (strong, nonatomic) IBOutlet UITableViewCell *acceptRejectCell;
@property (nonatomic, retain) NSMutableDictionary *thumbnailCache;
@property (nonatomic, weak) NSDictionary* themeOptionsDictionary;
@property (nonatomic, assign) id<AnsweredRequestsDelegate>delegate;

@end