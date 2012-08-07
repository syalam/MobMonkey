//
//  HomeCell.m
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation HomeCell
@synthesize locationNameLabel;
@synthesize timeLabel;
@synthesize thumbnailImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellBackgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 308, 186)];
        self.locationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 200, 25)];
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(256, 13, 100, 25)];
        self.thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 41, 296, 145)];
        
        
        self.thumbnailImageView.image = [UIImage imageNamed:@"monkey.jpg"];
        self.thumbnailImageView.clipsToBounds = YES;
        
        [self.locationNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
        [self.timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
        
        
        [self.locationNameLabel setTextColor:[UIColor colorWithRed:.8941 green:.4509 blue:.1725 alpha:1]];
        [self.timeLabel setTextColor:[UIColor whiteColor]];
        
        [locationNameLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        
        [self.cellBackgroundImage setImage:[UIImage imageNamed:@"LocationWindowPlusTime~iphone"]];
    }
    [self.contentView addSubview:self.cellBackgroundImage];
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
