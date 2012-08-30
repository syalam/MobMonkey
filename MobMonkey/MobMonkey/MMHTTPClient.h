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
-(NSMutableURLRequest*)requestWithMethod:(NSString *)method 
                                    path:(NSString *)path 
                              parameters:(NSDictionary *)parameters 
                                    data:(NSData*)data;

-(NSString*)applicationID;
-(NSString*)applicationSecret;
@end
