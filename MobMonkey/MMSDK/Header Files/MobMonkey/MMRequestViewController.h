//
//  MMRequestViewController.h
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/18/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMRequestScheduleViewController.h"

@class MMTableViewCell;

@interface MMRequestViewController : UITableViewController <MMRequestScheduleDelegate> {
    BOOL isRecurring;
}

@property (nonatomic, retain)NSDictionary *contentList;
@property (nonatomic, retain)NSDictionary *themeOptionsDictionary;

@end
