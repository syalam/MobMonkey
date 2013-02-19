//
//  FLAsanaClient.h
//  Firelog
//
//  Created by Sheehan Alam on 6/10/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface MMHTTPClient : AFHTTPClient
+(MMHTTPClient *)sharedClient;
- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
           data:(NSData*)data
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
            data:(NSData*)data
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
           data:(NSData*)data
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)deletePath:(NSString *)path
        parameters:(NSDictionary *)parameters
              data:(NSData*)data
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(NSMutableURLRequest*)requestWithMethod:(NSString *)method 
                                    path:(NSString *)path 
                              parameters:(NSDictionary *)parameters 
                                    data:(NSData*)data;

-(NSString*)applicationID;
-(NSString*)applicationSecret;
@end
