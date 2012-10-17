//
//  MMTableViewCell.m
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/17/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMTableViewCell.h"

@implementation MMTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat grey = 220.0/255.0;
        self.backgroundView = nil;
        self.backgroundColor = [UIColor colorWithRed:grey green:grey blue:grey alpha:1.0];
    }
    return self;
}

/**
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
*/
@end
