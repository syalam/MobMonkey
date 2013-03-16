//
//  MMSDK.m
//  MMSDK
//
//  Created by Reyaad Sidique on 2/13/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMSDK.h"
#import "MMLoginViewController.h"
#import "MMSignUpViewController.h"
#import "MMInboxViewController.h"
#import "MMInboxDetailViewController.h"
#import "MMAnsweredRequestsViewController.h"
#import "MMLocationViewController.h"
#import "MMRequestViewController.h"
#import "MMSearchViewController.h"



@interface MMSDK ()

- (void)MMActivateLocationServices;

@end

@implementation MMSDK

#pragma mark - Class Methods

+ (MMSDK*)sharedSDK {
    static dispatch_once_t once;
    static MMSDK *sharedSDK;
    dispatch_once(&once, ^ { sharedSDK = [[MMSDK alloc] init]; });
    return sharedSDK;
}

+ (void)MMActivateLocationServices {
    [[MMSDK sharedSDK]MMActivateLocationServices];
}

+ (void)displayMMSignInScreenFromPresentingViewController:(UIViewController*)presentingViewController withThemeOptions:(NSDictionary*)themeOptionsDictionary {
    MMLoginViewController *signInVc = [[MMLoginViewController alloc]initWithNibName:@"MMLoginViewController" bundle:nil];
    signInVc.title = @"Sign In";
    signInVc.themeOptionsDictionary = themeOptionsDictionary;
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:signInVc];
    [presentingViewController.navigationController presentViewController:navC animated:YES completion:NULL];
}

+ (void)displayMMSignUpScreenFromPresentingViewController:(UIViewController*)presentingViewController withThemeOptions:(NSDictionary*)themeOptionsDictionary {
    MMSignUpViewController *signUpVC = [[MMSignUpViewController alloc]initWithNibName:@"MMSignUpViewController" bundle:nil];
    signUpVC.themeOptionsDictionary = themeOptionsDictionary;
    signUpVC.title = @"Sign Up";
    [presentingViewController.navigationController pushViewController:signUpVC animated:YES];
}

+ (void)displayMMInboxScreenFromPresentingViewController:(UIViewController*)presentingViewController withThemeOptions:(NSDictionary*)themeOptionsDictionary {
    MMInboxViewController *inboxVC = [[MMInboxViewController alloc]initWithNibName:@"MMInboxViewController" bundle:nil];
    inboxVC.title = @"Inbox";
    inboxVC.themeOptionsDictionary = themeOptionsDictionary;
    [presentingViewController.navigationController pushViewController:inboxVC animated:YES];
}

+ (void)displayMMOpenRequestsScreenFromPresentingViewController:(UIViewController*)presentingViewController withThemeOptions:(NSDictionary*)themeOptionsDictionary {
    MMInboxDetailViewController *inboxDetailVC = [[MMInboxDetailViewController alloc]initWithNibName:@"MMInboxDetailViewController" bundle:nil];
    inboxDetailVC.title = @"Open Requests";
    inboxDetailVC.themeOptionsDictionary = themeOptionsDictionary;
    [presentingViewController.navigationController pushViewController:inboxDetailVC animated:YES];
}

+ (void)displayMMAnsweredRequestsScreenFromPresentingViewController:(UIViewController*)presentingViewController withThemeOptions:(NSDictionary*)themeOptionsDictionary {
    MMAnsweredRequestsViewController *answeredRequestsVC = [[MMAnsweredRequestsViewController alloc]initWithNibName:@"MMAnsweredRequestsViewController" bundle:nil];
    answeredRequestsVC.title = @"AnsweredRequests";
    answeredRequestsVC.themeOptionsDictionary = themeOptionsDictionary;
    [presentingViewController.navigationController pushViewController:answeredRequestsVC animated:YES];
}

+ (void)displayMMAssignedRequestsScreenFromPresentingViewController:(UIViewController*)presentingViewController withThemeOptions:(NSDictionary*)themeOptionsDictionary {
    MMInboxDetailViewController *inboxDetailVC = [[MMInboxDetailViewController alloc]initWithNibName:@"MMInboxDetailViewController" bundle:nil];
    inboxDetailVC.title = @"Assigned Requests";
    inboxDetailVC.themeOptionsDictionary = themeOptionsDictionary;
    [presentingViewController.navigationController pushViewController:inboxDetailVC animated:YES];
}

+ (void)displayMMLocationDetailScreenFromPresentingViewController:(UIViewController*)presentingViewController withLocationParams:(NSDictionary*)params withThemeOptions:(NSDictionary*)themeOptionsDictionary {
    MMLocationViewController *locationVC = [[MMLocationViewController alloc]initWithNibName:@"MMLocationViewController" bundle:nil];
    locationVC.themeOptionsDictionary = themeOptionsDictionary;
    [locationVC loadLocationDataWithLocationId:[params valueForKey:@"locationId"] providerId:[params valueForKey:@"providerId"]];
    [presentingViewController.navigationController pushViewController:locationVC animated:YES];
}

+ (void)displayMMMakeARequestScreenFromPresentingViewController:(UIViewController*)presentingViewController withLocationParams:(NSDictionary*)params withThemeOptions:(NSDictionary*)themeOptionsDictionary {
    MMRequestViewController *requestVC = [[MMRequestViewController alloc]initWithNibName:@"MMRequestViewController" bundle:nil];
    requestVC.themeOptionsDictionary = themeOptionsDictionary;
    [requestVC setContentList:params];
    UINavigationController *requestNavC = [[UINavigationController alloc]initWithRootViewController:requestVC];
    [presentingViewController.navigationController presentViewController:requestNavC animated:YES completion:NULL];
}

+ (void)displayMMSearchScreenFromPresentingViewController:(UIViewController*)presentingViewController withThemeOptions:(NSDictionary*)themeOptionsDictionary {
    MMSearchViewController *searchVC = [[MMSearchViewController alloc]initWithNibName:@"MMSearchViewController" bundle:nil];
    searchVC.title = @"Search";
    searchVC.themOptionsDictionary = themeOptionsDictionary;
    searchVC.pushedView = YES;
    [presentingViewController.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - Instance methods
- (void)MMActivateLocationServices {
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy =kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 60.0f; // update every 200ft
    [_locationManager startUpdatingLocation];
}

#pragma mark - CLLocationServices Delegate Methods
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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

@end
