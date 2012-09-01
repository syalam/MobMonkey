//
//  MMTrendingCell.m
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MMTrendingCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MMTrendingCell
@synthesize locationNameLabel;
@synthesize timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellBackgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 308, 186)];
        self.locationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 200, 25)];
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(256, 13, 100, 25)];
        self.thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 41, 296, 145)];
        _toggleOverlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _overlayButtonView = [[UIView alloc]initWithFrame:CGRectMake(_thumbnailImageView.frame.origin.x, _thumbnailImageView.frame.size.height + 11, _thumbnailImageView.frame.size.width, 30)];
        _overlayBGImageView = [[UIImageView alloc]initWithFrame:_thumbnailImageView.frame];
        
        //setup overlay view
        [_overlayButtonView setBackgroundColor:[UIColor clearColor]];
        _likeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _dislikeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _flagButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

        [_likeButton setFrame:CGRectMake(20, 0, 60, 30)];
        [_dislikeButton setFrame:CGRectMake(_likeButton.frame.origin.x + _likeButton.frame.size.width + 5, _likeButton.frame.origin.y, _likeButton.frame.size.width, _likeButton.frame.size.height)];
        [_flagButton setFrame:CGRectMake(_dislikeButton.frame.origin.x + _dislikeButton.frame.size.width + 5, _likeButton.frame.origin.y, _likeButton.frame.size.width, _likeButton.frame.size.height)];
        [_shareButton setFrame:CGRectMake(_flagButton.frame.origin.x + _flagButton.frame.size.width + 5, _likeButton.frame.origin.y, _likeButton.frame.size.width, _likeButton.frame.size.height)];
        
        [_likeButton setTitle:@"✔" forState:UIControlStateNormal];
        [_dislikeButton setTitle:@"x" forState:UIControlStateNormal];
        [_flagButton setTitle:@"Flag" forState:UIControlStateNormal];
        [_shareButton setTitle:@"Share" forState:UIControlStateNormal];
    
        [_likeButton addTarget:self action:@selector(likeButtonTapped:) forControlEvents:UIControlEventTouchDown];
        [_dislikeButton addTarget:self action:@selector(dislikeButtonTapped:) forControlEvents:UIControlEventTouchDown];
        [_flagButton addTarget:self action:@selector(flagButtonTapped:) forControlEvents:UIControlEventTouchDown];
        [_shareButton addTarget:self action:@selector(shareButtonTapped:) forControlEvents:UIControlEventTouchDown];
        
        [_overlayButtonView addSubview:_likeButton];
        [_overlayButtonView addSubview:_dislikeButton];
        [_overlayButtonView addSubview:_flagButton];
        [_overlayButtonView addSubview:_shareButton];
        
        [_overlayButtonView setAlpha:0];
        [_overlayBGImageView setAlpha:0];
        
        
        //setup toggle button which will toggle the overlay as visible or hidden
        [_toggleOverlayButton setFrame:_thumbnailImageView.frame];
        [_toggleOverlayButton addTarget:self action:@selector(toggleOverlayButtonTapped:) forControlEvents:UIControlEventTouchDown];
        
        self.thumbnailImageView.clipsToBounds = YES;
        
        [self.locationNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15]];
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
    [self.contentView addSubview:_overlayBGImageView];
    [self.contentView addSubview:_toggleOverlayButton];
    [self.contentView addSubview:_overlayButtonView];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)toggleOverlayButtonTapped:(id)sender {
    [_delegate toggleOverlayButtonTapped:sender];
}

- (void)likeButtonTapped:(id)sender {
    [_delegate likeButtonTapped:sender];
}

- (void)dislikeButtonTapped:(id)sender {
    [_delegate dislikeButtonTapped:sender];
}

- (void)flagButtonTapped:(id)sender {
    [_delegate flagButtonTapped:sender];
}

- (void)shareButtonTapped:(id)sender {
    [_delegate shareButtonTapped:sender];
}

@end
