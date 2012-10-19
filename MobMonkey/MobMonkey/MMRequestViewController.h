//
//  MMRequestViewController.h
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/18/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMRequestViewController : UITableViewController

@property (nonatomic, retain)NSDictionary *contentList;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mediaSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *requestLengthSegmentedControl;

@end
