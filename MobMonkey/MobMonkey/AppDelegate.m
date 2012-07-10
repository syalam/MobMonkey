//
//  AppDelegate.m
//  MobMonkey
//
//  Created by Sheehan Alam on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"
#import "SearchViewController.h"
#import "NearbyViewController.h"
#import "BookmarksViewController.h"
#import "SettingsViewController.h"

#import <Parse/Parse.h>

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
    [_locationManager startUpdatingLocation];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [Parse setApplicationId:@"UT8fGQ77gPqU8DKKOHYDlerNGi8QZBO3tpLmsu1x"
                  clientKey:@"3gdOuv0ehtCS6ZhmaPnwXSrHVdANvq59khwqhAjv"];
    
    [TestFlight takeOff:@"e6432d80aed42a955243c8d93a493dea_MTAwODk2MjAxMi0wNi0yMyAxODoxNzoxOC45NjMzMjY"];
    
    _apiObject = [[FactualAPI alloc] initWithAPIKey:@"BEoV3TPDev03P6NJSVJPgTmuTNOegwRsjJN41DnM" secret:@"hwxVQz4lAxb5YpWhbLq10KhWiEw5k35WgFuoR2YI"];
    
    [self initializeLocationManager];
    
    HomeViewController *homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController* homeNavController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    homeViewController.title = @"Home";
    
    UIViewController *searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    UINavigationController* searchNavController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    searchViewController.title = @"Search";
    
    HomeViewController *nearbyViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController* nearbyNavController = [[UINavigationController alloc] initWithRootViewController:nearbyViewController];
    nearbyViewController.title = @"Nearby";
    
    HomeViewController *bookmarksViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController* bookmarksNavController = [[UINavigationController alloc] initWithRootViewController:bookmarksViewController];
    bookmarksViewController.title = @"Bookmarks";
    
    UIViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    UINavigationController* settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    settingsNavController.title = @"Settings";
    
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:homeNavController, searchNavController, nearbyNavController, bookmarksNavController, settingsNavController, nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [_locationManager stopUpdatingLocation];
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [_locationManager startUpdatingLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
}

-(void)performFactualQuery
{
    FactualQuery* queryObject = [FactualQuery query];
    queryObject.limit = 50;
    [queryObject setGeoFilter:_currentLocation.coordinate radiusInMeters:100.0];
    
    NSLog(@"latitude %@",_currentLocation.coordinate.latitude);
    NSLog(@"longitude %@", _currentLocation.coordinate.longitude);
    
    FactualSortCriteria* primarySort = [[FactualSortCriteria alloc] initWithFieldName:@"$relevance" sortOrder:FactualSortOrder_Ascending];
    [queryObject setPrimarySortCriteria:primarySort];
    [queryObject addFullTextQueryTerms:@"coffee", nil];
    
    
    _activeRequest = [[AppDelegate getAPIObject] queryTable:@"global" optionalQueryParams:queryObject withDelegate:self];
}

#pragma mark -
#pragma mark FactualAPIDelegate methods

- (void)requestDidReceiveInitialResponse:(FactualAPIRequest *)request {
    NSLog(@"received factual response");
}

- (void)requestDidReceiveData:(FactualAPIRequest *)request { 
    NSLog(@"received factual data");
}

-(void) requestComplete:(FactualAPIRequest *)request failedWithError:(NSError *)error {
    NSLog(@"Active request failed with Error:%@", [error localizedDescription]);
}


-(void) requestComplete:(FactualAPIRequest *)request receivedQueryResult:(FactualQueryResult *)queryResultObj {
    NSLog(@"Active request Completed!");
}

@end
