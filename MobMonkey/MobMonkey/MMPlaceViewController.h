//
//  MMPlaceViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 5/22/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMPlaceViewController : UITableViewController <UIScrollViewDelegate> {
    CLLocationCoordinate2D center;
    CGFloat deltaLatFor1px;
}

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIImageView *testView;
@property (nonatomic, assign) CGRect defaultMapViewFrame;


@end
