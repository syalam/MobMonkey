//
//  UIColor+Additions.h
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;

- (UIColor *)initWithHex:(NSString *)hex alpha:(CGFloat)alpha;

@end
