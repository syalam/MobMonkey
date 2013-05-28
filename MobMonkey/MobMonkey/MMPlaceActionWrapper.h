//
//  MMPlaceActionWrapper.h
//  MobMonkey
//
//  Created by Michael Kral on 5/24/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMPlaceActionWrapper : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) NSNumber * badgeCount;
@property (nonatomic, strong) UIColor * backgroundColor;

@end
