//
//  MMSearchCitySelectViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 6/13/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMGooglePlacesCitySearch.h"


@class MMSearchCitySelectViewController;

@protocol MMSearchCitySelectDelegate <NSObject>

-(void)citySelectVC:(MMSearchCitySelectViewController *)viewController didSelectCityObject:(MMGoogleCityDataObject *)cityObject;

@end

@interface MMSearchCitySelectViewController : UITableViewController <UISearchBarDelegate>



@property (nonatomic, strong) UISearchBar * searchBar;
@property (assign) id <MMSearchCitySelectDelegate> delegate;


@end
