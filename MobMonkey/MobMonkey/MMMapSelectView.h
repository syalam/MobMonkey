//
//  MMMapSelectView.h
//  MobMonkey
//
//  Created by Michael Kral on 5/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MMLocationInformation.h"
#import "MMLocationAnnotation.h"

@class MMMapSelectView;

@protocol MMMapSelectViewDelegate <NSObject>

@optional
-(void)mapSelectView:(MMMapSelectView *)mapSelectView didSelectLocation:(CLLocationCoordinate2D)coordinate;
@end

@interface MMMapSelectView : UIView <MKMapViewDelegate> {
    MMLocationAnnotation *selectedLocation;
}

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) MMLocationInformation *parentLocation;
@property (nonatomic, assign) CLLocationCoordinate2D centerPointCoordinates;
@property (nonatomic, assign) CLLocationCoordinate2D northEastBound;
@property (nonatomic, assign) CLLocationCoordinate2D southWestBound;
@property (assign) id <MMMapSelectViewDelegate> delegate;


@end
