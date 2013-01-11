//
//  MMLocationMediaCell.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/5/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMLocationMediaCell.h"

@implementation MMLocationMediaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _timeStampLabel = [[UILabel alloc]initWithFrame:CGRectMake(231, 42, 72, 16)];
        [_timeStampLabel setTextAlignment:NSTextAlignmentRight];
        _locationImageView = [[TCImageView alloc]initWithFrame:CGRectMake(10, 29, 300, 235)];
        
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageButton setFrame:_locationImageView.frame];
        [_imageButton addTarget:self action:@selector(imageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setFrame:CGRectMake(242, 219, 53, 42)];
        [_moreButton setImage:[UIImage imageNamed:@"moreBtnOverlay"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _timeStampLabel.textColor = [UIColor whiteColor];
        [_timeStampLabel setBackgroundColor:[UIColor clearColor]];
        _timeStampLabel.font = [UIFont boldSystemFontOfSize:12];
        
        
        [_locationImageView setImage:[UIImage imageNamed:@"monkey.jpg"]];
        [_locationImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_locationImageView setClipsToBounds:YES];
        [_locationImageView setCaching:YES];
        
        UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(5, 6, 310, 290)];
        [backgroundView setBackgroundColor:[UIColor whiteColor]];
        
        _clockImageView = [[UIImageView alloc]initWithFrame:CGRectMake(218, 42, 15, 15)];
        [_clockImageView setImage:[UIImage imageNamed:@"timeIcnOverlay"]];
        
        UIImageView *toolbarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 216, 300, 48)];
        [toolbarImageView setImage:[UIImage imageNamed:@"ThumbsBG~iphone"]];
        
        [self.contentView addSubview:backgroundView];
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
-(void)moreButtonTapped:(id)sender {
    [_delegate moreButtonTapped:sender];
}
-(void)imageButtonTapped:(id)sender {
    [_delegate imageButtonTapped:sender];
}


@end
