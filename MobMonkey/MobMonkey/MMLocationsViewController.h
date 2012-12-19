//
//  MMLocationsViewController.h
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/16/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MMMapFilterViewController.h"

@interface MMLocationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate> {
  MKMapView *mapView;
  NSDictionary *category;
  MMMapFilterViewController *mapFilterViewController;
}

@property (strong, nonatomic) NSMutableArray *locations;
@property (assign, nonatomic) BOOL isSearching;
@property (strong, nonatomic) NSDictionary *category;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer;

@end
