//
//  MMSlideMenuViewController.h
//  MobMonkey_LVF
//
//  Created by Michael Kral on 4/17/13.
//  Copyright (c) 2013 MobMonkey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

typedef enum {
    MenuItemProfile,
    MenuItemStreamNow,
    MenuItemLiveStream,
    MenuItemFavorites,
    MenuItemManageList,
    MenuItemCustomList
    
} MenuItem;

@interface MMSlideMenuViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate> {
}

@property (nonatomic, strong) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *menuItems;

@end
