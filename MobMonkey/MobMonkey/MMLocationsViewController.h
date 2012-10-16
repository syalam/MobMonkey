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
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *searchString;

@end
