//
//  MMHotSpotInformation.m
//  MobMonkey
//
//  Created by Michael Kral on 4/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMHotSpotInformation.h"

@implementation MMHotSpotInformation

@end

@implementation MMHotSpots
+(NSArray *)testHotSpots {
    NSMutableArray *hotSpots = [NSMutableArray array];
    for(int i= 0; i < 4; i++){
        MMHotSpotInformation *hotSpot = [[MMHotSpotInformation alloc] init];
        hotSpot.name = [NSString stringWithFormat:@"HOT SPOT %d", i];
        [hotSpots addObject:hotSpot];
    }
    return hotSpots;
}
@end
