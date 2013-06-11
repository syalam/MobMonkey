//
//  MMMediaTimelineViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMLocationInformation.h"

@interface MMMediaTimelineViewController : UITableViewController

@property (nonatomic, strong) NSArray * mediaObjects;
@property (nonatomic, strong) NSArray * mediaCellWrappers;
@property (nonatomic, strong) MMLocationInformation * locationInformation;
@end
