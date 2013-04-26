//
//  MMSocialNetworkModel.m
//  MobMonkey
//
//  Created by Michael Kral on 4/23/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMSocialNetworkModel.h"
#import <Accounts/Accounts.h>
#import <FacebookSDK/FBSession.h>

@implementation MMSocialNetworkModel

+(MMSocialNetworkModel *)authentication{
    MMSocialNetworkModel *authentication = [[self alloc] init];
    return authentication;
}

+(void)authenticateFacebookWithSuccess:(void (^)(void))success
                               failure:(void (^)(NSError *))failure {
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
           
            switch (status) {
                case FBSessionStateOpen:
                case FBSessionStateCreated:
                case FBSessionStateCreatedOpening:
                case FBSessionStateCreatedTokenLoaded:
                case FBSessionStateOpenTokenExtended:
                {
                    //dispatch_sync(dispatch_get_main_queue(), ^{
                        success();
                    //});
                }
                    break;
                case FBSessionStateClosed: {
                    //dispatch_sync(dispatch_get_main_queue(), ^{
                        failure(error);
                    //});
                }
                    break;
                case FBSessionStateClosedLoginFailed: {
                    //dispatch_sync(dispatch_get_main_queue(), ^{
                        failure(error);
                    //});
                }
                    break;
                default:
                    //dispatch_sync(dispatch_get_main_queue(), ^{
                        failure(error);
                    //});
                    break;
            }
        }];
    //});
}

+(void)authenticateTwitterWithSuccess:(void (^)(void))success
                              failure:(void (^)(NSError *))failure{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        ACAccountStore * accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountTypeTwitter = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [accountStore requestAccessToAccountsWithType:accountTypeTwitter options:nil completion:^(BOOL granted, NSError *error) {
            if(granted) {
                
                NSArray *accounts = [accountStore accountsWithAccountType:accountTypeTwitter];
                
                if (!accounts) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        failure(nil);
                    });
                    
                }
                else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        success();
                    });
                }
            }
            else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    failure(nil);
                });
                NSLog(@"Error: %@", error);
            }
        }];
    });
    
    
}

+(void)uploadVideo:(NSData *)videoData title:(NSString*)title details:(NSString*)details toSocialNetwork:(SocialNetwork)socialNetwork success:(void (^)(void))success failure:(void (^)(NSError *))failure {
    
    if(socialNetwork == SocialNetworkFacebook){
        
        [self facebookPostVideo:videoData title:title details:details success:^{
            
            if(success){
                success();
            }
            
        } failure:^(NSError *error) {
            
            if(failure){
                failure(error);
            }
            
        }];
    }
    
}

+(void)uploadImage:(UIImage *)image
   toSocialNetwork:(SocialNetwork)socialNetwork
           success:(void (^)(void))success
           failure:(void (^)(NSError * error))failure {
    
    if(socialNetwork == SocialNetworkFacebook){
        [self facebookPostImage:image success:^{
            success();
        } failure:^(NSError *error) {
            failure(error);
            NSLog(@"error");
        }];
    }
}

//Facebook
+(void)facebookPostVideo:(NSData*)videoData title:(NSString *)title details:(NSString *)details success:(void(^)(void))success failure:(void(^)(NSError *error))failure {
    
    [self performPublishAction:^{
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:videoData forKey:@"video.mov"];
        [parameters setObject:@"video/quicktime" forKey:@"contentType"];
        [parameters setObject:title forKey:@"title"];
        [parameters setObject:details forKey:@"description"];
        
        FBRequest *uploadVideoRequest = [FBRequest requestWithGraphPath:@"me/videos" parameters:parameters HTTPMethod:@"POST"];
        
        [uploadVideoRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            NSLog(@"result: %@, error: %@", result, error);
            if(!error){
                if (success) {
                    success();
                }else{
                    failure(error);
                }
            }
        }];
        
    } video:NO];
    
}
+(void)facebookPostImage:(UIImage*)image success:(void(^)(void))success failure:(void(^)(NSError * error))failure {
    [self performPublishAction:^{
        
        [FBRequestConnection startForUploadPhoto:image
                               completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                   
                                   if(!error){
                                       [SVProgressHUD showSuccessWithStatus:@"Photo Posted to Facebook Successfully"];
                                       if(success){
                                           success();
                                       }
                                   }else{
                                       [SVProgressHUD showErrorWithStatus:@"Facebook Publish Failed"];
                                       if(failure){
                                           failure(error);
                                       }
                                   }
                                   
                               }];
    }];
}

+ (void) performPublishAction:(void (^)(void)) action {
    [self performPublishAction:action video:NO];
}

+ (void)authenticateFacebookIfNeeded:(void(^)(NSError *error))completion{
    if (FBSession.activeSession.state != FBSessionStateOpen) {
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceOnlyMe allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            completion(error);
        }];
    }else{
        completion(nil);
    }
}
+ (void) performPublishAction:(void (^)(void)) action video:(BOOL)video {
    // we defer request for permission to post to the moment of post, then we check for the permission
    //NSArray *permissions = [NSArray arrayWithObject:@"publish_actions",nil];
    
    
    [self authenticateFacebookIfNeeded:^(NSError *error) {
        if(!error){
            if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
                
                // if we don't already have the permission, then we request it now
                [[FBSession activeSession] reauthorizeWithPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
                    if (!error) {
                        action();
                    }
                    else{
                        NSLog(@"error: %@", error);
                    }
                }];
                
            }else{
                action();
            }
        }else{
            NSLog(@"error: %@", error);
        }
        
    }];
    

    
    
    /*[FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceOnlyMe allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        
        if([[FBSession activeSession] state] == FBSessionStateClosed){
            [self authenticateFacebookWithSuccess:^{
                
            } failure:^(NSError *error) {
                NSLog(@"Failed Authenticating");
            }];
        }else{
            if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
                
                // if we don't already have the permission, then we request it now
                [[FBSession activeSession] reauthorizeWithPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
                    if (!error) {
                        action();
                    }
                }];
                
            } else {
                action();
            }
        }
    }];*/
    
    
    
    
}


@end
