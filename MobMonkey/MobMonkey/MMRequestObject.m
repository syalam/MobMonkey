//
//  MMRequestObject.m
//  MobMonkey
//
//  Created by Michael Kral on 6/9/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMRequestObject.h"
#import "MMJSONCommon.h"

@implementation MMRequestObject


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
    
    requestObject.assignedDate = [MMJSONCommon dateFromServerTime:[jsonDictionary valueForKey:@"assignedDate"]];
    requestObject.expiryDate = [MMJSONCommon dateFromServerTime:[jsonDictionary valueForKey:@"expiryDate"]];
    requestObject.fulfilledDate = [MMJSONCommon dateFromServerTime:[jsonDictionary valueForKey:@"fulFilledDate"]];
    requestObject.coordinate = CLLocationCoordinate2DMake([[jsonDictionary valueForKey:@"latitude"] doubleValue], [[jsonDictionary valueForKey:@"longitude"] doubleValue]);
    requestObject.locationID = [jsonDictionary objectForKey:@"locationId"];
    requestObject.markAsRead = [MMJSONCommon boolFromServerBool:[jsonDictionary valueForKey:@"markAsRead"]];
    requestObject.mediaType = [[jsonDictionary valueForKey:@"mediaType"] intValue];
    requestObject.message = [jsonDictionary objectForKey:@"message"];
    requestObject.nameOfLocation = [jsonDictionary objectForKey:@"nameOfLocation"];
    requestObject.providerID = [jsonDictionary objectForKey:@"providerId"];
    requestObject.requestDate = [MMJSONCommon dateFromServerTime:[jsonDictionary valueForKey:@"requestDate"]];
    requestObject.requestID = [jsonDictionary objectForKey:@"requestId"];
    requestObject.requestType = [[jsonDictionary valueForKey:@"requestType"] intValue];
    requestObject.expired = [MMJSONCommon boolFromServerBool:[jsonDictionary valueForKey:@"expired"]];
    requestObject.emailAddress = [jsonDictionary objectForKey:@"eMailAddress"];
    requestObject.scheduleDate = [MMJSONCommon dateFromServerTime:[jsonDictionary valueForKey:@"scheduleDate"]];
    requestObject.requestFulfilled = [MMJSONCommon boolFromServerBool:[jsonDictionary valueForKey:@"requestFulfilled"]];
    requestObject.recurring = [MMJSONCommon boolFromServerBool:[jsonDictionary valueForKey:@"recurring"]];
    
    NSDictionary * mediaDictionary = [[jsonDictionary objectForKey:@"media"] lastObject];
    
    requestObject.mediaObject = [MMMediaObject mediaObjectFromJSON:mediaDictionary];
    
    return requestObject;
    
}

-(NSDictionary *)jsonParameters {
    
    /*
     requestObject.scheduleDate = self.selectedScheduleDate;
     requestObject.providerID = self.locationInformation.providerID;
     requestObject.locationID = self.locationInformation.locationID;
     requestObject.duration = self.duration;
     requestObject.recurring = [NSNumber numberWithBool:self.isRecurring];
     */
    NSMutableDictionary * jsonDictionary = [NSMutableDictionary dictionary];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
    if(self.scheduleDate) {
        NSString * scheduleDateString = [dateFormatter stringFromDate:self.scheduleDate];
        [jsonDictionary setObject:scheduleDateString forKey:@"scheduleDate"];
    }
    
    if(self.providerID){
        [jsonDictionary setObject:self.providerID forKey:@"providerId"];
    }
    
    if(self.locationID){
        [jsonDictionary setObject:self.locationID forKey:@"locationId"];
    }
    
    if(self.duration){
        [jsonDictionary setObject:self.duration forKey:@"duration"];
    }
    
    if(self.recurring){
        [jsonDictionary setObject:self.recurring forKey:@"recurring"];
    }
    
    return jsonDictionary;
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
