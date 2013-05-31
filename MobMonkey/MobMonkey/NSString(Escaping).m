//
//  NSString (Escaping).m
//  FactualSDK
//
//  Created by Ahad Rana on 2/2/12.
//  Copyright (c) 2012 Facutal Inc. All rights reserved.
//

#import "NSString(Escaping).h"

@implementation NSString (Escaping)
- (NSString*)stringWithPercentEscape {            
  return (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)[self mutableCopy], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"),kCFStringEncodingUTF8);
}
@end
