//
//  MMCategoryViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/10/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAPI.h"

@interface MMCategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MMAPIDelegate> {
    NSMutableDictionary *selectedItemsDictionary;
    NSArray *categoriesArray;
    NSArray *allCategoriesArray;
    UIButton *selectAllButton;
    int checkMarkCount;
    NSString  *SelectedInterestsKey;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) NSString *parentId;

@end
