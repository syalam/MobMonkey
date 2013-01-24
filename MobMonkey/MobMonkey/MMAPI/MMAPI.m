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


static NSString * const kBMHTTPClientBaseURLString = @"http://api.mobmonkey.com/rest/";
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
    NSLog(@"%@", params);
    NSMutableDictionary *paramsCopy = [params mutableCopy];
    [paramsCopy setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"apnsToken"] forKey:@"deviceId"];
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient  postPath:@"signup/user" parameters:paramsCopy success:success failure:failure];
}

+ (void)getUserOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient  getPath:@"signup/user" parameters:nil success:success failure:failure];
}

+ (void)signInWithEmail:(NSString *)email
               password:(NSString *)password
                 params:(NSDictionary*)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:email];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:password];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults] objectForKey:@"mmPartnerId"]];
    [httpClient postPath:@"signin" parameters:params success:success failure:failure];
}

+ (void)oauthSignIn:(NSDictionary*)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    //construct url
    NSString *urlString = [NSString stringWithFormat:@"signin?deviceType=ios&deviceId=%@&useOAuth=true&provider=%@&oauthToken=%@&providerUserName=%@", [params valueForKey:@"deviceId"], [params valueForKey:@"provider"], [params valueForKey:@"oauthToken"], [params valueForKey:@"providerUserName"]];

    
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient postPath:urlString parameters:nil success:success failure:failure];
}

+ (void)registerTwitterUserDetails:(NSDictionary*)params
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *urlString = [NSString stringWithFormat:@"signin/registeremail?deviceType=iOS&deviceId=%@&oauthToken=%@&providerUserName=%@&eMailAddress=%@", [params valueForKey:@"deviceId"], [params valueForKey:@"oauthToken"], [params valueForKey:@"providerUsername"], [params valueForKey:@"eMailAddress"]];
    MMHTTPClient *httpClient = [self setupHTTPClient];
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
    [httpClient  getPath:@"category/all" parameters:nil success:success failure:failure];
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
    [httpClient postPath:@"locations/create" parameters:params success:success failure:failure];
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
    NSString *urlString = [NSString stringWithFormat:@"locations?locationId=%@&providerId=%@", [param valueForKey:@"locationId"], [param valueForKey:@"providerId"]];
    [httpClient getPath:urlString parameters:nil success:success failure:failure];
}

#pragma mark - Helper Methods
+ (MMHTTPClient*)setupHTTPClient {
    MMHTTPClient *httpClient = [[MMHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBMHTTPClientBaseURLString]];
    
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"oauthUser"]) {
        [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    }
    else {
        [httpClient setDefaultHeader:@"OauthToken" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"oauthToken"]];
    }

    return httpClient;
}

@end
