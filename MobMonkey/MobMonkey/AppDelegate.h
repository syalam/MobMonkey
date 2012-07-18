//
//  AppDelegate.h
//  MobMonkey
//
//  Created by Sheehan Alam on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FactualSDK/FactualAPI.h>
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "NearbyViewController.h"
#import "BookmarksViewController.h"
#import "SettingsViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate, FactualAPIDelegate>
{
    CLLocationManager *_locationManager;
    CLLocation* _currentLocation;
    
    HomeViewController *homeViewController;
    
    UIApplicationState state;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, readonly) FactualAPI* apiObject;
@property (nonatomic, readonly) CLLocation* currentLocation;


- (void) initializeLocationManager;
+(FactualAPI*) getAPIObject;
+(AppDelegate*) getDelegate;

@end
