//
//  LocationInfoViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/15/12.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MMLocationAnnotation.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface LocationInfoViewController : UITableViewController <MKMapViewDelegate> {
    NSString *address;
}

@property (nonatomic, retain)IBOutlet MKMapView *mapView;
@property (nonatomic, retain)NSString *locationName;
@property (nonatomic, retain)NSString *address;
@property (nonatomic, retain)NSString *locality;
@property (nonatomic, retain)NSString *region;
@property (nonatomic, retain)NSString *postCode;
@property (nonatomic, retain)NSString *country;
@property (nonatomic)CLLocationCoordinate2D coordinate;
@property (nonatomic, retain)NSString *phoneNumber;
@property (nonatomic, retain)NSString *categories;

@end
