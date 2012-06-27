//
//  HomeCell.m
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell
@synthesize locationNameLabel;
@synthesize timeLabel;
@synthesize thumbnailImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.locationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 25)];
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 5, 100, 25)];
        self.thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 40, 310, 150)];
        self.thumbnailImageView.image = [UIImage imageNamed:@"monkey.jpg"];
    }
    
    [self.contentView addSubview:self.locationNameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.thumbnailImageView];

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
