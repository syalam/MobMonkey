//
//  MMCreateHotSpotMapViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 6/5/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMLocationInformation.h"

@interface MMCreateHotSpotMapViewController : UIViewController <MKMapViewDelegate> {
    MKPointAnnotation *hotSpotAnnotation;
}

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIButton * hotSpotActionButton;
@property (nonatomic, strong) MMLocationInformation *parentLocationInformation;

@end
