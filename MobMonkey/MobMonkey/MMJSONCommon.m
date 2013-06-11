//
//  MMJSONCommon.m
//  MobMonkey
//
//  Created by Michael Kral on 6/9/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMJSONCommon.h"

@implementation MMJSONCommon

+(NSDate *)dateFromServerTime:(id)jsonValue {
    
    if([jsonValue isEqual:[NSNull null]]){
        return nil;
    }
    
    double unixTime = [jsonValue floatValue]/1000;
    
    return [NSDate dateWithTimeIntervalSince1970:unixTime];
    
}
+(NSNumber *)boolFromServerBool:(id)jsonValue {
    if([jsonValue isEqual:[NSNull null]]){
        return nil;
    }
    return [NSNumber numberWithBool:[jsonValue boolValue]];
    
}
+(NSURL *)urlFromServerPath:(NSString *)pathString {
    if(pathString && ![pathString isEqual:[NSNull null]]){
        return [NSURL URLWithString:pathString];
    }
    return nil;
}
+(NSString *)dateStringDurationSinceDate:(NSDate *)previousDate {
    NSDate * dateNow = [NSDate date];
    NSTimeInterval diff = [dateNow timeIntervalSinceDate:previousDate];
    
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
