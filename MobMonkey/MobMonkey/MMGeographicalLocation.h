//
//  MMGeographicalLocation.h
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMGeographicalLocation : NSObject

@property (nonatomic, strong) NSString *locality;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, assign) CLLocationCoordinate2D coordinates;
@property (nonatomic, strong) NSString *factualID;

-(NSString *)formattedGeographicName;

+(void)getGeographicalLocationsThatStartWith:(NSString *)searchString
                                     success:(void(^)(NSArray * geographicalLocations))success
                                     failure:(void(^)(NSError *error))failure;

@end
