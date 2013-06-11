//
//  MMJSONCommon.h
//  MobMonkey
//
//  Created by Michael Kral on 6/9/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMJSONCommon : NSObject


+(NSDate *)dateFromServerTime:(id)jsonValue;
+(NSNumber *)boolFromServerBool:(id)jsonValue;
+(NSURL *)urlFromServerPath:(NSString *)pathString;
+(NSString *)dateStringDurationSinceDate:(NSDate *)previousDate ;
@end
