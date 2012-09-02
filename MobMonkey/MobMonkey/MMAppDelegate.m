//
//  MMAppDelegate.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/31/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMAppDelegate.h"
#import "MMTrendingViewController.h"
#import "MMInboxViewController.h"
#import "MMSearchViewController.h"
#import "MMSettingsViewController.h"

@implementation MMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //initialize testflight SDK
    //[TestFlight takeOff:@"e6432d80aed42a955243c8d93a493dea_MTAwODk2MjAxMi0wNi0yMyAxODoxNzoxOC45NjMzMjY"];
    
    [self initializeLocationManager];
    
    if ([UINavigationBar respondsToSelector:@selector(appearance)]) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavBar~iphone"] forBarMetrics:UIBarMetricsDefault];
    } 
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *inboxVC = [[MMInboxViewController alloc] initWithNibName:@"MMInboxViewController" bundle:nil];
    UIViewController *trendingVC = [[MMTrendingViewController alloc] initWithNibName:@"MMTrendingViewController" bundle:nil];
    UIViewController *searchVC = [[MMSearchViewController alloc]initWithNibName:@"MMSearchViewController" bundle:nil];
    UIViewController *bookmarksVC = [[MMTrendingViewController alloc]initWithNibName:@"MMTrendingViewController" bundle:nil];
    UIViewController *settingsVC = [[MMSettingsViewController alloc]initWithNibName:@"MMSettingsViewController" bundle:nil];
    
    UINavigationController *inboxNavC = [[UINavigationController alloc]initWithRootViewController:inboxVC];
    UINavigationController *trendingNavC = [[UINavigationController alloc]initWithRootViewController:trendingVC];
    UINavigationController *searchNavC = [[UINavigationController alloc]initWithRootViewController:searchVC];
    UINavigationController *bookmarksNavC = [[UINavigationController alloc]initWithRootViewController:bookmarksVC];
    UINavigationController *settingsNavC = [[UINavigationController alloc]initWithRootViewController:settingsVC];
    
    inboxVC.title = @"Inbox";
    trendingVC.title = @"Trending";
    searchVC.title = @"Search";
    bookmarksVC.title = @"Bookmarks";
    settingsVC.title = @"Settings";
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[inboxNavC, trendingNavC, searchNavC, bookmarksNavC, settingsNavC];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) initializeLocationManager {
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy =kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 60.0f; // update every 200ft
    [_locationManager startMonitoringSignificantLocationChanges];
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
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
