//
//  MMCreateHotSpotMapViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 6/5/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCreateHotSpotMapViewController : UIViewController <MKMapViewDelegate> {
    MKPointAnnotation *hotSpotAnnotation;
}

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIButton * hotSpotActionButton;


@end
