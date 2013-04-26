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
#import "MMAPI.h"

typedef enum {
    SocialNetworkTwitter,
    SocialNetworkFacebook
} SocialNetwork;
@interface MMSocialNetworkModel : NSObject <FBLoginViewDelegate>


//Authentication
+(void)authenticateFacebookWithSuccess:(void(^)(void))success failure:(void(^)(NSError *error))failure;
+(void)authenticateTwitterWithSuccess:(void(^)(void))success failure:(void(^)(NSError *error))failure;

//Upload Media Facebook
+(void)uploadImage:(UIImage*)image toSocialNetwork:(SocialNetwork)socialNetwork success:(void(^)(void))success failure:(void(^)(NSError* error))failure;
+(void)uploadVideo:(NSData *)videoData title:(NSString*)title details:(NSString*)details toSocialNetwork:(SocialNetwork)socialNetwork success:(void (^)(void))success failure:(void (^)(NSError *))failure;

//Up

+(MMSocialNetworkModel*)authentication;
@end
