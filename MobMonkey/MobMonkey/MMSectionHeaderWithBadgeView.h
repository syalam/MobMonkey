//
//  MMSectionHeaderWithBadgeView.h
//  MobMonkey
//
//  Created by Michael Kral on 6/6/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"

@interface MMSectionHeaderWithBadgeView : UIView

@property (nonatomic, strong) NSNumber *badgeNumber;
@property (nonatomic, strong) NSString * title;

-(id)initWithTitle:(NSString *)title andBadgeNumber:(NSNumber *)badgeNumber;
@end
