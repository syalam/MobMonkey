//
//  MMAPI.m
//  MobMonkey
//
//  Created by Sheehan Alam on 8/29/12.
//
//

#import "MMAPI.h"
#import "MMHTTPClient.h"
#import "SVProgressHUD.h"

@implementation MMAPI
+ (MMAPI *)sharedAPI {
    static MMAPI *_sharedAPI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAPI = [[MMAPI alloc] init];
    });
    
    return _sharedAPI;
}

-(void)signUpNewUser:(NSDictionary*)params {
    NSLog(@"%@", params);
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:@"aba0007c-ebee-42db-bd52-7c9f02e3d371"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient] postPath:@"signup/user" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON){
        NSLog(@"%@", JSON);
        [_delegate signUpSuccessful:JSON];
        
        //TODO: return the server response
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate signUpFailed:operation];
        /*id errorResponse = [(AFJSONRequestOperation *)operation responseJSON];
        NSString *responseString = operation.responseString;
        NSLog(@"/Users Error: %@", [error localizedDescription]);
        NSLog(@"%@, %@",errorResponse, responseString);
        [_delegate signUpFailed:operation];*/
    }];
}

-(void)signInUser:(NSDictionary*)params {
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:@"aba0007c-ebee-42db-bd52-7c9f02e3d371"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    //[[MMHTTPClient sharedClient]setAuthorizationHeaderWithUsername:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"] password:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [[MMHTTPClient sharedClient] postPath:@"signin/user" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate signInSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate signInFailed:operation];
    }];
}
    

@end
