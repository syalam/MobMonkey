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

@interface MMTrendingViewController : UITableViewController <MMResultCellDelegate, MKMapViewDelegate, UIActionSheetDelegate, SectionHeaderViewDelegate> {
    CLLocation* _queryLocation;
    NSMutableDictionary* _cellToggleOnState;
    NSMutableArray *sectionTitleArray;
}

@property (nonatomic, retain)NSMutableArray *sectionInfoArray;
@property (nonatomic, retain)NSMutableArray *contentList;
@property (nonatomic, strong) NSIndexPath* pinchedIndexPath;
@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, assign) CGFloat initialPinchHeight;


@end
