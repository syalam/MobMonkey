//
//  MMSearchPlacesViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 5/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMSearchDisplayModel.h"
#import "MMFixedHeaderViewController.h"

@interface MMSearchPlacesViewController : MMFixedHeaderViewController <UISearchBarDelegate, UIGestureRecognizerDelegate> {
    
}

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSArray * defaultList;
@property (nonatomic, strong) NSArray * placesSearchResults;
@property (nonatomic, strong) NSArray * categorySearchResults;


-(id)initWithStyle:(UITableViewStyle)style;
@end
