//
//  MMFactualAPI.m
//  MobMonkey
//
//  Created by Michael Kral on 5/30/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMFactualAPI.h"

@implementation MMFactualAPI

+(MMFactualAPI *)sharedAPI {
    static dispatch_once_t pred;
    static MMFactualAPI *sharedAPI = nil;
    dispatch_once(&pred, ^{
        sharedAPI = [[MMFactualAPI alloc] initWithAPIKey:@"4CghCzGRA37VHpyToY97L7W4QGUG9IGz3rzZQbru" secret:@"X4ZXy7AdLnRrmjkBn9GjQgANDiqVOz2sS2IZdigQ"];
    });
    return sharedAPI;
}


@end
