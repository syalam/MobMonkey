//
//  MMCategoryViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/10/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCategoryViewController : UITableViewController {
    NSMutableDictionary *selectedItemsDictionary;
}

@property (nonatomic, retain)NSMutableArray *contentList;

@end
