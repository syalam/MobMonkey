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
#import "NSString+URLParams.h"


static NSString * const kBMHTTPClientBaseURLString = @"http://staging.mobmonkey.com/rest/";
static NSString * const kBMHTTPClientApplicationID = @"29C851C2-CF6F-11E1-A0EC-4CE76188709B";
static NSString * const kBMHTTPClientApplicationSecret = @"305F0990-CF6F-11E1-BE33-4DE76188709B";

@implementation MMAPI

+ (NSURL *)baseURL
{
    return [NSURL URLWithString:kBMHTTPClientBaseURLString];
}

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
+ (void)signUpNewUser:(NSDictionary*)params
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *paramsCopy = [params mutableCopy];
    
    [paramsCopy setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"apnsToken"] forKey:@"deviceId"];
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
	[paramsCopy setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"apnsToken"] forKey:@"deviceId"];
    
//    if(![paramsCopy valueForKey:@"deviceId"])
//        [paramsCopy setValue:[NSNumber numberWithInt:123] forKey:@"deviceId"];
    
    NSString *urlString = [NSString stringWithFormat:@"user?deviceId=%@&deviceType=iOS", [paramsCopy valueForKey:@"deviceId"]];
    [paramsCopy removeObjectForKey:@"deviceId"];
    [paramsCopy removeObjectForKey:@"deviceType"];
    
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient putPath:urlString parameters:paramsCopy success:success failure:failure];
}

+ (void)getUserOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient  getPath:@"user" parameters:nil success:success failure:failure];
}

+ (void)updateUserOnSuccess:(NSDictionary*)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults] objectForKey:@"mmPartnerId"]];
    [httpClient postPath:@"user" parameters:params success:success failure:failure];
}

+ (void)signInWithEmail:(NSString *)email
               password:(NSString *)password
                 params:(NSDictionary*)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *urlString = @"";
    for (NSString *key in params) {
        NSLog(@"KEY: %@", key);
        if (urlString.length > 0) {
            urlString = [NSString stringWithFormat:@"%@&%@=%@", urlString, key, [params valueForKey:key]];
        }
        else {
            urlString = [NSString stringWithFormat:@"signin?%@=%@", key, [params valueForKey:key]];
        }
    }
        
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:email];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:password];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults] objectForKey:@"mmPartnerId"]];
    [httpClient postPath:urlString parameters:nil success:success failure:failure];
}

+ (void)oauthSignIn:(NSDictionary*)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    //construct url
    NSString *urlString;
    
    if([[params valueForKey:@"provider"] isEqualToString:@"facebook"])
    {
        urlString = [NSString stringWithFormat:@"signin?deviceType=ios&deviceId=%@&useOAuth=true&provider=%@&oauthToken=%@&providerUserName=%@&firstName=%@&lastName=%@&gender=%@&birthday=%@", [params valueForKey:@"deviceId"], [params valueForKey:@"provider"], [params valueForKey:@"oauthToken"], [params valueForKey:@"providerUserName"], [params valueForKey:@"firstName"], [params valueForKey:@"lastName"], [params valueForKey:@"gender"], [params valueForKey:@"birthday"]];
    }
    else if([[params valueForKey:@"provider"] isEqualToString:@"twitter"])
    {
        if([params valueForKey:@"firstName"] || [params valueForKey:@"lastName"] || [params valueForKey:@"birthday"] || [params valueForKey:@"gender"])
        {
            urlString = [NSString stringWithFormat:@"signin?deviceId=%@&deviceType=iOS&useOAuth=true&provider=%@&providerUserName=%@&firstName=%@&lastName=%@&gender=%@&birthday=%@",[params valueForKey:@"deviceId"], [params valueForKey:@"provider"], [params valueForKey:@"providerUserName"], [params valueForKey:@"firstName"], [params valueForKey:@"lastName"], [params valueForKey:@"gender"], [params valueForKey:@"birthday"]];
        }
        else
        {
            urlString = [NSString stringWithFormat:@"signin?deviceId=%@&deviceType=iOS&useOAuth=true&provider=%@&providerUserName=%@",[params valueForKey:@"deviceId"], [params valueForKey:@"provider"], [params valueForKey:@"providerUserName"]];
        }
    }
    
    NSLog(@"OAuth URL String: %@", urlString);
    
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    //[httpClient setDefaultHeader:@"OauthProviderUserName" value:[params valueForKey:@"providerUsername"]];
    //[httpClient setDefaultHeader:@"OauthToken" value:[params valueForKey:@"oauthToken"]];
    //[httpClient setDefaultHeader:@"OauthProvider" value:[params valueForKey:@"provider"]];
    [httpClient postPath:urlString parameters:nil success:success failure:failure];
}

+ (void)registerTwitterUserDetails:(NSDictionary*)params
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *urlString = [NSString stringWithFormat:@"signin/registeremail?deviceType=iOS&deviceId=%@&oauthToken=%@&providerUserName=%@&eMailAddress=%@&provider=%@&firstName=%@&lastName=%@&gender=%@&birthday=%@", [params valueForKey:@"deviceId"], [params valueForKey:@"oauthToken"], [params valueForKey:@"providerUsername"], [params valueForKey:@"eMailAddress"], @"twitter", [params valueForKey:@"firstName"], [params valueForKey:@"lastName"], [params valueForKey:@"gender"], [params valueForKey:@"birthday"]];
        
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
//    [httpClient setDefaultHeader:@"OauthProviderUserName" value:[params valueForKey:@"providerUsername"]];
//    [httpClient setDefaultHeader:@"OauthToken" value:[params valueForKey:@"oauthToken"]];
//    [httpClient setDefaultHeader:@"OauthProvider" value:@"twitter"];
    
    [httpClient postPath:urlString parameters:nil success:success failure:failure];
}

+ (void)TwitterSignIn:(NSDictionary*)params
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient postPath:@"signin" parameters:params success:success failure:failure];
}

+ (void)signOut:(NSDictionary*)params
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient  *httpClient = [MMHTTPClient sharedClient];
    [httpClient postPath:[NSString stringWithFormat:@"signout/iOS/%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"apnsToken"]] parameters:params success:success failure:failure];
}

#pragma mark - Request Media Methods

+ (void)requestMedia:(NSString*)mediaType params:(NSMutableDictionary*)params
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {    
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient  postPath:[NSString stringWithFormat:@"requestmedia/%@", mediaType]
               parameters:params
                  success:success
                  failure:failure];
}

+ (void)fulfillRequest:(NSString*)mediaType params:(NSMutableDictionary*)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {    
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient  postPath:[NSString stringWithFormat:@"media/%@", mediaType] parameters:params success:success failure:failure];
}

#pragma mark - Retrieve categories
    
+ (void)getAllCategories:(NSMutableDictionary*)params
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient  getPath:@"category" parameters:nil success:success failure:failure]; //MODIFIED category/all to category
}

+ (void)getCategoriesOnSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient  getPath:@"category?categoryId=1" parameters:nil success:success failure:failure];
}

#pragma mark - Add Location
+ (void)addNewLocation:(NSDictionary*)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient putPath:@"location" parameters:params success:success failure:failure];
}

#pragma mark - Inbox
+ (void)getInboxCounts:(NSMutableDictionary*)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient  getPath:@"inbox/counts" parameters:nil success:success failure:failure];
}


+ (void)getOpenRequests:(NSMutableDictionary*)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient getPath:@"inbox/openrequests" parameters:nil success:success failure:failure];
}

+ (void)getAssignedRequests:(NSMutableDictionary*)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient  getPath:@"inbox/assignedrequests" parameters:nil success:success failure:failure];
}

+ (void)getFulfilledRequests:(NSMutableDictionary*)params
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient getPath:@"inbox/fulfilledrequests" parameters:nil success:success failure:failure];
}

+ (void)rejectMedia:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient deletePath:[NSString stringWithFormat:@"media/request?requestId=%@&mediaId=%@", [params valueForKey:@"requestId"], [params valueForKey:@"mediaId"]] parameters:nil success:success failure:failure];
}

+ (void)acceptMedia:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient postPath:[NSString stringWithFormat:@"media/request?requestId=%@&mediaId=%@", [params valueForKey:@"requestId"], [params valueForKey:@"mediaId"]] parameters:nil success:success failure:failure];
}

+ (void)deleteMediaRequest:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient deletePath:[NSString stringWithFormat:@"requestmedia?requestId=%@&isRecurring=%@", [params valueForKey:@"requestId"], [params valueForKey:@"isRecurring"]] parameters:nil success:success failure:failure];
}


#pragma mark - User Checkin
+ (void)checkUserIn:(NSDictionary*)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient  postPath:@"checkin" parameters:params success:success failure:failure];
}

#pragma mark - Search
+ (void)searchForLocation:(NSMutableDictionary*)params mediaType:(NSString*)mediaType
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    NSString *urlString;
    if (mediaType) {
        urlString = [NSString stringWithFormat:@"search/location?mediaType=%@", mediaType];
    }
    else {
        urlString = @"search/location";
    }
    [httpClient postPath:urlString parameters:params success:success failure:failure];
}

#pragma marl - Media
+ (void)getMediaForLocationID:(NSString *)locationID
                   providerID:(NSString *)providerID
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient getPath:@"media" parameters:@{ @"locationId" : locationID , @"providerId" : providerID } success:success failure:failure];
}

#pragma mark - Bookmarks
+ (void)getBookmarksOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient getPath:@"bookmarks" parameters:nil success:success failure:failure];
}

+ (void)createBookmarkWithLocationID:(NSString *)locationID
                          providerID:(NSString *)providerID
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient postPath:@"bookmarks" parameters:@{ @"locationId" : locationID , @"providerId" : providerID } success:success failure:failure];
}


+ (void)deleteBookmarkWithLocationID:(NSString *)locationID
                          providerID:(NSString *)providerID
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                            locationID, @"locationId",
                            providerID, @"providerId", nil];
    NSString *urlParams = @"";
    for (NSString *key in params) {
        if (urlParams.length > 0) {
            urlParams = [NSString stringWithFormat:@"%@&%@=%@", urlParams, key, [params valueForKey:key]];
        }
        else {
            urlParams = [NSString stringWithFormat:@"bookmarks/?%@=%@", key, [params valueForKey:key]];
        }
    }

    [httpClient deletePath:@"bookmarks" parameters:params success:success failure:failure];
}

#pragma mark - Trending
+ (void)getTrendingType:(NSString *)type params:(NSDictionary *)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    NSString *urlParams = @"";
    for (NSString *key in params) {
        if (urlParams.length > 0) {
            urlParams = [NSString stringWithFormat:@"%@&%@=%@", urlParams, key, [params valueForKey:key]];
        }
        else {
            urlParams = [NSString stringWithFormat:@"trending/%@?%@=%@", type, key, [params valueForKey:key]];
        }
    }
    [httpClient getPath:urlParams parameters:nil success:success failure:failure];
}


#pragma mark - Location
+ (void)getLocationInfo:(NSDictionary *)param
                success:(void (^)(AFHTTPRequestOperation *, id))success
                failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    NSString *urlString = [NSString stringWithFormat:@"location?locationId=%@&providerId=%@", [param valueForKey:@"locationId"], [param valueForKey:@"providerId"]];
    [httpClient getPath:urlString parameters:nil success:success failure:failure];
}

#pragma mark - Helper Methods
+ (MMHTTPClient*)setupHTTPClient {
    MMHTTPClient *httpClient = [[MMHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBMHTTPClientBaseURLString]];
    
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"oauthUser"]) {
        [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
        [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    }
    else {
        [httpClient setDefaultHeader:@"OauthProviderUserName" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
        [httpClient setDefaultHeader:@"OauthProvider" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"oauthProvider"]];
        [httpClient setDefaultHeader:@"OauthToken" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"oauthToken"]];
    }

    return httpClient;
}

@end
