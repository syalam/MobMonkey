//
//  MMHotSpotInformation.h
//  MobMonkey
//
//  Created by Michael Kral on 4/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMLocationInformation.h"

@interface MMHotSpotInformation : NSObject

@property (nonatomic, strong) MMLocationInformation *masterLocation;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) CLLocationCoordinate2D coordinates;
@property (nonatomic, strong) NSString *detailedDesciption;

@end

@interface MMHotSpots : NSObject

+(NSArray *)testHotSpots;

@end
