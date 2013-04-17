#import "MMHTTPClient.h"

#import "AFJSONRequestOperation.h"

#ifdef STAGING

static NSString * const kBMHTTPClientBaseURLString = @"http://staging.mobmonkey.com/rest/";
static NSString * const kBMHTTPClientApplicationID = @"29C851C2-CF6F-11E1-A0EC-4CE76188709B";
static NSString * const kBMHTTPClientApplicationSecret = @"305F0990-CF6F-11E1-BE33-4DE76188709B";

#elif PRODUCTION

static NSString * const kBMHTTPClientBaseURLString = @"http://api.mobmonkey.com/rest/";
static NSString * const kBMHTTPClientApplicationID = @"29C851C2-CF6F-11E1-A0EC-4CE76188709B";
static NSString * const kBMHTTPClientApplicationSecret = @"305F0990-CF6F-11E1-BE33-4DE76188709B";

#endif


@implementation MMHTTPClient

+ (MMHTTPClient *)sharedClient {
    static MMHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[MMHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBMHTTPClientBaseURLString]];
        
        [_sharedClient setDefaultHeader:@"MobMonkey-partnerId" value:[[NSUserDefaults standardUserDefaults]objectForKey:@"mmPartnerId"]];
        
        [_sharedClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    });
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"oauthUser"]) {
        [_sharedClient setDefaultHeader:@"MobMonkey-auth" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
        [_sharedClient setDefaultHeader:@"MobMonkey-user" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    }
    else {
        [_sharedClient setDefaultHeader:@"OauthProviderUserName" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
        [_sharedClient setDefaultHeader:@"OauthProvider" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"oauthProvider"]];
        [_sharedClient setDefaultHeader:@"OauthToken" value:[[NSUserDefaults standardUserDefaults]valueForKey:@"oauthToken"]];
    }

    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }

    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];

    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setDefaultHeader:@"MobMonkey-partnerId" value:kBMHTTPClientApplicationID];
    [self setParameterEncoding:AFJSONParameterEncoding];

    return self;
}

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
           data:(NSData*)data
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters data:data];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}


- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
            data:(NSData*)data
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURLRequest *request = [self requestWithMethod:@"POST" path:path     parameters:parameters data:data];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    [self enqueueHTTPRequestOperation:operation];
}

- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
           data:(NSData*)data
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURLRequest *request = [self requestWithMethod:@"PUT" path:path parameters:parameters data:data];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)deletePath:(NSString *)path
     parameters:(NSDictionary *)parameters
           data:(NSData*)data
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURLRequest *request = [self requestWithMethod:@"DELETE" path:path parameters:parameters data:data];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

-(NSMutableURLRequest*)requestWithMethod:(NSString *)method
                                    path:(NSString *)path
                              parameters:(NSDictionary *)parameters
                                    data:(NSData*)data;
{
    NSMutableURLRequest* request = [super requestWithMethod:method
                                                       path:path
                                                 parameters:parameters];

    [request setHTTPBody:data];

    return request;
}

-(NSString*)applicationID
{
    return kBMHTTPClientApplicationID;
}

-(NSString*)applicationSecret
{
    return kBMHTTPClientApplicationSecret;
}

@end
