//
//  AppDelegate.m
//  MobMonkey
//
//  Created by Sheehan Alam on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize apiObject=_apiObject;
@synthesize currentLocation=_currentLocation;

- (void) initializeLocationManager { 
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy =kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 60.0f; // update every 200ft
    [_locationManager startMonitoringSignificantLocationChanges];
    //[_locationManager startUpdatingLocation];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    _notificationsCountLabel = [[UILabel alloc]init];
    [_notificationsCountLabel setTextColor:[UIColor whiteColor]];
    [_notificationsCountLabel setBackgroundColor:[UIColor clearColor]];
    [_notificationsCountLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11]];
    [_notificationsCountLabel setTextAlignment:UITextAlignmentCenter];

    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    if ([UINavigationBar respondsToSelector:@selector(appearance)]) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavBar~iphone"] forBarMetrics:UIBarMetricsDefault];
    }

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    [Parse setApplicationId:@"LUASgbV2PjApFDOJabTZeE1Yj8D2keJhLLua1DDl"
                  clientKey:@"1L3iRNHfSsOKc58TxlkOEpD69rTGi9sf8FIBPNmp"];
    
    [TestFlight takeOff:@"e6432d80aed42a955243c8d93a493dea_MTAwODk2MjAxMi0wNi0yMyAxODoxNzoxOC45NjMzMjY"];
    
    _apiObject = [[FactualAPI alloc] initWithAPIKey:@"BEoV3TPDev03P6NJSVJPgTmuTNOegwRsjJN41DnM" secret:@"hwxVQz4lAxb5YpWhbLq10KhWiEw5k35WgFuoR2YI"];
    
    [PFFacebookUtils initializeWithApplicationId:@"160583530745361"];
    
    if ([PFUser currentUser]) {
        //get UUID
        CFUUIDRef uuid;
        CFStringRef uuidStr;
        uuid = CFUUIDCreate(NULL);
        uuidStr = CFUUIDCreateString(NULL, uuid);
        
        NSString* uuidString = [NSString stringWithFormat:@"%@", uuidStr];
        NSLog(@"%@", uuidString);
        
        //Save UUID to user object
        [[PFUser currentUser]setObject:uuidString forKey:@"uuid"];
        [[PFUser currentUser]saveEventually];
        
        //subscribe to push cannel
        [PFPush subscribeToChannelInBackground:[NSString stringWithFormat:@"MM%@", uuidString]];        
    }
       
    [self initializeLocationManager];

    _homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController* homeNavController = [[UINavigationController alloc] initWithRootViewController:_homeViewController];
    _homeViewController.title = @"Trending";
    
    UIViewController *searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    UINavigationController* searchNavController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    searchViewController.title = @"Search";
    
    _requestsViewController = [[RequestsViewController alloc] initWithNibName:@"RequestsViewController" bundle:nil];
    UINavigationController *requestsNavController = [[UINavigationController alloc] initWithRootViewController:_requestsViewController];
    _requestsViewController.title = @"Inbox";
    
    HomeViewController *bookmarksViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController* bookmarksNavController = [[UINavigationController alloc] initWithRootViewController:bookmarksViewController];
    bookmarksViewController.title = @"Bookmarks";
    
    UIViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    UINavigationController* settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    settingsNavController.title = @"Settings";
    
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:homeNavController, searchNavController, requestsNavController, bookmarksNavController, settingsNavController, nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [_locationManager stopUpdatingLocation];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"savedSegmentValue"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"savedPickerValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    state = [application applicationState];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [_locationManager startUpdatingLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([PFUser currentUser]) {
        [_homeViewController checkForNotifications];
    }
    state = [application applicationState];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    // Tell Parse about the device token.
    [PFPush storeDeviceToken:newDeviceToken];
}

- (void)application:(UIApplication *)application 
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //[PFPush handlePush:userInfo];
    if ([PFUser currentUser]) {
        [_homeViewController checkForNotifications];
    }
}

+(FactualAPI*) getAPIObject {
    UIApplication* app = [UIApplication sharedApplication];
    return ((AppDelegate*)app.delegate).apiObject;
}

+(AppDelegate*) getDelegate {
    UIApplication* app = [UIApplication sharedApplication];
    return ((AppDelegate*)app.delegate);
}

#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    _currentLocation = newLocation;
    NSLog(@"AppDelegate Coordinate: %@", _currentLocation);
    
    //set user's location
    if (newLocation) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude] forKey:@"latitude"];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f", newLocation.coordinate.longitude] forKey:@"longitude"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
        [[PFUser currentUser]setObject:point forKey:@"userLocation"];
        [[PFUser currentUser]saveEventually];
        
        if (state == UIApplicationStateActive) {
            [_homeViewController doQuery:nil];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - FB Delegate Methods
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

@end
