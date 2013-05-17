//
//  MMTrendingMedia.h
//  MobMonkey
//
//  Created by Michael Kral on 5/15/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

typedef enum {
    MMTrendingTypeFavorites = 1,
    MMTrendingTypeTopViewed,
    MMTrendingTypeMyInterests,
    MMTrendingTypeNearBy
    
} MMTrendingType;

#import <Foundation/Foundation.h>

@interface MMTrendingMedia : NSObject

+(void)getTrendingMediaForType:(MMTrendingType)trendingType completion:(void(^)(NSArray *mediaObjects, NSError * error))completion;

+(void)getTrendingMediaForAllTypesCompletion:(void(^)(NSArray * mediaObjects, MMTrendingType trendingType, NSError * error))completion;

@end
