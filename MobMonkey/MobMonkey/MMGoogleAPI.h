//
//  MMGoogleAPI.h
//  MobMonkey
//
//  Created by Michael Kral on 5/17/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMCityInfo : NSObject

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *stateAbbreviation;
@property (nonatomic, strong) NSString *cityZipCode;

@property (nonatomic, assign) CLLocationCoordinate2D locationCoordinate;
@property (nonatomic, assign) NSNumber *cityRadiusInYards;

@end

@interface MMGoogleAPI : NSObject

+(void)getCityInfoForCity:(NSString *)city andState:(NSString *)stateAbbreviation
                  success:(void(^)(MMCityInfo *cityInfo))success
                  failure:(void(^)(NSError * error))failure;

+(void)getCityInforForZipCode:(NSString*)zipCode
                      success:(void(^)(MMCityInfo *cityInfo))success
                      failure:(void(^)(NSError * error))failure;

+(void)cityInfoForSearch:(NSString *)searchParameter success:(void(^)(MMCityInfo *cityInfo))success failure:(void(^)(NSError * error))failure;


@end
