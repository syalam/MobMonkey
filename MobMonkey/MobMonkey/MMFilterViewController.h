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
    IBOutlet UIButton *halfMileButton;
    IBOutlet UIButton *oneMileButton;
    IBOutlet UIButton *fiveMileButton;
    IBOutlet UIButton *tenMileButton;
    IBOutlet UIButton *twentyMileButton;
    
    IBOutlet UIButton *videoButton;
    IBOutlet UIButton *pictureButton;
    IBOutlet UIButton *liveFeedButton;
    IBOutlet UIButton *locationVideoButton;
    
    NSString *rangeSelection;
    NSUserDefaults* prefs;
    NSNumber *selectedRadius;
    NSString *selectedFilter;
}

- (IBAction)halfMileButtonClicked:(id)sender;
- (IBAction)oneMileButtonClicked:(id)sender;
- (IBAction)fiveMileButtonClicked:(id)sender;
- (IBAction)tenMileButtonClicked:(id)sender;
- (IBAction)twentyMileButtonClicked:(id)sender;

- (IBAction)videoButtonClicked:(id)sender;
- (IBAction)pictureButtonClicked:(id)sender;
- (IBAction)liveFeedButtonClicked:(id)sender;
- (IBAction)locationVideoButtonClicked:(id)sender;


@property(nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic, retain) NSMutableArray *contentList;
@property(nonatomic,assign) id<MMFilterViewDelegate> delegate;


@end
