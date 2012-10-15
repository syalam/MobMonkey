//
//  MMLocationListCell.m
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMLocationListCell.h"
#import "MMUtilities.h"
#import "UIColor+Additions.h"

@interface MMLocationListCell ()

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UIView *mediaIconsView;
@property (strong, nonatomic) UIImageView *customBackgroundView;


@end

@implementation MMLocationListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat grey = 220.0/255.0;
        self.backgroundView = nil;
        self.backgroundColor = [UIColor colorWithRed:grey green:grey blue:grey alpha:1.0];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //_customBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
        //_customBackgroundView.image = [[UIImage imageNamed:@"searchTableViewCellBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 3.0, 0.0, 3.0)];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.backgroundColor = self.backgroundColor;
        _nameLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _nameLabel.textColor = [UIColor colorWithHex:@"DF561B" alpha:1.0];
        [_nameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _addressLabel.backgroundColor = self.backgroundColor;
        _addressLabel.numberOfLines = 2;
        _addressLabel.font = [UIFont systemFontOfSize:12.0];
        _addressLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _distanceLabel.backgroundColor = self.backgroundColor;
        _distanceLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _distanceLabel.textColor = [UIColor colorWithHex:@"686868" alpha:1.0];        
        _mediaIconsView = [[UIView alloc] initWithFrame:CGRectZero];
        _mediaIconsView.backgroundColor = self.backgroundColor;
        
        //[self.contentView addSubview:_customBackgroundView];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_addressLabel];
        [self.contentView addSubview:_distanceLabel];
        [self.contentView addSubview:_mediaIconsView];
        
    }
    return self;
}

- (void)setLocation:(NSDictionary *)location
{
    _location = location;
    _nameLabel.text = [_location valueForKey:@"name"];
    [_nameLabel sizeToFit];
    _addressLabel.text = [NSString stringWithFormat:@"%@\n%@, %@ %@",
                          [_location valueForKey:@"streetAddress"],
                          [_location valueForKey:@"locality"],
                          [_location valueForKey:@"region"],
                          [_location valueForKey:@"postcode"]];
    CGFloat distance = [[MMUtilities sharedUtilities] calculateDistance:[_location valueForKey:@"latitude"]
                                                              longitude:[_location valueForKey:@"longitude"]];
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f miles", distance];
    [_distanceLabel sizeToFit];
    
    //Temporary
    UIImage *icons = [UIImage imageNamed:@"icons"];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:icons];
    [_mediaIconsView addSubview:iconView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat inset = 10.0;
    CGRect bounds = [[self contentView] bounds];
    CGFloat height = bounds.size.height;
    CGFloat width = bounds.size.width;
    
    self.contentView.frame = CGRectMake(inset, inset, width - inset * 2.0, height - inset);
    
    height = self.contentView.bounds.size.height;
    width = self.contentView.bounds.size.width;
    inset = 5.0;
    CGRect frame = CGRectMake(inset, 0, width - inset * 2.0, 22.0);
    self.nameLabel.frame = frame;
       
    CGSize distLabelFrameSize = self.distanceLabel.frame.size;
    frame = CGRectMake(width - distLabelFrameSize.width + 10, CGRectGetMaxY(frame) - distLabelFrameSize.height, distLabelFrameSize.width, distLabelFrameSize.height);
    self.distanceLabel.frame = frame;
    
    frame = self.nameLabel.frame;
    frame.size.width = CGRectGetMinX(self.distanceLabel.frame) - inset * 2;
    self.nameLabel.frame = frame;
    
    frame = CGRectMake(inset, height - 35.0, width - inset * 2.0, 30.0);
    self.addressLabel.frame = frame;
    
    frame = CGRectMake(width - 86, height - 21.0, 96.0, 16.0);
    self.mediaIconsView.frame = frame;
}

@end
