//
//  MapViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MMMapViewController : UIViewController <UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MKMapViewDelegate, UISearchBarDelegate> {
    IBOutlet UIButton *radiusButton;
    IBOutlet UIButton *addLocationButton;
    
    UIActionSheet *radiusActionSheet;
    UIPickerView *radiusPicker;
    
    UIImageView *notificationsImageView;
    UILabel *notificationsCountLabel;
    
    NSMutableArray *radiusPickerItemsArray;
    NSUserDefaults* prefs;
    double _mapRadius;
    
}

- (IBAction)radiusButtonClicked:(id)sender;
- (IBAction)addLocationButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
