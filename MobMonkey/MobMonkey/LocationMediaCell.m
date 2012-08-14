//
//  LocationMediaCell.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/2/12.
//
//

#import "LocationMediaCell.h"

@implementation LocationMediaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _cellImageView = [[TCImageView alloc]initWithFrame:CGRectMake(5, 5, 310, 400)];
        
        [_cellImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_cellImageView setClipsToBounds:YES];
        [_cellImageView setCaching:YES];
        
        [self.contentView addSubview:_cellImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
