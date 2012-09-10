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

@interface MMAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate> {
    CLLocationManager *_locationManager;
}

@property (strong, nonatomic) UIWindow *window; 
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, readonly) CLLocation* currentLocation;


@end
