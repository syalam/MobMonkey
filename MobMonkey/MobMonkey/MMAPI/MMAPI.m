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
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient] postPath:@"signup/user" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON){
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        int statusCode = operation.response.statusCode;
        NSLog(@"%d", statusCode);
        if (statusCode == 200 || statusCode == 201) {
            [_delegate MMAPICallSuccessful:[NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil]];
        }
        else {
            [_delegate MMAPICallFailed:operation];
        }
    }];
}

-(void)signInUser:(NSDictionary*)params {
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient] postPath:@"signin/user" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
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
                    //TODO: send FB token to server call
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
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient] postPath:@"signup/user/oauth/facebook" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
    }];
}

#pragma mark - Request Media Methods

-(void)requestMedia:(NSString*)mediaType params:(NSMutableDictionary*)params {
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]);
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"password"]);
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [[MMHTTPClient sharedClient] postPath:[NSString stringWithFormat:@"requestmedia/%@", mediaType] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, id JSON) {
        int statusCode = operation.response.statusCode;
        if (statusCode == 200 || statusCode == 201) {
            id response = operation.responseString;
            NSLog(@"%@", response);
            [_delegate MMAPICallSuccessful:response];
        }
        else {
            [_delegate MMAPICallFailed:operation];
        }
    }];
}

-(void)fulfillRequest:(NSString*)mediaType params:(NSMutableDictionary*)params
{
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [[MMHTTPClient sharedClient] postPath:[NSString stringWithFormat:@"media/%@", mediaType] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, id JSON) {
        int statusCode = operation.response.statusCode;
        if (statusCode == 200 || statusCode == 201) {
            id response = operation.responseString;
            NSLog(@"%@", response);
            [_delegate MMAPICallSuccessful:response];
        }
        else {
            [_delegate MMAPICallFailed:operation];
        }
    }];
}

- (void)fetchMediaCountsForLocation:(NSDictionary*)params {
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [[MMHTTPClient sharedClient] postPath:@"search/media/image" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, id JSON) {
        int statusCode = operation.response.statusCode;
        if (statusCode == 200 || statusCode == 201) {
            id response = operation.responseString;
            NSLog(@"%@", response);
            [_delegate MMAPICallSuccessful:response];
        }
        else {
            [_delegate MMAPICallFailed:operation];
        }
    }];
}

#pragma mark - Retrieve categories
-(void)categories {
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [[MMHTTPClient sharedClient] getPath:@"category" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
    }];
    
    /*NSMutableArray *categoriesArray = [[NSMutableArray alloc]initWithObjects:@"Health Clubs", @"Coffee Shops", @"Nightclubs", @"Pubs/Bars", @"Restaurants", @"Supermarkets", @"Cinemas", @"Dog Parks", @"Beaches", @"Hotels", @"Stadiums", @"Conferences" , @"Middle Schools & High Schools", nil];
    
    return categoriesArray;*/
}

#pragma mark - Add Location
-(void)addNewLocation:(NSDictionary*)params
{
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient] postPath:@"/location" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
    }];
}

#pragma mark - Inbox 
-(void)openRequests
{
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [[MMHTTPClient sharedClient] getPath:@"inbox/openrequests" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
    }];
}

-(void)assignedRequests
{
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [[MMHTTPClient sharedClient] getPath:@"inbox/assignedrequests" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
    }];
}

- (void)fulfilledRequests {
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [[MMHTTPClient sharedClient] getPath:@"inbox/fulfilledrequests" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
    }];
}

#pragma mark - User Checkin
-(void)checkUserIn:(NSDictionary*)params {
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [[MMHTTPClient sharedClient] postPath:@"checkin" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
    }];
}

#pragma mark - Search
- (void)globSearchForLocation:(NSDictionary*)params {
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [[MMHTTPClient sharedClient] postPath:@"search/location/glob" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
    }];
}

- (void)searchForLocation:(NSDictionary*)params {
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [[MMHTTPClient sharedClient]setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [[MMHTTPClient sharedClient] postPath:@"search/location" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
    }];
}

#pragma mark - Bookmarks
+ (void)createBookmarkWithLocationID:(NSString *)locationID providerID:(NSString *)providerID success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpclient = [MMHTTPClient sharedClient];
    [httpclient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpclient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpclient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpclient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpclient postPath:@"bookmarks" parameters:@{ @"locationId" : locationID , @"providerId" : providerID } success:success failure:failure];
}
@end
