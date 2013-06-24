//
//  MMMenuSlideCell.m
//  MobMonkey_LVF
//
//  Created by Michael Kral on 4/17/13.
//  Copyright (c) 2013 MobMonkey. All rights reserved.
//

#import "MMMenuSlideCell.h"

@implementation MMMenuSlideCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if(highlighted){
    
        [self.backgroundView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.500]];
        [self setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.500]];
        [UIView animateWithDuration:0.1 animations:^{
            
            [self.backgroundView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.500]];
            [self setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.500]];
            
    
        }];
    }
    

    
}

@end
