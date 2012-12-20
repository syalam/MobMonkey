//
//  MMMapFilterViewController.h
//  MobMonkey
//
//  Created by Scott Menor on 13/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MMMapFilterViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
  MKMapView *mapView;
  CLLocationManager *locationManager;
  NSArray *contentList;
  NSDictionary *category;
}

- initWithMapView:(MKMapView*)mapView;
- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSArray *contentList;
@property (strong, nonatomic) NSDictionary *category;

@end
