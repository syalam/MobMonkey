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
+(BOOL)boolFromServerBool:(id)jsonValue {
    if([jsonValue isEqual:[NSNull null]]){
        return NO;
    }
    return [jsonValue boolValue];
    
}
+(NSURL *)urlFromServerPath:(NSString *)pathString {
    if(pathString){
        return [NSURL URLWithString:pathString];
    }
    return nil;
}


@end
