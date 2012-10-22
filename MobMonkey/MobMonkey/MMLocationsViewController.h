//
//  MMLocationsViewController.h
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/16/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MMLocationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *locations;
@property (assign, nonatomic) BOOL isSearching;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
