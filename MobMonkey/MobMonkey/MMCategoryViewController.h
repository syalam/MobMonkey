//
//  MMCategoryViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/10/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAPI.h"

@protocol MMCategoryDelegate

@optional
- (void)categoriesSelected:(NSMutableDictionary*)selectedCategories;

@end

@interface MMCategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MMAPIDelegate, MMCategoryDelegate> {
    NSMutableDictionary *selectedItemsDictionary;
    NSArray *categoriesArray;
    NSDictionary *allCategories;
    UIButton *selectAllButton;
    int checkMarkCount;
    NSString  *SelectedInterestsKey;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) NSMutableDictionary *selectedItems;
@property (nonatomic) int subCategoryIndex;
@property (nonatomic) BOOL addingLocation;

@property (nonatomic, assign)id<MMCategoryDelegate>delegate;

@end
