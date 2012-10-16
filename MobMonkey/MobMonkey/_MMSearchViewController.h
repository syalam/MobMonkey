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
#import "MMAPI.h"

@interface MMSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MMSearchCellDelegate, MMFilterViewDelegate, UIGestureRecognizerDelegate, MMAPIDelegate> {
    __weak IBOutlet UIView *headerView;
    NSDictionary *filters;
    UITapGestureRecognizer *tapGesture;
    int currentAPICall;
    NSArray *categories;
    NSArray *searchResult;
}


@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, weak) IBOutlet UIImageView *screenBackground;
@property (nonatomic, weak) IBOutlet UIImageView *searchBackgroundImageView;
@property (nonatomic, weak) IBOutlet UIImageView *searchTextFieldBackgroundImageView;
@property (nonatomic, weak) IBOutlet UITextField *searchTextField;
@property (nonatomic, retain) UIButton *filterNavBarButton;
@property (nonatomic, retain) UIButton *mapNavBarButton;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL showCategories;
@property (nonatomic) BOOL showSearchResults;

@end
