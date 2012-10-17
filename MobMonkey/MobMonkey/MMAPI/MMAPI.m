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
-(void)signUpNewUser:(NSDictionary*)params {
    NSLog(@"%@", params);
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient  postPath:@"signup/user" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON){
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
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    //[httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient  postPath:@"signin/user" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
    }];
}

+ (void)signInWithEmail:(NSString *)email
               password:(NSString *)password
               provider:(OAuthProvider)provider
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    MMHTTPClient *httpClient = [[MMHTTPClient alloc] initWithBaseURL:[self baseURL]];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:email];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:password];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults] objectForKey:@"mmPartnerId"]];
    [httpClient postPath:@"signin/iOS/12341234123123123123123123123123" parameters:nil success:success failure:failure];
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
                    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Unable to log you in. Please try again." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease];
                    [alert show];
                }
                
            }];
        }
    }];
}

-(void)signUpWithFacebook:(NSDictionary*)params
{
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient  postPath:@"signup/user/oauth/facebook" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
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
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient  postPath:[NSString stringWithFormat:@"requestmedia/%@", mediaType] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
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
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient  postPath:[NSString stringWithFormat:@"media/%@", mediaType] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
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
-(void)categories {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient  getPath:@"category" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
    }];
    
    /*NSMutableArray *categoriesArray = [[NSMutableArray alloc]initWithObjects:@"Health Clubs", @"Coffee Shops", @"Nightclubs", @"Pubs/Bars", @"Restaurants", @"Supermarkets", @"Cinemas", @"Dog Parks", @"Beaches", @"Hotels", @"Stadiums", @"Conferences" , @"Middle Schools & High Schools", nil];
    
    return categoriesArray;*/
}

+ (void)getCategoriesOnSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient  getPath:@"category" parameters:nil success:success failure:failure];
}

#pragma mark - Add Location
-(void)addNewLocation:(NSDictionary*)params
{
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient  postPath:@"/location" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
    }];
}

#pragma mark - Inbox 
-(void)openRequests
{
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient  getPath:@"inbox/openrequests" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
    }];
}

-(void)assignedRequests
{
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient  getPath:@"inbox/assignedrequests" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
    }];
}

- (void)fulfilledRequests {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient  getPath:@"inbox/fulfilledrequests" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
    }];
}

#pragma mark - User Checkin
-(void)checkUserIn:(NSDictionary*)params {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient  postPath:@"checkin" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
    }];
}

#pragma mark - Search
- (void)globSearchForLocation:(NSDictionary*)params {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient  postPath:@"search/location/glob" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
    }];
}

- (void)searchForLocation:(NSDictionary*)params {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient  postPath:@"search/location" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", JSON);
        [_delegate MMAPICallSuccessful:JSON];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate MMAPICallFailed:operation];
    }];
}

+ (void)searchForLocation:(NSDictionary*)params
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [MMHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient  postPath:@"search/location" parameters:params success:success failure:failure];
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

/**
+ (void)deleteBookmarkWithLocationID:(NSString *)locationID
                          providerID:(NSString *)providerID
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    MMHTTPClient *httpClient = [[MMHTTPClient alloc] initWithBaseURL:[self baseURL]];
    [httpClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    [httpClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [httpClient deletePath:@"bookmarks" parameters:@{ @"locationId" : locationID , @"providerId" : providerID } success:success failure:failure];
}
 */
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

@end
