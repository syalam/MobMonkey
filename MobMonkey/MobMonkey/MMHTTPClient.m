#import "MMHTTPClient.h"

#import "AFJSONRequestOperation.h"

static NSString * const kBMHTTPClientBaseURLString = @"http://50.112.125.134/API/";
static NSString * const kBMHTTPClientApplicationID = @"29C851C2-CF6F-11E1-A0EC-4CE76188709B";
static NSString * const kBMHTTPClientApplicationSecret = @"305F0990-CF6F-11E1-BE33-4DE76188709B";

/**
    TappForce API Credentials:
    API URL: http://50.112.125.134/API/
    ApplicationID: 29C851C2-CF6F-11E1-A0EC-4CE76188709B 
    ApplicationSecret: 305F0990-CF6F-11E1-BE33-4DE76188709B
*/

@implementation MMHTTPClient

+ (MMHTTPClient *)sharedClient {
    static MMHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[MMHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBMHTTPClientBaseURLString]];
    });
    
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
    [self setParameterEncoding:AFJSONParameterEncoding];
    
    return self;
}

- (void)postPath:(NSString *)path 
      parameters:(NSDictionary *)parameters 
            data:(NSData*)data
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    NSURLRequest *request = [self requestWithMethod:@"POST" path:path     parameters:parameters data:data];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)putPath:(NSString *)path 
     parameters:(NSDictionary *)parameters 
           data:(NSData*)data
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    NSURLRequest *request = [self requestWithMethod:@"PUT" path:path parameters:parameters data:data];
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
