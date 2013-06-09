//
//  MMAdvancedSearchTableViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 6/7/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

typedef enum {
    MMSearchByNearby = 1,
    MMSearchByCategory,
    MMSearchByFavorites,
    MMSearchByInterests
}MMSearchByType;

#import <UIKit/UIKit.h>
#import "MMSearchTableViewController.h"

@interface MMAdvancedSearchTableViewController : MMSearchTableViewController

@property (nonatomic, assign) MMSearchByType searbyByType;
@property (nonatomic, strong) NSDictionary * category;
@property (nonatomic, strong) NSArray *allPlaces;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, assign) BOOL isSearching;


-(id)initWithStyle:(UITableViewStyle)style searchByType:(MMSearchByType)searchByType;

@end
