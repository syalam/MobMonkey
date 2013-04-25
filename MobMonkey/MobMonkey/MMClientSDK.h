//
//  MMClientSDK.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/1/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>

#import "MMLocationInformation.h"

@interface MMClientSDK : NSObject <UIActionSheetDelegate> {
    UIViewController *presentingVC;
    NSDictionary *storyToPublishToSocialNetworkDictionary;
}

+ (MMClientSDK *)sharedSDK;

- (void)signInScreen:(UIViewController*)presentingViewController;
- (void)signUpScreen:(UIViewController*)presentingViewController;

- (void)inboxScreen:(UIViewController*)presentingViewController selectedCategory:(NSString*)selectedCategory currentAPICall:(int)currentAPICall;
- (void)answeredRequestsScreen:(UIViewController*)presentingViewController answeredItemsToDisplay:(NSArray*)answeredItemsToDisplay;
- (void)inboxFullScreenImageScreen:(UIViewController*)presentingViewController imageToDisplay:(UIImage*)imageToDisplay locationName:(NSString*)locationName;
- (void)trendingScreen:(UIViewController*)presentingViewController selectedCategory:(NSString*)selectedCategory;


//- (void)locationScreen:(UIViewController*)presentingViewController locationDetail:(NSMutableDictionary*)locationDetail;
//New Method
-(void)locationScreen:(UIViewController *)presentingViewController locationInformation:(MMLocationInformation *)locationInformation;


- (void)makeARequestScreen:(UIViewController*)presentingViewController locationDetail:(MMLocationInformation*)locationInformation;
- (void)locationMediaScreen:(UIViewController*)presentingViewController locationMediaContent:(NSArray*)locationMediaContent locationName:(NSString*)locationName;
- (void)shareViaTwitter:(NSDictionary*)params presentingViewController:(UIViewController*)presentingViewController;
- (void)shareViaFacebook:(NSDictionary*)params presentingViewController:(UIViewController*)presentingViewController;
- (void)signInViaFacebook:(NSDictionary*)params presentingViewController:(UIViewController*)presentingViewController;
- (void)signInViaTwitter:(ACAccount*)account presentingViewController:(UIViewController*)presentingViewController;
- (void)showMoreActionSheet:(UIViewController*)presentingViewController showFromTabBar:(BOOL)showFromTabBar paramsForPublishingToSocialNetwork:(NSDictionary*)paramsForPublishingToSocialNetwork;


@end
