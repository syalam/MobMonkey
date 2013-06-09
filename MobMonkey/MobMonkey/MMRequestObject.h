//
//  MMRequestObject.h
//  MobMonkey
//
//  Created by Michael Kral on 6/9/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMRequestWrapper.h"
#import "MMMediaObject.h"

@class MMRequestWrapper;
@class MMMediaObject;

@interface MMRequestObject : NSObject

@property (nonatomic, strong) NSDate * assignedDate;
@property (nonatomic, strong) NSDate * expiryDate;
@property (nonatomic, strong) NSDate * fulfilledDate;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString * locationID;
@property (nonatomic, assign) BOOL markAsRead;
@property (nonatomic, assign) NSUInteger mediaType;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSString * nameOfLocation;
@property (nonatomic, strong) NSString * providerID;
@property (nonatomic, strong) NSDate * requestDate;
@property (nonatomic, strong) NSString * requestID;
@property (nonatomic, assign) NSUInteger requestType;
@property (nonatomic, strong) MMRequestWrapper *requestWrapper;
@property (nonatomic, strong) MMMediaObject * mediaObject;
@property (nonatomic, assign) BOOL expired;
@property (nonatomic, strong) NSString * emailAddress;
@property (nonatomic, strong) NSDate * scheduleDate;
@property (nonatomic, assign) BOOL requestFulfilled;
@property (nonatomic, assign) BOOL recurring;


+(MMRequestObject *)requestObjectFromJSON:(NSDictionary *)jsonDictionary;
-(NSString *)dateStringDurationSinceCreate;


/*
 {
 assignedDate = 1370798826310;
 expiryDate = 1370800625176;
 fulFilledDate = "<null>";
 latitude = "33.61819924109066";
 locationId = "806bcae9-cf40-4065-86ae-f3920983e405";
 longitude = "-112.43015747924";
 markAsRead = 0;
 mediaType = 2;
 message = "<null>";
 nameOfLocation = "MobMonkey Surprise AZ";
 providerId = "e048acf0-9e61-4794-b901-6a4bb49c3181";
 requestDate = "<null>";
 requestId = "71f42a02-b57b-4ef8-a0ce-58e858a262e1";
 requestType = 0;*/

@end
