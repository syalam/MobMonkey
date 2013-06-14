//
//  MMGooglePlacesCitySearch.h
//  MobMonkey
//
//  Created by Michael Kral on 6/13/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMGoogleCityDataObject : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D cooridnates;
@property (nonatomic, strong) NSString * formattedLocalityPoliticalGeocodeString;
@property (nonatomic, strong) NSString * referenceID;

@property (nonatomic, assign, readonly) BOOL isUpdated;


+(MMGoogleCityDataObject *)googleCityObjectFromJSONDictionary:(NSDictionary *)jsonDictionary;

-(void)updatePlaceWithDetails:(void(^)(MMGoogleCityDataObject * updatedObject, NSError * error))complete;


@end

@interface MMGooglePlacesCitySearch : NSObject

@property (nonatomic, strong) NSString * apiKey;


+(MMGooglePlacesCitySearch *)sharedCitySearch;

-(void)searchCityNamesForSearchString:(NSString *)searchString atCoordinate:(CLLocationCoordinate2D)coordinate success:(void(^)(NSArray * googleCityObjects))success failure:(void(^)(NSError *error))failure;

-(CLLocationCoordinate2D)coordinatesForGoogleID:(NSString *)googleID;

-(void)updateGoogleCityObjectDetails:(MMGoogleCityDataObject *)googleCityObject completion:(void(^)(MMGoogleCityDataObject * updatedObject, NSError * error))completion;

@end
