//
//  MMSetTitleImage.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/2/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMSetTitleImage.h"

@implementation MMSetTitleImage

-(UIImageView*)setTitleImageView {
    if (!_mmTitleImage) {
        _mmTitleImage = [UIImage imageNamed:@"logo~iphone"];
    }
    UIImageView *titleImageView = [[UIImageView alloc]initWithImage:_mmTitleImage];
    return titleImageView;
}

@end
