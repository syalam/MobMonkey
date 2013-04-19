//
//  MMLocationSearch.m
//  MobMonkey
//
//  Created by Michael Kral on 4/19/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMLocationSearch.h"

#import "MMAPI.h"

@implementation MMLocationSearch

-(void)locationsForCategory:(NSDictionary *)category searchString:(NSString *)searchString success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

    NSNumber * radius = [standardUserDefaults valueForKey:@"savedSegmentValue"];
    NSString * categoryID = category[@"categoryId"];
    
    double lat = [[standardUserDefaults valueForKey:@"latitude"] doubleValue];
    double lng = [[standardUserDefaults valueForKey:@"longitude"] doubleValue];
    
    NSString *mediaType;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"liveFeedFilter"]) {
        mediaType = @"3";
    }
    
    NSNumber *latitude = [NSNumber numberWithDouble:lat];
    NSNumber *longitude = [NSNumber numberWithDouble:lng];
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if(category){
        [parameters setObject:categoryID forKey:@"categoryIds"];
    }
    
    [parameters setObject:latitude forKey:@"latitude"];
    [parameters setObject:longitude forKey:@"longitude"];
    
    if(searchString){
        [parameters setObject:searchString forKey:@"name"];
    }else{
        [parameters setObject:@"" forKey:@"name"];
    }
    
    
    if(!radius){
        radius = [NSNumber numberWithInt:8800];
    }
    [parameters setObject:radius forKey:@"radiusInYards"];
    
    //NSDictionary *parameters = @{@"categoryIds":categoryID, @"latitude":latitude, @"longitude":longitude, @"name":@"", @"radiusInYards":radius};
    
    
    NSLog(@"Parameters: %@", parameters);
    [MMAPI searchForLocation:parameters.mutableCopy mediaType:mediaType success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success){
            
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure){
            failure(error);
        }
    }];
    
}
@end
