//
//  MMFactualAPI.h
//  MobMonkey
//
//  Created by Michael Kral on 5/30/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <FactualSDK/FactualAPI.h>
#import "MMFactualOperation.h"

@interface MMFactualAPI : FactualAPI

+(MMFactualAPI *)sharedAPI;

@end
