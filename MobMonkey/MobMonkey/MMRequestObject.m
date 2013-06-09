//
//  MMRequestObject.m
//  MobMonkey
//
//  Created by Michael Kral on 6/9/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMRequestObject.h"

@implementation MMRequestObject

+(NSDate *)dateFromServerTime:(id)jsonValue {
    
    if([jsonValue isEqual:[NSNull null]]){
        return nil;
    }
    
    double unixTime = [jsonValue floatValue]/1000;
    
    return [NSDate dateWithTimeIntervalSince1970:unixTime];
    
}
+(BOOL)boolFromServerBool:(id)jsonValue {
    if([jsonValue isEqual:[NSNull null]]){
        return NO;
    }
    return [jsonValue boolValue];
    
}

+(MMRequestObject *)requestObjectFromJSON:(NSDictionary *)jsonDictionary {
    
    /*{
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
    
    MMRequestObject *requestObject = [[self alloc] init];
    
    requestObject.assignedDate = [self dateFromServerTime:[jsonDictionary valueForKey:@"assignedDate"]];
    requestObject.expiryDate = [self dateFromServerTime:[jsonDictionary valueForKey:@"expiryDate"]];
    requestObject.fulfilledDate = [self dateFromServerTime:[jsonDictionary valueForKey:@"fulFilledDate"]];
    requestObject.coordinate = CLLocationCoordinate2DMake([[jsonDictionary valueForKey:@"latitude"] doubleValue], [[jsonDictionary valueForKey:@"longitude"] doubleValue]);
    requestObject.locationID = [jsonDictionary objectForKey:@"locationId"];
    requestObject.markAsRead = [self boolFromServerBool:[jsonDictionary valueForKey:@"markAsRead"]];
    requestObject.mediaType = [[jsonDictionary valueForKey:@"mediaType"] intValue];
    requestObject.message = [jsonDictionary objectForKey:@"message"];
    requestObject.nameOfLocation = [jsonDictionary objectForKey:@"nameOfLocation"];
    requestObject.providerID = [jsonDictionary objectForKey:@"providerId"];
    requestObject.requestDate = [self dateFromServerTime:[jsonDictionary valueForKey:@"requestDate"]];
    requestObject.requestID = [jsonDictionary objectForKey:@"requestId"];
    requestObject.requestType = [[jsonDictionary valueForKey:@"requestType"] intValue];
    
    return requestObject;
    
}

-(NSString *)dateStringDurationSinceCreate {
    NSDate * dateNow = [NSDate date];
    NSTimeInterval diff = [dateNow timeIntervalSinceDate:self.assignedDate];
    
    if(diff < 30){
        return @"Just Now";
    }else if(diff < 119) {
        return @"About a minute ago";
    }else if(diff < 3600) {
        NSUInteger minute = diff / 60;
        
        if(minute == 1){
            return [NSString stringWithFormat:@"%d minute ago", minute];
        }
        return [NSString stringWithFormat:@"%d minutes ago", minute];
    }else if (diff < 86400) {
        NSUInteger hour = diff / 3600;
        if(hour == 1){
            return [NSString stringWithFormat:@"%d hour ago", hour];
        }
        return [NSString stringWithFormat:@"%d hours ago", hour];
    }else {
        NSUInteger day = diff / 86400;
        if(day == 1){
            return @"Yesterday";
        }
        return [NSString stringWithFormat:@"%d days ago", day];
    }
    
}

@end
