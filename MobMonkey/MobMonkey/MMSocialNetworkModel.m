//
//  MMSocialNetworkModel.m
//  MobMonkey
//
//  Created by Michael Kral on 4/23/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMSocialNetworkModel.h"
#import <Accounts/Accounts.h>

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
@end
