//
//  MMLocationInformation.h
//  MobMonkey
//
//  Created by Michael Kral on 4/22/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
 
typedef enum {
    
    LocationCellTypeName = 100,
    LocationCellTypeCategories,
    LocationCellTypeStreet,
    LocationCellTypeCity,
    LocationCellTypeState,
    LocationCellTypeZip,
    LocationCellTypePhoneNumber,
    LocationCellTypeAddressBOOL,
    LocationCellTypeNotification
    
} LocationCellType;

@interface MMLocationInformation : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *locality;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *locationID;
@property (nonatomic, strong) NSString *providerID;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *unitNumber;
@property (nonatomic, strong) NSString *neighborhood;
@property (nonatomic, assign) BOOL isBookmark;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSNumber *livestreaming;
@property (nonatomic, strong) NSNumber *videos;
@property (nonatomic, strong) NSNumber *images;
@property (nonatomic, strong) NSNumber *monkeys;

-(void)geocodeLocationWithCompletionHandler:(void(^)(NSArray * placemarks, NSError * error))completion;
-(NSString *)formattedAddressString;

@end
