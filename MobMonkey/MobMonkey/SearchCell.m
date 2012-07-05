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
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 34, 34)];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _locationNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, 150, 20)];
        _videoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(55, 35, 15, 20)];
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 35, 100, 20)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _requestButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_requestButton setFrame:CGRectMake(220, 15, 70, 35)];
        [_requestButton setTitle:@"Request" forState:UIControlStateNormal];
        [_requestButton addTarget:self action:@selector(requestButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
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
