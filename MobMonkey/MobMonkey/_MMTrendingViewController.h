//
//  MMTrendingViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/31/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MMResultCell.h"
#import "SectionHeaderView.h"


@interface _MMTrendingViewController : UITableViewController <MMResultCellDelegate, MKMapViewDelegate, UIActionSheetDelegate, SectionHeaderViewDelegate> {
    CLLocation* _queryLocation;
    NSMutableDictionary* _cellToggleOnState;
    NSMutableArray *sectionTitleArray;
    NSDictionary *trendingCategoryCountsDictionary;
    NSArray *myInterestsArray;
    
    int selectedRow;
}

@property (nonatomic, retain) NSMutableArray *sectionInfoArray;
@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic)BOOL sectionSelected;
@property (nonatomic)BOOL bookmarkTab;


@end