//
//  SettingsViewController.h
//  MobMonkey
//
//  Created by Sheehan Alam on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SettingsViewController : UITableViewController {
    NSMutableDictionary *selectionDictionary;
}

@property (nonatomic, retain)NSMutableArray *contentList;

@end
