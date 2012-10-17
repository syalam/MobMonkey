//
//  MMFilterViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMFilterViewDelegate

- (void)setFilters:(NSDictionary *)filters;
    
@end

@interface MMFilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UIPickerView *pickerView;
    
    NSString *rangeSelection;
    NSMutableArray *pickerArray;
    NSUserDefaults* prefs;
    NSNumber *selectedRadius;
    NSString *selectedFilter;
}

- (IBAction)segmentedControlSelected:(id)sender;

@property(nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic, retain) NSMutableArray *contentList;
@property(nonatomic,assign) id<MMFilterViewDelegate> delegate;


@end
