//
//  MapViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MMAddLocationViewController.h"

@interface MMMapViewController : UIViewController <UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MKMapViewDelegate, UISearchBarDelegate, MMAddLocationDelegate> {
    __weak IBOutlet UIButton *radiusButton;
    __weak IBOutlet UIButton *addLocationButton;
    IBOutlet UIImageView *overlayImageView;
    UIActionSheet *radiusActionSheet;
    UIPickerView *radiusPicker;
    
    UIImageView *notificationsImageView;
    UILabel *notificationsCountLabel;
    
    NSMutableArray *radiusPickerItemsArray;
    NSUserDefaults* prefs;
    double _mapRadius;
    
    UIBarButtonItem *addLocationBarButton;
    UIBarButtonItem *cancelBarButton;
    
    UITapGestureRecognizer *mapTapGestureRecognizer;
    
}

- (IBAction)radiusButtonClicked:(id)sender;
- (IBAction)addLocationButtonClicked:(id)sender;

@property (nonatomic, retain)NSArray *contentList;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSString* address;

@end
