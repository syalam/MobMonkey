//
//  UIBarButtonItem+NoBorder.h
//  MobMonkey
//
//  Created by Michael Kral on 5/21/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (NoBorder)

+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action;

@end
