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
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient  postPath:@"signup/user"
               parameters:paramsCopy
                  success:success
                  failure:failure];
}

+ (void)getUserOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient  getPath:@"signup/user" parameters:nil success:success failure:failure];
}

+ (void)signInWithEmail:(NSString *)email
               password:(NSString *)password
               provider:(OAuthProvider)provider
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient postPath:[NSString stringWithFormat:@"signin/iOS/%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"apnsToken"]] parameters:nil success:success failure:failure];
}

+ (void)facebookSignIn:(NSDictionary*)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient  postPath:@"http://api.mobmonkey.com/rest/signup/user/oauth/facebook" parameters:params success:success failure:failure];
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

- (void)fetchMediaCountsForLocation:(NSDictionary*)params {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"password"]) {
        [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    }
    else {
        [httpClient setDefaultHeader:@"OauthToken" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"oAuthToken"]];
    }
    [httpClient  postPath:@"search/media/image" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
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
-(void)addNewLocation:(NSDictionary*)params
{
  [self addNewLocation:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"%@", responseObject);
    [_delegate MMAPICallSuccessful:responseObject];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [_delegate MMAPICallFailed:operation];
  }];
}

- (void)addNewLocation:(NSDictionary*)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
  // https://github.com/syalam/mobmonkey-api/wiki/Location-API
  
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"password"]) {
        [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    }
    else {
        [httpClient setDefaultHeader:@"OauthToken" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"oAuthToken"]];
    }
    
    [httpClient postPath:@"locations/create" parameters:params
                 success:success
                 failure:failure];
}

#pragma mark - Inbox
+ (void)getInboxCounts:(NSMutableDictionary*)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient  getPath:@"inbox/counts" parameters:nil success:success failure:failure];
}

+ (void)getOpenRequestsOnSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    NSString *urlString = [kBMHTTPClientBaseURLString stringByAppendingString:@"inbox/openrequests"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"mmPartnerId"] forHTTPHeaderField:@"MobMonkey-partnerId"];
    [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"] forHTTPHeaderField:@"MobMonkey-user"];
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"password"]) {
        [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"] forHTTPHeaderField:@"MobMonkey-auth"];
    }
    else {
        [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"oAuthToken"] forHTTPHeaderField:@"OauthToken"];
    }
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            failure(error);
            return;
        }
        NSLog(@"Open Requests: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        success([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
    }];
}

+ (void)getLocationsInOpenRequestsOnSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    NSString *urlString = [kBMHTTPClientBaseURLString stringByAppendingString:@"locations/openrequests"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"mmPartnerId"] forHTTPHeaderField:@"MobMonkey-partnerId"];
    [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"] forHTTPHeaderField:@"MobMonkey-user"];
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"password"]) {
        [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"] forHTTPHeaderField:@"MobMonkey-auth"];
    }
    else {
        [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"oAuthToken"] forHTTPHeaderField:@"OauthToken"];
    }
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            failure(error);
            return;
        }
        NSLog(@"Locations in Open Requests: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        success([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
    }];
}

+ (void)getAssignedRequests:(NSMutableDictionary*)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient  getPath:@"inbox/assignedrequests" parameters:nil success:success failure:failure];
}

+ (void)getAssignedRequestsOnSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    NSString *urlString = [kBMHTTPClientBaseURLString stringByAppendingString:@"inbox/assignedrequests"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"mmPartnerId"] forHTTPHeaderField:@"MobMonkey-partnerId"];
    [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"] forHTTPHeaderField:@"MobMonkey-user"];
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"password"]) {
        [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"] forHTTPHeaderField:@"MobMonkey-auth"];
    }
    else {
        [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"oAuthToken"] forHTTPHeaderField:@"OauthToken"];
    }    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            failure(error);
            return;
        }
        NSLog(@"Assigned Requests: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        success([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
    }];
}

+ (void)getLocationsInAssignedRequestsOnSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    NSString *urlString = [kBMHTTPClientBaseURLString stringByAppendingString:@"locations/openrequests"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"mmPartnerId"] forHTTPHeaderField:@"MobMonkey-partnerId"];
    [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"] forHTTPHeaderField:@"MobMonkey-user"];
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"password"]) {
        [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"] forHTTPHeaderField:@"MobMonkey-auth"];
    }
    else {
        [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"oAuthToken"] forHTTPHeaderField:@"OauthToken"];
    }
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            failure(error);
            return;
        }
        NSLog(@"Locations in Open Requests: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        success([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
    }];
}

+ (void)getFulfilledRequestsOnSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    NSString *urlString = [kBMHTTPClientBaseURLString stringByAppendingString:@"inbox/fulfilledrequests"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"mmPartnerId"] forHTTPHeaderField:@"MobMonkey-partnerId"];
    [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"] forHTTPHeaderField:@"MobMonkey-user"];
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"password"]) {
        [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"] forHTTPHeaderField:@"MobMonkey-auth"];
    }
    else {
        [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"oAuthToken"] forHTTPHeaderField:@"OauthToken"];
    }
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            failure(error);
            return;
        }
        NSLog(@"Fulfilled Requests: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        success([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
    }];
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
+ (void)searchForLocation:(NSDictionary*)params
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure {
    NSString *urlString = [kBMHTTPClientBaseURLString stringByAppendingString:@"search/location"];
    //urlString = [urlString stringByAppendingFormat:@"?%@", [NSString URLParameterizedStringFromDictionary:params]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:params options:0 error:nil]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"mmPartnerId"] forHTTPHeaderField:@"MobMonkey-partnerId"];
    [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"] forHTTPHeaderField:@"MobMonkey-user"];
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"password"]) {
        [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"] forHTTPHeaderField:@"MobMonkey-auth"];
    }
    else {
        [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"oAuthToken"] forHTTPHeaderField:@"OauthToken"];
    }
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            failure(error);
            return;
        }
        NSLog(@"Locations: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        success([NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
    }];
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
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure {
    NSString *urlString = [kBMHTTPClientBaseURLString stringByAppendingString:@"bookmarks"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"mmPartnerId"] forHTTPHeaderField:@"MobMonkey-partnerId"];
    [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"] forHTTPHeaderField:@"MobMonkey-user"];
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"password"]) {
        [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"] forHTTPHeaderField:@"MobMonkey-auth"];
    }
    else {
        [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"oAuthToken"] forHTTPHeaderField:@"OauthToken"];
    }
    NSData *body = [NSJSONSerialization dataWithJSONObject:@{ @"locationId" : locationID , @"providerId" : providerID } options:0 error:nil];
    [request setHTTPBody:body];    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            failure(error);
            return;
        }
        success([NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
    }];
}

+ (void)getTrendingType:(NSString *)type params:(NSDictionary *)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient getPath:[@"trending/" stringByAppendingString:type] parameters:params success:success failure:failure];
}


#pragma mark - Location
+ (void)getLocationInfo:(NSDictionary *)param
                success:(void (^)(AFHTTPRequestOperation *, id))success
                failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    MMHTTPClient *httpClient = [self setupHTTPClient];
    [httpClient getPath:[NSString stringWithFormat:@"locations?locationId=%@&providerId=%@", [param valueForKey:@"locationId"], [param valueForKey:@"providerId"]] parameters:nil success:success failure:failure];
}

#pragma mark - Helper Methods
+ (MMHTTPClient*)setupHTTPClient {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"password"]) {
        [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    }
    else {
        [httpClient setDefaultHeader:@"OauthToken" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"oAuthToken"]];
    }
    return httpClient;
}

@end
