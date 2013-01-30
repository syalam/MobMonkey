//
//  MMMapFilterViewController.h
//  MobMonkey
//
//  Created by Scott Menor on 13/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MMAddLocationViewController.h"

@protocol MMMapFilterDelegate

@optional
- (void)locationAddedViaMapViewWithLocationID:(NSString*)locationId providerId:(NSString*)providerId;

@end

@interface MMMapFilterViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, MMAddLocationDelegate> {
    MKMapView *mapView;
    NSArray *contentList;
    NSDictionary *category;
    
    IBOutlet UIImageView *overlayImageView;
    
    UIBarButtonItem *addButton;
    UIBarButtonItem *cancelButton;
    
    UITapGestureRecognizer *tapGestureRecognizer;
}

- initWithMapView:(MKMapView*)mapView;
- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSArray *contentList;
@property (strong, nonatomic) NSDictionary *category;
@property (nonatomic, assign) id<MMMapFilterDelegate> delegate;

@end
