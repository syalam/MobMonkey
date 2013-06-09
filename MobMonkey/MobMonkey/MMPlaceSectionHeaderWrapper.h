//
//  MMPlaceSectionHeaderWrapper.h
//  MobMonkey
//
//  Created by Michael Kral on 5/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMPlaceSectionHeaderWrapper : NSObject

@property (nonatomic, strong) UIImage * icon;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) UIView * accessoryView;
@property (nonatomic, assign) BOOL showDisclosureIndicator;
@property (nonatomic, assign) BOOL showSeperator;
@property (nonatomic, strong) UIColor *backgroundColor;
@end
