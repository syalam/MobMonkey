//
//  MMResultCell.m
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MMResultCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MMResultCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellBackgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 308, 186)];
        _locationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 200, 25)];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(256, 13, 100, 25)];
        _thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 41, 296, 145)];
        _toggleOverlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _overlayButtonView = [[UIView alloc]initWithFrame:CGRectMake(_thumbnailImageView.frame.origin.x, _thumbnailImageView.frame.size.height + 3, _thumbnailImageView.frame.size.width, 38)];
        _overlayBGImageView = [[UIImageView alloc]initWithFrame:_thumbnailImageView.frame];
        
        //setup overlay view
        _overlayButtonBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _overlayButtonView.frame.size.width, _overlayButtonView.frame.size.height)];
        _overlayButtonBackgroundImageView.image = [UIImage imageNamed:@"ThumbsBG~iphone.png"];
    
        [_overlayButtonView setBackgroundColor:[UIColor clearColor]];
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dislikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _flagButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _enlargeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];

        [_likeButton setFrame:CGRectMake(20, 0, 38, 38)];
        [_dislikeButton setFrame:CGRectMake(_likeButton.frame.origin.x + _likeButton.frame.size.width + 15, _likeButton.frame.origin.y, _likeButton.frame.size.width, _likeButton.frame.size.height)];
        [_flagButton setFrame:CGRectMake(_dislikeButton.frame.origin.x + _dislikeButton.frame.size.width + 15, _likeButton.frame.origin.y, _likeButton.frame.size.width, _likeButton.frame.size.height)];
        [_enlargeButton setFrame:CGRectMake(_flagButton.frame.origin.x + _flagButton.frame.size.width + 15, _likeButton.frame.origin.y, _likeButton.frame.size.width, _likeButton.frame.size.height)];
        [_shareButton setFrame:CGRectMake(_enlargeButton.frame.origin.x + _enlargeButton.frame.size.width + 15, _likeButton.frame.origin.y, _likeButton.frame.size.width, _likeButton.frame.size.height)];
        
        [_likeButton setImage:[UIImage imageNamed:@"ThumbUp~iphone"] forState:UIControlStateNormal];
        [_dislikeButton setImage:[UIImage imageNamed:@"ThumbDown~iphone"] forState:UIControlStateNormal];
        [_flagButton setTitle:@"Flag" forState:UIControlStateNormal];
        [_enlargeButton setTitle:@"Enlarge" forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"PopupBtn~iphone"] forState:UIControlStateNormal];
    
        [_likeButton addTarget:self action:@selector(likeButtonTapped:) forControlEvents:UIControlEventTouchDown];
        [_dislikeButton addTarget:self action:@selector(dislikeButtonTapped:) forControlEvents:UIControlEventTouchDown];
        [_flagButton addTarget:self action:@selector(flagButtonTapped:) forControlEvents:UIControlEventTouchDown];
        [_enlargeButton addTarget:self action:@selector(enlargeButtonTapped:) forControlEvents:UIControlEventTouchDown];
        [_shareButton addTarget:self action:@selector(shareButtonTapped:) forControlEvents:UIControlEventTouchDown];
        
        [_overlayButtonView addSubview:_overlayButtonBackgroundImageView];
        [_overlayButtonView addSubview:_likeButton];
        [_overlayButtonView addSubview:_dislikeButton];
        [_overlayButtonView addSubview:_flagButton];
        [_overlayButtonView addSubview:_enlargeButton];
        [_overlayButtonView addSubview:_shareButton];
        
        [_overlayButtonView setAlpha:0];
        [_overlayBGImageView setAlpha:0];
        
        
        //setup toggle button which will toggle the overlay as visible or hidden
        [_toggleOverlayButton setFrame:_thumbnailImageView.frame];
        [_toggleOverlayButton addTarget:self action:@selector(toggleOverlayButtonTapped:) forControlEvents:UIControlEventTouchDown];
        
        _thumbnailImageView.clipsToBounds = YES;
        
        [_locationNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15]];
        [_timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
        
        
        [_locationNameLabel setTextColor:[UIColor colorWithRed:.8941 green:.4509 blue:.1725 alpha:1]];
        [_timeLabel setTextColor:[UIColor whiteColor]];
        
        [_locationNameLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        
        [_cellBackgroundImage setImage:[UIImage imageNamed:@"LocationWindowPlusTime~iphone"]];
    }
    [self.contentView addSubview:_cellBackgroundImage];
    [self.contentView addSubview:_locationNameLabel];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_thumbnailImageView];
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

- (void)enlargeButtonTapped:(id)sender {
    [_delegate enlargeButtonTapped:sender];
}

@end