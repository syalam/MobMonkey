//
//  NSDate+JavaEpochTime.m
//  MobMonkey
//
//  Created by Dan Brajkovic on 11/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "NSDate+JavaEpochTime.h"

@implementation NSDate (JavaEpochTime)

+ (NSDate *)dateSinceJavaEpochTime:(NSNumber *)number
{
    return [NSDate dateWithTimeIntervalSince1970:[number integerValue] / 1000];
}

@end
