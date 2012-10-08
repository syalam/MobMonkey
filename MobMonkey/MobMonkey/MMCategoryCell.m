//
//  MMCategoryCell.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/18/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMCategoryCell.h"

@implementation MMCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _mmCategoryCellBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
        _mmCategoryCellImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 35, 35)];
        _mmCategoryTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 7, 280, 30)];
        
        //configure label
        [_mmCategoryTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
        [_mmCategoryTitleLabel setBackgroundColor:[UIColor clearColor]];
        [_mmCategoryTitleLabel setTextColor:[UIColor darkGrayColor]];
        
        //set cell background image
        _mmCategoryCellBackgroundImageView.image = [UIImage imageNamed:@"roundedRectLarge"];
        _mmCategoryCellBackgroundImageView.clipsToBounds = YES;
        
        //add items to the cell's content view
        [self.contentView addSubview:_mmCategoryCellBackgroundImageView];
        [self.contentView addSubview:_mmCategoryCellImageView];
        [self.contentView addSubview:_mmCategoryTitleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
