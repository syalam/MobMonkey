//
//  MMLocationInformation.h
//  MobMonkey
//
//  Created by Michael Kral on 4/22/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

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

-(void)geocodeLocationWithCompletionHandler:(void(^)(NSArray * placemarks, NSError * error))completion;

@end