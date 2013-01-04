//
//  MMSearchViewController.h
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/15/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMapFilterViewController.h"

@interface MMSearchViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, MMMapFilterDelegate> {
    NSArray* allCategoriesArray;
    NSUserDefaults *prefs;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSDictionary *filters;

@end
