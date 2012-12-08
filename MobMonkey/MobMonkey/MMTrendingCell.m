//
//  MMTrendingCell.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 12/7/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMTrendingCell.h"

@implementation MMTrendingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _pillboxImageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 5, 45, 20)];
        _itemCountLabel = [[UILabel alloc]initWithFrame:_pillboxImageView.frame];
        
        [_pillboxImageView setContentMode:UIViewContentModeCenter];
        
        _itemCountLabel.font = [UIFont boldSystemFontOfSize:12];
        [_itemCountLabel setBackgroundColor:[UIColor clearColor]];
        [_itemCountLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self.contentView addSubview:_pillboxImageView];
        [self.contentView addSubview:_itemCountLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
