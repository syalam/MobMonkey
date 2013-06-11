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
#import "MMSDK.h"
#import "UIAlertView+Blocks.h"
#import "Flurry.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "TestFlight.h"
#import "MMHotSpotViewController.h"
#import "MMInboxViewController.h"
#import "MMNavigationViewController.h"
#import "MMContentViewController.h"
#import "MMTableViewController.h"
#import "MMHappeningViewController.h"
//#import "MMSlideNavigationController.h"

@implementation MMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];

#if TARGET_IPHONE_SIMULATOR
    [[NSUserDefaults standardUserDefaults] setValue:@"1234" forKey:@"apnsToken"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
#endif
    popUpVisible = NO;
    //initialize testflight SDK
    // !!!: Use the next line only during beta
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    [TestFlight takeOff:@"c02622dc-9b14-438f-add8-c3247da6261f"];
    
    //Add Activity Indicator when AFNetwork is making requests
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [Flurry startSession:@"ZXW98Q8CBP2BNTRCCXHP"];
    
    
    NSString *subscribedUserKey = [NSString stringWithFormat:@"%@ subscribed", [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];
    
    
        
    //REMOVE ME: Hardcode the partner ID
    [[NSUserDefaults standardUserDefaults]setObject:@"aba0007c-ebee-42db-bd52-7c9f02e3d371" forKey:@"mmPartnerId"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [FBProfilePictureView class];
    
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert |
      UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];
    
    if ([UINavigationBar respondsToSelector:@selector(appearance)]) {
    
        [[UINavigationBar appearance] setTintColor:[UIColor clearColor]];
        [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
    
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *inboxVC = [[MMInboxViewController alloc] initWithNibName:@"MMInboxViewController" bundle:nil];
    MMTableViewController *hotSpotVC = [[MMHotSpotViewController alloc] initWithStyle:UITableViewStyleGrouped];
   // UIViewController *searchVC = [[MMSearchViewController alloc] initWithNibName:@"MMSearchViewController" bundle:nil];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setItemSize:CGSizeMake(128 , 128)];
    [flowLayout setMinimumInteritemSpacing:0.f];
    [flowLayout setMinimumLineSpacing:0.f];
    
    //UIViewController *trendingVC = [[MMTrendingViewController alloc] initWithCollectionViewLayout:flowLayout];
    UIViewController *bookmarksVC = [[MMBookmarksViewController alloc] initWithNibName:@"MMLocationsViewController" bundle:nil];
    MMContentViewController *settingsVC = [[MMSettingsViewController alloc] initWithNibName:@"MMSettingsViewController" bundle:nil];
    
    UINavigationController *inboxNavC = [[UINavigationController alloc] initWithRootViewController:inboxVC];
    MMNavigationViewController *searchNavC = [[MMNavigationViewController alloc] initWithRootViewController:hotSpotVC];

   // MMNavigationViewController *trendingNavC = [[MMNavigationViewController alloc] initWithRootViewController:trendingVC];

    UINavigationController *bookmarksNavC = [[UINavigationController alloc] initWithRootViewController:bookmarksVC];

    UINavigationController *settingsNavC = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    
    
    MMHappeningViewController * happeningViewController = [[MMHappeningViewController alloc] initWithStyle:UITableViewStylePlain];
    happeningViewController.title = @"What's Happening Now";
    MMNavigationViewController * happeningNVC = [[MMNavigationViewController alloc] initWithRootViewController:happeningViewController];
    
    

    inboxVC.title = @"Inbox";
    hotSpotVC.title = @"Search Locations";
    //trendingVC.title = @"What's Trending Now!";
    bookmarksVC.title = @"Favorites";
    settingsVC.title = @"Settings";
    
    
    _slideNavigationController = [[MMSlideNavigationController alloc] init];
    //MMNavigationViewController *navigationViewController = [[MMNavigationViewController alloc] initWithRootViewController:trendingVC];
    
    self.slideNavigationController.topViewController = happeningNVC;
    [self.window setRootViewController:_slideNavigationController];
//    bookmarksVC.sectionSelected = YES;
//    bookmarksVC.bookmarkTab = YES;
    
    
    //Changing to slide menu
    /*self.tabBarController = [[UITabBarController alloc] init];
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
    
    [bookmarksNavC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"favoritesIconOn"] withFinishedUnselectedImage:[UIImage imageNamed:@"favoritesIcon"]];
    [bookmarksNavC.tabBarItem setImageInsets:UIEdgeInsetsMake(inset-1, 0, -inset+1, 0)];
    bookmarksNavC.tabBarItem.title = nil;
    
    [settingsNavC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"settingsIcn"] withFinishedUnselectedImage:[UIImage imageNamed:@"settingsIcnOff"]];
    [settingsNavC.tabBarItem setImageInsets:UIEdgeInsetsMake(inset, 0, -inset, 0)];
    settingsNavC.tabBarItem.title = nil;
    
    self.window.rootViewController = self.tabBarController;
    */
    if (![[NSUserDefaults standardUserDefaults]boolForKey:subscribedUserKey]) {
        _adView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
        
        [_adView setHidden:YES];
        [self.window.rootViewController.view addSubview:_adView];
    }
  
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
    //42.029486, -87.680550
    /*[[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f", 33.421098] forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f", -111.942648] forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults]synchronize];*/
    
    [MMAPI getAllCategories:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        /*NSMutableArray *arrayToCleanUp = [responseObject mutableCopy];
        NSMutableArray *cleanArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dictionaryToCleanUp in arrayToCleanUp) {
            NSMutableDictionary *cleanDictionary = [[NSMutableDictionary alloc]init];
            id const nul = [NSNull null];
            for (NSString *key in dictionaryToCleanUp) {
                id const obj = [dictionaryToCleanUp valueForKey:key];
                if (nul == obj) {
                    [cleanDictionary setValue:@"" forKey:key];
                }
                else {
                    [cleanDictionary setValue:[dictionaryToCleanUp valueForKey:key] forKey:key];
                }
            }
            [cleanArray addObject:cleanDictionary];
        }*/

        
        [[NSUserDefaults standardUserDefaults]setObject:responseObject forKey:@"allCategories"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
    }];
    
    [self initializeLocationManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSNumber numberWithDouble:[[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"]doubleValue]] forKey:@"latitude"];
    [params setObject:[NSNumber numberWithDouble:[[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]doubleValue]]forKey:@"longitude"];
    [MMAPI checkUserIn:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", @"Checked In");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
    }];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"checkForUpdatedCounts" object:nil];
    
    [application setApplicationIconBadgeNumber:0];
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
    _locationManager.distanceFilter = 15.0f; // update every 200ft
    [_locationManager startUpdatingLocation];
}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"FAILED TO REGISTER DEVICE");
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"ERROR: %@", error]];
    TFLog(@"FAILED TO REEGISTER DEVICE: %@", error);
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    NSString* tokenString = [[[[newDeviceToken description]
                               stringByReplacingOccurrencesOfString: @"<" withString: @""]
                              stringByReplacingOccurrencesOfString: @">" withString: @""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];

    NSLog(@"Token String: %@",tokenString);
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", tokenString] forKey:@"apnsToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    NSLog(@"%@", userInfo);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"checkForUpdatedCounts" object:userInfo];
    
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSString *alert = [aps objectForKey:@"alert"];

   // NSLog(@"Request Type: %@", requestType);
    //#ifdef PRODUCTION
    
    //Make sure the root view controller is a tab bar controller.
    if([self.window.rootViewController isKindOfClass:[UITabBarController class]]){
        
        UITabBarController *tabBarController = (UITabBarController*)self.window.rootViewController;
        UINavigationController *inboxViewController = (UINavigationController*)tabBarController.selectedViewController;
        
        //UIViewController *visibleViewController = [inboxViewController.childViewControllers lastObject];
        
        //Check if the app is already open or not.
        if ( application.applicationState == UIApplicationStateActive ) {
            // app was already in the foreground
            
            //Ask the user if they want to go to the request screen from the push notifications
            
            RIButtonItem *cancelButton = [RIButtonItem itemWithLabel:@"Cancel"];
            RIButtonItem *goToRequestButton = [RIButtonItem itemWithLabel:@"Go to Inbox"];
            
            // Display screen, when "Go to Request" button is selected
            [goToRequestButton setAction:^{
                
                [tabBarController setSelectedIndex:1];
                [inboxViewController popToRootViewControllerAnimated:YES];
                popUpVisible = NO;
            }];
            
            [cancelButton setAction:^{
                popUpVisible = NO;
            }];
            
            UIAlertView *confirmGoToRequest = [[UIAlertView alloc] initWithTitle:@"New Request" message:@"You have a new request in your inbox. Would you like to go there now?" cancelButtonItem:cancelButton otherButtonItems:goToRequestButton, nil];
            
            
            if ([alert rangeOfString:@"You've been assigned a request"].location != NSNotFound) {
                //Present the alert view only if the user is signed in
                if(([[NSUserDefaults standardUserDefaults] stringForKey:@"userName"] &&
                    ![inboxViewController.title isEqualToString:@"Inbox"]) &&
                   !popUpVisible){
                    [confirmGoToRequest show];
                    popUpVisible = YES;
                }else{
                    NSLog(@"NOT LOGGED IN OR ON INBOX");
                    if(![inboxViewController.visibleViewController.title isEqualToString:@"Inbox"]){
                        [confirmGoToRequest show];
                        NSLog(@"TITLE: %@", inboxViewController.visibleViewController.title);
                    }else{
                        
                        if([inboxViewController.visibleViewController isKindOfClass:[MMInboxViewController class]]){
                            [SVProgressHUD showWithStatus:@"Refreshing"];
                            [((MMInboxViewController *)inboxViewController.visibleViewController) getInboxCountsWithComplete:^{
                                [SVProgressHUD showSuccessWithStatus:@"New Requests"];
                            }];
                            
                        }else{
                            NSLog(@"CLASS: %@", inboxViewController.visibleViewController.class);
                        }
                    }
                }
            }
            
            
            
        } else {
            // app was just brought from background to foreground
            
            //open the app with the inbox screen selected.
            [tabBarController setSelectedIndex:1];
            
        }
    }
    
            
    
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
        [MMAPI checkUserIn:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", @"Checked in");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", @"Unable to check in");
        }];
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power
    CLLocation* newLocation = [locations lastObject];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude] forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f", newLocation.coordinate.longitude] forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSNumber numberWithDouble:newLocation.coordinate.latitude] forKey:@"latitude"];
    [params setObject:[NSNumber numberWithDouble:newLocation.coordinate.longitude] forKey:@"longitude"];
    
    NSLog(@"%@, %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"], [[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]);
    
    [MMAPI checkUserIn:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", @"Checked in");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", @"Unable to check in");
    }];
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
    
   
    
    NSString *subscribedUserKey = [NSString stringWithFormat:@"%@ subscribed", [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];
    
    //TODO: UNCOMMENT WHEN iAD working
    if (![[NSUserDefaults standardUserDefaults]boolForKey:subscribedUserKey]) {
        [_adView setHidden:NO];
    }
    CGSize adSize = [adWhirlView actualAdSize];
    CGRect newFrame = adWhirlView.frame;
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    
    newFrame.size = adSize;
    newFrame.origin.x = (self.window.rootViewController.view.bounds.size.width - adSize.width)/ 2;
    newFrame.origin.y = (screenSize.size.height - adSize.height - 20);
    
    adWhirlView.frame = newFrame;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"AdWhirlChange" object:nil];
    
}
-(void)adWhirlDidFailToReceiveAd:(AdWhirlView *)adWhirlView usingBackup:(BOOL)yesOrNo {
    
        
    [adWhirlView setHidden:YES];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"AdWhirlChange" object:nil];

}

@end
