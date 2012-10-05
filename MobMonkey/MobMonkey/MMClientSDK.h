//
//  MMClientSDK.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/1/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMClientSDK : NSObject

+ (MMClientSDK *)sharedSDK;

- (void)signInScreen:(UIViewController*)presentingViewController;
- (void)signUpScreen:(UIViewController*)presentingViewController;

- (void)inboxScreen:(UIViewController*)presentingViewController selectedCategory:(NSString*)selectedCategory inboxItems:(NSArray*)inboxItems;
- (void)inboxFullScreenImageScreen:(UIViewController*)presentingViewController imageUrl:(NSString*)imageUrl locationName:(NSString*)locationName;
- (void)trendingScreen:(UIViewController*)presentingViewController selectedCategory:(NSString*)selectedCategory;
- (void)locationScreen:(UIViewController*)presentingViewController locationDetail:(NSDictionary*)locationDetail;
- (void)makeARequestScreen:(UIViewController*)presentingViewController locationDetail:(NSDictionary*)locationDetail;
- (void)locationMediaScreen:(UIViewController*)presentingViewController locationMediaContent:(NSArray*)locationMediaContent locationName:(NSString*)locationName;

@end
