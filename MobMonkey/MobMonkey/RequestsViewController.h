//
//  RequestsViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "RequestCell.h"


@interface RequestsViewController : UITableViewController <RequestCellDelegate> {
    NSMutableArray *indexPathArray;
    UILabel *notificationsCountLabel;
    
    int currentIndex;
    NSIndexPath *responseIndexPath;
    
}

@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) NSMutableArray *requestQueryItems;
@property (nonatomic)BOOL fromHome;

- (void)checkForNotifications;
- (void)responseComplete:(PFObject *)requestObject;
- (void)separateSections;

@end
