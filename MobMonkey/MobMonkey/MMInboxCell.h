//
//  MMInboxCell.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/1/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMUtilities.h"
#import "UIColor+Additions.h"

@interface MMInboxCell : MMTableViewCell

@property (strong, nonatomic) NSDictionary *location;

- (void)setLocation:(NSDictionary *)location;

@end

