//
//  MMAppDelegate.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/31/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MMAPI.h"

@interface MMAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate, AdWhirlDelegate> {
    CLLocationManager *_locationManager;
    AdWhirlView *adView;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UIView *adBannerView;
@property (nonatomic, readonly) CLLocation* currentLocation;


@end
