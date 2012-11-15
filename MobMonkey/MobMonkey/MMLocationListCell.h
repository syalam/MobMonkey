//
//  MMLocationListCell.h
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MMLocationListCell : MMTableViewCell

@property (strong, nonatomic) NSDictionary *location;

- (void)setLocation:(NSDictionary *)location;

@end
