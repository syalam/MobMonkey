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
        _categoryBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 286, 44)];
        _categoryTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 200, 30)];
        _categoryItemCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(240, 5, 50, 30)];
        
        _categoryBackgroundImageView.image = [UIImage imageNamed:@"roundedRectLarge"];
        _categoryBackgroundImageView.clipsToBounds = YES;
        
        [_categoryTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
        [_categoryItemCountLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
        
        [_categoryTitleLabel setBackgroundColor:[UIColor clearColor]];
        [_categoryItemCountLabel setBackgroundColor:[UIColor clearColor]];
        
        [_categoryTitleLabel setTextColor:[UIColor darkGrayColor]];
        [_categoryItemCountLabel setTextColor:[UIColor darkGrayColor]];
        
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:_categoryBackgroundImageView];
        [self.contentView addSubview:_categoryTitleLabel];
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
