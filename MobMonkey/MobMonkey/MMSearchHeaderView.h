//
//  MMSearchHeaderView.h
//  MobMonkey
//
//  Created by Michael Kral on 5/30/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMSearchHeaderView : UIView

-(void)addTarget:(id)target andSelector:(SEL)selector;

@property (nonatomic, strong) UILabel *locationLabel;

@end
