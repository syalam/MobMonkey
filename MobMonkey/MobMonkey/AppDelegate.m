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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [Parse setApplicationId:@"UT8fGQ77gPqU8DKKOHYDlerNGi8QZBO3tpLmsu1x"
                  clientKey:@"3gdOuv0ehtCS6ZhmaPnwXSrHVdANvq59khwqhAjv"];
    
    [TestFlight takeOff:@"e6432d80aed42a955243c8d93a493dea_MTAwODk2MjAxMi0wNi0yMyAxODoxNzoxOC45NjMzMjY"];
    
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
