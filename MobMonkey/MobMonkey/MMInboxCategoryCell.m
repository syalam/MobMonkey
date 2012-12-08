//
//  MMInboxCategoryCell.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/7/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMInboxCategoryCell.h"

@implementation MMInboxCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _pillboxImageView = [[UIImageView alloc]initWithFrame:CGRectMake(230, 12, 45, 20)];
        _categoryItemCountLabel = [[UILabel alloc]initWithFrame:_pillboxImageView.frame];
        
        [_categoryItemCountLabel setFont:[UIFont boldSystemFontOfSize:14]];
        
        [_categoryItemCountLabel setBackgroundColor:[UIColor clearColor]];
        
        [_categoryItemCountLabel setTextColor:[UIColor whiteColor]];
        
        [_categoryItemCountLabel setTextAlignment:NSTextAlignmentCenter];
        
        _pillboxImageView.contentMode = UIViewContentModeCenter;
        
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:_pillboxImageView];
        [self.contentView addSubview:_categoryItemCountLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
