//
//  MMSocialNetworkModel.h
//  MobMonkey
//
//  Created by Michael Kral on 4/23/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>

@interface MMSocialNetworkModel : NSObject <FBLoginViewDelegate>


+(void)authenticateFacebookWithSuccess:(void(^)(void))success failure:(void(^)(NSError *error))failure;
+(void)authenticateTwitterWithSuccess:(void(^)(void))success failure:(void(^)(NSError *error))failure;

+(MMSocialNetworkModel*)authentication;
@end
