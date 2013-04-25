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
    // we defer request for permission to post to the moment of post, then we check for the permission
    //NSArray *permissions = [NSArray arrayWithObject:@"publish_actions",nil];
    [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceOnlyMe allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        
        
        NSLog(@"STATE: %d", status);
        
        if(status == FBSessionStateOpen || status== FBSessionStateOpenTokenExtended || status==FBSessionStateCreatedOpening || status==FBSessionStateCreated){
            NSLog(@"ok");
        }
        
        if([[FBSession activeSession] state] != FBSessionStateOpen){
            [self authenticateFacebookWithSuccess:^{
                if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
                    
                    // if we don't already have the permission, then we request it now
                    [[FBSession activeSession] reauthorizeWithPublishPermissions:@[@"publish_actions", @"publish_streams"] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
                        if (!error) {
                            action();
                        }
                        else{
                            NSLog(@"error: %@", error);
                        }
                    }];
                    
                } else {
                    action();
                }
            } failure:^(NSError *error) {
                NSLog(@"Failed Authenticating");
            }];
        }else{
            if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
                
                // if we don't already have the permission, then we request it now
                [[FBSession activeSession] reauthorizeWithPublishPermissions:@[@"publish_actions", @"publish_streams"] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
                    if (!error) {
                        action();
                    }
                }];
                
            } else {
                action();
            }
        }
    }];
    
    
    
    
}


@end
