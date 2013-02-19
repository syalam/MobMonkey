//
//  NSString+URLParams.h
//  MobMonkey
//
//  Created by Dan Brajkovic on 11/6/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLParams)

+ (NSString *)URLParameterizedStringFromDictionary:(NSDictionary *)dictionary;

@end
