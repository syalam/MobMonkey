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
#import "MMSocialNetworkModel.h"


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

+(void)updateUserInfo:(MMMyInfo *)userInfo
            withOauth:(MMOAuth *)oauth
          newPassword:(NSString *)newPassword
              success:(void (^)(AFHTTPRequestOperation * operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation * opertaion, NSError * error))failure
{

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //Device Type and ID
    [parameters setObject:@"ios" forKey:@"deviceType"];
    [parameters setObject:oauth.deviceID forKey:@"deviceId"];
    [parameters setObject:@"true" forKey:@"useOAuth"];
    [parameters setObject:oauth.providerString forKey:@"provider"];
    [parameters setObject:oauth.token forKey:@"oauthToken"];
    [parameters setObject:oauth.username forKey:@"providerUserName"];
    
    
    // Editted Information
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

    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    
    [httpClient setDefaultHeader:@"MobMonkey-user" value:nil];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:nil];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults] objectForKey:@"mmPartnerId"]];
    NSString *path = [[[httpClient requestWithMethod:@"GET" path:@"signin" parameters:parameters data:nil] URL] absoluteString];
    

    [httpClient postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
+(void)oauthSignIn:(MMOAuth *)oauth userInfo:(MMMyInfo *)userInfo forService:(SocialNetwork)socialNetwork success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
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
    
    [parameters setObject:@"ios" forKey:@"deviceType"];
    [parameters setObject:@YES forKey:@"useOAuth"];
    [parameters setObject:oauth.providerString forKey:@"provider"];
    [parameters setObject:oauth.username forKey:@"providerUserName"]; 

    
    if(socialNetwork == SocialNetworkFacebook){
                
        [parameters setObject:oauth.token forKey:@"oauthToken"];
                
    }else if(socialNetwork == SocialNetworkTwitter){
        
        [parameters setObject:oauth.deviceID forKey:@"deviceId"];
        
    }
    
    
    [parameters setValue:oauth.username forKey:@"providerUserName"];
    [parameters setValue:oauth.deviceID forKey:@"deviceId"];
    [parameters setObject:@YES forKey:@"useOAuth"];
    [parameters setObject:@"iOS" forKey:@"deviceType"];
    
    
    //I'm doing this to create the GET parameters in the url, it's kind of sloppy but backend is requiring post, but we are not using post parameters.
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"signin" parameters:parameters data:nil];
    
    [httpClient postPath:request.URL.absoluteString parameters:nil success:success failure:failure];
    
}
+ (void) registerTwitterWithOauth:(MMOAuth*)oauth userInfo:(MMMyInfo *)userInfo
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSNumber * gender = [userInfo.gender isEqualToString:@"Male"] ? @1 : @0;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *birthdayDate = [dateFormatter dateFromString:userInfo.birthday];
    NSTimeInterval bdayUnixTime = birthdayDate.timeIntervalSince1970*1000;
    NSNumber * birthday = [NSNumber numberWithDouble:bdayUnixTime];
    
    userInfo.firstName ? [parameters setValue:userInfo.firstName forKey:@"firstName"]: nil;
    birthday ? [parameters setValue:birthday forKey:@"birthday"] : nil;
    userInfo.lastName ? [parameters setValue:userInfo.lastName forKey:@"lastName"]: nil;
    gender ? [parameters setValue:gender forKey:@"gender"] : nil;
    oauth.username ? [parameters setValue:oauth.username forKey:@"providerUserName"] : nil;
    oauth.deviceID ? [parameters setValue:oauth.deviceID forKey:@"deviceId"] : nil;
    
    /*if(oauth.providerString){
        [parameters setObject:oauth.providerString forKey:@"provider"];
        
    }*/
    
    
    if(oauth.provider == OAuthProviderTwitter)
    {
        //[parameters setValue:oauth.token forKey:@"oauthToken"];
        
    }
    
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"signin" parameters:parameters];
    
    NSString *urlstring = request.URL.absoluteString;
    
    [httpClient postPath:urlstring parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
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

//NEW METHOD
+ (void)searchForLocations:(NSMutableDictionary*)params mediaType:(NSString*)mediaType
                   success:(void (^)(AFHTTPRequestOperation *operation, NSArray *locationInformations))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    NSString *urlString;
    if (mediaType) {
        urlString = [NSString stringWithFormat:@"search/location?mediaType=%@", mediaType];
    }
    else {
        urlString = @"search/location";
    }
    [httpClient postPath:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *locationInformations = [NSMutableArray array];
        NSMutableArray *sublocations = [NSMutableArray array];
        
        for(NSDictionary *locationDictionary in responseObject){
            
            MMLocationInformation *locationInformation = [self locationInformationForLocationDictionary:locationDictionary];
            
            if(!locationInformation.name){
                locationInformation.name = @"Unnamed Location";
            }
            
            //Add the sublocations to a seperate array
            if(locationInformation.parentLocationID && ![locationInformation.parentLocationID isKindOfClass:[NSNull class]]&& locationInformation.parentLocationID.length > 0){
                [sublocations addObject:locationInformation];
            }else{
                [locationInformations addObject:locationInformation];
            }
            
            
        }
        
        if(sublocations.count > 0){
            for(MMLocationInformation *subLocation in sublocations){
                
                                NSPredicate *parentIdPredicate = [NSPredicate predicateWithFormat:@"locationID = %@", subLocation.parentLocationID];
                MMLocationInformation *parentLocation = [[locationInformations filteredArrayUsingPredicate:parentIdPredicate] lastObject];
                
                if(!parentLocation){
                    continue;
                }

                subLocation.parentLocation = parentLocation;
                
                NSMutableSet *subLocationsSet = [NSMutableSet set];
                [subLocationsSet addObjectsFromArray:parentLocation.sublocations.allObjects];
                
                [subLocationsSet addObject:subLocation];
                
                parentLocation.sublocations = subLocationsSet;
                
                NSUInteger parentIndex = [locationInformations indexOfObject:parentLocation];
                
                [locationInformations replaceObjectAtIndex:parentIndex withObject:parentLocation];
                
            
            }
        }
        
        
        success(operation, locationInformations);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
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

+ (void)getBookmarkLocationInformationOnSuccess:(void (^)(AFHTTPRequestOperation *operation, NSArray *locationInformations ))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [[MMHTTPClient sharedClient] getPath:@"bookmarks" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *locationInformations = [NSMutableArray array];
        
        for(NSDictionary *locationDictionary in responseObject){
            NSLog(@"Location Dictionary: %@", locationDictionary);
            MMLocationInformation *locationInformation = [self locationInformationForLocationDictionary:locationDictionary];
            
            [locationInformations addObject:locationInformation];
        }
        
        success(operation, locationInformations);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(operation, error);
        
    }];
    
    
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
    NSLog(@"URL: %@", urlParams);
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
        
        NSLog(@"JSON for Location: %@", responseObject);

         MMLocationInformation *locationInformation = [[MMLocationInformation alloc] init];
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *json = responseObject;
            
            locationInformation.locationID = [json objectForKey:@"locationId"];
            locationInformation.providerID = [json objectForKey:@"providerId"];
            locationInformation.street = [json objectForKey:@"address"];
            locationInformation.details = [json objectForKey:@"details"];
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
            locationInformation.message = [json objectForKey:@"message"];
            locationInformation.parentLocationID = [json objectForKey:@"parentLocationId"];
            locationInformation.parentProviderID = [json objectForKey:@"parentProviderId"];
            
            if([locationInformation.message isEqual:[NSNull null]] || locationInformation.message.length <= 0){
                locationInformation.message = @"See what's happening now on MobMonkey!";
                locationInformation.messageURL = [NSURL URLWithString:@"http://mobmonkey.com"];
            }else{
                NSString *urlPath = [json objectForKey:@"messageUrl"];
                if(urlPath && ![urlPath isEqual:[NSNull null]]){
                    locationInformation.messageURL = [NSURL URLWithString:urlPath];
                }
            }
            
            locationInformation.livestreaming = [json objectForKey:@"livestreaming"];
            locationInformation.videos = [json objectForKey:@"videos"];
            locationInformation.images = [json objectForKey:@"images"];
            locationInformation.monkeys = [json objectForKey:@"monkeys"];
            
        
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


+(void)createSubLocationWithLocationInformation:(MMLocationInformation *)locationInformation success:(void (^)(void))success failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if(!locationInformation.latitude){
        [parameters setObject:locationInformation.parentLocation.latitude forKey:@"latitude"];
    } else {
        [parameters setObject:locationInformation.latitude forKey:@"latitude"];
    }
    if(!locationInformation.longitude){
        [parameters setObject:locationInformation.parentLocation.longitude forKey:@"longitude"];
    } else {
        [parameters setObject:locationInformation.longitude forKey:@"longitude"];
    }
   // if(locationInformation.parentLocation.street)[parameters setObject:locationInformation.parentLocation.street forKey:@"address"];
    if(locationInformation.parentLocation.categories)[parameters setObject:locationInformation.parentLocation.categories forKey:@"categoryIds"];
    if(locationInformation.parentLocation.country)[parameters setObject:locationInformation.parentLocation.country forKey:@"countryCode"];
    if(locationInformation.parentLocation.locality)[parameters setObject:locationInformation.parentLocation.locality forKey:@"locality"];
    if(locationInformation.parentLocation.phoneNumber)[parameters setObject:locationInformation.parentLocation.phoneNumber forKey:@"phoneNumber"];
    if(locationInformation.parentLocation.zipCode)[parameters setObject:locationInformation.parentLocation.zipCode forKey:@"postcode"];
    [parameters setObject:@"e048acf0-9e61-4794-b901-6a4bb49c3181" forKey:@"providerId"];
    if(locationInformation.parentLocation.region)[parameters setObject:locationInformation.parentLocation.region forKey:@"region"];
    if(locationInformation.parentLocation.website)[parameters setObject:locationInformation.parentLocation.website forKey:@"webSite"];
    
    if(locationInformation.name)
    [parameters setObject:locationInformation.name forKey:@"name"];
    
    
    [parameters setObject:locationInformation.parentLocation.locationID forKey:@"parentLocationId"];
    [parameters setObject:locationInformation.parentLocation.providerID forKey:@"parentProviderId"];
    
    [[MMHTTPClient sharedClient] putPath:@"location" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        failure(error);
    }];

}


+(NSDictionary *)locationDictionaryForLocationInformation:(MMLocationInformation *)locationInformation{
    
    NSMutableDictionary *locationDictionary = [NSMutableDictionary dictionary];
    
    locationInformation.locationID ? [locationDictionary setObject:locationInformation.locationID forKey:@"locationId"] : nil;
    locationInformation.providerID ? [locationDictionary setObject:locationInformation.providerID forKey:@"providerId"] : nil;
    locationInformation.street ? [locationDictionary setObject:locationInformation.street forKey:@"address"] : nil;
    locationInformation.details ? [locationDictionary setObject:locationInformation.details forKey:@"details"] : nil;
    locationInformation.unitNumber ? [locationDictionary setObject:locationInformation.unitNumber forKey:@"address_ext"] : nil;
    locationInformation.categories ? [locationDictionary setObject:locationInformation.categories forKey:@"categoryIds"] : nil;
    locationInformation.country ? [locationDictionary setObject:locationInformation.country forKey:@"countryCode"] : nil;
    locationInformation.latitude ? [locationDictionary setObject:locationInformation.latitude forKey:@"latitude"] : nil;
    locationInformation.longitude ? [locationDictionary setObject:locationInformation.longitude forKey:@"longitude"] : nil;
    locationInformation.locality ? [locationDictionary setObject:locationInformation.locality forKey:@"locality"] : nil;
    locationInformation.name ? [locationDictionary setObject:locationInformation.name forKey:@"name"] : nil;
    locationInformation.neighborhood ? [locationDictionary setObject:locationInformation.neighborhood forKey:@"neighborhood"] : nil;
    locationInformation.phoneNumber ? [locationDictionary setObject:locationInformation.phoneNumber forKey:@"phoneNumber"] : nil;
    locationInformation.zipCode ? [locationDictionary setObject:locationInformation.zipCode forKey:@"postCode"] : nil;
    locationInformation.state ? [locationDictionary setObject:locationInformation.state forKey:@"region"] : nil;
    locationInformation.region ? [locationDictionary setObject:locationInformation.region forKey:@"region"] : nil;
    locationInformation.website ? [locationDictionary setObject:locationInformation.website forKey:@"webSite"] : nil;
    locationInformation.isBookmark ? [locationDictionary setObject:[NSNumber numberWithBool:locationInformation.isBookmark] forKey:@"bookmark"] : nil;
    locationInformation.message ? [locationDictionary setObject:locationInformation.message forKey:@"message"] : nil;
    locationInformation.livestreaming ? [locationDictionary setObject:locationInformation.livestreaming forKey:@"livestreaming"] : nil;
    locationInformation.videos ? [locationDictionary setObject:locationInformation.videos forKey:@"videos"] : nil;
    locationInformation.images ? [locationDictionary setObject:locationInformation.images forKey:@"images"] : nil;
    locationInformation.monkeys ? [locationDictionary setObject:locationInformation.monkeys forKey:@"monkeys"] : nil;
    locationInformation.messageURL ? [locationDictionary setObject:locationInformation.messageURL forKey:@"messageURL"] : nil;
    
   
    return locationDictionary;
    
    
    
}


+(MMLocationInformation *)locationInformationForLocationDictionary:(NSDictionary *)locationDictionary{
    
    MMLocationInformation *locationInformation = [[MMLocationInformation alloc] init];
    
    locationInformation.locationID = [locationDictionary objectForKey:@"locationId"];
    locationInformation.providerID = [locationDictionary objectForKey:@"providerId"];
    locationInformation.street = [locationDictionary objectForKey:@"address"];
    locationInformation.details = [locationDictionary objectForKey:@"details"];
    locationInformation.unitNumber = [locationDictionary objectForKey:@"address_ext"];
    locationInformation.categories = [locationDictionary objectForKey:@"categoryIds"];
    locationInformation.country = [locationDictionary objectForKey:@"countryCode"];
    locationInformation.latitude = [locationDictionary objectForKey:@"latitude"]; //warn
    locationInformation.longitude = [locationDictionary objectForKey:@"longitude"];//warn
    locationInformation.locality = [locationDictionary objectForKey:@"locality"];
    locationInformation.name = [locationDictionary objectForKey:@"name"];
    locationInformation.neighborhood = [locationDictionary objectForKey:@"neighborhood"];
    locationInformation.phoneNumber = [locationDictionary objectForKey:@"phoneNumber"];
    locationInformation.zipCode = [locationDictionary objectForKey:@"postCode"];
    locationInformation.region = [locationDictionary objectForKey:@"region"];
    locationInformation.state = [locationDictionary objectForKey:@"region"];
    locationInformation.website = [locationDictionary objectForKey:@"webSite"];
    locationInformation.isBookmark = ((NSNumber*)[locationDictionary objectForKey:@"bookmark"]).boolValue;
    locationInformation.message = [locationDictionary objectForKey:@"message"];
    locationInformation.livestreaming = [locationDictionary objectForKey:@"livestreaming"];
    locationInformation.videos = [locationDictionary objectForKey:@"videos"];
    locationInformation.images = [locationDictionary objectForKey:@"images"];
    locationInformation.monkeys = [locationDictionary objectForKey:@"monkeys"];
    locationInformation.parentLocationID = [locationDictionary objectForKey:@"parentLocationId"];
    locationInformation.messageURL = [NSURL URLWithString:@"http://mobmonkey.com"];
    
    return locationInformation;
    
}

@end
