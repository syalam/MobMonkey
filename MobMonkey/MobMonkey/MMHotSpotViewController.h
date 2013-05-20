//
//  MMHotSpotViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 4/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AdWhirlAdapterIAd.h"
#import "MMHotSpotHeaderView.h"
#import "MMLocationSearch.h"
#import "MMAddLocationViewController.h"
#import "WEPopoverController.h"
#import "MMLocationFilterTableViewController.h"

@interface MMHotSpotViewController : UITableViewController <UIGestureRecognizerDelegate, AdWhirlDelegate, MKMapViewDelegate, UISearchDisplayDelegate, MMAddLocationDelegate, UISearchBarDelegate, WEPopoverControllerDelegate> {
    MKMapView *mapView;
    UILabel *mapPanLabel;
    UIActivityIndicatorView *loadingIndicator;
    MMHotSpotHeaderView *headerView;
    NSUInteger numberOfLocations;
    NSArray *searchResults;
    UISearchDisplayController *searchDisplayController;
    BOOL loadFromServer;
    MMLocationSearch *searchModel;
    WEPopoverController *popOverController;
    NSString *cityString;
    NSString *zipString;
    MMLocationFilterTableViewController *filterLocationVC;
}

@property (nonatomic, strong) NSArray *nearbyLocations;


@end
