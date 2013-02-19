//
//  NSDate+JavaEpochTime.h
//  MobMonkey
//
//  Created by Dan Brajkovic on 11/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JavaEpochTime)

+ (NSDate *)dateSinceJavaEpochTime:(NSNumber *)number;

@end
