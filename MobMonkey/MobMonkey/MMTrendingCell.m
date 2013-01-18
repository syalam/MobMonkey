//
//  MMTrendingCell.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 1/9/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMTrendingCell.h"

@implementation MMTrendingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _locationNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 300, 21)];
        _requestLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 300, 60)];
        _responseLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 140, 300, 60)];
        _timeStampLabel = [[UILabel alloc]initWithFrame:CGRectMake(241, 62, 72, 16)];
        [_timeStampLabel setTextAlignment:NSTextAlignmentRight];
        _locationImageView = [[TCImageView alloc]initWithFrame:CGRectMake(10, 49, 300, 225)];
        
        _locationNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationNameButton setFrame:_locationNameLabel.frame];
        [_locationNameButton addTarget:self action:@selector(locationNameButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageButton setFrame:_locationImageView.frame];
        [_imageButton addTarget:self action:@selector(imageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setFrame:CGRectMake(242, 229, 53, 42)];
        [_moreButton setImage:[UIImage imageNamed:@"moreBtnOverlay"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //_locationNameLabel.textColor = [UIColor colorWithRed:.8941 green:.4509 blue:.1725 alpha:1];
        _locationNameLabel.textColor = [UIColor blackColor];
        [_locationNameLabel setBackgroundColor:[UIColor clearColor]];
        _locationNameLabel.font = [UIFont boldSystemFontOfSize:20.0];
        
        _requestLabel.textColor = [UIColor blackColor];
        [_requestLabel setBackgroundColor:[UIColor clearColor]];
        _requestLabel.font = [UIFont boldSystemFontOfSize:14];
        
        
        _responseLabel.textColor = [UIColor blackColor];
        [_responseLabel setBackgroundColor:[UIColor clearColor]];
        _responseLabel.font = [UIFont systemFontOfSize:14];
        
        
        _timeStampLabel.textColor = [UIColor whiteColor];
        [_timeStampLabel setBackgroundColor:[UIColor clearColor]];
        _timeStampLabel.font = [UIFont boldSystemFontOfSize:12];
        
        
        [_locationImageView setImage:[UIImage imageNamed:@"monkey.jpg"]];
        [_locationImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_locationImageView setClipsToBounds:YES];
        [_locationImageView setCaching:YES];
        
        UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(5, 6, 310, 302)];
        [backgroundView setBackgroundColor:[UIColor whiteColor]];
        
        _clockImageView = [[UIImageView alloc]initWithFrame:CGRectMake(218, 62, 15, 15)];
        [_clockImageView setImage:[UIImage imageNamed:@"timeIcnOverlay"]];
        
        UIImageView *toolbarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 226, 300, 48)];
        [toolbarImageView setImage:[UIImage imageNamed:@"ThumbsBG~iphone"]];
        [toolbarImageView setHidden:YES];
        
        [self.contentView addSubview:backgroundView];
        [self.contentView addSubview:_locationNameLabel];
        [self.contentView addSubview:_locationNameButton];
        [self.contentView addSubview:_requestLabel];
        [self.contentView addSubview:_responseLabel];
        [self.contentView addSubview:_locationImageView];
        [self.contentView addSubview:_imageButton];
        [self.contentView addSubview:_clockImageView];
        [self.contentView addSubview:_timeStampLabel];
        [self.contentView addSubview:toolbarImageView];
        [self.contentView addSubview:_moreButton];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - IBAction Methods
-(void)locationNameButtonTapped:(id)sender {
    [_delegate locationNameButtonTapped:sender];
}
-(void)moreButtonTapped:(id)sender {
    [_delegate moreButtonTapped:sender];
}
-(void)imageButtonTapped:(id)sender {
    [_delegate imageButtonTapped:sender];
}

@end
