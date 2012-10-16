//
//  MMLocationsViewController.h
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/16/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMLocationsViewController : UITableViewController

@property (strong, nonatomic) NSArray *locations;
@property (assign, nonatomic) BOOL isSearching;

@end
