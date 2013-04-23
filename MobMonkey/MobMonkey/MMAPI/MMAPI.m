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


#ifdef STAGING

static NSString * const kBMHTTPClientBaseURLString = @"http://staging.mobmonkey.com/rest/";
static NSString * const kBMHTTPClientApplicationID = @"29C851C2-CF6F-11E1-A0EC-4CE76188709B";
static NSString * const kBMHTTPClientApplicationSecret = @"305F0990-CF6F-11E1-BE33-4DE76188709B";

#elif PRODUCTION

static NSString * const kBMHTTPClientBaseURLString = @"http://api.mobmonkey.com/rest/";
static NSString * const kBMHTTPClientApplicationID = @"29C851C2-CF6F-11E1-A0EC-4CE76188709B";
static NSString * const kBMHTTPClientApplicationSecret = @"305F0990-CF6F-11E1-BE33-4DE76188709B";

#endif

@implementation MMOAuth

@synthesize provider = _provider, providerString = _providerString;

-(void)setProvider:(OAuthProvider)provider{
    
    if(provider == OAuthProviderTwitter){
        _providerString = @"twitter";
    }else if(provider == OAuthProviderFacebook){
        _providerString = @"facebook";
    }else {
        _providerString = nil;
    }
    _provider = provider;
}
-(void)setProviderString:(NSString *)providerString{
    
    if([providerString isEqualToString:@"twitter"]){
        _provider = OAuthProviderTwitter;
    }else if([providerString isEqualToString:@"facebook"]){
        _provider = OAuthProviderFacebook;
    }else{
        _provider = OAuthProviderNone;
    }
    
    _providerString = providerString;
}
@end

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
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient  getPath:@"user" parameters:nil success:success failure:failure];
}

+ (void)updateUserOnSuccess:(NSDictionary*)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults] objectForKey:@"mmPartnerId"]];
    [httpClient postPath:@"user" parameters:params success:success failure:failure];
}
+ (void) updateUserInfo:(MMMyInfo *)userInfo newPassword:(NSString *)newPassword success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSNumber * gender = [userInfo.gender isEqualToString:@"Male"] ? @1 : @0;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *birthdayDate = [dateFormatter dateFromString:userInfo.birthday];
    NSTimeInterval bdayUnixTime = birthdayDate.timeIntervalSince1970*1000;
    NSNumber * birthday = [NSNumber numberWithDouble:bdayUnixTime];
    
    [parameters setValue:userInfo.firstName forKey:@"firstName"];
    [parameters setValue:birthday forKey:@"birthday"];
    [parameters setValue:userInfo.lastName forKey:@"lastName"];
    [parameters setValue:gender forKey:@"gender"];
    
    if (newPassword) {
        [parameters setValue:newPassword forKey:@"password"];
    }else{
        [parameters setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"] forKey:@"password"];
    }
    
    
    
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    
    NSLog(@"PARAMETERS: %@", parameters);
    
    [httpClient postPath:@"user" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(newPassword){
            [[NSUserDefaults standardUserDefaults] setObject:newPassword forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if(success){
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure){
            failure(operation, error);
        }
    }];

    
    
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
    
    NSLog(@"%@", urlString);
        
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
    else// if([[params valueForKey:@"provider"] isEqualToString:@"twitter"])
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
+(void)oauthSignIn:(MMOAuth *)oauth userInfo:(MMMyInfo *)userInfo success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSNumber * gender = [userInfo.gender isEqualToString:@"Male"] ? @1 : @0;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *birthdayDate = [dateFormatter dateFromString:userInfo.birthday];
    NSTimeInterval bdayUnixTime = birthdayDate.timeIntervalSince1970*1000;
    NSNumber * birthday = [NSNumber numberWithDouble:bdayUnixTime];
    
    [parameters setValue:userInfo.firstName forKey:@"firstName"];
    [parameters setValue:birthday forKey:@"birthday"];
    [parameters setValue:userInfo.lastName forKey:@"lastName"];
    [parameters setValue:gender forKey:@"gender"];
    [parameters setValue:oauth.username forKey:@"providerUserName"];
    [parameters setValue:oauth.deviceID forKey:@"deviceId"];
    [parameters setObject:@YES forKey:@"useOAuth"];
    [parameters setObject:@"iOS" forKey:@"deviceType"];
    
    if(oauth.providerString){
        [parameters setObject:oauth.providerString forKey:@"provider"];

    }
        
    
    if(oauth.provider == OAuthProviderFacebook)
    {
        [parameters setValue:oauth.token forKey:@"oauthToken"];
    
    }
    
    //I'm doing this to create the GET parameters in the url, it's kind of sloppy but backend is requiring post, but we are not using post parameters.
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"signin" parameters:parameters data:nil];
    
    [httpClient postPath:request.URL.absoluteString parameters:nil success:success failure:failure];
    
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
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
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
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient  postPath:[NSString stringWithFormat:@"requestmedia/%@", mediaType]
               parameters:params
                  success:success
                  failure:failure];
}

+ (void)fulfillRequest:(NSString*)mediaType params:(NSMutableDictionary*)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient  postPath:[NSString stringWithFormat:@"media/%@", mediaType] parameters:params success:success failure:failure];
}

#pragma mark - Retrieve categories
    
+ (void)getAllCategories:(NSMutableDictionary*)params
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient  getPath:@"category" parameters:nil success:success failure:failure]; //MODIFIED category/all to category
}

+ (void)getCategoriesOnSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient  getPath:@"category?categoryId=1" parameters:nil success:success failure:failure];
}

#pragma mark - Add Location
+ (void)addNewLocation:(NSDictionary*)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient putPath:@"location" parameters:params success:success failure:failure];
}

#pragma mark - Inbox
+ (void)getInboxCounts:(NSMutableDictionary*)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient  getPath:@"inbox/counts" parameters:nil success:success failure:failure];
}


+ (void)getOpenRequests:(NSMutableDictionary*)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient getPath:@"inbox/openrequests" parameters:nil success:success failure:failure];
}

+ (void)getAssignedRequests:(NSMutableDictionary*)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient  getPath:@"inbox/assignedrequests" parameters:nil success:success failure:failure];
}

+ (void)getFulfilledRequests:(NSMutableDictionary*)params
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient getPath:@"inbox/fulfilledrequests" parameters:nil success:success failure:failure];
}

+ (void)rejectMedia:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient deletePath:[NSString stringWithFormat:@"media/request?requestId=%@&mediaId=%@", [params valueForKey:@"requestId"], [params valueForKey:@"mediaId"]] parameters:nil success:success failure:failure];
}

+ (void)acceptMedia:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient postPath:[NSString stringWithFormat:@"media/request?requestId=%@&mediaId=%@", [params valueForKey:@"requestId"], [params valueForKey:@"mediaId"]] parameters:nil success:success failure:failure];
}

+ (void)deleteMediaRequest:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient deletePath:[NSString stringWithFormat:@"requestmedia?requestId=%@&isRecurring=%@", [params valueForKey:@"requestId"], [params valueForKey:@"isRecurring"]] parameters:nil success:success failure:failure];
}


#pragma mark - User Checkin
+ (void)checkUserIn:(NSDictionary*)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient  postPath:@"checkin" parameters:params success:success failure:failure];
}

#pragma mark - Search
+ (void)searchForLocation:(NSMutableDictionary*)params mediaType:(NSString*)mediaType
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
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
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient getPath:@"media" parameters:@{ @"locationId" : locationID , @"providerId" : providerID } success:success failure:failure];
}

#pragma mark - Bookmarks
+ (void)getBookmarksOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient getPath:@"bookmarks" parameters:nil success:success failure:failure];
}

+ (void)createBookmarkWithLocationID:(NSString *)locationID
                          providerID:(NSString *)providerID
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient postPath:@"bookmarks" parameters:@{ @"locationId" : locationID , @"providerId" : providerID } success:success failure:failure];
}


+ (void)deleteBookmarkWithLocationID:(NSString *)locationID
                          providerID:(NSString *)providerID
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
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
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
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
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    NSString *urlString = [NSString stringWithFormat:@"location?locationId=%@&providerId=%@", [param valueForKey:@"locationId"], [param valueForKey:@"providerId"]];
    [httpClient getPath:urlString parameters:nil success:success failure:failure];
}

+(void)getLocationWithID:(NSString *)locationID providerID:(NSString *)providerID success:(void (^)(AFHTTPRequestOperation *, MMLocationInformation *))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    NSDictionary *parameters = @{@"locationId":locationID,@"providerId":providerID};
    
    [[MMHTTPClient sharedClient] getPath:@"location" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         MMLocationInformation *locationInformation = [[MMLocationInformation alloc] init];
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *json = responseObject;
            
            locationInformation.locationID = [json objectForKey:@"locationId"];
            locationInformation.providerID = [json objectForKey:@"providerId"];
            locationInformation.street = [json objectForKey:@"address"];
            locationInformation.details = [json objectForKey:@"description"];
            locationInformation.unitNumber = [json objectForKey:@"address_ext"];
            locationInformation.categories = [json objectForKey:@"categoryIds"];
            locationInformation.country = [json objectForKey:@"countryCode"];
            locationInformation.latitude = [json objectForKey:@"latitude"]; //warn
            locationInformation.longitude = [json objectForKey:@"longitude"];//warn
            locationInformation.locality = [json objectForKey:@"locality"];
            locationInformation.name = [json objectForKey:@"name"];
            locationInformation.neighborhood = [json objectForKey:@"neighborhood"];
            locationInformation.phoneNumber = [json objectForKey:@"phoneNumber"];
            locationInformation.zipCode = [json objectForKey:@"postCode"];
            locationInformation.region = [json objectForKey:@"region"];
            locationInformation.state = [json objectForKey:@"region"];
            locationInformation.website = [json objectForKey:@"webSite"];
            locationInformation.isBookmark = ((NSNumber*)[json objectForKey:@"bookmark"]).boolValue;
            
            if(success){
                success(operation, locationInformation);
            }
            
        } 
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure){
            failure(operation, error);
        }
    }];
    
}

/*#pragma mark - Helper Methods
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
}*/ //Modified this to use the sharedClient instead of initializing a new http client every call. 

#pragma mark - Subscription

+(void)subscribeUserEmail:(NSString *)userEmail partnerId:(NSString *)partnerId success:(void (^)(void))success failure:(void (^)(NSError *))failure {
    
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    
    //[httpClient setDefaultHeader:@"MobMonkey-user" value:@"manny.a.huerta@gmail.com"];
    //[httpClient setDefaultHeader:@"MobMonkey-auth" value:@"trustno1"];
    NSString *urlString = [NSString stringWithFormat:@"user/paidsubscription?email=%@&partnerId=%@", userEmail, partnerId ];
    //NSDictionary *parameters = @{@"email":userEmail, @"partnerId":partnerId};
    
    [httpClient postPath:urlString parameters:nil data:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Subscription was successful");
        if(success){
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed Subscription");
        if(failure){
            failure(error);
        }
    }];
}
@end
