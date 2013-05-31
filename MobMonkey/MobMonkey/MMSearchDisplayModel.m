//
//  MMSearchDisplayModel.m
//  MobMonkey
//
//  Created by Michael Kral on 5/30/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMSearchDisplayModel.h"
#import "MMFactualAPI.h"

@implementation MMSearchItem

+(MMSearchItem *)searchItemWithText:(NSString *)text accessoryType:(UITableViewCellAccessoryType)accessoryType badgeCount:(NSNumber *)badgeCount {
    MMSearchItem *searchItem = [[self alloc] init];
    
    searchItem.mainText = text;
    searchItem.accessoryType = accessoryType;
    searchItem.badgeCount = badgeCount;
    
    return searchItem;
}
+(MMSearchItem *)searchItemWithText:(NSString *)text accessoryType:(UITableViewCellAccessoryType)accessoryType {
    return [self searchItemWithText:text accessoryType:accessoryType badgeCount:nil];
}
+(MMSearchItem *)searchItemWithText:(NSString *)text {
    return [self searchItemWithText:text accessoryType:UITableViewCellAccessoryNone badgeCount:nil];
}

@end

@interface MMSearchDisplayModel ()

@property (nonatomic, strong) NSArray *categories;

@end

@implementation MMSearchDisplayModel

-(id)init {
    if(self = [super init]){
        _categories = @[@"Dog Parks", @"Museums", @"Day Care", @" Dance Studio", @"Music Hall"];
        _factualAPI = [[FactualAPI alloc] initWithAPIKey:@"4CghCzGRA37VHpyToY97L7W4QGUG9IGz3rzZQbru" secret:@"X4ZXy7AdLnRrmjkBn9GjQgANDiqVOz2sS2IZdigQ"];
    }
    return self;
}


-(NSArray *)defaultSearchItems {
    
    
    MMSearchItem * whatsHappeningItem = [MMSearchItem searchItemWithText:@"What's Happening Nearby"
                                                           accessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    MMSearchItem * searchByCategoryItem = [MMSearchItem searchItemWithText:@"Search By Category"
                                                             accessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    MMSearchItem * recentlyViewedPlacesItem = [MMSearchItem searchItemWithText:@"Recently Viewed Places"
                                                                 accessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    MMSearchItem * myFavoritesItem = [MMSearchItem searchItemWithText:@"My Favorites"
                                                        accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                                           badgeCount:@0];
    
    MMSearchItem * myInterestsItem = [MMSearchItem searchItemWithText:@"My Interests"
                                                        accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                                           badgeCount:@0];
    
    
    
    return @[whatsHappeningItem, searchByCategoryItem, recentlyViewedPlacesItem, myFavoritesItem, myInterestsItem];
    
}

-(NSArray *)categoriesMatchingSearchString:(NSString *)searchString {
    NSPredicate * resultPredicate = [NSPredicate
                                     predicateWithFormat:@"self BEGINSWITH[cd] %@",
                                     searchString];
    
    NSArray * filteredCategoryNames = [self.categories filteredArrayUsingPredicate:resultPredicate];
    
    NSMutableArray *filteredCategories = [NSMutableArray arrayWithCapacity:filteredCategoryNames.count];
    
    for(NSString *categoryName in filteredCategoryNames){
        
        MMSearchItem *searchItem = [MMSearchItem searchItemWithText:categoryName];
        
        [filteredCategories addObject:searchItem];
        
    }
    
    return filteredCategories;
    
}
-(void)placesMatchingSearchString:(NSString *)searchString atLocation:(CLLocationCoordinate2D)coordinates radius:(NSNumber *)radiusInMeters success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    
    if(_singleOperation){
        [_singleOperation cancelRequest];
        _singleOperation = nil;
    }

    FactualQuery * query = [FactualQuery query];
    
    query.limit = 50;
    
    [query setGeoFilter:coordinates radiusInMeters:radiusInMeters.doubleValue];
    
    FactualRowFilter *nameFilter = [FactualRowFilter fieldName:@"name" beginsWith:searchString];
    
    [query addRowFilter:nameFilter];
    
     _singleOperation = [MMFactualOperation factualOperationWithQuery:query onTable:@"places" setSuccessBlock:^(FactualQueryResult *queryResult) {
        
        NSMutableArray * placeItems = [NSMutableArray arrayWithCapacity:queryResult.rowCount];
        
        for(FactualRow *row in queryResult.rows){
            MMSearchItem *placeItem = [MMSearchItem searchItemWithText:[row valueForName:@"name"]];
            [placeItems addObject:placeItem];
        }
        if(success){
            success(placeItems);
        }
        
        
    } setFailureBlock:^(NSError *error) {
        NSLog(@"Query Failed: %@", error);
        
        if(failure){
            failure(error);
        }
        
    }];
    
    [_singleOperation start];
    
}
-(void)placesMatchingSearchString:(NSString *)searchString success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    [self placesMatchingSearchString:searchString atLocation:self.coordinates radius:@100 success:success failure:failure];
}

@end
