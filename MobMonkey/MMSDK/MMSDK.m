//
//  MMSDK.m
//  MMSDK
//
//  Created by Reyaad Sidique on 2/13/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMSDK.h"
#import "MMLoginViewController.h"


@implementation MMSDK

+ (void)signInScreen:(UIViewController*)presentingViewController {
    MMLoginViewController *signInVc = [[MMLoginViewController alloc]initWithNibName:@"MMLoginViewController" bundle:nil];
    signInVc.title = @"Sign In";
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:signInVc];
    [presentingViewController.navigationController presentViewController:navC animated:YES completion:NULL];
}

@end
