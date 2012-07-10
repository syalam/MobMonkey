//
//  AppDelegate.h
//  MobMonkey
//
//  Created by Sheehan Alam on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FactualSDK/FactualAPI.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate, FactualAPIDelegate>
{
    CLLocationManager *_locationManager;
    CLLocation* _currentLocation;
    FactualAPIRequest* _activeRequest;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, readonly) FactualAPI* apiObject;
@property (nonatomic, readonly) CLLocation* currentLocation;

+(FactualAPI*) getAPIObject;
+(AppDelegate*) getDelegate;

@end
