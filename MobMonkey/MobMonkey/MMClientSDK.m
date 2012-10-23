//
//  MMClientSDK.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/1/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMClientSDK.h"
#import "MMLoginViewController.h"
#import "MMSignUpViewController.h"
#import "MMTrendingViewController.h"
#import "MMInboxViewController.h"
#import "MMLocationViewController.h"
#import "MMMakeRequestViewController.h"
#import "MMLocationMediaViewController.h"
#import "MMInboxFullScreenImageViewController.h"
#import "MMAnsweredRequestsViewController.h"
#import "MMFullScreenImageViewController.h"

#import "MMRequestViewController.h"

@implementation MMClientSDK

#pragma mark - Singleton Method
+ (MMClientSDK *)sharedSDK {
    static MMClientSDK *_sharedSDK = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSDK = [[MMClientSDK alloc] init];
    });
    
    return _sharedSDK;
}


- (void)signInScreen:(UIViewController*)presentingViewController {
    MMLoginViewController *signInVc = [[MMLoginViewController alloc]initWithNibName:@"MMLoginViewController" bundle:nil];
    signInVc.title = @"Sign In";
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:signInVc];
    [presentingViewController.navigationController presentViewController:navC animated:YES completion:NULL];
}

- (void)signUpScreen:(UIViewController*)presentingViewController {
    MMSignUpViewController *myInfoVc = [[MMSignUpViewController alloc]initWithNibName:@"MMSignUpViewController" bundle:nil];
    myInfoVc.title = @"Sign Up";
    [presentingViewController.navigationController pushViewController:myInfoVc animated:YES];
}

- (void)inboxScreen:(UIViewController*)presentingViewController selectedCategory:(NSString*)selectedCategory currentAPICall:(int)currentAPICall {
    MMInboxViewController *inboxVC = [[MMInboxViewController alloc]initWithNibName:@"MMInboxViewController" bundle:nil];
    inboxVC.title = selectedCategory;
    inboxVC.categorySelected = YES;
    inboxVC.currentAPICall = currentAPICall;
    [presentingViewController.navigationController pushViewController:inboxVC animated:YES];
}

- (void)answeredRequestsScreen:(UIViewController*)presentingViewController answeredItemsToDisplay:(NSArray*)answeredItemsToDisplay {
    MMAnsweredRequestsViewController *answeredVc = [[MMAnsweredRequestsViewController alloc]initWithNibName:@"MMAnsweredRequestsViewController" bundle:nil];
    answeredVc.contentList = answeredItemsToDisplay;
    answeredVc.title = @"Answered Requests";
    [presentingViewController.navigationController pushViewController:answeredVc animated:YES];
}

- (void)inboxFullScreenImageScreen:(UIViewController*)presentingViewController imageToDisplay:(UIImage*)imageToDisplay locationName:(NSString*)locationName {
    MMFullScreenImageViewController *fsvc = [[MMFullScreenImageViewController alloc]initWithNibName:@"MMFullScreenImageViewController" bundle:nil];
    fsvc.title = locationName;
    fsvc.imageToDisplay = imageToDisplay;
    
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:fsvc];
    navC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [presentingViewController.navigationController presentViewController:navC animated:YES completion:NULL];
}

- (void)trendingScreen:(UIViewController*)presentingViewController selectedCategory:(NSString*)selectedCategory {
    MMTrendingViewController *trendingVC = [[MMTrendingViewController alloc]initWithNibName:@"MMTrendingViewController" bundle:nil];
    trendingVC.sectionSelected = YES;
    trendingVC.title = selectedCategory;
    [presentingViewController.navigationController pushViewController:trendingVC animated:YES];
}

- (void)locationScreen:(UIViewController*)presentingViewController locationDetail:(NSMutableDictionary*)locationDetail {
    MMLocationViewController *locationVC = [[MMLocationViewController alloc]initWithNibName:@"MMLocationViewController" bundle:nil];
    locationVC.contentList = locationDetail;
    [presentingViewController.navigationController pushViewController:locationVC animated:YES];
}

//- (void)makeARequestScreen:(UIViewController*)presentingViewController locationDetail:(NSDictionary*)locationDetail {
//    MMMakeRequestViewController *requestVC = [[MMMakeRequestViewController alloc]initWithNibName:@"MMMakeRequestViewController" bundle:nil];
//    requestVC.title = @"Make a Request";
//    requestVC.contentList = locationDetail;
//    UINavigationController *requestNavC = [[UINavigationController alloc]initWithRootViewController:requestVC];
//    [presentingViewController.navigationController presentViewController:requestNavC animated:YES completion:NULL];
//}

- (void)makeARequestScreen:(UIViewController*)presentingViewController locationDetail:(NSDictionary*)locationDetail {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Request" bundle:nil];
    UINavigationController *navVC = [storyboard instantiateInitialViewController];
    MMRequestViewController *requestVC = navVC.viewControllers[0];
    requestVC.title = @"Make Request";
    requestVC.contentList = locationDetail;
    //UINavigationController *requestNavC = [[UINavigationController alloc]initWithRootViewController:requestVC];
    [presentingViewController presentViewController:navVC animated:YES completion:NULL];
}

- (void)locationMediaScreen:(UIViewController*)presentingViewController locationMediaContent:(NSArray*)locationMediaContent locationName:(NSString*)locationName {
    MMLocationMediaViewController *lmvc = [[MMLocationMediaViewController alloc]initWithNibName:@"MMLocationMediaViewController" bundle:nil];
    lmvc.contentList = locationMediaContent;
    lmvc.title = locationName;
    UINavigationController *locationMediaNavC = [[UINavigationController alloc]initWithRootViewController:lmvc];
    [presentingViewController.navigationController presentViewController:locationMediaNavC animated:YES completion:NULL];
}

@end
