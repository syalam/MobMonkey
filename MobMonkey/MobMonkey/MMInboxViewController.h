//
//  MMInboxViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/31/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMInboxViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain)UIImageView *mmTitleImageView;
@property (nonatomic, retain)IBOutlet UITableView *tableView;
@property (nonatomic, retain)IBOutlet UIImageView *screenBackground;
@property (nonatomic, retain)NSMutableArray *contentList;
@property (nonatomic)BOOL categorySelected;

@end
