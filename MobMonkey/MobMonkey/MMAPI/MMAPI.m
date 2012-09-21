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

#pragma mark - Singleton Method
+ (MMAPI *)sharedAPI {
    static MMAPI *_sharedAPI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAPI = [[MMAPI alloc] init];
    });
    
    return _sharedAPI;
}

#pragma mark - Sign Up/Sign In Methods
-(void)signUpNewUser:(NSDictionary*)params {
    NSLog(@"%@", params);
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:@"aba0007c-ebee-42db-bd52-7c9f02e3d371"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient] postPath:@"signup/user" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON){
        NSLog(@"%@", JSON);
        [_delegate mmAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        int statusCode = operation.response.statusCode;
        NSLog(@"%d", statusCode);
        if (statusCode == 200 || statusCode == 201) {
            [_delegate mmAPICallSuccessful:[NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil]];
        }
        else {
            [_delegate mmAPICallFailed:operation];
        }
    }];
}

-(void)signInUser:(NSDictionary*)params {
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:@"aba0007c-ebee-42db-bd52-7c9f02e3d371"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient] postPath:@"signin/user" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate mmAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate mmAPICallFailed:operation];
    }];
}

-(void)facebookSignIn {
    [FBSession openActiveSessionWithPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        if (session.isOpen) {
            FBRequest *me = [FBRequest requestForMe];
            [me startWithCompletionHandler: ^(FBRequestConnection *connection,
                                              NSDictionary<FBGraphUser> *my,
                                              NSError *error) {
                if (!error) {
                    NSLog(@"%@", @"logged in");
                    //TODO: send FB token to server
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Unable to log you in. Please try again." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            }];
        }
    }];
}

-(void)signUpWithFacebook:(NSDictionary*)params
{
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:@"aba0007c-ebee-42db-bd52-7c9f02e3d371"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient] postPath:@"signup/user/oauth/facebook" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate mmAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate mmAPICallFailed:operation];
    }];
}

#pragma mark - Request Media Methods

-(void)requestMedia:(NSString*)mediaType params:(NSMutableDictionary*)params {
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]);
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"password"]);
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:@"aba0007c-ebee-42db-bd52-7c9f02e3d371"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [[MMHTTPClient sharedClient] postPath:[NSString stringWithFormat:@"requestmedia/%@", mediaType] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate mmAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, id JSON) {
        int statusCode = operation.response.statusCode;
        if (statusCode == 200 || statusCode == 201) {
            id response = operation.responseString;
            NSLog(@"%@", response);
            [_delegate mmAPICallSuccessful:response];
        }
        else {
            [_delegate mmAPICallFailed:operation];
        }
    }];
}

-(void)fulfillRequest:(NSString*)mediaType params:(NSMutableDictionary*)params
{
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:@"aba0007c-ebee-42db-bd52-7c9f02e3d371"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [[MMHTTPClient sharedClient] postPath:[NSString stringWithFormat:@"media/%@", mediaType] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate mmAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, id JSON) {
        int statusCode = operation.response.statusCode;
        if (statusCode == 200 || statusCode == 201) {
            id response = operation.responseString;
            NSLog(@"%@", response);
            [_delegate mmAPICallSuccessful:response];
        }
        else {
            [_delegate mmAPICallFailed:operation];
        }
    }];
}

#pragma mark - Retrieve categories
-(NSMutableArray *)retrieveCategories {
    NSMutableArray *sectionOneArray = [[NSMutableArray alloc]initWithObjects:@"Health Clubs", @"Coffee Shops", @"Nightclubs", @"Pubs/Bars", @"Restaurants", @"Supermarkets", @"Cinemas", @"Dog Parks", @"Beaches", @"Hotels", @"Stadiums", @"Conferences" , @"Middle Schools & High Schools", nil];
    
    NSMutableArray *sectionTwoArray = [[NSMutableArray alloc]initWithObjects:@"History", @"My Locations", @"Events", @"Locations of Interest", nil];
    
    NSMutableArray *categoriesArray = [NSMutableArray arrayWithObjects:sectionOneArray, sectionTwoArray, nil];
    return categoriesArray;
}

#pragma mark - Add Location
-(void)addNewLocation:(NSDictionary*)params
{
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:@"aba0007c-ebee-42db-bd52-7c9f02e3d371"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient] postPath:@"/location" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate mmAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate mmAPICallFailed:operation];
    }];
}

#pragma mark - Inbox 
-(void)openRequests
{
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:@"aba0007c-ebee-42db-bd52-7c9f02e3d371"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [[MMHTTPClient sharedClient] getPath:@"/inbox/openrequests" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate mmAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate mmAPICallFailed:operation];
    }];
}

-(void)assignedRequests
{
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:@"aba0007c-ebee-42db-bd52-7c9f02e3d371"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [[MMHTTPClient sharedClient] getPath:@"/inbox/assignedrequests" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate mmAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate mmAPICallFailed:operation];
    }];
}

@end
