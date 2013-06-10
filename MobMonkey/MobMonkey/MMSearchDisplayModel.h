//
//  MMSearchDisplayModel.h
//  MobMonkey
//
//  Created by Michael Kral on 5/30/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FactualSDK/FactualAPI.h>
#import <FactualSDK/FactualQuery.h>
#import "MMFactualOperation.h"

@interface MMFactualLocationItem : NSObject

@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *addressLine1;
@property (nonatomic, strong) NSString *addressLine2;
@property (nonatomic, assign) CLLocationCoordinate2D coordinates;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSString *factualId;

+(MMFactualLocationItem *)locationItemWithFactualID:(NSString*)factualID
                                       locationName:(NSString*)locationName
                                            address:(NSString *)address
                                               city:(NSString *)city
                                              state:(NSString *)state
                                        coordinates:(CLLocationCoordinate2D)coordinates;

@end

//Base Class for Search cell items
@interface MMSearchItem : NSObject

@property (nonatomic, strong) NSString *mainText;
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;
@property (nonatomic, strong) NSNumber *badgeCount;


+(MMSearchItem *)searchItemWithText:(NSString *)text;

+(MMSearchItem *)searchItemWithText:(NSString *)text
                      accessoryType:(UITableViewCellAccessoryType)accessoryType;

+(MMSearchItem *)searchItemWithText:(NSString *)text
                      accessoryType:(UITableViewCellAccessoryType)accessoryType
                         badgeCount:(NSNumber *)badgeCount;

+(MMSearchItem *)searchItemFromLocationInformation:(MMLocationInformation *)locationInformation;

@end



@interface MMSearchDisplayModel : NSObject <FactualAPIDelegate> {

}

@property (nonatomic, assign) CLLocationCoordinate2D coordinates;
@property (nonatomic, strong) FactualAPI *factualAPI;
@property (nonatomic, strong) FactualAPIRequest *activeRequest;
@property (nonatomic, strong) MMFactualOperation * singleOperation;

-(void)allCategoriesComplete:(void(^)(NSArray * categories , NSError * error))complete;
-(NSArray *)defaultSearchItems;
-(NSArray *)categoriesMatchingSearchString:(NSString *)searchString;
-(void)placesMatchingSearchString:(NSString *)searchString success:(void(^)(NSArray *searchItems))success failure:(void(^)(NSError * error))failure;
-(void)placesMatchingSearchString:(NSString *)searchString atLocation:(CLLocationCoordinate2D)coordinates radius:(NSNumber *)radiusInMeters success:(void(^)(NSArray *searchItems))success failure:(void(^)(NSError * error))failure;

@end
