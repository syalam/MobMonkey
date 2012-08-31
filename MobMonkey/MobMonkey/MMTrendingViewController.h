//
//  MMTrendingViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/31/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MMTrendingViewController : UITableViewController {
    CLLocation* _queryLocation;
}

@property (nonatomic, retain)NSMutableArray *contentList;

@end
