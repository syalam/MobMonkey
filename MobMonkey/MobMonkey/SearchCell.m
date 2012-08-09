//
//  SearchCell.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell
@synthesize iconImageView = _iconImageView;
@synthesize locationNameLabel = _locationNameLabel;
@synthesize videoImageView = _videoImageView;
@synthesize timeLabel = _timeLabel;
@synthesize requestButton = _requestButton;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellBackGroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 5, 313, 96)];
        _iconImageView = [[TCImageView alloc]initWithFrame:CGRectMake(13, 16.5, 67, 67)];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _locationNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(88, 17, 175, 20)];
        _videoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(52, 35, 15, 20)];
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(109, 39, 100, 20)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _requestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_requestButton setFrame:CGRectMake(275, 35, 28, 28)];
        [_requestButton setImage:[UIImage imageNamed:@"ResultArrow~iphone"] forState:UIControlStateNormal];
        [_requestButton addTarget:self action:@selector(requestButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _locationNameLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.backgroundColor = [UIColor clearColor];
        
        [_locationNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
        [_timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13]];
        
        
        [_locationNameLabel setTextColor:[UIColor colorWithRed:.8941 green:.4509 blue:.1725 alpha:1]];
        [_timeLabel setTextColor:[UIColor whiteColor]];
        
        _timeLabel.text = @"10m Ago";

        
        _cellBackGroundImageView.image = [UIImage imageNamed:@"SearchResultPlusTimePlusIcons~iphone"];
        _iconImageView.image = [UIImage imageNamed:@"PlaceHolderImg~iphone"];
        
        
    }
    [self.contentView addSubview:_cellBackGroundImageView];
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_locationNameLabel];
    [self.contentView addSubview:_videoImageView];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_requestButton];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)requestButtonClicked:(id)sender {
    [_delegate requestButtonClicked:sender];
}

@end
