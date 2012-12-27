//
//  MMFilterViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMSearchViewController.h"

@protocol MMFilterViewDelegate

- (void)setFilters:(NSDictionary *)filters;
    
@end

@interface MMFilterViewController : UIViewController {
    IBOutlet UISegmentedControl *distancePicker;
    
    IBOutlet UISwitch *liveFeedSwitch;
    
    NSString *rangeSelection;
    NSUserDefaults* prefs;
    NSNumber *selectedRadius;
    BOOL selectedFilter;
}
- (IBAction)distanceSelected:(id)sender;

@property(nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic, retain) NSMutableArray *contentList;
@property(nonatomic,assign) id<MMFilterViewDelegate> delegate;


@end
