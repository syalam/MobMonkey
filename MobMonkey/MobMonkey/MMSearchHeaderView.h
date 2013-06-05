//
//  MMSearchHeaderView.h
//  MobMonkey
//
//  Created by Michael Kral on 5/30/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMSearchHeaderView : UIView



@property (nonatomic, strong) UILabel *locationLabel;
@property (copy, nonatomic) void (^clickAction)();

@end
