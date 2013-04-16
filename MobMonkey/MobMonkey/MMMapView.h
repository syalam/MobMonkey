//
//  MMMapView.h
//  MobMonkey
//
//  Created by Michael Kral on 4/9/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <MapKit/MapKit.h>

@class MMMapView;

@protocol MMMapViewDelegate <NSObject>

@optional
-(void)mapview:(MMMapView*)mapview didSelectLocation:(CLLocationCoordinate2D)location;

@end
@interface MMMapView : MKMapView {
    
}


@property (assign) id <MMMapViewDelegate> delegate;

-(void)startSelectingLocation;
-(void)stopSelectingLocation;
@end
