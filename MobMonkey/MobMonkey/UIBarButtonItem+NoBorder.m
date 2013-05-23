//
//  UIBarButtonItem+NoBorder.m
//  MobMonkey
//
//  Created by Michael Kral on 5/21/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "UIBarButtonItem+NoBorder.h"

@implementation UIBarButtonItem (NoBorder)

+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //[button setBackgroundImage: image forState:UIControlStateNormal];
    //[button setBackgroundImage: selectedImage forState:UIControlStateHighlighted];
    
    button.frame= CGRectMake(5, 0.0, 44, 44);
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((44 - image.size.width) /2, (44 - image.size.height) / 2, image.size.width, image.size.height)];
    [imageView setImage:image];
    
    [button addSubview:imageView];
    
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, button.frame.size.width +10, button.frame.size.height)];
    button.showsTouchWhenHighlighted = YES;
    [container addSubview:button];
    
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:container];
   
    return barButton;
}
@end
