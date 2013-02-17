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


@implementation MMSDK

+ (void)displayMMSignInScreenFromPresentingViewController:(UIViewController*)presentingViewController {
    MMLoginViewController *signInVc = [[MMLoginViewController alloc]initWithNibName:@"MMLoginViewController" bundle:nil];
    signInVc.title = @"Sign In";
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:signInVc];
    [presentingViewController.navigationController presentViewController:navC animated:YES completion:NULL];
}

+ (void)displayMMSignUpScreenFromPresentingViewController:(UIViewController*)presentingViewController{
    MMSignUpViewController *signUpVC = [[MMSignUpViewController alloc]initWithNibName:@"MMSignUpViewController" bundle:nil];
    signUpVC.title = @"Sign Up";
    [presentingViewController.navigationController pushViewController:signUpVC animated:YES];
}

+ (void)displayMMInboxScreenFromPresentingViewController:(UIViewController*)presentingViewController {
    MMInboxViewController *inboxVC = [[MMInboxViewController alloc]initWithNibName:@"MMInboxViewController" bundle:nil];
    inboxVC.title = @"Inbox";
    [presentingViewController.navigationController pushViewController:inboxVC animated:YES];
}

+ (void)displayMMOpenRequestsScreenFromPresentingViewController:(UIViewController*)presentingViewController {
    MMInboxDetailViewController *inboxDetailVC = [[MMInboxDetailViewController alloc]initWithNibName:@"MMInboxDetailViewController" bundle:nil];
    inboxDetailVC.title = @"Open Requests";
    [presentingViewController.navigationController pushViewController:inboxDetailVC animated:YES];
}

+ (void)displayMMAnsweredRequestsScreenFromPresentingViewController:(UIViewController*)presentingViewController {
    MMAnsweredRequestsViewController *answeredRequestsVC = [[MMAnsweredRequestsViewController alloc]initWithNibName:@"MMAnsweredRequestsViewController" bundle:nil];
    answeredRequestsVC.title = @"AnsweredRequests";
    [presentingViewController.navigationController pushViewController:answeredRequestsVC animated:YES];
}

+ (void)displayMMAssignedRequestsScreenFromPresentingViewController:(UIViewController*)presentingViewController {
    MMInboxDetailViewController *inboxDetailVC = [[MMInboxDetailViewController alloc]initWithNibName:@"MMInboxDetailViewController" bundle:nil];
    inboxDetailVC.title = @"Assigned Requests";
    [presentingViewController.navigationController pushViewController:inboxDetailVC animated:YES];
}

+ (void)displayMMLocationDetailScreenFromPresentingViewController:(UIViewController*)presentingViewController withLocationParams:(NSDictionary*)params {
    MMLocationViewController *locationVC = [[MMLocationViewController alloc]initWithNibName:@"MMLocationViewController" bundle:nil];
    [locationVC loadLocationDataWithLocationId:[params valueForKey:@"locationId"] providerId:[params valueForKey:@"providerId"]];
    [presentingViewController.navigationController pushViewController:locationVC animated:YES];
}

+ (void)displayMMMakeARequestScreenFromPresentingViewController:(UIViewController*)presentingViewController withLocationParams:(NSDictionary*)params {
    MMRequestViewController *requestVC = [[MMRequestViewController alloc]initWithNibName:@"MMRequestViewController" bundle:nil];
    [requestVC setContentList:params];
    UINavigationController *requestNavC = [[UINavigationController alloc]initWithRootViewController:requestVC];
    [presentingViewController.navigationController presentViewController:requestNavC animated:YES completion:NULL];
}


@end
