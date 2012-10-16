//
//  MMAppDelegate.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/31/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMAppDelegate.h"
#import "MMBookmarksViewController.h"
#import "MMTrendingViewController.h"
#import "MMInboxViewController.h"
#import "MMSearchViewController.h"
#import "MMSettingsViewController.h"
#import "MMTabBarViewController.h"

@implementation MMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //initialize testflight SDK
    //[TestFlight takeOff:@"e6432d80aed42a955243c8d93a493dea_MTAwODk2MjAxMi0wNi0yMyAxODoxNzoxOC45NjMzMjY"];
    
    
    //REMOVE ME: Hardcode the partner ID
    [[NSUserDefaults standardUserDefaults]setObject:@"aba0007c-ebee-42db-bd52-7c9f02e3d371" forKey:@"mmPartnerId"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [FBProfilePictureView class];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    [self initializeLocationManager];
    
    if ([UINavigationBar respondsToSelector:@selector(appearance)]) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavBar~iphone"] forBarMetrics:UIBarMetricsDefault];
    } 
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *inboxVC = [[MMInboxViewController alloc] initWithNibName:@"MMInboxViewController" bundle:nil];
    UIViewController *searchVC = [[MMSearchViewController alloc]initWithNibName:@"MMSearchViewController" bundle:nil];
    UIViewController *trendingVC = [[MMTrendingViewController alloc] initWithNibName:@"MMTrendingViewController" bundle:nil];
    UIViewController *bookmarksVC = [[MMBookmarksViewController alloc]initWithNibName:@"MMBookmarksViewController" bundle:nil];
    UIViewController *settingsVC = [[MMSettingsViewController alloc]initWithNibName:@"MMSettingsViewController" bundle:nil];
    
    UINavigationController *inboxNavC = [[UINavigationController alloc]initWithRootViewController:inboxVC];
    UINavigationController *searchNavC = [[UINavigationController alloc]initWithRootViewController:searchVC];
    UINavigationController *trendingNavC = [[UINavigationController alloc]initWithRootViewController:trendingVC];
    UINavigationController *bookmarksNavC = [[UINavigationController alloc]initWithRootViewController:bookmarksVC];
    UINavigationController *settingsNavC = [[UINavigationController alloc]initWithRootViewController:settingsVC];
    
    inboxVC.title = @"Inbox";
    searchVC.title = @"Search";
    trendingVC.title = @"Trending";
    bookmarksVC.title = @"Bookmarks";
    settingsVC.title = @"Settings";
    
//    bookmarksVC.sectionSelected = YES;
//    bookmarksVC.bookmarkTab = YES;
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[ trendingNavC, inboxNavC, searchNavC, bookmarksNavC, settingsNavC];
    [self.tabBarController.tabBar setBackgroundImage:[[UIImage imageNamed:@"tabbar-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 2.0, 0.0, 2.0)]];
    [self.tabBarController.tabBar setSelectionIndicatorImage:[[UIImage imageNamed:@"selected-tab-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)]];
    
    
    CGFloat inset = 5.0;
    
    [trendingNavC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"trendingIcn"] withFinishedUnselectedImage:[UIImage imageNamed:@"trendingIcnOff"]];
    [trendingNavC.tabBarItem setImageInsets:UIEdgeInsetsMake(inset, 0, -inset, 0)];
    trendingNavC.tabBarItem.title = nil;
    
    [inboxNavC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"inboxIcn"] withFinishedUnselectedImage:[UIImage imageNamed:@"inboxIcnOff"]];
    [inboxNavC.tabBarItem setImageInsets:UIEdgeInsetsMake(inset, 0, -inset, 0)];
    inboxNavC.tabBarItem.title=nil;
    
    [searchNavC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"searchIcn"] withFinishedUnselectedImage:[UIImage imageNamed:@"searchIcnOff"]];
    [searchNavC.tabBarItem setImageInsets:UIEdgeInsetsMake(inset, 0, -inset, 0)];
    searchNavC.tabBarItem.title = nil;
    
    [bookmarksNavC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"bookmarkIcn"] withFinishedUnselectedImage:[UIImage imageNamed:@"bookmarkIcnOff"]];
    [bookmarksNavC.tabBarItem setImageInsets:UIEdgeInsetsMake(inset, 0, -inset, 0)];
    bookmarksNavC.tabBarItem.title = nil;
    
    [settingsNavC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"settingsIcn"] withFinishedUnselectedImage:[UIImage imageNamed:@"settingsIcnOff"]];
    [settingsNavC.tabBarItem setImageInsets:UIEdgeInsetsMake(inset, 0, -inset, 0)];
    settingsNavC.tabBarItem.title = nil;
    
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
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSNumber numberWithDouble:[[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"]doubleValue]] forKey:@"latitude"];
    [params setObject:[NSNumber numberWithDouble:[[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]doubleValue]]forKey:@"longitude"];
    [MMAPI sharedAPI].delegate = self;
    [[MMAPI sharedAPI] checkUserIn:params];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

- (void) initializeLocationManager {
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy =kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 60.0f; // update every 200ft
    [_locationManager startMonitoringSignificantLocationChanges];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    NSString* tokenString = [[[[newDeviceToken description]
                               stringByReplacingOccurrencesOfString: @"<" withString: @""]
                              stringByReplacingOccurrencesOfString: @">" withString: @""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"%@",tokenString);
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", tokenString] forKey:@"apnsToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo {
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
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:[NSNumber numberWithDouble:newLocation.coordinate.latitude] forKey:@"latitude"];
        [params setObject:[NSNumber numberWithDouble:newLocation.coordinate.longitude] forKey:@"longitude"];
        
        NSLog(@"%@, %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"], [[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]);
        
        //TEST CODE. REMOVE ME
        /*[params setObject:[NSNumber numberWithDouble:33.49829] forKey:@"latitude"];
        [params setObject:[NSNumber numberWithDouble:-111.927526] forKey:@"longitude"];*/
        
        
        [MMAPI sharedAPI].delegate = self;
        [[MMAPI sharedAPI]checkUserIn:params];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - Facebook Methods
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
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

#pragma mark - MMAPI Delegate Methods
- (void)MMAPICallSuccessful:(id)response {
    NSLog(@"%@", response);
}
- (void)MMAPICallFailed:(AFHTTPRequestOperation*)operation {
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
    NSLog(@"%@", response);
}

@end
