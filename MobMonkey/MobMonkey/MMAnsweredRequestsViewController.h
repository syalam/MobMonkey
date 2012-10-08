//
//  MMAnsweredRequestsViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/7/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAnsweredRequestCell.h"

@interface MMAnsweredRequestsViewController : UITableViewController <MMAnsweredRequestCellDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) NSArray *contentList;

@end
