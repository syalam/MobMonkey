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

- (void)inboxScreen:(UIViewController*)presentingViewController selectedCategory:(NSString*)selectedCategory {
    MMInboxViewController *inboxVC = [[MMInboxViewController alloc]initWithNibName:@"MMInboxViewController" bundle:nil];
    inboxVC.title = selectedCategory;
    inboxVC.categorySelected = YES;
    [presentingViewController.navigationController pushViewController:inboxVC animated:YES];
}

- (void)trendingScreen:(UIViewController*)presentingViewController selectedCategory:(NSString*)selectedCategory {
    MMTrendingViewController *trendingVC = [[MMTrendingViewController alloc]initWithNibName:@"MMTrendingViewController" bundle:nil];
    trendingVC.sectionSelected = YES;
    trendingVC.title = selectedCategory;
    [presentingViewController.navigationController pushViewController:trendingVC animated:YES];
}

- (void)locationScreen:(UIViewController*)presentingViewController {
    MMLocationViewController *locationVC = [[MMLocationViewController alloc]initWithNibName:@"MMLocationViewController" bundle:nil];
    //REPLACE WITH REAL LOCATION NAME;
    locationVC.title = @"Nando's";
    [presentingViewController.navigationController pushViewController:locationVC animated:YES];
}

@end
