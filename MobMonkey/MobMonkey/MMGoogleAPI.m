//
//  MMGoogleAPI.m
//  MobMonkey
//
//  Created by Michael Kral on 5/17/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMGoogleAPI.h"
#import "AFNetworking.h"

@implementation MMCityInfo

@end

@implementation MMGoogleAPI


+(void)cityInfoForSearch:(NSString *)searchParameter success:(void(^)(MMCityInfo *cityInfo))success failure:(void(^)(NSError * error))failure {
    
    
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString :@"http://maps.googleapis.com/maps/api/"]];
    
    //Add city, state or zip
    NSString * path = [NSString stringWithFormat:@"geocode/json?address=%@&sensor=false", searchParameter];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        MMCityInfo *cityInfo = [[MMCityInfo alloc] init];
        
        NSDictionary *firstResult = [[JSON valueForKeyPath:@"results"] count] > 0 ? [[JSON valueForKeyPath:@"results"] objectAtIndex:0] : nil;
        
        if(firstResult){
            
            NSArray *types = [firstResult objectForKey:@"types"];
            
            if(types.count > 0){
                BOOL isCityOrZip = NO;
                for( NSString *type in types){
                    if([type isEqualToString:@"locality"] || [type isEqualToString:@"postal_code"]){
                        isCityOrZip = YES;
                        break;
                    }
                }
                
                if(isCityOrZip){
                    
                    NSDictionary *boundsDictionary = [firstResult valueForKeyPath:@"geometry.bounds"];
                    NSDictionary *locationDictionary = [firstResult valueForKeyPath:@"geometry.location"];
                    
                    NSNumber *latitude = [[JSON valueForKeyPath:@"results.geometry.location.lat"] lastObject];
                    NSNumber *longitude = [[JSON valueForKeyPath:@"results.geometry.location.lng"] lastObject];
                    
                    NSNumber *neLatitude = [boundsDictionary valueForKeyPath:@"northeast.lat"];
                    NSNumber *neLongitude = [boundsDictionary valueForKeyPath:@"northeast.lng"];
                    
                    NSNumber *swLatitude = [boundsDictionary valueForKeyPath:@"southwest.lat"];
                    NSNumber *swLongitude = [boundsDictionary valueForKeyPath:@"southwest.lng"];
                    
                    if(![latitude isEqual:[NSNull null]] &&
                       ![longitude isEqual:[NSNull null]] &&
                       ![neLatitude isEqual:[NSNull null]] &&
                       ![neLongitude isEqual:[NSNull null]] &&
                       ![swLatitude isEqual:[NSNull null]] &&
                       ![swLongitude isEqual:[NSNull null]]){
                        
                        
                        CLLocation *locA = [[CLLocation alloc] initWithLatitude:neLatitude.doubleValue longitude:neLongitude.doubleValue];
                        
                        CLLocation *locB = [[CLLocation alloc] initWithLatitude:swLatitude.doubleValue longitude:swLongitude.doubleValue ];
                        
                        CLLocationDistance distance = [locA distanceFromLocation:locB];
                        
                        double distanceInYards = distance * 1.09361; //Convert To Yards
                        
                        
                        cityInfo.locationCoordinate = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
                        cityInfo.cityRadiusInYards = [NSNumber numberWithDouble:distanceInYards / 2];
                        
                        if(success){
                            success(cityInfo);
                        }
                        
                    }else{//lat longs missing
                        if(failure){
                            failure(nil);
                            return;
                        }
                    }

                    
                    //TODO: FIX LOCATION DATA
                    
                }else{ // NOT CITY OR ZIP
                    if(failure){
                        failure(nil);
                        return;
                    }
                }
                
                
            }else{ // NO TYPES
                if(failure){
                    failure(nil);
                    return;
                }
            }
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failed: %@", error);
    }];
    
    [operation start];
    
}

@end
