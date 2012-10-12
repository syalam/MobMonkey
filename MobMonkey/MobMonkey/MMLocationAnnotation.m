//
//  MMLocationAnnotation.m
//  MobMonkey
//
//  Created by Sheehan Alam on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MMLocationAnnotation.h"

@implementation MMLocationAnnotation
@synthesize address = _address;
@synthesize name = _name;
@synthesize coordinate = _coordinate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate arrayIndex:(int)arrayIndex;
{
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
        _arrayIndex = arrayIndex;
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]]) 
        return @"Unknown charge";
    else
        return _name;
}

- (NSString *)subtitle {
    return _address;
}

@end
