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
    [TestFlight takeOff:@"e6432d80aed42a955243c8d93a493dea_MTAwODk2MjAxMi0wNi0yMyAxODoxNzoxOC45NjMzMjY"];
    
    adView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
    
    //REMOVE ME: Hardcode the partner ID
    [[NSUserDefaults standardUserDefaults]setObject:@"aba0007c-ebee-42db-bd52-7c9f02e3d371" forKey:@"mmPartnerId"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [FBProfilePictureView class];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    if ([UINavigationBar respondsToSelector:@selector(appearance)]) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavBar~iphone"] forBarMetrics:UIBarMetricsDefault];
    } 
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *inboxVC = [[MMInboxViewController alloc] initWithNibName:@"MMInboxViewController" bundle:nil];
  
    UIViewController *searchVC = [[MMSearchViewController alloc] initWithNibName:@"MMSearchViewController" bundle:nil];
    UIViewController *trendingVC = [[MMTrendingViewController alloc] initWithNibName:@"MMTrendingViewController" bundle:nil];
    UIViewController *bookmarksVC = [[MMBookmarksViewController alloc] initWithNibName:@"MMLocationsViewController" bundle:nil];
    UIViewController *settingsVC = [[MMSettingsViewController alloc] initWithNibName:@"MMSettingsViewController" bundle:nil];
    
    UINavigationController *inboxNavC = [[UINavigationController alloc] initWithRootViewController:inboxVC];
    UINavigationController *searchNavC = [[UINavigationController alloc] initWithRootViewController:searchVC];

    UINavigationController *trendingNavC = [[UINavigationController alloc] initWithRootViewController:trendingVC];

    UINavigationController *bookmarksNavC = [[UINavigationController alloc] initWithRootViewController:bookmarksVC];

    UINavigationController *settingsNavC = [[UINavigationController alloc] initWithRootViewController:settingsVC];

    inboxVC.title = @"Inbox";
    searchVC.title = @"Search";
    trendingVC.title = @"What's Trending Now";
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
    
    
    //TODO: UNCOMMENT WHEN iAD working
    //[self.window.rootViewController.view addSubview:adView];
  
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
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f", 33.298231] forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f", -111.931412] forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    /*[MMAPI getAllCategories:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
    }];*/
    
    [self initializeLocationManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSNumber numberWithDouble:[[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"]doubleValue]] forKey:@"latitude"];
    [params setObject:[NSNumber numberWithDouble:[[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]doubleValue]]forKey:@"longitude"];
    [MMAPI checkUserIn:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", @"Checked In");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
    }];
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
        [MMAPI checkUserIn:params success:nil failure:nil];
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

#pragma mark - Adwhirl delegate methods
- (NSString *)adWhirlApplicationKey {
    return @"8f2f46a21dff4f20b2771f46d86b409c";
}

- (UIViewController *)viewControllerForPresentingModalView {
    return self.window.rootViewController;
}

- (void)adWhirlDidReceiveAd:(AdWhirlView *)adWhirlView {
    [UIView beginAnimations:@"AdWhirlDelegate.adWhirlDidReceiveAd:"
                    context:nil];
    
    [UIView setAnimationDuration:0.7];
    
    CGSize adSize = [adWhirlView actualAdSize];
    CGRect newFrame = adWhirlView.frame;
    
    newFrame.size = adSize;
    newFrame.origin.x = (self.window.rootViewController.view.bounds.size.width - adSize.width)/ 2;
    
    adWhirlView.frame = newFrame;
    
    [UIView commitAnimations];
}


@end
