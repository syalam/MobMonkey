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
#import "RequestsViewController.h"
#import "NearbyViewController.h"
#import "BookmarksViewController.h"
#import "SettingsViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate, FactualAPIDelegate>
{
    CLLocationManager *_locationManager;
    CLLocation* _currentLocation;
    
    UIApplicationState state;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, readonly) FactualAPI* apiObject;
@property (nonatomic, readonly) CLLocation* currentLocation;
@property (nonatomic, strong) UILabel *notificationsCountLabel;
@property (nonatomic, retain) RequestsViewController *requestsViewController;
@property (nonatomic, retain) HomeViewController *homeViewController;

- (void) initializeLocationManager;
+(FactualAPI*) getAPIObject;
+(AppDelegate*) getDelegate;

@end
