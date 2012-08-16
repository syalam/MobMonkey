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
        _cellBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 308, 186)];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(256, 13, 100, 25)];
        _cellImageView = [[TCImageView alloc]initWithFrame:CGRectMake(16, 41, 296, 145)];
        _voteBGImageView = [[UIImageView alloc]initWithFrame:CGRectMake(228, 139, 77, 38)];
        _thumbsDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _thumbsUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_cellImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_cellImageView setClipsToBounds:YES];
        [_cellImageView setCaching:YES];
        
        [_cellBackgroundImageView setImage:[UIImage imageNamed:@"LocationWindowPlusTime~iphone"]];
        
        [_timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setTextColor:[UIColor whiteColor]];
        
        _voteBGImageView.image = [UIImage imageNamed:@"ThumbsBG~iphone"];
        
        [_thumbsDownButton setFrame:CGRectMake(239, 147, 18, 25)];
        [_thumbsDownButton setImage:[UIImage imageNamed:@"ThumbDown~iphone"] forState:UIControlStateNormal];
        [_thumbsDownButton addTarget:self action:@selector(thumbsDownButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [_thumbsUpButton setFrame:CGRectMake(275, 147, 18, 25)];
        [_thumbsUpButton setImage:[UIImage imageNamed:@"ThumbUp~iphone"] forState:UIControlStateNormal];
        [_thumbsUpButton addTarget:self action:@selector(thumbsUpButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_cellBackgroundImageView];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_cellImageView];
        [self.contentView addSubview:_voteBGImageView];
        [self.contentView addSubview:_thumbsUpButton];
        [self.contentView addSubview:_thumbsDownButton];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)thumbsUpButtonTapped:(id)sender {
    [_delegate thumbsUpButtonTapped:sender];
}
- (void)thumbsDownButtonTapped:(id)sender {
    [_delegate thumbsDownButtonTapped:sender];
}


@end
