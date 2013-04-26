//
//  MMLocationListCell.h
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMTableViewCell.h"
#import "MMLocationInformation.h"

@interface MMLocationListCell : MMTableViewCell

@property (strong, nonatomic) NSDictionary *location;
@property (nonatomic, strong) MMLocationInformation *locationInformation;

- (void)setLocation:(NSDictionary *)location;
-(void)setLocationInformation:(MMLocationInformation*)locationInformation;

@end
