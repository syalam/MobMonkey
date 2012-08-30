//
//  MMAPI.m
//  MobMonkey
//
//  Created by Sheehan Alam on 8/29/12.
//
//

#import "MMAPI.h"
#import "MMHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"

@implementation MMAPI
+ (MMAPI *)sharedAPI {
    static MMAPI *_sharedAPI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAPI = [[MMAPI alloc] init];
    });
    
    return _sharedAPI;
}

-(NSDictionary*)signUpNewUser:(NSDictionary*)params{
    [[MMHTTPClient sharedClient] postPath:@"Users" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON){
        //TODO: return the server response
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        id errorResponse = [(AFJSONRequestOperation *)operation responseJSON];
        NSLog(@"/Users Error: %@", [error localizedDescription]);
        NSLog(@"%@",errorResponse);
        [SVProgressHUD showErrorWithStatus:[errorResponse valueForKey:@"Message"]];
    }];
}
@end
