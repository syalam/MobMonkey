//
//  MapViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <FactualSDK/FactualAPI.h>

@interface MapViewController : UIViewController <UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, FactualAPIDelegate, MKMapViewDelegate, UISearchBarDelegate> {
    IBOutlet UIButton *radiusButton;
    IBOutlet UIButton *addLocationButton;
    
    UIActionSheet *radiusActionSheet;
    UIPickerView *radiusPicker;
    
    NSMutableArray *radiusPickerItemsArray;
    NSUserDefaults* prefs;
    FactualAPIRequest* _activeRequest;
    double _mapRadius;
    
}

- (IBAction)radiusButtonClicked:(id)sender;
- (IBAction)addLocationButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) FactualQueryResult* queryResult;

@end
