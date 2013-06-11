//
//  MMTrendingMedia.m
//  MobMonkey
//
//  Created by Michael Kral on 5/15/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMTrendingMedia.h"
#import "MMAPI.h"
#import "MMMediaObject.h"

@implementation MMTrendingMedia


+(void)getTrendingMediaForType:(MMTrendingType)trendingType completion:(void (^)(NSArray *, NSError *))completion {
    
    NSMutableDictionary *parameters = [@{@"timeSpan":@"week"} mutableCopy];
    
    switch (trendingType) {
        case MMTrendingTypeFavorites:{
            [parameters setValue:@"true" forKey:@"bookmarksonly"];
            break;
        }
        case MMTrendingTypeMyInterests: {
            NSString *selectedInterestsKey = [NSString stringWithFormat:@"%@ selectedInterests", [[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
            NSDictionary *favorites = [[NSUserDefaults standardUserDefaults] valueForKey:selectedInterestsKey];
            NSString *favoritesParams = [[favorites allValues] componentsJoinedByString:@","];
            if (favoritesParams && ![favoritesParams isEqualToString:@""]) {
                [parameters setValue:favoritesParams forKey:@"categoryIds"];
                [parameters setValue:@"true" forKey:@"myinterests"];
            }

            break;
        }
        case MMTrendingTypeNearBy:
            //No parameters add
            break;
        case MMTrendingTypeTopViewed:{
            NSNumber * latitude = [[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"];
            NSNumber * longitude = [[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"];
            [parameters setValue:@"true" forKey:@"nearby"];
            [parameters setValue:[NSNumber numberWithDouble:latitude.doubleValue] forKey:@"latitude"];
            [parameters setValue:[NSNumber numberWithDouble:longitude.doubleValue] forKey:@"longitude"];
            [parameters setValue:[NSNumber numberWithInt:10000] forKey:@"radius"];
            break;
        }
            
            
        default:
            break;
    }
    
    [MMAPI getTrendingType:@"topviewed" params:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@", responseObject);
        
        
        
        NSMutableArray * trendingObjects = [NSMutableArray array];
        
        if([responseObject isKindOfClass:[NSArray class]]){
            for(NSDictionary *locationDictionary in responseObject){
                NSDictionary *mediaDictionary = [locationDictionary objectForKey:@"media"];
                
                
                
                if(![mediaDictionary isEqual:[NSNull null]] && mediaDictionary.allKeys.count > 0){
                    MMMediaObject *mediaObject = [MMMediaObject mediaObjectFromJSON:mediaDictionary];
                    mediaObject.nameOfPlace = [locationDictionary objectForKey:@"name"];
                    mediaObject.placeLocationID = [locationDictionary objectForKey:@"locationId"];
                    mediaObject.placeProviderID = [locationDictionary objectForKey:@"providerId"];
                    [trendingObjects addObject:mediaObject];
                }
            }
        }
        
        if(completion)
        completion(trendingObjects, nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(completion)
            completion(nil, error);

       
    }];
    
}
+(void)getTrendingMediaForAllTypesCompletion:(void (^)(NSArray *, MMTrendingType, NSError *))completion {
    
    //Favorites
    [self getTrendingMediaForType:MMTrendingTypeFavorites completion:^(NSArray *mediaObjects, NSError *error) {
        completion(mediaObjects, MMTrendingTypeFavorites, error);
    }];
    
    //Top Viewed
    [self getTrendingMediaForType:MMTrendingTypeTopViewed completion:^(NSArray *mediaObjects, NSError *error) {
        completion(mediaObjects, MMTrendingTypeTopViewed, error);
    }];
    
    //My interests
    [self getTrendingMediaForType:MMTrendingTypeMyInterests completion:^(NSArray *mediaObjects, NSError *error) {
        completion(mediaObjects, MMTrendingTypeMyInterests, error);
    }];
    
    //Nearby
    [self getTrendingMediaForType:MMTrendingTypeNearBy completion:^(NSArray *mediaObjects, NSError *error) {
        completion(mediaObjects, MMTrendingTypeNearBy, error);
    }];
}
@end
