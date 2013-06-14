//
//  MMGooglePlacesCitySearch.m
//  MobMonkey
//
//  Created by Michael Kral on 6/13/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMGooglePlacesCitySearch.h"
#import "AFNetworking/AFNetworking.h"


@implementation MMGoogleCityDataObject


+(MMGoogleCityDataObject *)googleCityObjectFromJSONDictionary:(NSDictionary *)jsonDictionary {
    
    MMGoogleCityDataObject * googleCityObject = [[MMGoogleCityDataObject alloc] init];
    
    
    googleCityObject.referenceID = [jsonDictionary objectForKey:@"reference"];
    
    googleCityObject.formattedLocalityPoliticalGeocodeString = [jsonDictionary objectForKey:@"description"];
    
    
    return googleCityObject;
    
}

-(void)updatePlaceWithDetails:(void (^)(MMGoogleCityDataObject *, NSError *))complete {
    
    //Do not update if the object is already updated.
    if(_isUpdated){
        if(complete){
            complete(self, nil);
        }
        return;
    }
    
    _isUpdated = YES;
    
    [[MMGooglePlacesCitySearch sharedCitySearch] updateGoogleCityObjectDetails:self completion:^(MMGoogleCityDataObject *updatedObject, NSError *error) {
        if(complete){
            complete(updatedObject, error);
        }
    }];
}

#pragma mark - Encoder to Save to NSUserDefaults
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.referenceID forKey:@"referenceID"];
    [encoder encodeDouble:self.cooridnates.latitude forKey:@"latitude"];
    [encoder encodeDouble:self.cooridnates.longitude forKey:@"longitude"];
    [encoder encodeObject:self.formattedLocalityPoliticalGeocodeString forKey:@"formattedCityString"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.referenceID = [decoder decodeObjectForKey:@"referenceID"];
        self.cooridnates = CLLocationCoordinate2DMake([decoder decodeDoubleForKey:@"latitude"], [decoder decodeDoubleForKey:@"longitude"]);
        self.formattedLocalityPoliticalGeocodeString = [decoder decodeObjectForKey:@"formattedCityString"];
    }
    return self;
}

@end

@interface MMGooglePlacesCitySearch()

@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, strong) AFJSONRequestOperation * currentOperation;
@property (nonatomic, strong) AFHTTPClient * httpClient;

@end

@implementation MMGooglePlacesCitySearch

#pragma mark - Singleton Method
+(id)sharedCitySearch{
    static MMGooglePlacesCitySearch *_sharedCitySearch = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCitySearch = [[MMGooglePlacesCitySearch alloc] init];
        _sharedCitySearch.apiKey = @"AIzaSyAzS0KYAcdc3tJ-66r4yA5PdLJ_gBHl8vM";
        NSString * baseURLPath = @"https://maps.googleapis.com/";
        _sharedCitySearch.httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseURLPath]];
    });
    
    return _sharedCitySearch;
}

-(MMGoogleCityDataObject *)updateGoogleCityObjectDetails:(MMGoogleCityDataObject *)googleCityObject withGooglePlaceDetailJSONDictionary:(NSDictionary *)jsonDictionary {
    //This method can expand to collect more information but for now it's just for lat/lng
    
    NSDictionary * geometry = [jsonDictionary objectForKey:@"geometry"];
    
    if(geometry){
        NSDictionary * locationCoordinateDictionary = [geometry objectForKey:@"location"];
        
        if(locationCoordinateDictionary){
            NSNumber * latitude = [locationCoordinateDictionary objectForKey:@"lat"];
            NSNumber * longitude = [locationCoordinateDictionary objectForKey:@"lng"];
            
            if(latitude && longitude){
                googleCityObject.cooridnates = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
            }

        }
        
    }
    
    return googleCityObject;
 
}

-(void)updateGoogleCityObjectDetails:(MMGoogleCityDataObject *)googleCityObject
                          completion:(void(^)(MMGoogleCityDataObject * updatedObject, NSError * error))completion{
    
    NSString * urlPath = @"maps/api/place/details/json";
    
    __block MMGoogleCityDataObject * updatedGoogleCityObject = googleCityObject;
    
    
    //Get Parameters
    
    NSDictionary * parameters = @{@"reference":googleCityObject.referenceID,
                                  @"sensor":@"true",
                                  @"key":self.apiKey
                                };
    
    NSMutableURLRequest * request = [self.httpClient requestWithMethod:@"GET" path:urlPath parameters:parameters];
    
    AFJSONRequestOperation * operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary * detailedPlaceDictionary = [JSON objectForKey:@"result"];
        
        updatedGoogleCityObject = [self updateGoogleCityObjectDetails:googleCityObject withGooglePlaceDetailJSONDictionary:detailedPlaceDictionary];
        
        if(completion){
            completion(updatedGoogleCityObject, nil);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(completion){
            completion(nil, error);
        }
        
    }];
    
    [operation start];
    
}
-(void)searchCityNamesForSearchString:(NSString *)searchString
                              atCoordinate:(CLLocationCoordinate2D)coordinate
                                   success:(void(^)(NSArray * googleCityObjects))success
                                   failure:(void(^)(NSError *error))failure {
    
    
    _isSearching = YES;
    
    NSString * urlPath = @"maps/api/place/autocomplete/json";
    
    
    //Get Parameters
    
    NSDictionary * parameters = @{@"input":searchString,
                                         @"types":@"(cities)",
                                         @"location":[NSString stringWithFormat:@"%f, %f", coordinate.latitude, coordinate.longitude],
                                         @"radius":@160934, //Biased to cities within 100 miles
                                         @"sensor":@"true",
                                         @"key":self.apiKey,
                                         @"components":@"country:us"};
    
    NSMutableURLRequest * request = [self.httpClient requestWithMethod:@"GET" path:urlPath parameters:parameters];
    
    
    AFJSONRequestOperation * currentOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray * cityPredictions = [JSON objectForKey:@"predictions"];
        
        NSMutableArray * googleCityObjects = [NSMutableArray arrayWithCapacity:cityPredictions.count];
        
        for(NSDictionary * predictionDictionary in cityPredictions){
            
            MMGoogleCityDataObject * cityObject = [MMGoogleCityDataObject googleCityObjectFromJSONDictionary:predictionDictionary];
            
            [googleCityObjects addObject:cityObject];
            
        }
        
        if(success){
            success(googleCityObjects);
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        if(failure){
            failure(error);
        }
        
    }];
    
    [currentOperation start];
    
}


@end
