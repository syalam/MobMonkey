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
    
    IBOutlet UIImageView *overlayImageView;
    
    UITapGestureRecognizer *tapGestureRecognizer;
    
    UIBarButtonItem* globeButton;
    UIBarButtonItem* addLocationButton;
    UIBarButtonItem* cancelButton;
    UIBarButtonItem *clearBarButton;
}

@property (strong, nonatomic) NSMutableArray *locations;
@property (assign, nonatomic) BOOL isSearching;
@property (strong, nonatomic) NSDictionary *category;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) BOOL isHistory;

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer;

@end
