//
//  MMGeographicalLocation.m
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMGeographicalLocation.h"
#import "MMFactualAPI.h"

@implementation MMGeographicalLocation

-(NSString *)formattedGeographicName {
    
    NSMutableString * formattedName = [NSMutableString string];
    if(self.locality){
        [formattedName appendFormat:@"%@, ", self.locality];
    }
    
    if(self.region){
        [formattedName appendFormat:@"%@, ", self.region];
    }
    
    if(self.country) {
        [formattedName appendFormat:@"%@, ", self.country];
    }
    
    if(formattedName.length <= 0){
        return nil;
    }
    
    //remove the last space and comma from the string
    return [formattedName substringToIndex:[formattedName length] - 2];
}

+(void)getGeographicalLocationsThatStartWith:(NSString *)searchString
                                     success:(void (^)(NSArray *))success
                                     failure:(void (^)(NSError *))failure {
    
    FactualQuery * query = [FactualQuery query];
    query.limit = 10;
    FactualRowFilter *nameSearchFilter = [FactualRowFilter fieldName:@"name" beginsWith:searchString];
    FactualRowFilter *countryUSFilter = [FactualRowFilter fieldName:@"country" equalTo:@"US"];
    FactualRowFilter *countryCAFilter = [FactualRowFilter fieldName:@"country" equalTo:@"CA"];
    FactualRowFilter *countryGBFilter = [FactualRowFilter fieldName:@"country" equalTo:@"GB"];
    FactualRowFilter *localityFilter = [FactualRowFilter fieldName:@"placetype" equalTo:@"locality"];
    
    [query addRowFilter:nameSearchFilter];
    [query addRowFilter:countryCAFilter];
    [query addRowFilter:countryGBFilter];
    [query addRowFilter:countryUSFilter];
    [query addRowFilter:localityFilter];
    
    
    MMFactualOperation *operation = [MMFactualOperation factualOperationWithQuery:query onTable:@"world-geographies" setSuccessBlock:^(FactualQueryResult *queryResult) {
        
        NSMutableArray * geographicLocations = [NSMutableArray arrayWithCapacity:queryResult.rowCount];
        for(FactualRow *row in queryResult.rows){
            NSLog(@"DATA: %@",row.namesAndValues);
            
            MMGeographicalLocation *location = [[MMGeographicalLocation alloc] init];
            location.locality = [row valueForName:@""];
        }
        if(success){
            //success(placeItems);
        }

        
    } setFailureBlock:^(NSError *error) {
        if(failure){
            failure(error);
        }
    }];
    
    
}


@end
