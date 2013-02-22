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

@implementation MMSDK

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


@end
