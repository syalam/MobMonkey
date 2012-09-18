//
//  MMSearchViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/2/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMResultCell.h"
#import "MMFilterViewController.h"
#import "MMSearchCell.h"
#import "MMCategoryCell.h"

@interface MMSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MMSearchCellDelegate, MMFilterViewDelegate> {
}


@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) IBOutlet UIImageView *screenBackground;
@property (nonatomic, retain) IBOutlet UIImageView *searchBackgroundImageView;
@property (nonatomic, retain) IBOutlet UIImageView *searchTextFieldBackgroundImageView;
@property (nonatomic, retain) IBOutlet UITextField *searchTextField;
@property (nonatomic, retain) UIButton *filterNavBarButton;
@property (nonatomic, retain) UIButton *mapNavBarButton;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL showCategories;
@property (nonatomic) BOOL showSearchResults;

@end
