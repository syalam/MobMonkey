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
    __weak IBOutlet UIButton *radiusButton;
    __weak IBOutlet UIButton *addLocationButton;
    
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

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSString* address;

@end
