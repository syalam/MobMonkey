//
//  MMLocationSearch.h
//  MobMonkey
//
//  Created by Michael Kral on 4/19/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RadiusInMiles5,
    RadiusInMiles10,
    RadiusInMiles20
} RadiusInMiles;

@interface MMLocationSearch : NSObject

-(void)locationsForCategory:(NSDictionary *)category searchString:(NSString *)searchString success:(void(^)(NSArray * locations))success failure:(void(^)(NSError *error))failure;

-(void)locationsInfoForCategory:(NSDictionary *)category searchString:(NSString *)searchString success:(void(^)(NSArray * locationInformations))success failure:(void(^)(NSError *error))failure;

-(void)locationsInfoForCategory:(NSDictionary *)category searchString:(NSString *)searchString rangeInYards:(NSNumber*)yards success:(void(^)(NSArray * locationInformations))success failure:(void(^)(NSError *error))failure;

-(void)testLocationsComplete:(void(^)(NSArray * locations))completion;

@end
