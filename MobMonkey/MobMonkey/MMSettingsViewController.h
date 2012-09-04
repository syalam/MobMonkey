//
//  MMSettingsViewController.h
//  MobMonkey
//
//  Created by Sheehan Alam on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableDictionary *selectionDictionary;
    UIImageView *notificationsImageView;
    UILabel *notificationsCountLabel;
}

@property (nonatomic, retain)NSMutableArray *contentList;
@property (nonatomic, retain)IBOutlet UIImageView *screenBackground;
@property (nonatomic, retain)IBOutlet UITableView *tableView;

@end
