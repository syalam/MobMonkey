//
//  MMSearchTableViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 6/7/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMSearchTableViewController : UITableViewController <UISearchBarDelegate>

@property (nonatomic, strong, readonly) UISearchBar *searchBar;

@end
