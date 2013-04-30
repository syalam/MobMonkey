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

@interface MMHotSpotViewController : UITableViewController <UIGestureRecognizerDelegate, AdWhirlDelegate, MKMapViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate> {
    MKMapView *mapView;
    UILabel *mapPanLabel;
    UIActivityIndicatorView *loadingIndicator;
    MMHotSpotHeaderView *headerView;
    NSUInteger numberOfLocations;
}

@property (nonatomic, strong) NSArray *nearbyLocations;


@end
