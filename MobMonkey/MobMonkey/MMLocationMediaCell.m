//
//  MMLocationMediaCell.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/5/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMLocationMediaCell.h"

@implementation MMLocationMediaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _locationImageView = [[TCImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width / 2 - 100, 5, 200, 120)];
        [_locationImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_locationImageView setClipsToBounds:YES];
        _locationImageView.caching = YES;
        
        [self.contentView addSubview:_locationImageView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
