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
#import "MMAddLocationViewController.h"

@interface MMLocationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, MMMapFilterDelegate, MMAddLocationDelegate> {
  MKMapView *mapView;
  NSDictionary *category;
  MMMapFilterViewController *mapFilterViewController;
    
    IBOutlet UIImageView *overlayImageView;
    
    UITapGestureRecognizer *tapGestureRecognizer;
    
    UIBarButtonItem* globeButton;
    UIBarButtonItem* addLocationButton;
    UIBarButtonItem* cancelButton;
    UIBarButtonItem *clearBarButton;
    IBOutlet UIToolbar *radiusToolbar;
}

@property (nonatomic, strong) NSMutableArray *locationsInformationCollection;
//@property (strong, nonatomic) NSMutableArray *locations;
@property (assign, nonatomic) BOOL isSearching;
@property (strong, nonatomic) NSDictionary *category;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) BOOL isHistory;

@property (nonatomic, strong) NSString *searchString;

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer;

@end
