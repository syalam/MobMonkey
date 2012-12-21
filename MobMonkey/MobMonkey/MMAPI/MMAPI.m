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
    [httpClient  postPath:@"signup/user"
               parameters:paramsCopy
                  success:success
                  failure:failure];
}

+ (void)getUserOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient  getPath:@"signup/user" parameters:nil success:success failure:failure];
}

+ (void)signInWithEmail:(NSString *)email
               password:(NSString *)password
               provider:(OAuthProvider)provider
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"apnsToken"]);
    MMHTTPClient *httpClient = [[MMHTTPClient alloc] initWithBaseURL:[self baseURL]];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:email];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:password];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults] objectForKey:@"mmPartnerId"]];
    [httpClient postPath:[NSString stringWithFormat:@"signin/iOS/%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"apnsToken"]] parameters:nil success:success failure:failure];
}

+ (void)facebookSignIn {
    NSArray *permissions = [NSArray arrayWithObjects:@"email", nil];
    [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        if (session.isOpen) {
            FBRequest *me = [FBRequest requestForMe];
            [me startWithCompletionHandler: ^(FBRequestConnection *connection,
                                              NSDictionary<FBGraphUser> *my,
                                              NSError *error) {
                if (!error) {
                    NSLog(@"%@", my);
                    //TODO: send FB token to server call
                    NSString* accessToken = me.session.accessToken;
                    NSLog(@"%@", accessToken);
                }
                else {
                    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Unable to log you in. Please try again." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease];
                    [alert show];
                }
                
            }];
        }
    }];
}

#pragma mark - Request Media Methods

+ (void)requestMedia:(NSString*)mediaType params:(NSMutableDictionary*)params
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]);
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"password"]);
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient  postPath:[NSString stringWithFormat:@"requestmedia/%@", mediaType]
               parameters:params
                  success:success
                  failure:failure];
}

+ (void)fulfillRequest:(NSString*)mediaType params:(NSMutableDictionary*)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {    
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient  postPath:[NSString stringWithFormat:@"media/%@", mediaType] parameters:params success:success failure:failure];
}

- (void)fetchMediaCountsForLocation:(NSDictionary*)params {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
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
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient  getPath:@"category/all" parameters:nil success:success failure:failure];
}

+ (void)getCategoriesOnSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
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
  [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];

  [httpClient postPath:@"locations/create" parameters:params
               success:success
               failure:failure];
}

#pragma mark - Inbox
+ (void)getInboxCounts:(NSMutableDictionary*)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient  getPath:@"inbox/counts" parameters:nil success:success failure:failure];
}

+ (void)getOpenRequestsOnSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    NSString *urlString = [kBMHTTPClientBaseURLString stringByAppendingString:@"inbox/openrequests"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"mmPartnerId"] forHTTPHeaderField:@"MobMonkey-partnerId"];
    [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"] forHTTPHeaderField:@"MobMonkey-user"];
    [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"] forHTTPHeaderField:@"MobMonkey-auth"];
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
    [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"] forHTTPHeaderField:@"MobMonkey-auth"];
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
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient  getPath:@"inbox/assignedrequests" parameters:nil success:success failure:failure];
}

+ (void)getAssignedRequestsOnSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    NSString *urlString = [kBMHTTPClientBaseURLString stringByAppendingString:@"inbox/assignedrequests"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"mmPartnerId"] forHTTPHeaderField:@"MobMonkey-partnerId"];
    [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"] forHTTPHeaderField:@"MobMonkey-user"];
    [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"] forHTTPHeaderField:@"MobMonkey-auth"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
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
    [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"] forHTTPHeaderField:@"MobMonkey-auth"];
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
    [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"] forHTTPHeaderField:@"MobMonkey-auth"];
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
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient deletePath:[NSString stringWithFormat:@"media/request?requestId=%@&mediaId=%@", [params valueForKey:@"requestId"], [params valueForKey:@"mediaId"]] parameters:nil success:success failure:failure];
}

+ (void)acceptMedia:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient postPath:[NSString stringWithFormat:@"media/request?requestId=%@&mediaId=%@", [params valueForKey:@"requestId"], [params valueForKey:@"mediaId"]] parameters:nil success:success failure:failure];
}

+ (void)deleteMediaRequest:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient deletePath:[NSString stringWithFormat:@"requestmedia?requestId=%@&isRecurring=%@", [params valueForKey:@"requestId"], [params valueForKey:@"isRecurring"]] parameters:nil success:success failure:failure];
}


#pragma mark - User Checkin
+ (void)checkUserIn:(NSDictionary*)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
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
    [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"] forHTTPHeaderField:@"MobMonkey-auth"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            failure(error);
            return;
        }
        NSLog(@"Locations: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        success([NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
    }];
    
//    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
//    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
//    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
//    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
//    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
//    [httpClient  getPath:@"search/location" parameters:params success:success failure:failure];
}

#pragma marl - Media
+ (void)getMediaForLocationID:(NSString *)locationID
                   providerID:(NSString *)providerID
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient getPath:@"media" parameters:@{ @"locationId" : locationID , @"providerId" : providerID } success:success failure:failure];
}

#pragma mark - Bookmarks
+ (void)getBookmarksOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient getPath:@"bookmarks" parameters:nil success:success failure:failure];
}

+ (void)createBookmarkWithLocationID:(NSString *)locationID
                          providerID:(NSString *)providerID
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
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
    [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"] forHTTPHeaderField:@"MobMonkey-auth"];
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
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient getPath:[@"trending/" stringByAppendingString:type] parameters:params success:success failure:failure];
}

/*+ (void)getTrendingType:(NSString *)type
                 params:(NSDictionary *)params
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    NSString *endpoint = [@"trending/" stringByAppendingString:type];
    NSString *urlString = [kBMHTTPClientBaseURLString stringByAppendingString:endpoint];
    urlString = [urlString stringByAppendingFormat:@"?%@", [NSString URLParameterizedStringFromDictionary:params]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"mmPartnerId"] forHTTPHeaderField:@"MobMonkey-partnerId"];
    [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"] forHTTPHeaderField:@"MobMonkey-user"];
    [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"] forHTTPHeaderField:@"MobMonkey-auth"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            failure(error);
            return;
        }
        NSLog(@"Locations: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        success([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
    }];
}*/

#pragma mark - Location
+ (void)getLocationInfo:(NSDictionary *)param
                success:(void (^)(AFHTTPRequestOperation *, id))success
                failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient getPath:[NSString stringWithFormat:@"locations?locationId=%@&providerId=%@", [param valueForKey:@"locationId"], [param valueForKey:@"providerId"]] parameters:nil success:success failure:failure];
}

@end
