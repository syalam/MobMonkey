//
//  NSString+URLParams.m
//  MobMonkey
//
//  Created by Dan Brajkovic on 11/6/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "NSString+URLParams.h"

@implementation NSString (URLParams)


+ (NSString *)URLParameterizedStringFromDictionary:(NSDictionary *)dictionary
{
    NSMutableString *parameterizedString = [[NSMutableString alloc] init];
    
    for (NSString *key in [dictionary allKeys]) {
        [parameterizedString appendFormat:@"%@=%@", key, [dictionary objectForKey:key]];
        
        if (key != [[dictionary allKeys] lastObject]) {
            [parameterizedString appendFormat:@"&"];
        }
    }
    
    return parameterizedString;
}

@end
